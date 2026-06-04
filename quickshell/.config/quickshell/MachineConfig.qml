pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    FileView {
        id: configFile
        path: Quickshell.env("HOME") + "/.config/quickshell/machine.json"
        watchChanges: false
    }

    readonly property var config: {
        try { return JSON.parse(configFile.text || "{}") } catch(_) { return {} }
    }

    readonly property string primaryScreen: config.primaryScreen ?? (Quickshell.screens[0]?.name ?? "")
    readonly property int iconFontSize: config.iconFontSize ?? 22
    readonly property string iconSpacing: config.iconSpacing ?? " "
}
