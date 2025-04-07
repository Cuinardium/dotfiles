local handler = Load_File("cuini.plugin-configs.lsp.handlers")

return {
    cmd = {
        '/home/cuini/developer/zls/zig-out/bin/zls',
    },
    on_attach = handler.on_attach,
    capabilities = handler.capabilities,
}
