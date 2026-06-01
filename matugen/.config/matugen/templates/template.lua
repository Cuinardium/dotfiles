-- ~/.config/matugen/templates/nvim-theme.lua
-- Heavily based on AvengeMedia/DankMaterialShell
-- https://github.com/AvengeMedia/DankMaterialShell/blob/master/quickshell/matugen/templates/neovim-colors.lua

local present, base46 = pcall(require, "base46")
if not present then
	return
end

-- 1. Matugen injects light/dark mode here based on your system preference
local is_light_mode = { { mode == "light" } }
if is_light_mode then
	vim.o.background = "light"
else
	vim.o.background = "dark"
end

-- 2. Define your preferences directly (no DMS settings file needed)
local theme_base = "kanagawa" -- The base theme to use
local harmony = 0.5 -- How strongly to tint the theme (0.0 to 1.0)
local theme_name = "matugen_harmonized"
local current_file_path = debug.getinfo(1, "S").source:sub(2)

-- 3. Live Reloading Watcher (Keep this, it's great!)
if not _G._matugen_theme_watcher then
	local uv = vim.uv or vim.loop
	_G._matugen_theme_watcher = { uv.new_fs_event(), reload_timer = uv.new_timer() }

	local function handler()
		_G._matugen_theme_watcher.reload_timer:stop()
		_G._matugen_theme_watcher.reload_timer:start(
			100,
			0,
			vim.schedule_wrap(function()
				-- 1. Pause the watcher so we don't trigger infinite loops while reloading
				_G._matugen_theme_watcher[1]:stop()

				-- 2. Wipe the old theme from base46's memory
				base46.theme_tables[theme_name] = nil

				-- 3. Clear this specific module from Neovim's package cache
				package.loaded["cuini.matugen"] = nil

				-- 4. Re-evaluate the file. This forces Lua to read the new hex codes
				-- Matugen just wrote, and it will run base46.load() at the bottom of the script.
				require("cuini.matugen")

				-- 5. Broadcast the colorscheme change
				vim.api.nvim_exec_autocmds("ColorScheme", { pattern = theme_name })

				-- 6. Force Neovim to redraw the screen with the new highlights
				vim.cmd("redraw!")

				-- 7. Restart the watcher so the next wallpaper change is caught
				_G._matugen_theme_watcher[1]:start(current_file_path, {}, handler)
			end)
		)
	end
	_G._matugen_theme_watcher[1]:start(current_file_path, {}, handler)
end

-- 4. Calculate the theme using Matugen variables
-- NUKE THE CACHE: Force base46 to forget the old compiled files on disk
if vim.fn.isdirectory(vim.g.base46_cache) == 1 then
	vim.fn.delete(vim.g.base46_cache, "rf")
	vim.fn.mkdir(vim.g.base46_cache, "p")
end

-- Now base46 is forced to read your new table
local builtin = vim.deepcopy(assert(base46.get_builtin_theme(theme_base)))
local source_color = "{{colors.primary.default.hex}}"
local bg_color = "{{colors.surface.default.hex}}"

if base46.theme_harmonize then
	local harmonized = base46.theme_harmonize(builtin, source_color, harmony)

	-- NOTE: If you want the TRUE gruvbox/catppuccin background,
	-- comment out the next line! Otherwise, it forces the Material background.
	harmonized = base46.theme_set_bg(harmonized, bg_color)

	base46.theme_tables[theme_name] = harmonized
else
	base46.theme_tables[theme_name] = builtin
end

base46.load(theme_name)
vim.g.colors_name = theme_name
