import QtQuick
import qs.style
import qs.components
import qs

Item {
    id: root

    implicitWidth: 32
    implicitHeight: 32

    // Estado del menú
    readonly property bool menuOpen: ShellState.menus.powerMenu

    // El botón en la barra
    Rectangle {
        anchors.fill: parent
        radius: Tokens.appearance.rounding.full
        color: root.menuOpen ? Qt.alpha(Theme.error, 0.24) : Qt.alpha(Theme.background, 0.24)

        Behavior on color {
            ColorAnimation {
                duration: Tokens.appearance.animDurations.expressiveFastEffects
                easing.type: Easing.Bezier
                easing.bezierCurve: Tokens.appearance.curves.standard
            }
        }

        MaterialIcon {
            anchors.centerIn: parent
            text: "power_settings_new"
            color: root.menuOpen ? Theme.error : Theme.primary
            fill: root.menuOpen ? 1 : 0

            Behavior on color {
                ColorAnimation { duration: Tokens.appearance.animDurations.expressiveFastEffects }
            }
        }

        StateLayer {
            anchors.fill: parent
            radius: Tokens.appearance.rounding.full
            onClicked: ShellState.menus.powerMenu = !ShellState.menus.powerMenu
        }
    }
}
