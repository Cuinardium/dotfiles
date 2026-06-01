#!/bin/bash
set -euo pipefail

DEST_DIR="/home/cuini/Pictures/wallpapers/.fetched"
mkdir -p "$DEST_DIR"

cp_no_overwrite() {
  src="$1"
  dest="$2"

  if [ ! -e "$dest" ]; then
    cp "$src" "$dest"
  else
    base="$dest"
    count=1
    while [ -e "${base}_$count" ]; do
      count=$((count + 1))
    done
    cp "$src" "${base}_$count"
  fi
}

# Landscape
cp_no_overwrite /tmp/wallpaper_landscape "$DEST_DIR/wallpaper_landscape"
cp_no_overwrite /tmp/wallpaper_landscape-adapted "$DEST_DIR/wallpaper_landscape-adapted"

# Portrait
cp_no_overwrite /tmp/wallpaper_portrait "$DEST_DIR/wallpaper_portrait"
cp_no_overwrite /tmp/wallpaper_portrait-adapted "$DEST_DIR/wallpaper_portrait-adapted"

echo "✅ Wallpapers copied to $DEST_DIR (with unique names if duplicates existed)"
