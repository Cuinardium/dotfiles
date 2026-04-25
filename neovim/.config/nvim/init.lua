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

-- Supress the vim.tbl_islist deprecation warning
if vim.fn.has('nvim-0.12') == 1 then
    vim.tbl_islist = vim.islist
end

-- Plugins -> ./lua/cuini/lazy.lua
Load_File('cuini.lazy')

-- Colorscheme -> ./lua/cuini/colorscheme.lua
Load_File('cuini.colorscheme') -- colorscheme, usamos lua para manejar errores en la carga del colorscheme

-- Options -> ./lua/cuini/options.lua, usamos la carpeta 'cuini' para evitar colisiones de nombre de archivo
Load_File('cuini.options')

-- Keymaps -> ./lua/cuini/keymaps.lua
Load_File('cuini.keymaps')

-- Autocommands -> ./lua/cuini/autocommands.lua
Load_File('cuini.autocommands')

