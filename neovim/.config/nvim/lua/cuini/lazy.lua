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
    { "nvim-lua/plenary.nvim" },                                         -- useful lua functions used by lots of plugins
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
        enabled = false
    },
    {
        "nvzone/typr", -- Typing game
        dependencies = "nvzone/volt",
        opts = {},
        cmd = { "Typr", "TyprStats" },
    },
    {
        "m4xshen/hardtime.nvim", -- Self punishment
        lazy = false,
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {},
    },
    {
        "kawre/leetcode.nvim",
        cmd = "Leet",
        build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
        },
        opts = {
            -- configuration goes here
        },
    },
    require("cuini.plugins.mini"),           -- mini ecosystem
    require("cuini.plugins.lualine"),        -- better statusline
    require("cuini.plugins.startup-screen"), -- startup screen

    -- LSP
    { 'mfussenegger/nvim-jdtls' },               -- java setup
    require("cuini.plugins.lsp"),          -- config del resto de language servers

    -- Autocomplete
    require('cuini.plugins.autocomplete'), -- Engine de autocompletado



    -- -- LLM integration
    {
      "supermaven-inc/supermaven-nvim",
      config = function()
        require("supermaven-nvim").setup({})
      end,
    },
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
    { 'RRethy/base16-nvim' },

    -- Highlight todo, notes, etc in comments
    { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

    -- TMUX navigation integration
    {
        "christoomey/vim-tmux-navigator",
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
            "TmuxNavigatorProcessList",
        },
        keys = {
            { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
            { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
            { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
            { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
            { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
        },
    }
})
