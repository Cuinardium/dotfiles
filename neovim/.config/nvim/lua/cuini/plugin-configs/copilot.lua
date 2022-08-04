-- Nose pero no anda lo q  esta comentado
-- local copilot = Load_Plugin('copilot')

-- Config

 vim.cmd [[
   imap <silent><script><expr> <C-A> copilot#Accept("\<CR>")
   let g:copilot_no_tab_map = v:true
]]


--copilot.setup {
--  cmp = {
--    enabled = true,
--    method = "getPanelCompletions",
--  },
--  panel = { -- no config options yet
--    enabled = true,
--  },
--  ft_disable = { "markdown" },
--  -- plugin_manager_path = vim.fn.stdpath "data" .. "/site/pack/packer",
--  -- server_opts_overrides = {},
--}