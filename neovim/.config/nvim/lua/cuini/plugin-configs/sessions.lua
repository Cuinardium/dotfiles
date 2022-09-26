local session_manager = Load_Plugin('session_manager')

session_manager.setup {
    autoload_mode = require('session_manager.config').AutoloadMode.Disabled,
    autosave_last_session = false, -- Automatically save last session on exit and on session switch.
}
