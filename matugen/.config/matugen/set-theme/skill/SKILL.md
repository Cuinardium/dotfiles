---
name: wallpaper-theme-review
description: Review the Material You theme that set-theme generates for wallpapers, and pin an override where the palette misses the image's subject. Use when the user adds new wallpapers, asks to review or check wallpaper themes/colours, or says a wallpaper's theme looks wrong.
---

# Reviewing wallpaper themes

`set-theme` seeds a palette from the most dominant colour in a wallpaper that is
usable (not too dark, not too grey). That matches human judgement on roughly 26
of every 30 wallpapers. Your job is to catch the rest and pin them.

Read `~/.config/matugen/set-theme/README.md` first if you need the background on
why the heuristic is shaped the way it is.

## Steps

**1. Build the review bundle.** Never apply themes to judge them — `review`
resolves what each wallpaper *would* get without touching the user's desktop:

```bash
set-theme review <paths or directories> --out ~/.cache/matugen/review
```

**2. Look at every contact sheet.** Read each PNG in the out directory with the
Read tool. Each shows the wallpaper, its candidate swatches with the chosen one
boxed, and the resulting theme colours. Judge from the image, not from hex codes —
the question is whether the palette suits the wallpaper.

**3. Decide, one wallpaper at a time.**

Accept the automatic pick when the theme colour matches what the image is *about*.
A night city that themes deep blue is correct even though blue is a common result;
dominance is the right default and most wallpapers should pass untouched.

Pin an override when the palette locks onto a large background while the eye reads
a smaller subject as the subject — a train's yellow lost to the sky, a sunset's red
lost to a treeline. Pick the candidate index from the contact sheet or the
manifest, then:

```bash
set-theme override set <wallpaper-filename> <index> --note "<why, in a few words>"
```

Always write a note. Future readers need to know whether the pin is still wanted.

**4. Report.** Tell the user which wallpapers you pinned and why, and which you
left automatic. Keep it to a line each.

## Judgement calls

- **Prefer leaving it alone.** The heuristic is right far more often than not, and
  an unnecessary pin is worse than none — it freezes a choice that would otherwise
  improve if the policy did. Pin only when the automatic result is clearly wrong.
- **A merely desaturated or dark theme is not wrong.** It is wrong when it takes
  its hue from something the image is not about.
- **Never change the thresholds** in `settheme/selection.py` to fix a single
  wallpaper. They sit mid-plateau and were fitted against a recorded human review;
  moving them to rescue one wallpaper breaks others. Overrides exist for this.
- **If the user disagrees with your call**, that settles it — pin or unpin as they
  say without re-arguing.

## Checking your work

```bash
set-theme override list      # what is pinned now
set-theme selftest           # policy still agrees with the recorded review
```

If you edited anything under `settheme/`, `selftest` must still print `OK`.
It replays 30 recorded human verdicts and names any wallpaper whose previously
approved pick has changed.
