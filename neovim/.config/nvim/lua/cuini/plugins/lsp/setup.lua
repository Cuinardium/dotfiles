--  ======= Keymaps =================

local function lsp_keymaps(event)
    local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    local telescope_builtin = Load_Plugin("telescope.builtin")
    if telescope_builtin == nil then
        vim.notify("Error loading telescope builtin", vim.log.levels.ERROR)
        return
    end

    -- Rename the variable under your cursor.
    map('<leader>lr', vim.lsp.buf.rename, '[L]sp [R]ename')

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    map('<leader>la', vim.lsp.buf.code_action, '[L]sp [A]ction', { 'n', 'x' })

    -- Go next diagnostic.
    map('<leader>ln', function()
        vim.diagnostic.jump({ count = 1, float = true })
    end, '[L]sp [N]ext')

    -- Go previous diagnostic.
    map('<leader>lp', function()
        vim.diagnostic.jump({ count = -1, float = true })
    end, '[L]sp [P]rev')

    -- Open diagnostics in a floating window.
    map('<leader>lc', function()
        vim.diagnostic.open_float(nil, { focusable = false })
    end, '[L]sp [C]urrent Diagnostic')

    -- Find references for the word under your cursor.
    map('<leader>gr', telescope_builtin.lsp_references, '[G]oto [R]eferences')

    -- Jump to the implementation of the word under your cursor.
    map('<leader>gi', telescope_builtin.lsp_implementations, '[G]oto [I]mplementation')

    -- Jump to the definition of the word under your cursor.
    map('<leader>gd', telescope_builtin.lsp_definitions, '[G]oto [D]efinition')

    -- Jump to the declaration of the word under your cursor.
    map('<leader>gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    -- Fuzzy find all the symbols in your current document.
    map('<leader>fs', telescope_builtin.lsp_document_symbols, '[F]ind [S]ymbols')

    -- Fuzzy find all the symbols in your current workspace.
    map('<leader>fS', telescope_builtin.lsp_workspace_symbols, '[F]ind [S]ymbols in Workspace')

    -- Jump to the type of the word under your cursor.
    map('<leader>gt', vim.lsp.buf.type_definition, '[G]oto [T]ype Definition')

    -- Hover documentation.
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = event.buf, desc = "LSP: Hover Documentation" })

    -- Signature help.
    vim.keymap.set("n", "<leader>lk", vim.lsp.buf.signature_help, { buffer = event.buf, desc = "LSP: Signature Help" })
end

-- ===================== Highlights ===============================

local function lsp_highlights(event)
    local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end
    -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
    ---@param client vim.lsp.Client
    ---@param method vim.lsp.protocol.Method
    ---@param bufnr? integer some lsp support methods only in specific files
    ---@return boolean
    local function client_supports_method(client, method, bufnr)
        if vim.fn.has 'nvim-0.11' == 1 then
            return client:supports_method(method, bufnr)
        else
            return client.supports_method(method, { bufnr = bufnr })
        end
    end

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
        })
    end

    -- The following code creates a keymap to toggle inlay hints in your
    -- code, if the language server you are using supports them
    --
    -- This may be unwanted, since they displace some of your code
    if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
        map('<leader>lh', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
        end, '[L]sp [H]ints')
    end
end


return {
    {
        "neovim/nvim-lspconfig",                         -- para configurar el cliente lsp de nvim
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },       -- instala programas que va a usar nvim
            'mason-org/mason-lspconfig.nvim',            -- para que los configs de lsp-config usen los nombres de mason
            'WhoIsSethDaniel/mason-tool-installer.nvim', --
            {
                "j-hui/fidget.nvim",                     -- for useful lsp status updates
                opts = {
                    -- options
                },
            },
            'saghen/blink.cmp',    -- for autocompletion capabilities for lsp client
            'SmiteshP/nvim-navic', -- for winbar
        },
        config = function()
            --  This function gets run when an LSP attaches to a particular buffer.
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
                callback = function(event)
                    lsp_keymaps(event)
                    lsp_highlights(event)
                end,
            })



            -- Diagnostic Config
            -- See :help vim.diagnostic.Opts
            vim.diagnostic.config {
                severity_sort = true,
                float = { border = 'rounded', source = 'if_many' },
                underline = { severity = vim.diagnostic.severity.ERROR },
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = '󰅚 ',
                        [vim.diagnostic.severity.WARN] = '󰀪 ',
                        [vim.diagnostic.severity.INFO] = '󰋽 ',
                        [vim.diagnostic.severity.HINT] = '󰌶 ',
                    },
                },
                virtual_text = {
                    source = 'if_many',
                    spacing = 2,
                    format = function(diagnostic)
                        local diagnostic_message = {
                            [vim.diagnostic.severity.ERROR] = diagnostic.message,
                            [vim.diagnostic.severity.WARN] = diagnostic.message,
                            [vim.diagnostic.severity.INFO] = diagnostic.message,
                            [vim.diagnostic.severity.HINT] = diagnostic.message,
                        }
                        return diagnostic_message[diagnostic.severity]
                    end,
                },
            }

            -- ACA AGREGAR LSP y linters/formatters, fijarse los que soporta mason
            local tools = {
                -- LSP
                'lua_ls',
                'clangd',
                'html',
                'zls',
                'cmake',
                'pyright',
                'bashls',
                'taplo',
                'lemminx',
                'cssls',
                'ts_ls',
                'rust_analyzer',
                'jdtls',

                -- Formatters y linters
                'stylua', -- Used to format Lua code
                'google-java-format',
                'clang-format',

                -- python
                'black',
                'mypy',

                -- web
                'prettier',
            }

            local mason_tool_installer = Load_Plugin("mason-tool-installer")
            mason_tool_installer.setup { ensure_installed = tools }


            -- Nvim java setup
            -- Load_Plugin("java").setup()


            local navic = Load_Plugin("nvim-navic")
            local function navic_on_attach(client, bufnr)
                if client.server_capabilities.documentSymbolProvider then
                    navic.attach(client, bufnr)
                end
            end


            -- Default server configs
            -- Specific configs automatically added by lspconfig
            -- The specific config files should be added to after/lsp/ folder
            vim.lsp.config('*', {
                on_attach = navic_on_attach,
            })


            local mason_lspconfig = Load_Plugin("mason-lspconfig")
            mason_lspconfig.setup {
                ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
                automatic_installation = false,
            }
        end
    },
}
