--- @type vim.lsp.Config
return {
	cmd = { "qmlls", "-E" },
	cmd_env = {
		QML_IMPORT_PATH = "/usr/lib/quickshell:/usr/lib/qt6/qml",
	},
}
