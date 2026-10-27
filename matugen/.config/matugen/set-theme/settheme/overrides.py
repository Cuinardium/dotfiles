"""Per-wallpaper source-colour pins.

The selection heuristic cannot distinguish a photo's subject from its
background (see settheme.selection). For the handful of wallpapers where those
disagree, the index is pinned by hand here instead.

The file is TOML so it stays hand-editable, and is rewritten from parsed data on
every change -- notes live in a `note` field rather than in trailing comments, so
nothing is lost in a round-trip.
"""

from __future__ import annotations

import tomllib
from dataclasses import dataclass
from pathlib import Path

HEADER = """\
# Per-wallpaper source-colour overrides.
#
# set-theme normally seeds a palette from the most dominant colour that is
# usable (not too dark, not too grey). That matches human judgement on the large
# majority of wallpapers. It misses when a large background wins on area but the
# eye reads a smaller subject -- a train, a sunset -- as the subject of the
# image. Matugen exposes only a handful of quantised colours with no spatial
# information, so no threshold can recover that. Pin the index by hand instead.
#
# Keys are wallpaper filenames (basename, not full path).
#   index : which candidate to use, 0 = most dominant
#   note  : why, so future-you knows whether it is still wanted
#
# Inspect candidates with:  set-theme inspect <image>
# Edit from the CLI with:   set-theme override set <name> <index> --note "..."
# Delete an entry to fall back to the automatic pick.
"""


@dataclass(frozen=True)
class Override:
    index: int
    note: str = ""


class Overrides:
    """A loaded override table, addressed by wallpaper basename."""

    def __init__(self, path: Path, entries: dict[str, Override]):
        self.path = path
        self._entries = entries

    @classmethod
    def load(cls, path: Path) -> "Overrides":
        if not path.exists():
            return cls(path, {})
        with path.open("rb") as handle:
            raw = tomllib.load(handle)

        entries: dict[str, Override] = {}
        for name, value in raw.items():
            if not isinstance(value, dict) or "index" not in value:
                raise ValueError(
                    f"{path}: entry [{name!r}] must be a table with an `index` key")
            index = value["index"]
            if not isinstance(index, int) or index < 0:
                raise ValueError(
                    f"{path}: [{name!r}] index must be a non-negative integer, "
                    f"got {index!r}")
            entries[name] = Override(index, str(value.get("note", "")))
        return cls(path, entries)

    def get(self, wallpaper_name: str) -> Override | None:
        return self._entries.get(wallpaper_name)

    def set(self, wallpaper_name: str, index: int, note: str = "") -> None:
        self._entries[wallpaper_name] = Override(index, note)

    def unset(self, wallpaper_name: str) -> bool:
        return self._entries.pop(wallpaper_name, None) is not None

    def items(self) -> list[tuple[str, Override]]:
        return sorted(self._entries.items())

    def __len__(self) -> int:
        return len(self._entries)

    def save(self) -> None:
        lines = [HEADER]
        for name, override in self.items():
            lines.append(f'\n["{name}"]')
            lines.append(f"index = {override.index}")
            if override.note:
                lines.append(f"note = {_toml_string(override.note)}")
        self.path.parent.mkdir(parents=True, exist_ok=True)
        self.path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def _toml_string(value: str) -> str:
    escaped = value.replace("\\", "\\\\").replace('"', '\\"')
    return f'"{escaped}"'
