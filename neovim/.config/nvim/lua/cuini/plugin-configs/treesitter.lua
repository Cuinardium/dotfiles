-- Safe load treesitter
local configs = Load_Plugin("nvim-treesitter.configs")

-- Config
configs.setup {
    ensure_installed = "all",
    sync_install = false,
    ignore_install = { "phpdoc", "sql", "norg" }, -- List of parsers to ignore installing
    highlight = {
        enable = true, -- false will disable the whole extension
        disable = { "" }, -- list of language that will be disabled
        additional_vim_regex_highlighting = true,

    },
    indent = { enable = true, disable = {} },
    autopairs = { enable = true }, -- autopairs integration
    context_commentstring = { -- Comment.nvim integration
        enable = true,
        enable_autocmd = false,
    },
    rainbow = {
        enable = true,
        -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = nil, -- Do not enable for files with more than n lines, int
        -- colors = {}, -- table of hex strings
        -- termcolors = {} -- table of colour name strings
    },
}
