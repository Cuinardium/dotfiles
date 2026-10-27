"""Applying a theme: the pipeline randomize-wallpaper.sh drives."""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path

from . import backend
from .overrides import Overrides
from .selection import Selection, select

CACHE_DIR = Path.home() / ".cache" / "matugen"
DANK_JSON = CACHE_DIR / "dank.json"


@dataclass
class Applied:
    selection: Selection
    palette: backend.Palette


def resolve(image: Path, overrides: Overrides) -> Applied:
    """Work out which seed and palette this image gets, without applying it."""
    cands = backend.candidates(image)
    pin = overrides.get(image.name)
    selection = select(cands,
                       pin.index if pin else None,
                       pin.note if pin else None)
    return Applied(selection, backend.palette(image, selection.index))


def apply(image: Path, overrides: Overrides, dank_json: Path = DANK_JSON) -> Applied:
    """Resolve, build the dank16 ANSI palette, then write every template.

    dank16 is generated before matugen runs because matugen's templates
    interpolate it from the imported JSON.
    """
    resolved = resolve(image, overrides)
    backend.dank16(resolved.palette.primary_dark,
                   resolved.palette.primary_light,
                   dank_json)
    backend.apply(image, resolved.selection.index, dank_json)
    return resolved
