local handler = Load_File("cuini.plugin-configs.lsp.handlers")


return {
    filetypes = { "html", "jsp" },

    init_options = {
        provideFormatter = false
    },

    on_attach = handler.on_attach,
    capabilities = handler.capabilities,
}

