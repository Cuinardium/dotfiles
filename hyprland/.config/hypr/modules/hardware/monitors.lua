hl.monitor({
    output = "eDP-1",
    mode = "2560x1600",
    position = "0x0",
    scale = "1.333333",
})

-- Do not scale xwayland
hl.config({
    xwayland = {
        force_zero_scaling = true
    }
})

-- Workspaces
for i = 1, 5 do
    hl.workspace_rule({
        workspace = i,
        monitor = "eDP-1",
        persistent = true,
    })
end

hl.workspace_rule({
    workspace = "special:agents",
    monitor = "eDP-1",
    layout = "scrolling"
})
