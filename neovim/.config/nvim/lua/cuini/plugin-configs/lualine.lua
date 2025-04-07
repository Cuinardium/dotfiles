-- Safe load lualine
local lualine = Load_Plugin("lualine")
local navic = Load_Plugin("nvim-navic")

local lualine_theme = 'gruvbox-material'
if COLORSCHEME == 'catppuccin-latte' then
    lualine_theme = 'catppuccin-latte'
elseif COLORSCHEME == 'catppuccin-mocha' then
    lualine_theme = 'catppuccin-mocha'
end

-- Config
navic.setup {
    highlight = true
}

lualine.setup {
    options = {
        icons_enabled = true,
        theme = lualine_theme,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = { 'NvimTree', 'alpha' },
        always_divide_middle = true,
        globalstatus = true,
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'copilot', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    extensions = {},
    winbar = {
        lualine_c = {
            {
                'navic',
                color_correction = nil,
                navic_opts = nil
            }
        }
    }
}
