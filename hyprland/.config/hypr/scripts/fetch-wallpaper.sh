#!/bin/bash
set -euo pipefail

# -------------------------------------------------------------------
# Usage:
#   ./fetch-wallpaper.sh [--prompt|-p] "https://tusitio.com/wallpapers"
#
# Con --prompt/-p: abre rofi para ingresar un término -> agrega ?q=term
# al URL final (respetando parámetros existentes).
#
# Estrategia de cache (evita latencia por request):
#   - Cada corrida consume UNA imagen ya descargada de /tmp/wallpaper_cache.
#   - Cuando el pool baja a <=1 imagen restante, dispara un refill en
#     background (todas las imágenes de la página de listado, en paralelo)
#     para la próxima corrida.
#   - Si el pool está vacío (primera corrida), hace el refill sync.
# -------------------------------------------------------------------

CACHE_DIR="/tmp/wallpaper_cache"
POOL_SIZE="${WALLPAPER_POOL_SIZE:-8}"
mkdir -p "$CACHE_DIR"

# --- modo interno: refill en background (re-exec del propio script) --------
REFILL_MODE=0
if [[ "${1:-}" == "--__refill" ]]; then
  REFILL_MODE=1
  REFILL_URL="$2"
  REFILL_RATIO="$3"
  REFILL_ATLEAST="$4"
  shift 4
fi

if (( ! REFILL_MODE )); then
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
need setsid

if (( ! REFILL_MODE )) && (( PROMPT_MODE )); then
  need rofi
fi

# --- helpers -----------------------------------------------------------------

