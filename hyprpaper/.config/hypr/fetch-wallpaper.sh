#!/bin/bash

# 1. Set the starting URL
URL="$1"
CONVERT="$2"

# 2. Download the HTML and extract href from <a class="preview">
echo "getting first page"
preview_href=$(http -b "$URL" | grep -oP '<a[^>]+class="preview"[^>]+href="\K[^"]+' | head -n 1)

# Optional: make sure the URL is absolute
if [[ $preview_href != http* ]]; then
  preview_url="${URL%/}/$preview_href"
else
  preview_url="$preview_href"
fi

echo "Preview page: $preview_url"

# 3. Download the preview page and extract the image src from <img id="wallpaper">
echo "getting second page"
img_src=$(http -b "$preview_url" | grep -oP '<img[^>]+id="wallpaper"[^>]+src="\K[^"]+')

# Optional: make sure the image URL is absolute
if [[ $img_src != http* ]]; then
  base_url=$(echo "$preview_url" | grep -oE '^https?://[^/]+')
  img_url="$base_url/$img_src"
else
  img_url="$img_src"
fi

echo "Image URL: $img_url"

# 4. Download the image
curl -L "$img_url" -o /tmp/wallpaper

echo "Downloaded wallpaper.jpg"

# 5. convert to catppucin

if CONVERT; then
    mv /tmp/wallpaper /tmp/wallpaper.jpg
    gowall convert --batch /tmp/wallpaper.jpg --output /tmp/ -t catppuccin
    mv /tmp/wallpaper.jpg /tmp/wallpaper
fi

hyprctl hyprpaper reload , /tmp/wallpaper
