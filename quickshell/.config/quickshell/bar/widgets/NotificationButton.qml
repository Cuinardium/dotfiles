import QtQuick
import qs.style
import qs.style.motions
import qs.components
import qs.services
import qs

Item {
    id: root

    implicitWidth: 32
    implicitHeight: 32

    readonly property bool panelOpen: ShellState.menus.notificationsOpen
    readonly property bool hasNotifications: Notifications.hasNotifications

    Rectangle {
        anchors.fill: parent
        radius: Tokens.appearance.rounding.full
        color: root.panelOpen ? Qt.alpha(Theme.primary, 0.24) : Qt.alpha(Theme.background, 0.24)

        MaterialIcon {
            id: icon

            anchors.centerIn: parent
            text: "notifications"
            fill: root.panelOpen ? 1 : 0

            Binding {
                target: icon
                property: "color"
                value: Theme.primary
                when: !beepMotion.running
                restoreMode: Binding.RestoreBinding
            }

            BeepMotion {
                id: beepMotion
                running: root.hasNotifications
                target: icon
            }
        }

        StateLayer {
            anchors.fill: parent
            radius: Tokens.appearance.rounding.full
            onClicked: ShellState.menus.notificationsOpen = !ShellState.menus.notificationsOpen
        }
    }
}
