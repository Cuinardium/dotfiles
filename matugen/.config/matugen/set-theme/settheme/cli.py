"""Command line interface.

`set-theme <image>` stays the primary form: hyprland's randomize-wallpaper.sh
invokes it that way, so it must keep working exactly as before.
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

from .apply import apply as apply_theme, resolve
from .backend import BackendError
from .overrides import Overrides
from .review import review, write_manifest

DEFAULT_OVERRIDES = Path.home() / ".config" / "matugen" / "set-theme" / "overrides.toml"
DEFAULT_REVIEW_DIR = Path.home() / ".cache" / "matugen" / "review"
IMAGE_SUFFIXES = {".jpg", ".jpeg", ".png", ".webp"}


def _overrides(args) -> Overrides:
    return Overrides.load(args.overrides)


def _image(value: str) -> Path:
    path = Path(value).expanduser()
    if not path.is_file():
        raise argparse.ArgumentTypeError(f"no such image: {value}")
    return path


def _expand(paths: list[Path]) -> list[Path]:
    """Accept files or directories; directories contribute their images."""
    found: list[Path] = []
    for path in paths:
        if path.is_dir():
            found += sorted(p for p in path.rglob("*")
                            if p.suffix.lower() in IMAGE_SUFFIXES)
        else:
            found.append(path)
    return found


def cmd_apply(args) -> int:
    result = apply_theme(args.image, _overrides(args))
    print(f"[+] Source colour: {result.selection.explain()}")
    print(f"[+] Primary: dark={result.palette.primary_dark.hex} "
          f"light={result.palette.primary_light.hex}")
    print("[+] Theme applied")
    return 0


def cmd_inspect(args) -> int:
    result = resolve(args.image, _overrides(args))
    print(f"{args.image.name}")
    for index, color in enumerate(result.selection.candidates):
        marker = "*" if index == result.selection.index else " "
        print(f"  {marker} idx{index}  {color.describe()}")
    print(f"\n  chosen: {result.selection.explain()}")
    print(f"  theme : {result.palette.primary_dark.hex} "
          f"({result.palette.primary_dark.hue_name})")
    return 0


def cmd_review(args) -> int:
    images = _expand(args.images)
    if not images:
        print("No images found.", file=sys.stderr)
        return 1
    items = review(images, _overrides(args), args.out, previews=not args.no_previews)
    manifest = write_manifest(items, args.out)

    for item in items:
        flag = "pinned" if item.pinned else item.reason
        print(f"{item.wallpaper:40} idx{item.chosen_index} {item.chosen_hex} "
              f"-> {item.primary_dark} ({item.primary_dark_hue}) [{flag}]")
    print(f"\nManifest: {manifest}")
    if not args.no_previews:
        print(f"Previews: {args.out}")
    return 0


def cmd_override_list(args) -> int:
    overrides = _overrides(args)
    if not len(overrides):
        print(f"No overrides in {overrides.path}")
        return 0
    for name, override in overrides.items():
        note = f"  # {override.note}" if override.note else ""
        print(f"{name:40} index={override.index}{note}")
    return 0


def cmd_override_set(args) -> int:
    overrides = _overrides(args)
    overrides.set(args.wallpaper, args.index, args.note or "")
    overrides.save()
    print(f"Pinned {args.wallpaper} to index {args.index} in {overrides.path}")
    return 0


def cmd_override_unset(args) -> int:
    overrides = _overrides(args)
    if not overrides.unset(args.wallpaper):
        print(f"No override for {args.wallpaper}", file=sys.stderr)
        return 1
    overrides.save()
    print(f"Removed override for {args.wallpaper}")
    return 0


def cmd_selftest(args) -> int:
    from .selftest import run
    return run()


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="set-theme",
        description="Generate a Material You theme from a wallpaper.")
    parser.add_argument("--overrides", type=Path, default=DEFAULT_OVERRIDES,
                        help="override table (default: %(default)s)")
    sub = parser.add_subparsers(dest="command")

    p = sub.add_parser("apply", help="apply a theme (default action)")
    p.add_argument("image", type=_image)
    p.set_defaults(func=cmd_apply)

    p = sub.add_parser("inspect", help="show candidates and the chosen seed")
    p.add_argument("image", type=_image)
    p.set_defaults(func=cmd_inspect)

    p = sub.add_parser("review", help="build a review bundle for new wallpapers")
    p.add_argument("images", nargs="+", type=Path)
    p.add_argument("--out", type=Path, default=DEFAULT_REVIEW_DIR)
    p.add_argument("--no-previews", action="store_true",
                   help="skip PNG contact sheets (manifest only)")
    p.set_defaults(func=cmd_review)

    p = sub.add_parser("override", help="manage per-wallpaper pins")
    osub = p.add_subparsers(dest="override_command", required=True)
    q = osub.add_parser("list"); q.set_defaults(func=cmd_override_list)
    q = osub.add_parser("set")
    q.add_argument("wallpaper"); q.add_argument("index", type=int)
    q.add_argument("--note", default="")
    q.set_defaults(func=cmd_override_set)
    q = osub.add_parser("unset")
    q.add_argument("wallpaper"); q.set_defaults(func=cmd_override_unset)

    p = sub.add_parser("selftest", help="check the policy against recorded verdicts")
    p.set_defaults(func=cmd_selftest)

    return parser


def main(argv: list[str] | None = None) -> int:
    argv = list(sys.argv[1:] if argv is None else argv)

    # Backwards compatibility: `set-theme <image>` with no subcommand.
    known = {"apply", "inspect", "review", "override", "selftest"}
    if argv and not argv[0].startswith("-") and argv[0] not in known:
        argv.insert(0, "apply")

    args = build_parser().parse_args(argv)
    if not hasattr(args, "func"):
        build_parser().print_help()
        return 1
    try:
        return args.func(args)
    except (BackendError, ValueError, IndexError) as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 1
