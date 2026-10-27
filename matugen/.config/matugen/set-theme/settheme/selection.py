"""Choosing which of matugen's candidate colours should seed the palette.

Matugen offers up to five candidate source colours, ranked by pixel population.
Picking index 0 (the most dominant) is right the overwhelming majority of the
time -- it is what makes a theme feel like it belongs to its wallpaper.

It has one systematic failure. A photograph's largest colour region is often a
near-black shadow mass or a near-grey haze whose residual tint is noise. Material
You normalises chroma on the way to tone 80, so that noise is amplified into a
fully saturated primary: a black brick wall seeds a bright cyan theme. The fix is
not to abandon dominance but to skip candidates too dark or too grey to carry a
hue at all.

Thresholds
----------
MIN_LIGHTNESS / MIN_SATURATION were fitted against a full human review of the
collection (see tests/fixtures/verdicts.json). The scoring surface is a plateau,
not a peak -- every value in L 0.10-0.15 x S 0.10-0.14 scores identically, so
these sit mid-plateau rather than balanced on an edge. Both bounds are set by
real images:

  * Raising MIN_LIGHTNESS past ~0.15 rejects legitimately dark seeds. The deep
    night blue of japan-city-night.jpg sits at L=0.17.
  * Raising MIN_SATURATION past ~0.14 rejects legitimately muted ones. The misty
    forest of minecraft-forest-house.png sits at S=0.14.

What this policy deliberately cannot do
---------------------------------------
It scores 26/30 against human judgement, which is the ceiling for this family of
rule. The four remaining disagreements all have the same shape: a large
background wins on area while the eye reads a smaller subject -- a train, a
sunset -- as the subject of the image. They are provably not separable by any
threshold on the candidates:

  * train-coast-day (rejected) has a +0.20 saturation pull toward its warm
    alternative; balcony-baloons (accepted) has a *stronger* +0.26 pull.
  * telescope-girl-cats (accepted) has S=0.58 at index 0 -- identical to
    train-coast-day (rejected).
  * minecraft-forest-house's wanted green is S=0.11, *less* saturated than the
    blue it would replace, so no saturation rule can ever reach it.

Matugen hands us four quantised colours with no spatial information, so
subject-versus-background is not recoverable from the data. Those cases are
handled by explicit per-wallpaper overrides instead of by a cleverer rule.
"""

from __future__ import annotations

from dataclasses import dataclass
from enum import Enum

from .color import Color

MIN_LIGHTNESS = 0.12
MIN_SATURATION = 0.12


class Reason(str, Enum):
    """Why a particular candidate was chosen. Surfaced in CLI output so an
    unexpected theme explains itself without needing a debugger."""

    DOMINANT = "most dominant"
    SKIPPED_UNUSABLE = "most dominant candidate was too dark or too grey"
    PINNED = "pinned by override"
    NO_USABLE_CANDIDATE = "no candidate was usable; fell back to most dominant"


@dataclass(frozen=True)
class Selection:
    index: int
    color: Color
    reason: Reason
    candidates: tuple[Color, ...]
    note: str | None = None

    def explain(self) -> str:
        detail = self.reason.value
        if self.reason is Reason.SKIPPED_UNUSABLE:
            detail = f"{detail} ({self.candidates[0].hex})"
        elif self.reason is Reason.PINNED and self.note:
            detail = f"{detail}: {self.note}"
        return f"{self.color.hex} (index {self.index}; {detail})"


def is_usable_seed(color: Color) -> bool:
    """Can this colour carry a hue, or is it shadow/haze whose tint is noise?"""
    return color.lightness >= MIN_LIGHTNESS and color.saturation >= MIN_SATURATION


def select(candidates: list[Color], pinned_index: int | None = None,
           pinned_note: str | None = None) -> Selection:
    """Pick a seed: an explicit pin if present, else the most dominant usable
    candidate, else index 0."""
    if not candidates:
        raise ValueError("matugen returned no candidate source colours")

    if pinned_index is not None:
        if not 0 <= pinned_index < len(candidates):
            raise IndexError(
                f"override index {pinned_index} is out of range; this image has "
                f"{len(candidates)} candidates (0-{len(candidates) - 1})")
        return Selection(pinned_index, candidates[pinned_index], Reason.PINNED,
                         tuple(candidates), pinned_note)

    for index, color in enumerate(candidates):
        if is_usable_seed(color):
            reason = Reason.DOMINANT if index == 0 else Reason.SKIPPED_UNUSABLE
            return Selection(index, color, reason, tuple(candidates))

    return Selection(0, candidates[0], Reason.NO_USABLE_CANDIDATE, tuple(candidates))
