-- Telescope picker over git hunks.
--
-- Items come from gitsigns' own quickfix builder, which handles repo discovery,
-- the index blob, untracked files and `config.base`. Preview prefers gitsigns'
-- in-memory hunk bodies (attached buffers, no subprocess) and falls back to a
-- per-file `git diff` job for everything else.

local M = {}

--- Resolve a quickfix item to an absolute path.
--- `vim.fn.getqflist()` normalises `filename` away, so always go via the bufnr.
--- @param item table
--- @return string?
local function item_path(item)
	if not item.bufnr or item.bufnr == 0 then
		return nil
	end
	local name = vim.api.nvim_buf_get_name(item.bufnr)
	return name ~= "" and name or nil
end

--- Hunk body straight from gitsigns' cache. Attached buffers only.
--- @param bufnr integer
--- @param lnum integer
--- @return string[]?
local function cached_hunk_lines(bufnr, lnum)
	local ok, gs = pcall(require, "gitsigns")
	if not ok then
		return nil
	end
	local hunks = gs.get_hunks(bufnr)
	if not hunks then
		return nil
	end
	for _, h in ipairs(hunks) do
		if h.added.start == lnum then
			-- `lines` is already prefixed with -/+; prepend the unified header
			return vim.list_extend({ h.head }, h.lines)
		end
	end
	return nil
end

--- Move the preview window onto the changed line.
--- `git diff -U3` merges nearby changes, so a hunk header's start rarely equals
--- the start gitsigns reported. Find the header whose new-side range *contains*
--- lnum, then walk the body tracking new-side line numbers.
local function scroll_to_hunk(winid, bufnr, lnum)
	if not vim.api.nvim_win_is_valid(winid) or not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end

	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local target

	for i, line in ipairs(lines) do
		local start, count = line:match("^@@ %-%S+ %+(%d+),?(%d*) @@")
		if start then
			start, count = tonumber(start), tonumber(count) or 1
			if lnum >= start and lnum < start + math.max(count, 1) then
				local cur = start
				for j = i + 1, #lines do
					local c = lines[j]:sub(1, 1)
					if c == "@" then
						break
					elseif c ~= "-" then -- context or addition: occupies a new-side line
						if cur == lnum then
							target = j
							break
						end
						cur = cur + 1
					end
				end
				target = target or i -- fall back to the header
				break
			end
		end
	end

	if not target then
		return
	end
	pcall(vim.api.nvim_win_set_cursor, winid, { target, 0 })
	pcall(vim.api.nvim_win_call, winid, function()
		vim.cmd("normal! zz")
	end)
end

local function make_previewer(opts, root)
	local previewers = require("telescope.previewers")
	local putils = require("telescope.previewers.utils")

	return previewers.new_buffer_previewer({
		title = "Hunk Diff",

		-- Cache key. Cached entries render from memory and never spawn a job,
		-- so keep the lnum in it: each hunk gets its own buffer.
		get_buffer_by_name = function(_, entry)
			return entry.path .. ":" .. entry.lnum
		end,

		define_preview = function(self, entry)
			-- Fast path: gitsigns has the body already.
			local lines = cached_hunk_lines(entry.bufnr, entry.lnum)
			if lines then
				vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
				putils.highlighter(self.state.bufnr, "diff", opts)
				return
			end

			-- Fallback: diff the single file, then scroll to the hunk.
			putils.job_maker({ "git", "--no-pager", "diff", "-U3", "--", entry.path }, self.state.bufnr, {
				value = entry.path,
				bufname = self.state.bufname,
				cwd = root,
				callback = function(bufnr)
					if not vim.api.nvim_buf_is_valid(bufnr) then
						return
					end
					putils.highlighter(bufnr, "diff", opts)
					scroll_to_hunk(self.state.winid, bufnr, entry.lnum)
				end,
			})
		end,
	})
end

local function open_picker(items, opts)
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values

	local root = vim.fs.root(0, ".git") or vim.uv.cwd()

	local results = {}
	for _, item in ipairs(items) do
		local path = item_path(item)
		if path then
			results[#results + 1] = { path = path, bufnr = item.bufnr, lnum = item.lnum, text = item.text }
		end
	end

	if #results == 0 then
		return vim.notify("No hunks", vim.log.levels.INFO)
	end

	pickers
		.new(opts, {
			prompt_title = "Git Hunks (" .. #results .. ")",
			finder = finders.new_table({
				results = results,
				entry_maker = function(e)
					local rel = vim.fn.fnamemodify(e.path, ":.")
					return {
						value = e,
						path = e.path,
						filename = e.path, -- lets <CR> and send_to_qflist work unchanged
						bufnr = e.bufnr,
						lnum = e.lnum,
						col = 1,
						ordinal = rel .. " " .. e.text,
						display = string.format("%s:%d  %s", rel, e.lnum, e.text),
					}
				end,
			}),
			sorter = conf.generic_sorter(opts),
			previewer = make_previewer(opts, root),
		})
		:find()
end

--- Rebuild the hunk quickfix list in place, keeping the cursor near where it
--- was. Only fires when the quickfix window is actually showing *our* list, so
--- staging never clobbers a list from :grep, LSP references, etc.
function M.refresh_qflist()
	local open = false
	for _, w in ipairs(vim.fn.getwininfo()) do
		if w.quickfix == 1 and w.loclist == 0 then
			open = true
			break
		end
	end
	if not open or vim.fn.getqflist({ title = 0 }).title ~= "Hunks" then
		return
	end

	local idx = vim.fn.getqflist({ idx = 0 }).idx

	local ok, gs = pcall(require, "gitsigns")
	if not ok then
		return
	end

	gs.setqflist("all", { open = false }, function()
		vim.schedule(function()
			local n = #vim.fn.getqflist()
			if n > 0 then
				-- empty list + `what` is the only valid shape for an idx-only write
				vim.fn.setqflist({}, "r", { idx = math.min(idx, n) })
			end
		end)
	end)
end

--- @param opts table? telescope opts; `target` is 'all'|'attached'|bufnr (default 'all')
function M.hunks(opts)
	opts = opts or {}
	local ok, gs = pcall(require, "gitsigns")
	if not ok then
		return vim.notify("gitsigns not available", vim.log.levels.ERROR)
	end

	-- NOTE: this replaces the quickfix list as a side effect -- gitsigns'
	-- builder is not exported, so populating qf is the only way to reach it.
	gs.setqflist(opts.target or "all", { open = false }, function(err)
		if err then
			return vim.schedule(function()
				vim.notify("gitsigns setqflist: " .. err, vim.log.levels.ERROR)
			end)
		end
		local items = vim.fn.getqflist()
		vim.schedule(function()
			open_picker(items, opts)
		end)
	end)
end

return M
