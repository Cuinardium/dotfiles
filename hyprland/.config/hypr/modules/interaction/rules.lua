--------------------------------
----      WINDOW RULES      ----
--------------------------------

-- Clipse (Clipboard Manager)
hl.window_rule({
    name = "clipse",
    match = { class = "^(clipse)$" },
    float = true,
    size = "622 652",
    stay_focused = true,
})

-- MPV Viewer
hl.window_rule({
    name = "mpv-viewer",
    match = { class = "^(mpv)$" },
    float = true,
    opaque = true,
})

-- Lofi Player
hl.window_rule({
    name = "mini-player",
    match = { class = "^(lofi.player)$" },
    float = true,
    size = "480 240",
})

-- File Explorer
hl.window_rule({
    name = "file-explorer",
    match = { class = "^(yazi|xdg-desktop-portal-gtk)$" },
    float = true,
    size = "800 700",
    center = false,
    pin = true,
})

-- Image Viewer
hl.window_rule({
    name = "image-viewer",
    match = { class = "^(feh)$" },
    float = true,
    size = "800 700",
    center = true,
    opaque = true,
})

-- Floating Terminals
hl.window_rule({
    name = "floating-terminal",
    match = { class = "^(term.float)$" },
    float = true,
    center = true,
    size = "800 500",
})

-- Opaque Tag
hl.window_rule({
    name = "opaque",
    match = { tag = "opaque" },
    opaque = true,
})

-- Global App Fixes
hl.window_rule({
    name = "global-app-fixes",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- SDDM / Empty Workspace Rule
hl.window_rule({
    name = "emptym",
    match = { 
        workspace = "emptym",
        class = "^(sddm-greeter)$" 
    },
    fullscreen = true,
    stay_focused = true,
    decorate = false,
    no_anim = true,
    border_size = 0,
    no_dim = true,
    rounding = 0,
    no_shadow = true,
})

-- Agents to special workspaces
hl.window_rule({
    name = "agents",
    match = { class = "^(agent)$"},
    workspace = "special:agents silent",
    float = true,
    size = {"(monitor_w*0.3)", "(monitor_h*0.75)"},
    center = true
})

--------------------------------
----      LAYER RULES       ----
--------------------------------

hl.layer_rule({
    name = "rofi-slide-bottom",
    match = { namespace = "rofi" },
    animation = "slide bottom",
})

hl.layer_rule({
    name = "quickshell blur",
    match = { namespace = "quickshell" },
    blur = true,
    ignore_alpha = 0.1
})

--------------------------------
----        XWAYLAND        ----
--------------------------------

hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})
