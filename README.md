# dotfiles

Personal configurations for my development environment both for `macOS` and `arch`.

## Arch (catpuccin themed)

![arch-tiling-preview](previews/arch-tiling-preview.png)

![arch-floating-preview](previews/arch-floating-preview.png)

## Mac (gruvbox themed)

![mac-preview](previews/mac-preview.png)


## Considerations

Some `macOS` configurations conflict with the ones used for `arch`. Use the `mac` branch to override the `arch` settings.

For `hyprpanel` weather module a [weatherapi](https://www.weatherapi.com/) api key is needed. See [here](https://www.weatherapi.com/). 
The current config expects one in the `hyprpanel` config directory.

For `sketchybar` weather module a [weatherapi](https://www.weatherapi.com/) api key is also needed. 
Create a file called `weather.env.sh` in `.config/sketchybar/scripts` that defines two variables:
- **KEY**: which should be your **API** key
- **CITY**: which is the city to show the weather for.

See more details [here](https://github.com/CriticalElement/dotfiles). 

## Credits

- [gh0stzk/dotfiles](https://github.com/gh0stzk/dotfiles) (old bspwm config)
- [LierB/fastfetch](https://github.com/LierB/fastfetch) (arch fetch preset)
- [mac rice](https://www.reddit.com/r/unixporn/comments/jupmda/aquayabai_a_fun_colorful_rice_to_brighten_my/) (mac rice inspiration)
- [adi1090x/rofi](https://github.com/adi1090x/rofi?tab=readme-ov-file) (rofi theme inspiration)
- [pivoshenko](https://github.com/pivoshenko/catppuccin-startpage) (arch firefox startpage)
- [ninepointeight](https://codeberg.org/nine_point_eight/config-files) (mac firefox startpage)
- [CriticalElement](https://github.com/CriticalElement/dotfiles) (mac status bar inspiration)
