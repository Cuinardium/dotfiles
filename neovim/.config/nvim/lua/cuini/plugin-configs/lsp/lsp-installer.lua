-- Safe load nvim-lsp-installer && handler
local lsp_installer = require("nvim-lsp-installer")
local handler = Load_File("cuini.plugin-configs.lsp.handlers")
local lspconfig = Load_Plugin("lspconfig")

local default_opts = {
    on_attach = handler.on_attach,
    capabilities = handler.capabilities,
}

local servers = {
    sumneko_lua = Load_File("cuini.plugin-configs.lsp.settings.sumneko_lua"),
    clangd = Load_File("cuini.plugin-configs.lsp.settings.clangd"),
    cmake = default_opts,
    pyright = default_opts,
    bashls = default_opts,
    taplo = default_opts,
    rust_analyzer = nil,
    jdtls = nil
}


lsp_installer.setup()

local keymap = vim.keymap.set
local key_opts = { silent = true }

-- codelldb path
local extension_path = vim.env.HOME .. "/Developer/codelldb/"
local codelldb_path = extension_path .. "adapter/codelldb"
local liblldb_path = extension_path .. "/lldb/lib/liblldb.dylib"

-- rust-tools config
require("rust-tools").setup {
    tools = {
        on_initialized = function()
            vim.cmd [[
            autocmd BufEnter,CursorHold,InsertLeave,BufWritePost *.rs silent! lua vim.lsp.codelens.refresh()
          ]]
        end,
    },
    server = {
        on_attach = handler.on_attach,
        capabilities = handler.capabilities,
        settings = {
            ["rust-analyzer"] = {
                lens = {
                    enable = true,
                },
                checkOnSave = {
                    command = "clippy",
                },
            },
        },
    },
    dap = {
        adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
    }
}

-- Lsp setup
for server, options in pairs(servers) do
    if options ~= nil then
        lspconfig[server].setup(options)
    end
end
