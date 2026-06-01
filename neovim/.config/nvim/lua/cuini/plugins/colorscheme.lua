return {
	{
		"AvengeMedia/base46",
		lazy = false, -- We need colors immediately on startup
		priority = 1000, -- Force it to load before any UI elements like lualine
		config = function()
			-- 1. Tell base46 where to store its compiled highlight files
			vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46/"

			-- Ensure the cache directory actually exists
			local uv = vim.uv or vim.loop
			if not uv.fs_stat(vim.g.base46_cache) then
				vim.fn.mkdir(vim.g.base46_cache, "p")
			end

			-- 2. Try to load the Matugen-generated theme
			-- This assumes Matugen outputs to: ~/.config/nvim/lua/matugen_theme.lua
			local ok, _ = pcall(require, "cuini.matugen")

			-- 3. Fallback just in case Matugen hasn't generated the file yet
			if not ok then
				vim.notify("Matugen theme missing. Generating default base46 cache...", vim.log.levels.WARN)

				-- Force a default theme so your editor isn't completely broken
				local base46 = require("base46")
				base46.theme_tables["default"] = base46.get_builtin_theme("gruvbox")
				base46.load("default")
			end
		end,
	},
}
