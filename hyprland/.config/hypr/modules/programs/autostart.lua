hl.on("hyprland.start", function()
    -- System Services
    hl.exec_cmd("quickshell & hyprpaper &")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")

    -- Scripts
    hl.exec_cmd("/home/cuini/.config/hypr/randomize-wallpaper.sh \"/home/cuini/.config/hypr/wallpapers\" 1")

    -- Clipboard
    hl.exec_cmd("clipse -listen")

    -- Cursor Setup
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme BreezeX-RosePine-Linux")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size 24")

    -- XDG Desktop Portal settings
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
end)
