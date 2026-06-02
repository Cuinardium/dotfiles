pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Hyprland

import qs
import qs.style.motions
import qs.style
import qs.components

PanelWindow {
    id: panel

    screen: Quickshell.screens[0]

    anchors.left: true

    readonly property bool isVisibleOrAnimating: ShellState.menus.powerMenu || slidingContainer.x > -totalWidth

    property int totalWidth: 66
    implicitWidth: ShellState.menus.powerMenu || slideAnim.running ? totalWidth : 0
    implicitHeight: buttons.implicitHeight + totalWidth * 1.5

    exclusionMode: ExclusionMode.Ignore
    focusable: true
    visible: isVisibleOrAnimating

    color: "transparent"

    HyprlandFocusGrab {
        active: ShellState.menus.powerMenu
        windows: [panel]
        onCleared: ShellState.menus.powerMenu = false
    }

    // ── Clip + teclado wrapper ──────────────────────────
    Item {
        anchors.fill: parent
        clip: true
        focus: true

        Keys.onEscapePressed: ShellState.menus.powerMenu = false
        onVisibleChanged: if (ShellState.menus.powerMenu)
            forceActiveFocus()

        Item {
            id: slidingContainer
            width: panel.totalWidth
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            // The animatio has a slight overshoot, so we need to compensate for that (-2)
            // if it was 0, there would be a small gap between the panel and the screen while it overshoots
            x: ShellState.menus.powerMenu ? -2 : -panel.totalWidth

            Behavior on x {
                Anim {
                    id: slideAnim
                    type: Anim.SlowSpatial
                }
            }

            LeftFlaredBackground {
                anchors.fill: parent
                flareRadius: panel.totalWidth / 2
                cornerRadius: panel.totalWidth / 2
                effectColor: Theme.background
                alpha: 0.48
            }

            PowerMenuButtons {
                id: buttons
                anchors.centerIn: parent
            }
        }
    }
}
