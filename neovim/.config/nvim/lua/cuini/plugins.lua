-- Shorten fn name
local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
    print "Installing packer close and reopen Neovim..."
    vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Safe load packer
local packer = Load_Plugin("packer")

-- Have packer use a popup window
packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border = "rounded" }
        end,
    },
}

-- Install your plugins here (use "user/repo")
return packer.startup(function(use)
    -- General plugins
    use "wbthomason/packer.nvim" -- have packer manage itself
    use "nvim-lua/popup.nvim" -- an implementation of the Popup API from vim in Neovim
    use "nvim-lua/plenary.nvim" -- useful lua functions used by lots of plugins
    use "windwp/nvim-autopairs" -- autopairs, integrates with both cmp and treesitter
    use "numToStr/Comment.nvim" -- easily comment stuff
    use 'kyazdani42/nvim-web-devicons' -- icons for other plugind
    use 'kyazdani42/nvim-tree.lua' -- project tree view
    -- use "akinsho/bufferline.nvim" -- better bufferline
    use "nvim-lualine/lualine.nvim" -- better statusline
    use "moll/vim-bbye" -- idk
    use "akinsho/toggleterm.nvim" -- terminal
    use "goolord/alpha-nvim" -- start screen
    use "Shatur/neovim-session-manager" -- session manager
    use "famiu/bufdelete.nvim" -- delete buffer

    -- Autocomplete
    use "hrsh7th/nvim-cmp" -- the completion plugin
    use "hrsh7th/cmp-buffer" -- buffer completions
    use "hrsh7th/cmp-path" -- path completions
    use "hrsh7th/cmp-cmdline" -- cmdline completions
    use "saadparwaiz1/cmp_luasnip" -- snippet completions
    use "hrsh7th/cmp-nvim-lsp" -- lsp completions
    use "hrsh7th/cmp-nvim-lua" -- config files completions
    use "hrsh7th/cmp-nvim-lsp-signature-help" -- signature help completions

    -- Snippets
    use "L3MON4D3/LuaSnip" -- snippet engine
    use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

    -- LSP
    use "neovim/nvim-lspconfig" -- enable LSP
    use "williamboman/nvim-lsp-installer" -- simple to use language server installer
    use "jose-elias-alvarez/null-ls.nvim" -- for formaters and linters
    use "ericpubu/lsp_codelens_extensions.nvim" -- for code lenses
    use "github/copilot.vim" -- copilot
    use "mfussenegger/nvim-jdtls" -- jdtls
    use "simrat39/rust-tools.nvim" -- rust tools

    -- Debugging
    use "mfussenegger/nvim-dap" -- debug adapter protocol
    use "rcarriga/nvim-dap-ui" -- debug adapter ui
    use "theHamsta/nvim-dap-virtual-text" -- virtual text for dap

    -- Telescope
    use "nvim-telescope/telescope.nvim" -- telescope itself
    use "nvim-telescope/telescope-project.nvim" -- telescope project view
    use "nvim-telescope/telescope-file-browser.nvim" -- telescope file browser
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' } -- better sorting algorithm
    use "gbrlsnchs/telescope-lsp-handlers.nvim" -- telescope lsp integeration
    use "nvim-telescope/telescope-ui-select.nvim" -- para code actions
    use "nvim-telescope/telescope-dap.nvim" -- telescope dap integration

    -- Treesitter
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
    }
    use "p00f/nvim-ts-rainbow" -- different colors for nested parenthesis
    use "nvim-treesitter/playground" -- visualize parser tree
    use 'JoosepAlviste/nvim-ts-context-commentstring' -- context for comments

    -- Git
    use "lewis6991/gitsigns.nvim" -- git integration

    -- Colorschemes
    use "sainnhe/gruvbox-material"
    use "neanias/everforest-nvim"
    use 'folke/lsp-colors.nvim' -- colors for lsp diagnostics
    use { "iamcco/markdown-preview.nvim", run = "cd app && npm install", cmd = "MarkdownPreview" } -- Markdown previewer

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        packer.sync()
    end
end)
