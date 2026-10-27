"""Building review bundles for a human or an AI agent to judge.

The question a reviewer answers is "does this palette suit this wallpaper?",
which is a visual judgement. Hex codes alone are a poor substrate for it, so
each wallpaper gets a contact sheet: the image itself above a strip of swatches
showing every candidate (the chosen one marked) and the resulting theme colours.
A vision-capable agent can open one PNG and see everything at once.

The manifest carries the same information as structured JSON so the agent can
act on it -- and, importantly, knows which candidate index to pin if it
disagrees.
"""

from __future__ import annotations

import json
import shutil
import subprocess
from dataclasses import asdict, dataclass
from pathlib import Path

from .backend import BackendError, Palette, candidates, palette
from .color import Color
from .overrides import Overrides
from .selection import Selection, select

THUMB_WIDTH = 900
SWATCH_HEIGHT = 90
LABEL_HEIGHT = 28


@dataclass
class ReviewItem:
    wallpaper: str
    path: str
    chosen_index: int
    chosen_hex: str
    reason: str
    pinned: bool
    primary_dark: str
    primary_dark_hue: str
    preview: str
    candidates: list[dict]


def _font() -> str | None:
    """A usable font path, or None.

    ImageMagick has no default font on a minimal Arch install -- annotating
    without one fails the whole command -- so resolve one through fontconfig and
    degrade to unlabelled swatches if even that is missing.
    """
    if shutil.which("fc-match") is None:
        return None
    try:
        found = subprocess.run(["fc-match", "-f", "%{file}", "monospace"],
                               capture_output=True, text=True, check=True).stdout.strip()
    except subprocess.CalledProcessError:
        return None
    return found or None


def _swatch(color: Color, width: int, label: str, marked: bool,
            font: str | None) -> list[str]:
    """One swatch column, as ImageMagick arguments.

    The chosen candidate gets a white border; every other swatch gets a
    transparent one of the same width so the columns stay aligned.
    """
    args = [
        "(", "-size", f"{width}x{SWATCH_HEIGHT}", f"xc:{color.hex}",
        "-bordercolor", "white" if marked else "#111111", "-border", "3",
    ]
    if font:
        args += [
            # Caption bar appended *below* the swatch: splice with south
            # gravity adds rows at the bottom rather than through the middle.
            "-background", "#111111", "-fill", "white",
            "-font", font, "-pointsize", "15", "-gravity", "south",
            "-splice", f"0x{LABEL_HEIGHT}",
            "-annotate", "+0+7", label,
        ]
    args.append(")")
    return args


def build_preview(image: Path, selection: Selection, theme: Palette,
                  destination: Path) -> Path:
    """Compose wallpaper + candidate swatches + resulting theme into one PNG."""
    if shutil.which("magick") is None:
        raise BackendError("'magick' (ImageMagick) is not on PATH; needed for previews")

    font = _font()
    args: list[str] = ["magick", str(image), "-resize", f"{THUMB_WIDTH}x420^",
                       "-gravity", "center", "-extent", f"{THUMB_WIDTH}x420"]

    candidate_width = THUMB_WIDTH // max(len(selection.candidates), 1)
    args.append("(")
    for index, color in enumerate(selection.candidates):
        marked = index == selection.index
        label = f"idx{index}{'  <= chosen' if marked else ''}"
        args += _swatch(color, candidate_width, label, marked, font)
    args += ["+append", ")"]

    theme_width = THUMB_WIDTH // 3
    args.append("(")
    for color, name in ((theme.primary_dark, "primary dark"),
                        (theme.primary_light, "primary light"),
                        (theme.surface_dark, "surface")):
        args += _swatch(color, theme_width, name, False, font)
    args += ["+append", ")"]

    destination.parent.mkdir(parents=True, exist_ok=True)
    args += ["-background", "#111111", "-append", str(destination)]
    try:
        subprocess.run(args, check=True, capture_output=True, text=True,
                       stdin=subprocess.DEVNULL)
    except subprocess.CalledProcessError as exc:
        raise BackendError(
            f"preview generation failed for {image.name}: "
            f"{(exc.stderr or '').strip()}") from exc
    return destination


def review(images: list[Path], overrides: Overrides, out_dir: Path,
           previews: bool = True) -> list[ReviewItem]:
    """Resolve the theme each image would get, and render it for judgement."""
    items: list[ReviewItem] = []
    for image in images:
        cands = candidates(image)
        pin = overrides.get(image.name)
        selection = select(cands,
                           pin.index if pin else None,
                           pin.note if pin else None)
        theme = palette(image, selection.index)

        preview_path = out_dir / f"{image.stem}.png"
        if previews:
            build_preview(image, selection, theme, preview_path)

        items.append(ReviewItem(
            wallpaper=image.name,
            path=str(image),
            chosen_index=selection.index,
            chosen_hex=selection.color.hex,
            reason=selection.reason.value,
            pinned=pin is not None,
            primary_dark=theme.primary_dark.hex,
            primary_dark_hue=theme.primary_dark.hue_name,
            preview=str(preview_path) if previews else "",
            candidates=[
                {"index": i, "hex": c.hex, "hue": c.hue_name,
                 "lightness": round(c.lightness, 3),
                 "saturation": round(c.saturation, 3)}
                for i, c in enumerate(selection.candidates)
            ],
        ))
    return items


def write_manifest(items: list[ReviewItem], out_dir: Path) -> Path:
    out_dir.mkdir(parents=True, exist_ok=True)
    path = out_dir / "manifest.json"
    path.write_text(json.dumps([asdict(i) for i in items], indent=2) + "\n",
                    encoding="utf-8")
    return path
