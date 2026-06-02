pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import Quickshell.Hyprland

import qs.components
import qs.style
import qs.style.motions

Loader {
    id: root
    property var workspace: Hyprland.workspaces.values.find(w => w.name === "special:agents")
    active: workspace !== undefined
    Layout.alignment: Qt.AlignVCenter
    // Hyprland no expone bien esta propiedad para special workspaces
    readonly property bool isFocused: (Hyprland.focusedMonitor?.lastIpcObject.specialWorkspace?.name ?? "") === "special:agents"

    // Este es para opencode
    property bool hasNativeUrgentWindow: root.workspace?.urgent ?? false
    // Este es para claude code
    property bool hasTaggedUrgentWindow: root.workspace?.toplevels.values.map(v => v.lastIpcObject.tags.includes("urgent*")).includes(true) ?? false
    property bool isUrgent: hasNativeUrgentWindow || hasTaggedUrgentWindow

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event.name === "activespecialv2" || (event.name === "custom" && event.data === "claude-urgent")) {
                Hyprland.refreshToplevels();
                Hyprland.refreshMonitors();
            }
        }
    }

    sourceComponent: StyledRect {
        implicitWidth: 32
        implicitHeight: 32

        color: root.isFocused ? Qt.alpha(Theme.primary, 0.24) : Qt.alpha(Theme.background, 0.24)

        Behavior on color {
            ColorAnimation {
                duration: Tokens.appearance.animDurations.expressiveFastEffects
                easing.type: Easing.Bezier
                easing.bezierCurve: Tokens.appearance.curves.standard
            }
        }

        MaterialIcon {
            id: icon
            text: "robot_2"
            color: Theme.primary
            anchors.centerIn: parent
            fill: root.isFocused ? 1 : 0

            Behavior on color {
                enabled: !root.isUrgent
                ColorAnimation {
                    duration: Tokens.appearance.animDurations.expressiveFastEffects
                }
            }

            BeepMotion {
                running: root.isUrgent
                target: icon
            }
        }

        StateLayer {
            anchors.fill: parent
            effectColor: Theme.primary
            radius: Tokens.appearance.rounding.full

            onClicked: {
                if (root.workspace)
                    Hyprland.dispatch("hl.dsp.workspace.toggle_special('agents')");
            }
        }
    }
}
