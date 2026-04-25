-- file: lua/lsp_servers/qmlls.lua
return {
  -- The -E flag is mandatory for Quickshell in 2026
  cmd = { "qmlls", "-E"  },
}
