local keymap = vim.keymap.set
local opts = { silent = true }

-- Remap leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- MiniFiles (Replacement for NvimTree)
keymap("n", "<leader>e", function()
    MiniFiles.open()
end, { desc = "Open File Browser" })

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)
keymap("n", "<C-w>", ":Bdelete<CR>", {silent = true, nowait = true})

-- Insert Mode Escape
keymap("i", "jk", "<ESC>", opts)

-- Visual Mode Indenting
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text (Visual/Block)
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Telescope & Navigation
local builtin = require("telescope.builtin")

-- Standard Search
keymap("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })

-- Search All (Includes Hidden and Gitignored)
keymap("n", "<leader>fA", function()
    builtin.find_files({ no_ignore = true, hidden = true })
end, { desc = "Find All Files (Ignored/Hidden)" })

keymap("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
keymap("n", "<leader>fw", function()
    builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({ height = 10, previewer = false }))
end, { desc = "Fuzzy Find in Buffer" })

keymap("n", "<leader>fs", "<cmd>Navbuddy<cr>", opts)
keymap("n", "<leader>fS", builtin.lsp_workspace_symbols, { desc = "LSP Symbols" })
keymap("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostics" })
keymap("n", "<leader>fa", vim.lsp.buf.code_action, { desc = "LSP Code Action" })
keymap("n", "<leader>fk", builtin.keymaps, { desc = "Search Keymaps" })
keymap("n", "<leader>fb", function()
    builtin.buffers(require("telescope.themes").get_dropdown({ height = 10 }))
end, { desc = "Search Buffers" })

-- Git. Buffer-local hunk/staging maps live in plugins/gitsigns.lua's on_attach.
keymap("n", "<leader>gh", function()
    require("cuini.hunks").hunks()
end, { desc = "Hunk Picker" })

keymap("n", "<leader>gg", builtin.git_status, { desc = "Git Status" })
keymap("n", "<leader>gf", builtin.git_files, { desc = "Git Files" })
keymap("n", "<leader>gc", builtin.git_commits, { desc = "Git Commits" })
keymap("n", "<leader>gC", builtin.git_bcommits, { desc = "Git Commits (buffer)" })
keymap("n", "<leader>gw", builtin.git_branches, { desc = "Git Branches" })

-- Quickfix
keymap("n", "<leader>gq", "<cmd>copen<CR>", { desc = "Open Quickfix" })
keymap("n", "<leader>gQ", "<cmd>cclose<CR>", { desc = "Close Quickfix" })
keymap("n", "]q", "<cmd>cnext<CR>zz", opts)
keymap("n", "[q", "<cmd>cprev<CR>zz", opts)

-- Formatting
keymap("n", "<leader>F", function()
    require("conform").format({ lsp_format = "fallback", async = true, timeout_ms = 1000 })
end, { desc = "Format Document" })

keymap("x", "<leader>F", function()
    -- Replicate conform's range_from_selection while still in visual mode
    -- so only the selected text is formatted. Falls back to marks '< and '>
    -- if visual mode has already been exited.
    local function get_range()
        local mode = vim.api.nvim_get_mode().mode
        if mode == "v" or mode == "V" or mode == "\22" then
            local start = vim.fn.getpos("v")
            local end_ = vim.fn.getpos(".")
            local s_row, s_col = start[2], start[3]
            local e_row, e_col = end_[2], end_[3]
            if s_row == e_row and e_col < s_col then
                s_col, e_col = e_col, s_col
            elseif e_row < s_row then
                s_row, e_row = e_row, s_row
                s_col, e_col = e_col, s_col
            end
            if mode == "V" then
                s_col = 1
                local lines = vim.api.nvim_buf_get_lines(0, e_row - 1, e_row, true)
                e_col = #(lines[1] or "") + 1
            end
            return { start = { s_row, s_col - 1 }, ["end"] = { e_row, e_col - 1 } }
        end
        -- Visual mode already left: use the '< and '> marks (1,0)-indexed via nvim_buf_get_mark)
        local s = vim.api.nvim_buf_get_mark(0, "<")
        local e = vim.api.nvim_buf_get_mark(0, ">")
        if s[1] > e[1] or (s[1] == e[1] and s[2] > e[2]) then
            s, e = e, s
        end
        -- Extend to full lines if last visual mode was linewise
        if vim.fn.visualmode() == "V" then
            s[2] = 0
            local line = vim.api.nvim_buf_get_lines(0, e[1] - 1, e[1], true)[1] or ""
            e[2] = #line
        end
        return { start = s, ["end"] = e }
    end

    require("conform").format({
        lsp_format = "fallback",
        async = true,
        timeout_ms = 1000,
        range = get_range(),
    })
end, { desc = "Format Selection" })