# Set or add query param ?key=value (replace if exists)
set_param() {
  local base="$1" key="$2" val="$3"
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

# Download the full image for a single preview page -> $CACHE_DIR/<ratio>_*
download_one() {
  local preview_url="$1" ratio="$2"
  local page img_src img_url ext out

  page="$(http -b GET "$preview_url" || true)"
  img_src="$(grep -oP '<img[^>]+id="wallpaper"[^>]+src="\K[^"]+' <<<"$page" || true)"
  if [[ -z "$img_src" ]]; then
    echo "[refill] no <img id=\"wallpaper\"> at $preview_url"
    return 1
  fi

  img_url="$(make_absolute "$preview_url" "$img_src")"
  ext="${img_url##*.}"
  [[ "$ext" =~ ^[a-zA-Z0-9]{2,4}$ ]] || ext="jpg"
  out="$CACHE_DIR/${ratio}_$(date +%s%N)_${RANDOM}.${ext}"

  if curl -fsSL "$img_url" -o "$out" && [[ -s "$out" ]]; then
    echo "[refill] saved $out"
  else
    rm -f "$out"
    echo "[refill] failed download $img_url"
    return 1
  fi
}

# Fetch the listing page and download ALL preview images found (parallel)
refill_cache() {
  local base_url="$1" ratio="$2" atleast="$3"
  local url_q page hrefs

  url_q="$(set_param "$base_url" "ratios" "$ratio")"
  url_q="$(set_param "$url_q"  "atleast" "$atleast")"

  echo "[refill] List page: $url_q"
  page="$(http -b GET "$url_q" || true)"
  hrefs="$(grep -oP '<a[^>]+class="preview"[^>]+href="\K[^"]+' <<<"$page" | awk '!seen[$0]++' | head -n "$POOL_SIZE")"

  if [[ -z "$hrefs" && -n "$atleast" ]]; then
    echo "[refill] no results with atleast=$atleast, retrying without it"
    url_q="$(set_param "$base_url" "ratios" "$ratio")"
    page="$(http -b GET "$url_q" || true)"
    hrefs="$(grep -oP '<a[^>]+class="preview"[^>]+href="\K[^"]+' <<<"$page" | awk '!seen[$0]++' | head -n "$POOL_SIZE")"
  fi

  if [[ -z "$hrefs" ]]; then
    echo "[refill] ERROR: no preview links found for ratio=$ratio"
    return 2
  fi

  local max_parallel="${WALLPAPER_MAX_PARALLEL:-3}"
  local pids=() ok=0
  while IFS= read -r href; do
    [[ -z "$href" ]] && continue
    local preview_url
    preview_url="$(make_absolute "$url_q" "$href")"
    while (( $(jobs -rp | wc -l) >= max_parallel )); do
      wait -n
    done
    download_one "$preview_url" "$ratio" &
    pids+=($!)
  done <<<"$hrefs"

  for pid in "${pids[@]}"; do
    wait "$pid" && (( ++ok )) || true
  done
  echo "[refill] done: ${ok}/${#pids[@]} images cached"
  (( ok > 0 ))
}

count_cache() {
  local ratio="$1"
  ls -1 "$CACHE_DIR/${ratio}_"* 2>/dev/null | wc -l
}

pop_cache() {
  local ratio="$1"
  ls -1 "$CACHE_DIR/${ratio}_"* 2>/dev/null | sort | head -n1
}

# Kick a detached background refill (no-op if one is already running)
trigger_refill() {
  local url="$1" ratio="$2" atleast="$3"
  local lockdir="$CACHE_DIR/.refill.lock"
  if mkdir "$lockdir" 2>/dev/null; then
    setsid bash -c "\"$0\" --__refill \"$url\" \"$ratio\" \"$atleast\"; rmdir \"$lockdir\"" \
      >>"$CACHE_DIR/refill.log" 2>&1 </dev/null &
    disown
    echo "Pool low, background refill triggered"
  fi
}

# --- modo refill: solo llenar cache y salir ---------------------------------
if (( REFILL_MODE )); then
  refill_cache "$REFILL_URL" "$REFILL_RATIO" "$REFILL_ATLEAST"
  exit $?
fi

# --- rofi prompt (modo opcional) --------------------------------------------
if (( PROMPT_MODE )); then
  query="$(printf "" | rofi -dmenu -theme catppuccin -p "Search term")" || true
  if [[ -n "$query" ]]; then
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

# --- consumir del pool (fetch solo si está vacío), por orientación ----------
port_atleast="${port_w}x${port_h}"
land_atleast="${land_w}x${land_h}"

PORT_FILE=""
LAND_FILE=""

if (( port_count > 0 )); then
  if (( $(count_cache portrait) == 0 )); then
    echo "Cache portrait vacía, fetch sync..."
    refill_cache "$URL" portrait "$port_atleast" || refill_cache "$URL" portrait ""
  fi
  PORT_FILE="$(pop_cache portrait)"
  if [[ -z "$PORT_FILE" ]]; then
    echo "ERROR: no se pudo obtener wallpaper portrait"
    exit 4
  fi
  remaining=$(( $(count_cache portrait) - 1 ))
  (( remaining <= 1 )) && trigger_refill "$URL" portrait "$port_atleast"
fi

if (( land_count > 0 )); then
  if (( $(count_cache landscape) == 0 )); then
    echo "Cache landscape vacía, fetch sync..."
    refill_cache "$URL" landscape "$land_atleast" || refill_cache "$URL" landscape ""
  fi
  LAND_FILE="$(pop_cache landscape)"
  if [[ -z "$LAND_FILE" ]]; then
    echo "ERROR: no se pudo obtener wallpaper landscape"
    exit 4
  fi
  remaining=$(( $(count_cache landscape) - 1 ))
  (( remaining <= 1 )) && trigger_refill "$URL" landscape "$land_atleast"
fi

# --- apply with hyprpaper ----------------------------------------------------
for i in "${!MON_NAMES[@]}"; do
  m="${MON_NAMES[$i]}"
  case "${MON_RATIO[$i]}" in
    portrait)  f="$PORT_FILE" ;;
    landscape) f="$LAND_FILE" ;;
  esac
  hyprctl hyprpaper wallpaper "$m,$f"
done

echo "Done:"
for i in "${!MON_NAMES[@]}"; do
  case "${MON_RATIO[$i]}" in
    portrait)  f="$PORT_FILE" ;;
    landscape) f="$LAND_FILE" ;;
  esac
  echo "  ${MON_NAMES[$i]} (${MON_RATIO[$i]}) -> $f"
done

[[ -n "$PORT_FILE" ]] && rm -f "$PORT_FILE"
[[ -n "$LAND_FILE" ]] && rm -f "$LAND_FILE"

# set-theme "$PORT_FILE"
