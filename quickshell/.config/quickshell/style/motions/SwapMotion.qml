import QtQuick
import qs.style

Behavior {
    id: root
    property var item

    SequentialAnimation {
        // Fade out
        Anim {
            target: item
            property: "opacity"
            to: 0
            duration: Tokens.appearance.animDurations.small
            easing.bezierCurve: Tokens.appearance.curves.standardAccel
        }

        // Instant swap
        PropertyAction {
        }

        // Fade in
        NumberAnimation {
            target: item
            property: "opacity"
            to: 1
            duration: Tokens.appearance.animDurations.normal
            easing.bezierCurve: Tokens.appearance.curves.standardDecel
        }
    }
}
