# Quickshell

## Machine-local display config

Create `~/.config/quickshell/machine.json` (gitignored) with display properties for the current machine.

```json
{
    "primaryScreen": "eDP-1",
    "iconFontSize": 14,
    "iconSpacing": "   "
}
```

| Key | Description | Default |
|-----|-------------|---------|
| `primaryScreen` | Screen name for bar/panels (`hyprctl monitors`) | first detected screen |
| `iconFontSize` | Workspace pill icon size in px | `22` |
| `iconSpacing` | Separator between workspace icons | `" "` |
