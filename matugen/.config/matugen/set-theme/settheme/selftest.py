"""Regression check: does the policy still agree with the recorded human review?

The thresholds in settheme.selection were fitted against a full review of the
collection. This replays that review from tests/fixtures/verdicts.json, which
stores each wallpaper's candidate list, so it needs neither matugen nor the
original images.

It exists to make threshold changes honest. Tighten MIN_SATURATION to rescue one
wallpaper and this will tell you which two you broke.
"""

from __future__ import annotations

import json
from pathlib import Path

from .color import Color
from .selection import MIN_LIGHTNESS, MIN_SATURATION, select

FIXTURE = Path(__file__).resolve().parent.parent / "tests" / "fixtures" / "verdicts.json"

# Verdicts recorded before per-wallpaper overrides existed. These four are the
# cases the policy provably cannot reach (see settheme.selection); they are
# expected to need a pin, and are not counted as policy failures.
EXPECTED_TO_NEED_OVERRIDE = {
    "lake-studio.png",
    "minecraft-forest-house.png",
    "train-coast-day.jpg",
    "tree-grass-moto-sunset.jpg",
}


def run() -> int:
    if not FIXTURE.exists():
        print(f"fixture missing: {FIXTURE}")
        return 1
    data = json.loads(FIXTURE.read_text())["wallpapers"]

    agreed, needs_override, regressions = 0, [], []
    for name, entry in sorted(data.items()):
        candidates = [Color.from_hex(h) for h in entry["candidates"]]
        chosen = select(candidates).index

        if "approved_index" in entry:
            if chosen == entry["approved_index"]:
                agreed += 1
            else:
                regressions.append(
                    f"{name}: reviewer approved idx{entry['approved_index']}, "
                    f"policy now picks idx{chosen}")
        else:
            primary = Color.from_hex(entry["primaries"][chosen])
            if primary.hue_name in entry["wanted_hues"]:
                agreed += 1  # policy improved enough to satisfy them unaided
            else:
                needs_override.append(name)

    total = len(data)
    print(f"policy thresholds: L>={MIN_LIGHTNESS:.2f} S>={MIN_SATURATION:.2f}")
    print(f"agrees with reviewer on {agreed}/{total} wallpapers unaided")

    unexpected = sorted(set(needs_override) - EXPECTED_TO_NEED_OVERRIDE)
    resolved = sorted(EXPECTED_TO_NEED_OVERRIDE - set(needs_override))

    if needs_override:
        print(f"needs an override ({len(needs_override)}): "
              f"{', '.join(sorted(needs_override))}")
    if resolved:
        print(f"no longer needs an override: {', '.join(resolved)}")

    ok = True
    if regressions:
        ok = False
        print("\nREGRESSIONS -- previously approved picks have changed:")
        for line in regressions:
            print(f"  {line}")
    if unexpected:
        ok = False
        print("\nNEW FAILURES -- not in the known-unreachable set:")
        for name in unexpected:
            print(f"  {name}")

    print("\nOK" if ok else "\nFAILED")
    return 0 if ok else 1
