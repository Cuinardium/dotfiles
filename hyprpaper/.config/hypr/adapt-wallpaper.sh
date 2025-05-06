#!/bin/bash

cp /tmp/wallpaper /tmp/wallpaper-adapted.jpg
gowall convert --batch /tmp/wallpaper-adapted.jpg --output /tmp/ -t catppuccin
mv /tmp/wallpaper-adapted.jpg /tmp/wallpaper-adapted
hyprctl hyprpaper reload , /tmp/wallpaper-adapted
