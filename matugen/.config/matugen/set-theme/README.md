# set-theme

Generates a Material You theme from a wallpaper: picks a seed colour, builds a
16-colour ANSI palette with `dank-gen`, and renders every matugen template.

Called by `randomize-wallpaper.sh` on every wallpaper change, and usable directly:

```bash
set-theme ~/Pictures/wallpapers/rotation/train-coast-day.jpg
```

## Why this exists

Matugen offers a handful of candidate source colours ranked by pixel population,
and the obvious choice — take the most dominant — is right most of the time. It
has one systematic failure. A photograph's largest colour region is often a
near-black shadow mass or a near-grey haze whose residual tint is sensor noise.
Material You normalises chroma on the way to tone 80, so that noise is amplified
into a fully saturated primary.

A dark green wallpaper seeded a bright cyan theme this way: its dominant colour
was `#0f1517`, which is 7% lightness and reads as black, but computes to hue 195°.

The fix is not to abandon dominance but to **skip candidates too dark or too grey
to carry a hue at all**:

> Walk candidates in dominance order; take the first with L ≥ 0.12 and S ≥ 0.12.
> If none qualify, fall back to the most dominant.

## What the thresholds are based on

Every wallpaper in the collection was applied and judged by hand. Those verdicts
live in `tests/fixtures/verdicts.json` and the policy is checked against them:

```bash
set-theme selftest
```

The scoring surface is a **plateau, not a peak** — every value in
L 0.10–0.15 × S 0.10–0.14 scores identically — so the shipped thresholds sit
mid-plateau rather than balanced on an edge. Both bounds are set by real images:

| Bound | Set by | Why |
|---|---|---|
| L ≤ 0.15 | `japan-city-night.jpg` (L=0.17) | a legitimately dark night-blue seed |
| S ≤ 0.14 | `minecraft-forest-house.png` (S=0.14) | a legitimately muted misty seed |

The policy agrees with human judgement on **26 of 30** wallpapers, which is the
ceiling for this family of rule. Tightening a threshold to rescue one wallpaper
breaks two others — `selftest` will name them.

## What the policy deliberately cannot do

The four remaining disagreements share a shape: a large background wins on area
while the eye reads a smaller subject — a train, a sunset — as the subject of the
image. They are provably not separable by any threshold on the candidates:

- `train-coast-day` (rejected) has a +0.20 saturation pull toward its warm
  alternative. `balcony-baloons` (accepted) has a **stronger** +0.26 pull.
- `telescope-girl-cats` (accepted) sits at S=0.58 at index 0 — identical to
  `train-coast-day` (rejected).
- `minecraft-forest-house`'s wanted green is S=0.11, **less** saturated than the
  blue it would replace, so no saturation rule can ever reach it.

Matugen hands over quantised colours with no spatial information, so
subject-versus-background is not recoverable from the data. Those cases get an
explicit override rather than a cleverer rule.

## Overrides

`overrides.toml` pins a candidate index for a specific wallpaper:

```toml
["train-coast-day.jpg"]
index = 1
note = "the train's yellow over the sky"
```

```bash
set-theme inspect train-coast-day.jpg          # list candidates with H/L/S
set-theme override set train-coast-day.jpg 1 --note "the train's yellow"
set-theme override list
set-theme override unset train-coast-day.jpg   # back to automatic
```

Deleting an entry restores the automatic pick. Notes are a TOML field rather than
a trailing comment, so they survive a CLI round-trip.

## Reviewing new wallpapers

`review` resolves the theme each wallpaper *would* get without applying it, and
renders a contact sheet per image — the wallpaper above its candidate swatches
(chosen one boxed) and the resulting theme colours:

```bash
set-theme review ~/Pictures/wallpapers/new/ --out ~/.cache/matugen/review
```

It writes `manifest.json` alongside the PNGs with each candidate's index, hex,
hue name, lightness and saturation — everything needed to decide on a pin.

### With an AI agent

Ask Claude Code:

> review the new wallpapers in ~/Pictures/wallpapers/new

The `wallpaper-theme-review` skill (in `skill/SKILL.md`) runs the command, looks
at each contact sheet, and pins the ones where the palette misses the subject.
Because the previews are images, the judgement is made on what the theme *looks*
like rather than on hex codes. Nothing is applied — it only edits
`overrides.toml`.

The skill lives here rather than under `claude-code/` so the subproject stays
self-contained; Claude Code finds it through a chain of relative symlinks that
`stow` recreates on any machine:

```
~/.claude/skills/wallpaper-theme-review
  -> dotfiles/claude-code/.claude/skills/wallpaper-theme-review   (stowed)
  -> dotfiles/matugen/.config/matugen/set-theme/skill             (repo-relative)
```

Both links are relative, so nothing breaks if the repo is cloned elsewhere.

To vet the result, re-run `set-theme review` and check the previews yourself, or
apply one directly with `set-theme <image>`.

## Layout

```
set-theme/
├── README.md
├── overrides.toml          # per-wallpaper pins
├── skill/SKILL.md          # the Claude Code review skill (symlinked into ~/.claude)
├── settheme/
│   ├── color.py            # hex -> HSL, coarse hue naming
│   ├── selection.py        # the seed policy, and why it is what it is
│   ├── overrides.py        # TOML pin table, round-trip safe
│   ├── backend.py          # the only module that shells out
│   ├── apply.py            # resolve -> dank16 -> render templates
│   ├── review.py           # contact sheets + manifest
│   ├── selftest.py         # replays the recorded human review
│   └── cli.py
└── tests/fixtures/verdicts.json
```

`selection.py` is pure: it takes colours and returns a choice, so the policy is
testable against recorded candidate lists without matugen or the images.

## Requirements

Python 3.11+ (stdlib only — `tomllib`, `colorsys`), `matugen` 4.2+, `dank-gen`
(see `../dank16/`), `jq` is no longer needed. ImageMagick and `fc-match` are used
for review previews only; without a usable font the swatches render unlabelled
rather than failing.

## Gotcha worth knowing

Matugen **blocks on an interactive prompt** when given neither
`--source-color-index` nor a `prefer` setting. Every call here passes an explicit
index. A missing one hangs the wallpaper rotation silently at login.
