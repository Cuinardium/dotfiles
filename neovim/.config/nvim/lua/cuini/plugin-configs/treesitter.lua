-- Safe load treesitter
local configs = Load_Plugin("nvim-treesitter.configs")

-- Config
configs.setup {
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
        "rust"
    },
    sync_install = false,
    highlight = {
        enable = true, -- false will disable the whole extension
    },
    indent = { enable = true, disable = {} },
    autopairs = { enable = true }, -- autopairs integration
}
