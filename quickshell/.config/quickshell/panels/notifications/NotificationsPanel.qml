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

    anchors.right: true

    readonly property bool isVisibleOrAnimating: ShellState.menus.notificationsOpen || slidingContainer.x < totalWidth

    property int totalWidth: 320
    property int totalHeight: Math.round(screen.height * 0.8)
    property int flareRadius: 64
    property int cornerRadius: 32
    implicitWidth: ShellState.menus.notificationsOpen || slideAnim.running ? totalWidth : 0
    implicitHeight: totalHeight

    exclusionMode: ExclusionMode.Ignore
    focusable: true
    visible: isVisibleOrAnimating

    color: "transparent"

    HyprlandFocusGrab {
        active: ShellState.menus.notificationsOpen
        windows: [panel]
        onCleared: ShellState.menus.notificationsOpen = false
    }

    Item {
        anchors.fill: parent
        clip: true
        focus: true

        Keys.onEscapePressed: ShellState.menus.notificationsOpen = false
        onVisibleChanged: if (ShellState.menus.notificationsOpen)
            forceActiveFocus()

        Item {
            id: slidingContainer
            width: panel.totalWidth
            height: panel.totalHeight
            anchors.verticalCenter: parent.verticalCenter
            // Overshoot compensation: +2 keeps panel flush against screen edge
            x: ShellState.menus.notificationsOpen ? 2 : panel.totalWidth

            Behavior on x {
                Anim {
                    id: slideAnim
                    type: Anim.SlowSpatial
                }
            }

            RightFlaredBackground {
                anchors.fill: parent
                flareRadius: panel.flareRadius
                cornerRadius: panel.cornerRadius
                effectColor: Theme.background
                alpha: 0.48
            }

            NotificationsPanelContent {
                anchors.fill: parent
                // Inset content past the flare curves so nothing bleeds outside the shape.
                // Top/bottom match flareRadius (the diagonal zones at each end).
                // Left matches cornerRadius (the rounded left corners).
                anchors.topMargin: panel.flareRadius
                anchors.bottomMargin: panel.flareRadius
                anchors.leftMargin: panel.cornerRadius
                anchors.rightMargin: 16
            }
        }
    }
}
