local scriptPath = "/home/cuini/.config/hypr/scripts/"
local wallpaperDir = "/home/cuini/Pictures/wallpapers/rotation"

hl.on("hyprland.start", function()
    -- System Services (hyprpaper is started by randomize-wallpaper.sh, which
    -- generates its config first so it comes up already on the right wallpaper)
    hl.exec_cmd("quickshell &")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")

    -- Wallpaper: a different one every session
    hl.exec_cmd(scriptPath .. 'randomize-wallpaper.sh "' .. wallpaperDir .. '"')

    -- Clipboard
    hl.exec_cmd("clipse -listen")

    -- Cursor Setup
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme BreezeX-RosePine-Linux")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size 24")

    -- XDG Desktop Portal settings
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    -- Voice dictation (Vocalinux). Hyprland does not process XDG autostart
    -- (~/.config/autostart), so the entry the app writes from its own settings
    -- is never launched here; we start it explicitly. No pgrep guard needed:
    -- vocalinux is single-instance and exits by itself if already running.
    hl.exec_cmd("vocalinux --start-minimized")
end)
