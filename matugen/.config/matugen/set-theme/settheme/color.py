"""Colour primitives: hex parsing, HSL, and coarse hue naming.

Selection reasons about *hue*, *lightness* and *saturation* rather than RGB,
because the failure mode being guarded against is specifically a seed whose hue
is meaningless -- a near-black or near-grey pixel cluster whose residual tint is
sensor noise. HSL makes "too dark" and "too grey" directly expressible.
"""

from __future__ import annotations

import colorsys
from dataclasses import dataclass

# Coarse hue bands, in degrees. Deliberately wide: these exist to describe a
# colour in review output and to check "did we land on the hue the reviewer
# asked for", never to make selection decisions.
_HUE_BANDS = (
    (0, 15, "red"),
    (15, 45, "orange"),
    (45, 70, "yellow"),
    (70, 160, "green"),
    (160, 200, "cyan"),
    (200, 250, "blue"),
    (250, 290, "purple"),
    (290, 335, "magenta"),
    (335, 360, "red"),
)

# Below this saturation a colour reads as grey and its hue carries no meaning.
_GREY_SATURATION = 0.10


@dataclass(frozen=True)
class Color:
    """An sRGB colour, parsed once and queried in HSL terms."""

    hex: str
    hue: float          # degrees, 0-360
    lightness: float    # 0-1
    saturation: float   # 0-1, HSL (not HSV) saturation

    @classmethod
    def from_hex(cls, value: str) -> "Color":
        text = value.strip().lstrip("#")
        if len(text) != 6:
            raise ValueError(f"expected a 6-digit hex colour, got {value!r}")
        try:
            r, g, b = (int(text[i:i + 2], 16) / 255 for i in (0, 2, 4))
        except ValueError as exc:
            raise ValueError(f"not a hex colour: {value!r}") from exc
        hue, lightness, saturation = colorsys.rgb_to_hls(r, g, b)
        return cls(f"#{text.lower()}", hue * 360, lightness, saturation)

    @property
    def hue_name(self) -> str:
        """Coarse human name, or 'grey' when the hue is not meaningful."""
        if self.saturation < _GREY_SATURATION:
            return "grey"
        for low, high, name in _HUE_BANDS:
            if low <= self.hue < high:
                return name
        return "red"  # hue == 360.0 exactly

    @property
    def rgb(self) -> tuple[int, int, int]:
        text = self.hex.lstrip("#")
        return tuple(int(text[i:i + 2], 16) for i in (0, 2, 4))

    def describe(self) -> str:
        return (f"{self.hex} H={self.hue:3.0f} L={self.lightness:.2f} "
                f"S={self.saturation:.2f} {self.hue_name}")
