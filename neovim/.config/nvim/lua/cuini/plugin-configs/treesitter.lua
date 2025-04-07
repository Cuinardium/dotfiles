-- Safe load treesitter
local configs = Load_Plugin("nvim-treesitter.configs")

-- Config
configs.setup {
    ensure_installed = { "c", "typescript", "java", "javascript", "lua", "bash" },
    sync_install = false,
    ignore_install = { "norg" },
    highlight = {
        enable = true,    -- false will disable the whole extension
        disable = { "" }, -- list of language that will be disabled
        additional_vim_regex_highlighting = true,

    },
    indent = { enable = true, disable = {} },
    autopairs = { enable = true }, -- autopairs integration
    rainbow = {
        enable = true,
        -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = nil, -- Do not enable for files with more than n lines, int
        -- colors = {}, -- table of hex strings
        -- termcolors = {} -- table of colour name strings
    },
}
