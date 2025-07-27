-- ========== [BINARY VIEWER] ===============================

-- Create augroup
local group = vim.api.nvim_create_augroup("Binary", { clear = true })

-- Define file pattern
local binary_patterns = { "*.bmp", "*.bin", "*.out" }

-- BufReadPre: set binary option
vim.api.nvim_create_autocmd("BufReadPre", {
    pattern = binary_patterns,
    group = group,
    callback = function()
        vim.opt_local.binary = true
    end,
})

-- BufReadPost: convert to hex view and set filetype
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = binary_patterns,
    group = group,
    callback = function()
        if vim.opt_local.binary:get() then
            vim.cmd("%!xxd")
            vim.bo.filetype = "xxd"
        end
    end,
})

-- BufWritePre: convert hex back to binary
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = binary_patterns,
    group = group,
    callback = function()
        if vim.opt_local.binary:get() then
            vim.cmd("%!xxd -r")
        end
    end,
})

-- BufWritePost: convert to hex again and mark unmodified
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = binary_patterns,
    group = group,
    callback = function()
        if vim.opt_local.binary:get() then
            vim.cmd("%!xxd")
            vim.cmd("set nomodified")
        end
    end,
})

-- =============== [ Highlight yanked text ] ================


-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- ================= [ Langauge indenting ] ====================

-- Create augroup for indentation settings
local indent_group = vim.api.nvim_create_augroup("IndentSettings", { clear = true })

-- Helper function to apply indentation settings
local function set_indent(filetypes, shiftwidth, tabstop)
    for _, ft in ipairs(filetypes) do
        vim.api.nvim_create_autocmd("FileType", {
            pattern = ft,
            group = indent_group,
            callback = function()
                vim.bo.shiftwidth = shiftwidth
                vim.bo.tabstop = tabstop
            end,
        })
    end
end

-- Apply 2-space indent to specified filetypes
set_indent({ "javascript", "typescript", "typescriptreact", "c", "cpp" }, 2, 2)

-- Apply 4-space indent to specified filetypes
set_indent({ "python", "html", "css", "lua", "json", "java" }, 4, 4)
