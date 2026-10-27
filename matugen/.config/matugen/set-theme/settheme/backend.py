"""Adapter over the external tools: matugen and dank-gen.

Everything that shells out lives here, so the selection policy stays pure and
testable against recorded candidate lists.

One matugen behaviour is load-bearing: without an explicit --source-color-index
(and with no `prefer` set in its config) matugen *blocks on an interactive
prompt*. Every call below therefore passes an explicit index. A missing one
would hang the wallpaper rotation silently at login.
"""

from __future__ import annotations

import json
import shutil
import subprocess
from dataclasses import dataclass
from pathlib import Path

from .color import Color


class BackendError(RuntimeError):
    pass


def _run(command: list[str]) -> str:
    exe = command[0]
    if shutil.which(exe) is None:
        raise BackendError(f"{exe!r} is not on PATH")
    try:
        done = subprocess.run(command, capture_output=True, text=True,
                              stdin=subprocess.DEVNULL, check=True)
    except subprocess.CalledProcessError as exc:
        detail = (exc.stderr or exc.stdout or "").strip()
        raise BackendError(f"{exe} failed ({exc.returncode}): {detail}") from exc
    return done.stdout


def candidates(image: Path) -> list[Color]:
    """Matugen's candidate source colours, most dominant first."""
    out = _run(["matugen", "image", str(image), "--show-source-colors"])
    colors = [Color.from_hex(line) for line in out.split() if line.strip()]
    if not colors:
        raise BackendError(f"matugen returned no source colours for {image}")
    return colors


@dataclass(frozen=True)
class Palette:
    """The parts of a generated scheme that anything downstream needs."""

    source: Color
    primary_dark: Color
    primary_light: Color
    surface_dark: Color

    @property
    def preview_colors(self) -> list[Color]:
        return [self.primary_dark, self.primary_light, self.surface_dark]


def palette(image: Path, source_index: int) -> Palette:
    """Resolve the scheme matugen would generate, without applying it."""
    out = _run(["matugen", "image", str(image),
                "--source-color-index", str(source_index),
                "--dry-run", "--json", "hex"])
    try:
        colors = json.loads(out)["colors"]
    except (json.JSONDecodeError, KeyError) as exc:
        raise BackendError(f"could not parse matugen JSON for {image}: {exc}") from exc

    def pick(name: str, mode: str) -> Color:
        try:
            return Color.from_hex(colors[name][mode]["color"])
        except (KeyError, TypeError, ValueError) as exc:
            raise BackendError(f"matugen JSON missing {name}.{mode}: {exc}") from exc

    return Palette(
        source=pick("source_color", "default"),
        primary_dark=pick("primary", "dark"),
        primary_light=pick("primary", "light"),
        surface_dark=pick("surface", "dark"),
    )


def dank16(primary_dark: Color, primary_light: Color, destination: Path) -> None:
    """Generate the 16-colour ANSI palette.

    dank-gen takes <dark_primary> <light_primary>. Passing the dark primary for
    both -- as this script once did -- silently gives light mode a palette built
    from a dark-mode tone.
    """
    out = _run(["dank-gen", primary_dark.hex, primary_light.hex])
    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_text(out, encoding="utf-8")


def apply(image: Path, source_index: int, imported_json: Path) -> str:
    """Apply the theme for real: writes every template and fires its post-hooks."""
    return _run(["matugen", "image", str(image),
                 "--import-json", str(imported_json),
                 "--source-color-index", str(source_index)])
