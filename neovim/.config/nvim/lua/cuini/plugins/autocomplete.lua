return {
	{ -- Autocompletion
		"saghen/blink.cmp",
		event = "VimEnter",
		dependencies = {
			"saghen/blink.lib",
			-- Snippets
			"rafamadriz/friendly-snippets",
			-- lazydev
			"folke/lazydev.nvim",
		},
		version = "1.*",
		build = function()
			-- build the fuzzy matcher, wait up to 60 seconds
			-- you can use `gb` in `:Lazy` to rebuild the plugin as needed
			require("blink.cmp").build():wait(60000)
		end,
		--- @module 'blink.cmp'
		--- @type blink.cmp.Config
		opts = {
			keymap = {
				preset = "default",
			},

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			completion = {
				-- By default, you may press `<c-space>` to show the documentation.
				-- Optionally, set `auto_show = true` to show the documentation after a delay.
				documentation = { auto_show = true, auto_show_delay_ms = 500 },
				list = {
					selection = {
						preselect = false,
					},
				},
			},

			sources = {
				default = { "lsp", "path", "snippets", "lazydev" },
				providers = {
					lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
				},
			},

			-- Blink.cmp includes an optional, recommended rust fuzzy matcher,
			-- which automatically downloads a prebuilt binary when enabled.
			--
			-- By default, we use the Lua implementation instead, but you may enable
			-- the rust implementation via `'prefer_rust_with_warning'`
			--
			-- See :h blink-cmp-config-fuzzy for more information
			fuzzy = {
				sorts = {
					-- (optionally) always prioritize exact matches
					-- 'exact',

					-- pass a function for custom behavior
					-- function(item_a, item_b)
					--   return item_a.score > item_b.score
					-- end,

					"score",
					"sort_text",
				},
				implementation = "prefer_rust_with_warning",
			},

			-- Shows a signature help window while you type arguments for a function
			signature = { enabled = true },
		},
	},
}
