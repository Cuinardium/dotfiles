# Hyprland

## Machine-local hardware config

Two files must be created manually on each machine (gitignored):

**`~/.config/hypr/modules/hardware/monitors.local.lua`**
```lua
hl.monitor({
    output = "HDMI-A-1",
    mode = "2560x1080",
    position = "1080x485",
    scale = "1",
})

for i = 1, 5 do
    hl.workspace_rule({ workspace = i, monitor = "HDMI-A-1", persistent = true })
end

hl.workspace_rule({ workspace = "special:agents", monitor = "HDMI-A-1", layout = "scrolling" })
```

**`~/.config/hypr/modules/hardware/input.local.lua`**
```lua
hl.device({
    name = "your-keyboard-name",  -- find with: hyprctl devices
})

hl.device({
    name = "your-mouse-name",
    sensitivity = -0.5
})
```

For Apple Silicon (Asahi), see the `input.lua` history for the trackpad + gesture config.
