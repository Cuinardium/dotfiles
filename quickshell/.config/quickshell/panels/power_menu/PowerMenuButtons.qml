import QtQuick

import Quickshell
import qs.style
import qs.components
import qs.services

Column {
    id: column
    spacing: Tokens.appearance.spacing.smaller

    Repeater {
        // ── Acciones sin repetir el close ──────────────────────
        model: [
            {
                icon: "lock",
                action: Session.lock
            },
            {
                icon: "bedtime",
                action: Session.suspend
            },
            {
                icon: "restart_alt",
                action: Session.reboot
            },
            {
                icon: "power_settings_new",
                action: Session.poweroff
            },
        ]

        // ── Rectangle como raíz directa, sin Item wrapper ──────
        delegate: Rectangle {
            required property var modelData

            implicitWidth: icon.implicitWidth + Tokens.appearance.padding.larger
            implicitHeight: icon.implicitHeight + Tokens.appearance.padding.larger
            radius: Tokens.appearance.rounding.full
            color: Qt.alpha(Theme.primary, 0.12)

            MaterialIcon {
                id: icon
                anchors.centerIn: parent
                text: modelData.icon
                color: Theme.primary
                font.pointSize: 24
            }

            StateLayer {
                anchors.fill: parent
                radius: Tokens.appearance.rounding.full
                onClicked: {
                    modelData.action();
                    ShellState.menus.powerMenu = false;
                }
            }
        }
    }
}
