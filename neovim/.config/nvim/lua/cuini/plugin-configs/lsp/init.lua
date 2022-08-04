-- Safe load lsp-config
Load_Plugin("lspconfig")

-- Safe load config files
Load_File("cuini.plugin-configs.lsp.lsp-installer") -- installer configs
Load_File("cuini.plugin-configs.lsp.handlers").setup() -- config de handlers? xdu
Load_File("cuini.plugin-configs.lsp.null-ls") -- config de null-ls
