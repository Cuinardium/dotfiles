#!/usr/bin/env bash
set -euo pipefail

WALLPAPER_DIR="${1:-$HOME/.config/hypr/wallpapers}"
SLEEP="${2:-0}"

sleep "$SLEEP"

# --- helpers ---------------------------------------------------------------

have() { command -v "$1" >/dev/null 2>&1; }

# Return "W H" (width height) via ImageMagick identify or ffprobe; empty if unknown
img_wh() {
  local p=$1
  if have identify; then
    identify -format "%w %h" -- "$p" 2>/dev/null | awk 'NF{print $1, $2; exit}'
  elif have ffprobe; then
    ffprobe -v error -select_streams v:0 -show_entries stream=width,height \
      -of csv=p=0:s=" " -- "$p" 2>/dev/null | awk 'NF{print $1, $2; exit}'
  else
    echo ""
  fi
}

is_vertical() {
  local p=$1 wh w h
  wh="$(img_wh "$p")" || true
  [[ -z "$wh" ]] && return 1  # unknown -> treat as not-vertical
  read -r w h <<<"$wh"
  (( h > w ))
}

# --- choose files ----------------------------------------------------------

mapfile -t FILES < <(find -L "$WALLPAPER_DIR" -type f -readable)
((${#FILES[@]})) || { echo "No wallpapers found"; exit 1; }

# Filter out CURRENT if present
CAND=()
for f in "${FILES[@]}"; do
  CAND+=("$f")
done
((${#CAND[@]})) || CAND=("${FILES[@]}")

SRC="${CAND[RANDOM % ${#CAND[@]}]}"

# Resolve to a real path (helps with FUSE edge cases, still no copy/link)
REAL_SRC="$(readlink -f -- "$SRC" || echo "$SRC")"

# If REAL_SRC is vertical, find the first horizontal candidate
HORIZONTAL_SRC=""
if is_vertical "$REAL_SRC"; then
  # Shuffle candidates to randomize order, then pick first horizontal match
  mapfile -t SHUFFLED < <(printf '%s\n' "${CAND[@]}" | shuf)
  for cand in "${SHUFFLED[@]}"; do
    local_real="$(readlink -f -- "$cand" 2>/dev/null || echo "$cand")"
    if ! is_vertical "$local_real"; then
      HORIZONTAL_SRC="$local_real"
      break
    fi
  done
fi

# --- monitors --------------------------------------------------------------

if have jq; then
  readarray -t MONS < <(hyprctl -j monitors | jq -r '.[].name')
else
  readarray -t MONS < <(hyprctl monitors | awk -F'[][]' '/Monitor/ {print $2}')
fi
((${#MONS[@]})) || { echo "No monitors found"; exit 1; }

# --- apply wallpapers ------------------------------------------------------


# First monitor: use horizontal if available; others: use REAL_SRC
for i in "${!MONS[@]}"; do
  m="${MONS[$i]}"
  if (( i == 0 )) && [[ -n "${HORIZONTAL_SRC:-}" ]]; then
    hyprctl hyprpaper wallpaper "$m,$HORIZONTAL_SRC"
  else
    hyprctl hyprpaper wallpaper "$m,$REAL_SRC"
  fi
done

set-theme "$REAL_SRC" 
