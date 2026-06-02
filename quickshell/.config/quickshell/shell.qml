pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import qs.bar
import qs.panels

Scope {
    id: shell
    readonly property string primaryScreen: "HDMI-A-1"

    Bar {
        primaryScreen: shell.primaryScreen
    }

    Panels {
        id: panels
        targetScreen: shell.primaryScreen
    }

    Shortcuts {
        id: shortcuts
    }
}
