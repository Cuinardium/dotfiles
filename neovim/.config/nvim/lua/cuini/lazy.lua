-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then
        error('Error cloning lazy.nvim:\n' .. out)
    end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Safe load lazy
local lazy = Load_Plugin("lazy")

-- Install your plugins here ({ "user/repo" })
lazy.setup({

    -- General plugins
    { "nvim-lua/popup.nvim" },                                           -- an implementation of the Popup API from vim in Neovim
    { "nvim-lua/plenary.nvim" },                                         -- useful lua functions used by lots of plugins
    { "vigoux/notifier.nvim",        opts = {} },                        -- notifications
    { "windwp/nvim-autopairs",       event = 'InsertEnter', opts = {} }, -- autopairs
    { "kyazdani42/nvim-web-devicons" },                                  -- icons for other plugind
    { "famiu/bufdelete.nvim" },                                          -- delete buffer
    {
        "3rd/image.nvim",                                                -- image previewer
        build = false,
        opts = {
            processor = "magick_cli"
        },

    },
    {
        "andweeb/presence.nvim", -- discord presence
        opts = {
            main_image = "file",
            buttons = false,
            show_time = false,
        },
        event = "VimEnter",
    },
    require("cuini.plugins.mini"),           -- mini ecosystem
    require("cuini.plugins.lualine"),        -- better statusline
    require("cuini.plugins.startup-screen"), -- startup screen

    -- LSP
    require("cuini.plugins.lsp.none-ls"), -- para linters y formatters
    require("cuini.plugins.lsp.lazydev"), -- para el lsp de lua con nvim
    { "nvim-java/nvim-java",      ft = "java" }, -- java
    require("cuini.plugins.lsp.setup"),   -- config del resto de language servers

    -- Autocomplete
    require('cuini.plugins.autocomplete'), -- Engine de autocompletado



    -- LLM integration
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {
            suggestion = {
                enabled = true,
                hide_during_completion = true,
                auto_trigger = false,
                keymap = {
                    accept = "<C-a>",
                    next   = "<C-s>"
                }
            },
            panel = {
                enabled = true,
                layout = {
                    position = "left",
                    ratio = 0.4
                },
            }
        },
    },                         -- copilot
    {
        "SmiteshP/nvim-navic", -- winbar
        opts = { highlight = true }
    },

    -- Telescope
    require("cuini.plugins.telescope"), -- fuzzy finder

    -- Treesitter
    require("cuini.plugins.treesitter"),

    -- Git
    {
        "lewis6991/gitsigns.nvim", -- git integration
        opts = {
            signs = {
                add          = { text = '┃' },
                change       = { text = '┃' },
                delete       = { text = '┃' },
                topdelete    = { text = '‾' },
                changedelete = { text = '~' },
                untracked    = { text = '┆' },
            }
        }
    },


    -- Colorschemes
    { "sainnhe/gruvbox-material" },
    { 'catppuccin/nvim',          priority = 1000 },
    { "neanias/everforest-nvim" },
    { 'folke/lsp-colors.nvim' }, -- colors for lsp diagnostics

    -- Highlight todo, notes, etc in comments
    { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
})
