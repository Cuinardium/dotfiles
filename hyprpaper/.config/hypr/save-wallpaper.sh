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


cp_no_overwrite /tmp/wallpaper /home/cuini/Pictures/wallpapers/.fetched/wallpaper
cp_no_overwrite /tmp/wallpaper-adapted /home/cuini/Pictures/wallpapers/.fetched/wallpaper-adapted
