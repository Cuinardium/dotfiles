local mainMod  = "SUPER"
local cache    = os.getenv("HOME") .. "/.cache/hyprland/zen_mode"

local active = {
    decoration = {
        active_opacity   = 1.0,
        inactive_opacity = 0,
        blur             = { enabled = false },
    },
}

local inactive = {
    decoration = {
        active_opacity   = 0.9,
        inactive_opacity = 0.9,
        blur             = { enabled = true },
    },
}

local function read_state()
    local f = io.open(cache, "r")
    if not f then return false end
    local v = f:read("*l")
    f:close()
    return v == "enabled"
end

local function write_state(v)
    local f = io.open(cache, "w")
    if f then
        f:write(v and "enabled" or "disabled")
        f:close()
    end
end

local enabled = read_state()
hl.config(enabled and active or inactive)

local function toggle()
    enabled = not enabled
    write_state(enabled)
    os.execute("hyprctl reload &")
    os.execute("hyprctl dispatch \"hl.dsp.global('quickshell:toggle-bar')\" &")
end

hl.bind(mainMod .. "+ SHIFT + I", toggle)
