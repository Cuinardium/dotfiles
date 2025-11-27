#!/bin/bash
set -euo pipefail

# -------------------------------------------------------------------
# Usage:
#   ./set_wallpapers.sh [--prompt|-p] "https://tusitio.com/wallpapers"
#
# Con --prompt/-p: abre rofi para ingresar un término -> agrega ?q=term
# al URL final (respetando parámetros existentes).
# -------------------------------------------------------------------

PROMPT_MODE=0
if [[ "${1:-}" == "--prompt" || "${1:-}" == "-p" ]]; then
  PROMPT_MODE=1
  shift
fi

URL="${1:-}"
if [[ -z "$URL" ]]; then
  echo "Usage: $0 [--prompt|-p] <base-url>"
  exit 1
fi

# --- deps --------------------------------------------------------------------
need() { command -v "$1" >/dev/null 2>&1 || { echo "Missing '$1'"; exit 1; }; }
need http
need jq
need curl
need hyprctl
need hyprpaper
need grep
need sed

# rofi solo si modo prompt
if (( PROMPT_MODE )); then
  need rofi
fi

# --- helpers -----------------------------------------------------------------

# Set or add query param ?key=value (replace if exists)
set_param() {
  local base="$1" key="$2" val="$3"
  # si val es vacío, no toques nada
  if [[ -z "$val" ]]; then
    echo "$base"; return 0
  fi
  if [[ "$base" == *\?* ]]; then
    if [[ "$base" =~ ([\?\&])$key=([^&]*) ]]; then
      sed -E "s/([?&])$key=[^&]*/\1${key}=${val}/" <<<"$base"
    else
      echo "${base}&${key}=${val}"
    fi
  else
    echo "${base}?${key}=${val}"
  fi
}

