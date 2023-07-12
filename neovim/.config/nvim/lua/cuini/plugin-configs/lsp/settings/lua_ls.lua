--local withoutchecknil = require 'without-check-nil'

--withoutchecknil.enable()

local handler = Load_File("cuini.plugin-configs.lsp.handlers")

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
    on_attach = handler.on_attach,
    capabilities = handler.capabilities,
}
