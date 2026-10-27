return {
	"lewis6991/gitsigns.nvim", -- git integration
	event = "BufReadPre",
	opts = {
		-- Every sign is a distinct glyph, so hunk type is readable without
		-- relying on the highlight colour. Two families:
		--   unstaged -> ASCII operators
		--   staged   -> box-drawing crosses
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "±" },
			untracked = { text = "┆" },
		},
		signs_staged = {
			add = { text = "┿" },
			change = { text = "╫" },
			delete = { text = "╧" },
			topdelete = { text = "╤" },
			changedelete = { text = "╪" },
		},
		signs_staged_enable = true,

		-- Show hunks for files git does not track yet.
		attach_to_untracked = true,

		on_attach = function(bufnr)
			local gs = require("gitsigns")
			local function map(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
			end

			-- Navigation. Falls through to ]c/[c inside a real diff split.
			map("n", "]h", function()
				if vim.wo.diff then
					vim.cmd.normal({ "]c", bang = true })
				else
					gs.nav_hunk("next")
				end
			end, "Next Hunk")

			map("n", "[h", function()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					gs.nav_hunk("prev")
				end
			end, "Prev Hunk")

			-- Staging. stage_hunk toggles: with no unstaged hunk under the
			-- cursor it inverts and unstages the staged one instead.
			--
			-- Staging removes the hunk from the diff against the index, so the
			-- quickfix list goes stale. Rebuild it after every staging action --
			-- refresh_qflist() no-ops unless our list is on screen.
			local function restage(err)
				if err then
					return vim.schedule(function()
						vim.notify("gitsigns: " .. err, vim.log.levels.ERROR)
					end)
				end
				require("cuini.hunks").refresh_qflist()
			end

			map("n", "<leader>gs", function()
				gs.stage_hunk(nil, nil, restage)
			end, "Stage/Unstage Hunk")
			map("n", "<leader>gS", function()
				gs.stage_buffer(restage)
			end, "Stage Buffer")
			map("n", "<leader>gu", function()
				gs.undo_stage_hunk(restage)
			end, "Undo Last Stage (this session)")

			map("v", "<leader>gs", function()
				gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }, nil, restage)
			end, "Stage Selection")

			-- Inspect
			map("n", "<leader>gp", gs.preview_hunk, "Preview Hunk")
			map("n", "<leader>gb", function()
				gs.blame_line({ full = true })
			end, "Blame Line")
			map("n", "<leader>gB", gs.toggle_current_line_blame, "Toggle Inline Blame")
			map("n", "<leader>gd", gs.diffthis, "Diff This")
			map("n", "<leader>gD", function()
				gs.diffthis("~")
			end, "Diff This (HEAD~)")

			-- Lists
			map("n", "<leader>gl", function()
				gs.setqflist("all", { open = true })
			end, "All Hunks -> Quickfix")
		end,
	},
}
