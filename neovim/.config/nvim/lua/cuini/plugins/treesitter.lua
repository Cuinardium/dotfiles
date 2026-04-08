-- Config
return { {
    "nvim-treesitter/nvim-treesitter",
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    opts = {
        ensure_installed = {
            "c",
            "typescript",
            "java",
            "javascript",
            "lua",
            "bash",
            "vim",
            "vimdoc",
            "python",
            "rust",
            "markdown",
            "markdown_inline",
            "latex",
            "html",
            "hcl",
            "haskell",
            "solidity"
        },
        sync_install = false,
        highlight = {
            enable = true, -- false will disable the whole extension

            -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
            --  If you are experiencing weird indenting issues, add the language to
            --  the list of additional_vim_regex_highlighting and disabled languages for indent.
            additional_vim_regex_highlighting = { 'ruby' },
        },
        indent = { enable = true, disable = { 'ruby' } },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "gnn", -- set to `false` to disable one of the mappings
                node_incremental = "grn",
                scope_incremental = "grc",
                node_decremental = "grm",
            },
        }
    }
} }
