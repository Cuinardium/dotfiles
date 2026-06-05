pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property list<QtObject> _children: [
        FileView {
            path: Quickshell.shellDir + "/machine.json"
            watchChanges: true
            onFileChanged: reload()

            adapter: JsonAdapter {
                id: config
                property string primaryScreen: Quickshell.screens[0]?.name ?? ""
                property int iconFontSize: 22
                property string iconSpacing: " "
                property string thermalPath: ""
            }
        }
    ]

    readonly property string primaryScreen: config.primaryScreen
    readonly property int iconFontSize: config.iconFontSize
    readonly property string iconSpacing: config.iconSpacing
    readonly property string thermalPath: config.thermalPath
}
