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
                    -- Java
                    formatting.google_java_format.with({
                        extra_args = { "--aosp" }
                    }),

                    -- Python
                    formatting.black,

                    -- Web
                    formatting.prettier,

                },
            }
        end
    }
}
