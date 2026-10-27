-- Import your programs table (assuming the file is named programs.lua)
local p = require("modules.programs.programs")

local mainMod = "SUPER"

--------------------------
----   SYSTEM BINDS   ----
--------------------------
hl.bind(mainMod .. "+ W",       hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exit())
hl.bind(mainMod .. "+ T",       hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. "+ P",       hl.dsp.window.pseudo())
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.window.set_prop({ prop = "opaque", value = "toggle" }))
hl.bind(mainMod .. "+ F",       hl.dsp.window.fullscreen(0))
hl.bind(mainMod .. "+ Q",       hl.dsp.global("quickshell:toggle-power-menu"))

--------------------------
----     PROGRAMS     ----
--------------------------
hl.bind(mainMod .. "+ return",       hl.dsp.exec_cmd(p.terminal))
hl.bind(mainMod .. "+ SHIFT + return", hl.dsp.exec_cmd(p.terminal .. ' --class="term.float"'))
hl.bind(mainMod .. "+ E",            hl.dsp.exec_cmd(p.fileManager))
hl.bind(mainMod .. "+ M",            hl.dsp.exec_cmd(p.musicterm))
hl.bind(mainMod .. "+ space",        hl.dsp.global('quickshell:toggle-run-menu'))
hl.bind(mainMod .. "+ B",            hl.dsp.exec_cmd(p.browser))
hl.bind(mainMod .. "+ O",            hl.dsp.exec_cmd(p.notes))
hl.bind(mainMod .. "+ V",            hl.dsp.exec_cmd(p.terminal .. ' --class="clipse" -e clipse'))

--------------------------
----    NAVIGATION    ----
--------------------------
local dirs = { H = "left", J = "down", K = "up", L = "right" }

for key, dir in pairs(dirs) do
    -- Focus
    hl.bind(mainMod .. "+" .. key, hl.dsp.focus({ direction = dir }))
    -- Swap
    hl.bind(mainMod .. "+ CTRL +" .. key, hl.dsp.window.swap({ direction = dir }))
end

-- Move Windows (including Monitor moves)
hl.bind(mainMod .. "+ SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. "+ SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. "+ SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. "+ SHIFT + L", hl.dsp.window.move({ direction = "right" }))

--------------------------
----    WORKSPACES    ----
--------------------------
for i = 1, 10 do
    local key = i % 10
    -- Switch to workspace
    hl.bind(mainMod .. "+ " .. key, hl.dsp.focus({ workspace = i }))
    -- Move window to workspace
    hl.bind(mainMod .. "+ SHIFT +" .. key, hl.dsp.window.move({ workspace = i }))
end

-- Workspace Scrolling
hl.bind(mainMod .. "+ left",  hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. "+ right", hl.dsp.focus({ workspace = "m+1" }))

-- Agent Workspace (super + A)
-- Hyprland no tiene "special workspace por monitor": al togglear, el special
-- se reasigna al monitor con foco (CMonitor::setSpecialWorkspace hace
-- pWorkspace->m_monitor = m_self) y TODAS las ventanas se van con el,
-- re-tileadas con el layout y el tamano del monitor nuevo.
-- Fix: el toggle siempre se ejecuta estando en el monitor dueno del special,
-- que se declara en modules/hardware/monitors.local.lua (archivo local).
-- Si ahi no se declara, se usa el comportamiento default de Hyprland.
local agentsWsName = "agents"
local agentsMonitor = require("modules.hardware.monitors").agents_monitor

-- monitor en el que esta abierto el special, o nil si esta cerrado
local function agentsOpenOn()
    for _, mon in ipairs(hl.get_monitors()) do
        local special = mon.active_special_workspace
        if special and special.name == "special:" .. agentsWsName then
            return mon
        end
    end
    return nil
end

local function toggleAgents()
    local owner = agentsMonitor and hl.get_monitor(agentsMonitor) or nil
    if not owner then
        -- sin monitor configurado (o desconectado): comportamiento default
        hl.dispatch(hl.dsp.workspace.toggle_special(agentsWsName))
        return
    end

    local prev = hl.get_active_monitor()
    local prevName = prev and prev.name
    local away = prevName ~= nil and prevName ~= agentsMonitor
    local openOn = agentsOpenOn()

    -- cerrado: abrirlo en el monitor dueno
    if not openOn then
        if away then
            hl.dispatch(hl.dsp.focus({ monitor = agentsMonitor }))
        end
        hl.dispatch(hl.dsp.workspace.toggle_special(agentsWsName))
        return
    end

    -- abierto en el dueno: cerrarlo y volver a donde estabamos
    if openOn.id == owner.id then
        if away then
            hl.dispatch(hl.dsp.focus({ monitor = agentsMonitor }))
        end
        hl.dispatch(hl.dsp.workspace.toggle_special(agentsWsName))
        if away then
            hl.dispatch(hl.dsp.focus({ monitor = prevName }))
        end
        return
    end

    -- abierto en otro monitor (se lo robaron): traerlo de vuelta al dueno
    hl.dispatch(hl.dsp.focus({ monitor = agentsMonitor }))
    hl.dispatch(hl.dsp.workspace.toggle_special(agentsWsName))
end

hl.bind(mainMod .. "+ A", toggleAgents)
hl.bind(mainMod .. "+ SHIFT + A", hl.dsp.window.move({ workspace = "special:" .. agentsWsName }))

--------------------------
----    WALLPAPER     ----
--------------------------
local scriptPath = "/home/cuini/.config/hypr/scripts/"

hl.bind(mainMod .. "+ SHIFT + W", hl.dsp.exec_cmd(scriptPath .. 'randomize-wallpaper.sh "/home/cuini/Pictures/wallpapers/rotation/"'))
hl.bind(mainMod .. "+ SHIFT + F", hl.dsp.exec_cmd(scriptPath .. 'fetch-wallpaper.sh "https://wallhaven.cc/search?categories=110&purity=100&sorting=random&order=desc&ai_art_filter=1"'))
hl.bind(mainMod .. "+ CTRL + ALT + S", hl.dsp.exec_cmd(scriptPath .. "save-wallpaper.sh"))
hl.bind(mainMod .. "+ SHIFT + CTRL + ALT + A", hl.dsp.exec_cmd(scriptPath .. "adapt-wallpaper.sh"))
hl.bind(mainMod .. "+ SHIFT + CTRL + ALT + U", hl.dsp.exec_cmd(scriptPath .. "unadapt-wallpaper.sh"))

--------------------------
----    MULTIMEDIA    ----
--------------------------
-- Audio and Brightness (el = locked + repeat)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl s 10%+"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"))

-- Media Controls (l = locked)
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"))

--------------------------
----   SCREENSHOTS    ----
--------------------------
hl.bind(mainMod .. "+ S",       hl.dsp.exec_cmd("hyprshot -m window --clipboard-only"))
hl.bind(mainMod .. "+ SHIFT + S", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))

--------------------------
----   MOUSE BINDS    ----
--------------------------
hl.bind(mainMod .. "+ mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. "+ mouse:273", hl.dsp.window.resize(), { mouse = true })

-------------------------
---    KB BINDS ---------
-------------------------
hl.bind("ALT + N", hl.dsp.exec_cmd("wtype ñ"))
