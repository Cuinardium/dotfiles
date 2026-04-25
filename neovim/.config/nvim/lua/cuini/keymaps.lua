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
keymap("n", "<C-w>", ":Bdelete<CR>", opts) -- Uses bufdelete.nvim

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

-- Formatting
keymap({ "n", "v" }, "<leader>F", function()
    vim.lsp.buf.format({ async = true })
end, { desc = "Format Document" })
