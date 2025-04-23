return {
    {
        "nvimtools/none-ls.nvim",
        config = function()
            -- Safe load null-ls
            local none_ls = Load_Plugin("null-ls")


            -- Config
            local formatting = none_ls.builtins.formatting
            local diagnostics = none_ls.builtins.diagnostics

            none_ls.setup {
                debug = false,
                sources = { -- Sources here
                    -- C/C++
                    formatting.clang_format.with({
                        extra_args = {
                            "-style={IndentWidth: 4, ColumnLimit: 120}"
                        }
                    }),

                    -- Java
                    formatting.google_java_format.with({
                        -- extra_args = { "--aosp" }
                    }),

                    -- Python
                    formatting.black,
                    diagnostics.mypy,

                    -- Web
                    formatting.prettier,

                },
            }
        end
    }
}
