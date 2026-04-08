
-- Set colorscheme

COLORSCHEME = "everforest"

-- Llamado seguro, equivalente a vim.cmd "colorschme ..."
local status_ok, _ = pcall(vim.cmd, "colorscheme " .. COLORSCHEME)
if not status_ok then
  vim.notify("Colorscheme " .. COLORSCHEME .. " not found!")
  return
end
status_ok = pcall(vim.cmd, "hi Normal guibg=NONE ctermbg=NONE")
if not status_ok then
  vim.notify("Error setting background to NONE")
  return
end

local scheme_highlights = vim.api.nvim_get_hl(0, {})

vim.api.nvim_set_hl(0, "NavicIconsFile",          scheme_highlights["Normal"])
vim.api.nvim_set_hl(0, "NavicIconsModule",        scheme_highlights["@namespace"])
vim.api.nvim_set_hl(0, "NavicIconsNamespace",     scheme_highlights["@namespace"])
vim.api.nvim_set_hl(0, "NavicIconsPackage",       scheme_highlights["@namespace"])
vim.api.nvim_set_hl(0, "NavicIconsClass",         scheme_highlights["@lsp.type.class"])
vim.api.nvim_set_hl(0, "NavicIconsMethod",        scheme_highlights["@lsp.type.method"])
vim.api.nvim_set_hl(0, "NavicIconsProperty",      scheme_highlights["@property"])
vim.api.nvim_set_hl(0, "NavicIconsField",         scheme_highlights["@field"])
vim.api.nvim_set_hl(0, "NavicIconsConstructor",   scheme_highlights["@constructor"])
vim.api.nvim_set_hl(0, "NavicIconsEnum",          scheme_highlights["@lsp.type.enum"])
vim.api.nvim_set_hl(0, "NavicIconsInterface",     scheme_highlights["@lsp.type.interface"])
vim.api.nvim_set_hl(0, "NavicIconsFunction",      scheme_highlights["@function"])
vim.api.nvim_set_hl(0, "NavicIconsVariable",      scheme_highlights["@variable"])
vim.api.nvim_set_hl(0, "NavicIconsConstant",      scheme_highlights["@constant"])
vim.api.nvim_set_hl(0, "NavicIconsString",        scheme_highlights["@string"])
vim.api.nvim_set_hl(0, "NavicIconsNumber",        scheme_highlights["@number"])
vim.api.nvim_set_hl(0, "NavicIconsBoolean",       scheme_highlights["@boolean"])
vim.api.nvim_set_hl(0, "NavicIconsArray",         scheme_highlights["@lsp.type.enum"])
vim.api.nvim_set_hl(0, "NavicIconsObject",        scheme_highlights["@lsp.type.struct"])
vim.api.nvim_set_hl(0, "NavicIconsKey",           scheme_highlights["@keyword"])
vim.api.nvim_set_hl(0, "NavicIconsNull",          scheme_highlights["@character"])
vim.api.nvim_set_hl(0, "NavicIconsEnumMember",    scheme_highlights["@lsp.type.enumMember"])
vim.api.nvim_set_hl(0, "NavicIconsStruct",        scheme_highlights["@lsp.type.struct"])
-- vim.api.nvim_set_hl(0, "NavicIconsEvent",         scheme_highlights["@lsp.typemod.keyword.async"])
vim.api.nvim_set_hl(0, "NavicIconsOperator",      scheme_highlights["@operator"])
vim.api.nvim_set_hl(0, "NavicIconsTypeParameter", scheme_highlights["@lsp.type.typeParameter"])
vim.api.nvim_set_hl(0, "NavicText",               scheme_highlights["Normal"])
vim.api.nvim_set_hl(0, "NavicSeparator",          scheme_highlights["Normal"])
