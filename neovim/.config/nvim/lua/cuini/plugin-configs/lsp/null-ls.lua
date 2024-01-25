-- Safe load null-ls
local null_ls = Load_Plugin("null-ls")


-- Config
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup {
    debug = false,
    sources = { -- Sources here
        -- C/C++
        formatting.clang_format.with({
            extra_args = {
                "-style={IndentWidth: 4, ColumnLimit: 120}"
            }
        }),

        -- Java
        formatting.google_java_format,

        -- Python
        formatting.black,
        diagnostics.mypy,
        diagnostics.ruff,

        -- Web
       formatting.prettier,

        -- Json
       formatting.jq
    },
}
