-- ============================================================================
-- TOOL LIST DEFINITION
-- ============================================================================

-- === Some names for vim.lsp.enable are different to the ones in Mason ===
-- This table is used to map the names in Mason to the ones in vim.lsp.enable
-- If the name is the same we set true, otherwise we set the name
local servers = {
	-- Names that are exactly the same in both
	clangd = true,
	zls = true,
	pyright = true,
	taplo = true,
	lemminx = true,
	jdtls = true,
	gopls = true,
	tinymist = true,
	qmlls = true,
	checkmake = true,

	-- The Exceptions (LspConfig name -> Mason name)
	lua_ls = "lua-language-server",
	html = "html-lsp",
	cmake = "cmake-language-server",
	bashls = "bash-language-server",
	cssls = "css-lsp",
	ts_ls = "typescript-language-server",
	rust_analyzer = "rust-analyzer",
	terraformls = "terraform-ls",
	hls = "haskell-language-server",
	csharp_ls = "csharp-language-server",
}

local formatters_by_filetype = {
	lua = { "stylua" },
	python = { "black" },
	java = { "google-java-format" },
	javascript = { "prettier" },
	html = { "prettier" },
}

-- ============================================================================
-- Generate the list for Mason to install
-- ============================================================================

local mason_ensure_installed = { "mypy" } -- Add standalone linters here

-- Parse servers for Mason
for lsp_name, mason_name in pairs(servers) do
	local package_to_install = type(mason_name) == "string" and mason_name or lsp_name
	table.insert(mason_ensure_installed, package_to_install)
end

-- Parse formatters for Mason
for _, tools in pairs(formatters_by_filetype) do
	for _, tool in ipairs(tools) do
		if not vim.list_contains(mason_ensure_installed, tool) then
			table.insert(mason_ensure_installed, tool)
		end
	end
end

-- ============================================================================
-- Helper Functions (Keymaps, Highlights, JDTLS)
-- ============================================================================

local function lsp_keymaps(event)
	local map = function(keys, func, desc, mode)
		vim.keymap.set(mode or "n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
	end
	local telescope = require("telescope.builtin")

	map("<leader>lr", vim.lsp.buf.rename, "[L]sp [R]ename")
	map("<leader>la", vim.lsp.buf.code_action, "[L]sp [A]ction", { "n", "x" })
	map("<leader>ln", function()
		vim.diagnostic.jump({ count = 1, float = true })
	end, "[L]sp [N]ext")
	map("<leader>lp", function()
		vim.diagnostic.jump({ count = -1, float = true })
	end, "[L]sp [P]rev")
	map("<leader>lc", function()
		vim.diagnostic.open_float(nil, { focusable = false })
	end, "[L]sp [C]urrent Diagnostic")
	map("<leader>gr", telescope.lsp_references, "[G]oto [R]eferences")
	map("<leader>gi", telescope.lsp_implementations, "[G]oto [I]mplementation")
	map("<leader>gd", telescope.lsp_definitions, "[G]oto [D]efinition")
	map("<leader>gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	map("<leader>fs", telescope.lsp_document_symbols, "[F]ind [S]ymbols")
	map("<leader>fS", telescope.lsp_workspace_symbols, "[F]ind [S]ymbols in Workspace")
	map("<leader>gt", vim.lsp.buf.type_definition, "[G]oto [T]ype Definition")
	map("K", vim.lsp.buf.hover, "Hover Documentation")
	map("<leader>lk", vim.lsp.buf.signature_help, "Signature Help")
end

local function lsp_highlights(event)
	local client = vim.lsp.get_client_by_id(event.data.client_id)
	if not client then
		return
	end

	if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
		local group = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			buffer = event.buf,
			group = group,
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			buffer = event.buf,
			group = group,
			callback = vim.lsp.buf.clear_references,
		})
		vim.api.nvim_create_autocmd("LspDetach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
			callback = function(e)
				vim.lsp.buf.clear_references()
				vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = e.buf })
			end,
		})
	end

	if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
		vim.keymap.set("n", "<leader>lh", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
		end, { buffer = event.buf, desc = "LSP: Toggle [H]ints" })
	end
end

local function get_java_cmd()
	-- Try a JDTLS-specific override first (useful if your project needs a different JDK than your system)
	if vim.env.JDTLS_JAVA_HOME then
		return vim.env.JDTLS_JAVA_HOME .. "/bin/java"
	end

	-- Try the standard JAVA_HOME environment variable
	if vim.env.JAVA_HOME then
		return vim.env.JAVA_HOME .. "/bin/java"
	end

	-- Fallback to Neovim's native system PATH search
	-- This acts exactly like running `which java` in your terminal
	local sys_java = vim.fn.exepath("java")
	if sys_java ~= "" then
		return sys_java
	end

	-- Blind fallback
	return "java"
end

local function setup_jdtls()
	local workspace_dir = vim.fn.stdpath("data") .. "/workspace/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
	local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
	local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
	local java_cmd = get_java_cmd()

	require("jdtls").start_or_attach({
		cmd = {
			java_cmd,
			"-Declipse.application=org.eclipse.jdt.ls.core.id1",
			"-Dosgi.bundles.defaultStartLevel=4",
			"-Declipse.product=org.eclipse.jdt.ls.core.product",
			"-Dlog.protocol=true",
			"-Dlog.level=ALL",
			"-Xmx1g",
			"-javaagent:" .. jdtls_path .. "/lombok.jar",
			"--add-modules=ALL-SYSTEM",
			"--add-opens",
			"java.base/java.util=ALL-UNNAMED",
			"--add-opens",
			"java.base/java.lang=ALL-UNNAMED",
			"-jar",
			launcher_jar,
			"-configuration",
			jdtls_path .. "/config_linux",
			"-data",
			workspace_dir,
		},
		root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),
		settings = { java = {} },
		init_options = { bundles = {} },
	})
end

-- ============================================================================
-- Plugins
-- ============================================================================

return {
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = { library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } } },
	},

	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			-- Pass the dynamic table we created at the top
			formatters_by_ft = formatters_by_filetype,
		},
	},

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"mason-org/mason.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"j-hui/fidget.nvim",
			"saghen/blink.cmp",
			"SmiteshP/nvim-navic",
		},
		config = function()
			require("fidget").setup({})
			require("mason").setup({})

			-- Pass our auto-generated list to Mason
			require("mason-tool-installer").setup({ ensure_installed = mason_ensure_installed })

			-- Global Diagnostic Config
			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = { text = { [1] = "󰅚 ", [2] = "󰀪 ", [3] = "󰋽 ", [4] = "󰌶 " } },
				virtual_text = { source = "if_many", spacing = 2 },
			})

			-- Attach keymaps, highlights, and Navic when Native LSP boots
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					lsp_keymaps(event)
					lsp_highlights(event)
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if
						client
						and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentSymbol, event.buf)
					then
						require("nvim-navic").attach(client, event.buf)
					end
				end,
			})

			-- LSP activation and capabilities registering
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- Setup servers using the servers table
			for lsp_name, _ in pairs(servers) do
				if lsp_name ~= "jdtls" then
					-- Ensure the native config table exists
					vim.lsp.config[lsp_name] = vim.lsp.config[lsp_name] or {}

					-- Inject blink.cmp capabilities
					vim.lsp.config[lsp_name].capabilities = capabilities

					-- Let Neovim handle the autocommands and process spawning
					vim.lsp.enable(lsp_name)
				end
			end

			-- JDTLS manual trigger
			vim.api.nvim_create_autocmd("Filetype", {
				pattern = "java",
				callback = setup_jdtls,
			})
		end,
	},
}
