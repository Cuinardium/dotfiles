# Quickshell

QtQuick desktop shell (bar, panels, menus) for Hyprland. Entry point: `shell.qml`.

```
bar/          bar + widgets (workspaces, agent scratchpad, audio, clock, ...)
panels/       run menu, power menu, notifications
components/   shared styled QML primitives
style/        theme + motion tokens (matugen generated)
MachineConfig.qml   reads machine.json (machine-local values)
Shortcuts.qml       GlobalShortcut handlers (toggle-bar, toggle-run-menu, toggle-power-menu)
```

## Machine-local display config

Create `~/.config/quickshell/machine.json` (gitignored). A `machine.json.sample` with the
same keys is shipped, and every key has a sane default, so the file is optional on a new
machine.

```json
{
    "primaryScreen": "HDMI-A-1",
    "agentsMonitor": "HDMI-A-1",
    "iconFontSize": 22,
    "iconSpacing": " ",
    "thermalPath": "/sys/class/hwmon/hwmon0/temp1_input"
}
```

| Key | Description | Default |
|-----|-------------|---------|
| `primaryScreen` | Screen name for bar/panels (`hyprctl monitors`) | first detected screen |
| `agentsMonitor` | Screen that owns the agent scratchpad (SUPER + A). Must match `agents_monitor` in `~/.config/hypr/modules/hardware/monitors.local.lua`; see [hyprland/README.md](../hyprland/README.md) for why. | `primaryScreen` |
| `iconFontSize` | Workspace pill icon size in px | `22` |
| `iconSpacing` | Separator between workspace icons | `" "` |
| `thermalPath` | hwmon file used by the temperature widget | auto-detected at startup (`coretemp` / `k10temp`); the key only overrides it |

`MachineConfig.qml` is the only place that reads the JSON; widgets ask the singleton
(`MachineConfig.primaryScreen`, `MachineConfig.agentsMonitor`, ...). If `agentsMonitor` is
empty, `AgentWidget` does not move focus and just toggles the workspace.
