#!/usr/bin/env bash

WALLPAPER_DIR="$1"
SLEEP="${2:-0}"
CURRENT_WALL=$(hyprctl hyprpaper listloaded)

# Sleep if needed
sleep $SLEEP

# Get a random wallpaper that is not the current one
WALLPAPER=$(find -L "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)

# Apply the selected wallpaper
hyprctl hyprpaper reload ,"$WALLPAPER"
