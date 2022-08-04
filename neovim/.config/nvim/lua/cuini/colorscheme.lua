local colorscheme = "gruvbox-material"

-- Llamado seguro, equivalente a vim.cmd "colorschme gruvbox-material"
local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("Colorscheme " .. colorscheme .. " not found!")
  return
end