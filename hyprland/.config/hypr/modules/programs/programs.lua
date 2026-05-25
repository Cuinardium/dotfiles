---@class MyPrograms
---@field terminal string The primary terminal emulator
---@field fileManager string Terminal-based file manager (yazi)
---@field musicterm string Lofi music player instance
---@field browser string Web browser command
---@field notes string Note-taking application command

local terminal = "kitty --single-instance"

---@type MyPrograms
local programs = {
    terminal = terminal,
    fileManager = terminal .. " --class=yazi -e yazi",
    musicterm = terminal .. " --class=lofi.player --title=\"Lofi\" -e /home/cuini/.bin/lofi.sh --instance-group=music",
    browser = "firefox",
    notes = "obsidian",
}

return programs
