pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Hyprland
import qs

Item {
    id: shortcutsRoot

    GlobalShortcut {
        name: "toggle-bar"
        description: "Toggle the bar visibility"
        onPressed: {
            ShellState.barVisible = !ShellState.barVisible
        }
    }

    GlobalShortcut {
        name: "toggle-power-menu"
        description: "Open the power menu"
        onPressed: ShellState.menus.powerMenu = !ShellState.menus.powerMenu
    }

    GlobalShortcut {
        name: "toggle-run-menu"
        description: "Open the app launcher"
        onPressed: ShellState.menus.runMenu = !ShellState.menus.runMenu
    }

    // You can easily drop volume, brightness, or screenshot shortcuts here later
}
