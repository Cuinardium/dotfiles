#!/usr/bin/env bash

WALLPAPER_DIR="$1"
CURRENT_WALL=$(hyprctl hyprpaper listloaded)

# Get a random wallpaper that is not the current one
WALLPAPER=$(find -L "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)

echo $WALLPAPER
echo $WALLPAPER_DIR
echo $CURRENT_WALL

echo $(find "$WALLPAPER_DIR")

# Apply the selected wallpaper
hyprctl hyprpaper reload ,"$WALLPAPER"
