import QtQuick
import Quickshell.Hyprland
import QtQuick.Layouts

import qs.style

RowLayout {
    id: root
    required property HyprlandMonitor monitor
    readonly property string appId: monitor.activeWorkspace.toplevels.values.find(t => t.activated)?.wayland?.appId ?? ""
    readonly property var mappedEntry: IconMap.getMatch(appId)

    spacing: 8

    Text {
        text: mappedEntry.icon
        color: Theme.primary
        font.pixelSize: 26
        textFormat: Text.PlainText
    }

    Text {
        text: mappedEntry.title
        color: Theme.primary
        font.pixelSize: 14
        font.bold: true
        textFormat: Text.PlainText
    }
}
