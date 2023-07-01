
-- Configure colorscheme plugin
Load_Plugin('catppuccin').setup({
    transparent_background = true,
})

-- Set colorscheme
local ricetheme = os.getenv("RICETHEME")

COLORSCHEME = "gruvbox-material"

if ricetheme == "aline" then
    COLORSCHEME = "catppuccin-latte"
elseif ricetheme == "cristina" then
    COLORSCHEME = "catppuccin-mocha"
end

-- Llamado seguro, equivalente a vim.cmd "colorschme ..."
local status_ok, _ = pcall(vim.cmd, "colorscheme " .. COLORSCHEME)
if not status_ok then
  vim.notify("Colorscheme " .. colorscheme .. " not found!")
  return
end
status_ok = pcall(vim.cmd, "hi Normal guibg=NONE ctermbg=NONE")
if not status_ok then
  vim.notify("Error setting background to NONE")
  return
end
