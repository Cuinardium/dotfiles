import QtQuick
import qs.style
import qs.style.motions

Rectangle {
    id: root

    color: Qt.alpha(Theme.background, 0.24)
    radius: Tokens.appearance.rounding.full

    Behavior on color {
        Anim {}
    }
}
