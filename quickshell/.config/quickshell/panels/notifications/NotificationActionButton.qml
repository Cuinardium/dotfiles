pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications
import qs.style
import qs.components

// Single action pill button. Size is driven by the label text — 8px vertical
// padding and 16px horizontal padding around it. The Rectangle is purely visual;
// the StateLayer on top handles hover, ripple, and the click that fires invoke().
Item {
    id: root

    required property NotificationAction action

    // Grow to fit the label + fixed padding on each axis
    implicitHeight: label.implicitHeight + 8
    implicitWidth: label.implicitWidth + 16

    // ── Background pill ──────────────────────────────────────────────────────
    Rectangle {
        anchors.fill: parent
        radius: Tokens.appearance.rounding.small
        color: Qt.alpha(Theme.primary, 0.15)
    }

    // ── Label ────────────────────────────────────────────────────────────────
    StyledText {
        id: label
        anchors.centerIn: parent
        text: root.action.text
        color: Theme.primary
        font.pointSize: Tokens.appearance.fontSize.smaller
    }

    // ── Interaction layer ────────────────────────────────────────────────────
    // Sits above everything; invoke() sends the action reply over D-Bus.
    StateLayer {
        radius: Tokens.appearance.rounding.small
        onClicked: root.action.invoke()
    }
}