# Make absolute URL from base + possibly relative path
make_absolute() {
  local current_url="$1" path="$2"
  if [[ "$path" == http* ]]; then
    echo "$path"
  else
    local base_host
    base_host="$(grep -oE '^https?://[^/]+' <<<"$current_url")"
    if [[ "$path" == /* ]]; then
      echo "${base_host}${path}"
    else
      echo "${current_url%/}/$path"
    fi
  fi
}

# Fetch first preview image for (ratio[, atleast]) -> out_path
fetch_wallpaper_for() {
  local base_url="$1" ratio="$2" atleast="$3" out_path="$4"

  local url_q
  url_q="$(set_param "$base_url" "ratios" "$ratio")"
  url_q="$(set_param "$url_q"  "atleast" "$atleast")"

  echo "List page: $url_q"
  local preview_href
  preview_href="$(http -b "$url_q" | grep -oP '<a[^>]+class="preview"[^>]+href="\K[^"]+' | head -n 1 || true)"
  if [[ -z "$preview_href" ]]; then
    echo "ERROR: no preview link for ratio=$ratio atleast=${atleast:-<none>}"
    return 2
  fi

  local preview_url
  preview_url="$(make_absolute "$url_q" "$preview_href")"
  echo "Preview page: $preview_url"

  local img_src
  img_src="$(http -b "$preview_url" | grep -oP '<img[^>]+id="wallpaper"[^>]+src="\K[^"]+' || true)"
  if [[ -z "$img_src" ]]; then
    echo "ERROR: no <img id=\"wallpaper\"> for ratio=$ratio atleast=${atleast:-<none>}"
    return 3
  fi

  local img_url
  img_url="$(make_absolute "$preview_url" "$img_src")"
  echo "Image URL: $img_url"

  curl -fsSL "$img_url" -o "$out_path"
  [[ -s "$out_path" ]] || { echo "ERROR: empty download $out_path"; return 4; }
}

# --- rofi prompt (modo opcional) --------------------------------------------
if (( PROMPT_MODE )); then
  # Mensaje para rofi; -dmenu devuelve la línea seleccionada/ingresada en stdout
  query="$(printf "" | rofi -dmenu -theme catppuccin -p "Search term")" || true
  # Si el user cancela (escape) o deja vacío, seguimos sin q=
  if [[ -n "$query" ]]; then
    # URL-encode con jq @uri (ya lo tenemos como dependencia)
    enc_query="$(printf '%s' "$query" | jq -sRr @uri)"
    URL="$(set_param "$URL" "q" "$enc_query")"
    echo "Applied q=${query} -> $URL"
  else
    echo "No query provided; continuing without q="
  fi
fi

# --- read monitors & determine orientation (accounting for transform) -------
mapfile -t MON_NAMES < <(hyprctl -j monitors | jq -r '.[]?.name')
mapfile -t MON_W     < <(hyprctl -j monitors | jq -r '.[]?.width')
mapfile -t MON_H     < <(hyprctl -j monitors | jq -r '.[]?.height')
mapfile -t MON_T     < <(hyprctl -j monitors | jq -r '.[]?.transform // 0')  # 0..7

(( ${#MON_NAMES[@]} )) || { echo "No monitors found"; exit 5; }

land_w=0; land_h=0; land_count=0
port_w=0; port_h=0; port_count=0
declare -a MON_RATIO=()

for i in "${!MON_NAMES[@]}"; do
  w="${MON_W[$i]:-0}"; h="${MON_H[$i]:-0}"; t="${MON_T[$i]:-0}"
  [[ "$w" == "null" || -z "$w" ]] && w=0
  [[ "$h" == "null" || -z "$h" ]] && h=0
  [[ "$t" == "null" || -z "$t" ]] && t=0

  # Wayland transform: odd => 90/270 (con o sin flip) -> swap axes
  if (( t % 2 == 1 )); then
    w_eff="$h"
    h_eff="$w"
  else
    w_eff="$w"
    h_eff="$h"
  fi

  if (( w_eff >= h_eff )); then
    MON_RATIO[$i]="landscape"
    (( w_eff > land_w )) && land_w="$w_eff"
    (( h_eff > land_h )) && land_h="$h_eff"
    (( ++land_count ))
  else
    MON_RATIO[$i]="portrait"
    (( w_eff > port_w )) && port_w="$w_eff"
    (( h_eff > port_h )) && port_h="$h_eff"
    (( ++port_count ))
  fi
done

# --- fetch once per ratio (no resolution in filenames) ----------------------
LAND_FILE="/tmp/wallpaper_landscape"
PORT_FILE="/tmp/wallpaper_portrait"

if (( land_count > 0 )); then
  land_atleast="${land_w}x${land_h}"
  echo "Fetching LANDSCAPE (atleast=$land_atleast) -> $LAND_FILE"
  if ! fetch_wallpaper_for "$URL" "landscape" "$land_atleast" "$LAND_FILE"; then
    echo "Fallback: LANDSCAPE without atleast"
    fetch_wallpaper_for "$URL" "landscape" "" "$LAND_FILE"
  fi
fi

if (( port_count > 0 )); then
  port_atleast="${port_w}x${port_h}"
  echo "Fetching PORTRAIT (atleast=$port_atleast) -> $PORT_FILE"
  if ! fetch_wallpaper_for "$URL" "portrait" "$port_atleast" "$PORT_FILE"; then
    echo "Fallback: PORTRAIT without atleast"
    fetch_wallpaper_for "$URL" "portrait" "" "$PORT_FILE"
  fi
fi

# --- apply with hyprpaper ----------------------------------------------------
hyprctl hyprpaper unload all || true
[[ -f "$LAND_FILE" ]] && hyprctl hyprpaper preload "$LAND_FILE"
[[ -f "$PORT_FILE" ]] && hyprctl hyprpaper preload "$PORT_FILE"

for i in "${!MON_NAMES[@]}"; do
  m="${MON_NAMES[$i]}"
  case "${MON_RATIO[$i]}" in
    landscape) f="$LAND_FILE" ;;
    portrait)  f="$PORT_FILE" ;;
    *) echo "Unknown ratio for monitor $m"; exit 6 ;;
  esac
  hyprctl hyprpaper wallpaper "$m,$f"
done

echo "Done:"
for i in "${!MON_NAMES[@]}"; do
  echo "  ${MON_NAMES[$i]} (${MON_RATIO[$i]}) -> $( [[ ${MON_RATIO[$i]} == landscape ]] && echo "$LAND_FILE" || echo "$PORT_FILE" )"
done
