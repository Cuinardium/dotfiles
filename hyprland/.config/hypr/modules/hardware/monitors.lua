-- Carga la descripcion local del hardware (archivo gitignored) y expone los
-- datos derivados que necesita el resto de la config, para no hardcodear
-- nombres de monitores en los modulos versionados.
--
-- monitors.local.lua hace las llamadas a hl.monitor / hl.workspace_rule y al
-- final devuelve una tabla con los datos. Ejemplo:
--   return { agents_monitor = "HDMI-A-1" }
local hardwareFile = os.getenv("HOME") .. "/.config/hypr/modules/hardware/monitors.local.lua"

local hardware = dofile(hardwareFile) or {}

return {
    -- monitor dueno del scratchpad de agentes (nil = usar el monitor con foco)
    agents_monitor = hardware.agents_monitor,
}
