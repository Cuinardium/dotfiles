hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

local home = os.getenv("HOME")
local path = os.getenv("PATH")
hl.env("PATH", home .. "/.local/bin:" .. path)

-- # --- Cursor Themes ---
hl.env("HYPRCURSOR_THEME", "Nordzy-hyprcursors")
hl.env("HYPRCURSOR_SIZE", "24")
-- hl.env("XCURSOR_THEME", "BreezeX-RoséPine")
-- hl.env("XCURSOR_SIZE", "24")

-- # --- XDG Desktop Portal ---
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

