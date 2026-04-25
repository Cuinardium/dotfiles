--- @type vim.lsp.Config
return {
    settings = {
        Lua = {
            diagnostics = {
                globals = { "hs", "vim", "it", "describe", "before_each", "after_each" },
                disable = { "lowercase-global", "undefined-global", "unused-local", "unused-vararg", "trailing-space" }
            },
            workspace = {
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.stdpath("config") .. "/lua"] = true,
                },
            },
        },
    },
}
