local handler = Load_File("cuini.plugin-configs.lsp.handlers")


return {
    filetypes = { "html", "jsp" },

    on_attach = handler.on_attach,
    capabilities = handler.capabilities,
}

