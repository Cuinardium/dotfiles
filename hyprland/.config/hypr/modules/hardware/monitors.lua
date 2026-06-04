local host = io.popen("hostname"):read("*l")

if host == "asahi" then
    hl.monitor({
        output = "eDP-1",
        mode = "2560x1600",
        position = "0x0",
        scale = "1.333333",
    })

    hl.config({
        xwayland = {
            force_zero_scaling = true
        }
    })

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
else
    hl.monitor({
        output = "HDMI-A-1",
        mode = "2560x1080",
        position = "1080x485",
        scale = "1",
    })

    hl.monitor({
        output = "DP-3",
        mode = "preferred",
        position = "0x0",
        scale = "auto",
        transform = 3,
    })

    for i = 1, 5 do
        hl.workspace_rule({
            workspace = i,
            monitor = "DP-3",
            persistent = true,
        })
    end

    for i = 6, 10 do
        hl.workspace_rule({
            workspace = i,
            monitor = "HDMI-A-1",
            persistent = true,
        })
    end

    hl.workspace_rule({
        workspace = "special:agents",
        monitor = "HDMI-A-1",
        layout = "scrolling"
    })
end
