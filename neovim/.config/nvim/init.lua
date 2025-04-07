-- Safe loads por si no se encuentran los archivos o plugins
local function safe_load(toLoad, type)
    local status_ok, resp = pcall(require, toLoad)
    if not status_ok then
        vim.notify("Error loading " .. type .. ": " .. toLoad, vim.log.levels.ERROR)
        vim.notify(resp, vim.log.levels.ERROR)
        return
    end
    return resp
end

function Load_File(path)
    return safe_load(path, "file")
end

function Load_Plugin(plugin)
    return safe_load(plugin, "plugin")
end

-- Colorscheme -> ./lua/cuini/colorscheme.lua
Load_File('cuini.colorscheme') -- colorscheme, usamos lua para manejar errores en la carga del colorscheme

-- Plugins -> ./lua/cuini/plugins.lua
Load_File('cuini.plugins')

-- Plugin configs -> ./lua//cuini/plugin-configs/init.lua
Load_File('cuini.plugin-configs.init')

-- Options -> ./lua/cuini/options.lua, usamos la carpeta 'cuini' para evitar colisiones de nombre de archivo
Load_File('cuini.options')

-- Keymaps -> ./lua/cuini/keymaps.lua
Load_File('cuini.keymaps')

vim.cmd ([[
augroup Binary
    autocmd!
    " set the 'bin' option to true if the file I'm opening is a .bin
    au BufReadPre   *.bmp,*.bin,*.out let &bin=1

    " before I start editing set the binary editor
    au BufReadPost  *.bmp,*.bin,*.out if &bin | :%!xxd
    au BufReadPost  *.bmp,*.bin,*.out set ft=xxd | endif

    " before saving
    au BufWritePre  *.bmp,*.bin,*.out if &bin | :%!xxd -r
    au BufWritePre  *.bmp,*.bin,*.out endif

    " after saving
    au BufWritePost *.bmp,*.bin,*.out if &bin | :%!xxd
    au BufWritePost *.bmp,*.bin,*.out set nomod | endif
augroup END
    ]])
