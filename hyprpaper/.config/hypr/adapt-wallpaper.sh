#!/bin/bash
set -euo pipefail

# Opcional: paths de entrada (por defecto usa los generados por tu script anterior)
LAND_SRC="${1:-/tmp/wallpaper_landscape}"
PORT_SRC="${2:-/tmp/wallpaper_portrait}"

# Paths de salida (convertidos/adaptados)
LAND_ADAPT_JPG="/tmp/wallpaper_landscape-adapted.jpg"
PORT_ADAPT_JPG="/tmp/wallpaper_portrait-adapted.jpg"
LAND_ADAPT="/tmp/wallpaper_landscape-adapted"
PORT_ADAPT="/tmp/wallpaper_portrait-adapted"

require() {
  command -v "$1" >/dev/null 2>&1 || { echo "ERROR: missing command '$1'"; exit 1; }
}

require "jq"
require "hyprctl"
require "hyprpaper"
require "gowall"

# --- validar fuentes ---------------------------------------------------------
[[ -f "$LAND_SRC" ]] || { echo "ERROR: landscape source not found: $LAND_SRC"; exit 2; }
[[ -f "$PORT_SRC" ]] || { echo "ERROR: portrait source not found:  $PORT_SRC"; exit 3; }

# --- convertir con gowall (tema catppuccin) ---------------------------------
# Copiamos con extensión .jpg para que gowall procese sin drama de formato
cp -f "$LAND_SRC" "$LAND_ADAPT_JPG"
cp -f "$PORT_SRC" "$PORT_ADAPT_JPG"

# Nota: --batch procesa el archivo y deja el resultado en --output
gowall convert --batch "$LAND_ADAPT_JPG" --output /tmp/ -t catppuccin
gowall convert --batch "$PORT_ADAPT_JPG" --output /tmp/ -t catppuccin

# Dejar sin extensión (como usabas antes)
mv -f "$LAND_ADAPT_JPG" "$LAND_ADAPT"
mv -f "$PORT_ADAPT_JPG" "$PORT_ADAPT"

# --- aplicar con hyprpaper ---------------------------------------------------
hyprctl hyprpaper unload all || true

# Preload de ambos
hyprctl hyprpaper preload "$LAND_ADAPT"
hyprctl hyprpaper preload "$PORT_ADAPT"

# Monitores
readarray -t MONS < <(hyprctl -j monitors | jq -r '.[].name')
((${#MONS[@]})) || { echo "ERROR: no monitors found"; exit 4; }

# Primer monitor -> landscape; resto -> portrait
for i in "${!MONS[@]}"; do
  m="${MONS[$i]}"
  if [[ "$i" -eq 0 ]]; then
    hyprctl hyprpaper wallpaper "$m,$LAND_ADAPT"
  else
    hyprctl hyprpaper wallpaper "$m,$PORT_ADAPT"
  fi
done

echo "OK: ${MONS[0]}=LANDSCAPE (${LAND_ADAPT}), ${#MONS[@]}-1 others=PORTRAIT (${PORT_ADAPT})"
