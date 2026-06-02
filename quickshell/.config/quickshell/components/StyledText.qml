pragma ComponentBehavior: Bound

import QtQuick
import qs.style
import qs.style.motions

Text {
    id: root

    property bool animate: false
    property string animateProp: "scale"
    property real animateFrom: 0
    property real animateTo: 1
    property int animateDuration: Tokens.appearance.animDurations.normal
    color: Theme.on_surface

    renderType: Text.NativeRendering
    textFormat: Text.PlainText
    font.family: Tokens.appearance.fontFamily.sans
    font.pointSize: Tokens.appearance.fontSize.small

    Behavior on color {
        Anim {
        }
    }

    Behavior on text {
        enabled: root.animate

        SequentialAnimation {
            Anim {
                to: root.animateFrom
                easing: Tokens.appearance.curves.standardAccel
            }
            PropertyAction {}
            Anim {
                to: root.animateTo
                easing: Tokens.appearance.curves.standardDecel
            }
        }
    }

    component Anim: NumberAnimation {
        target: root
        property: root.animateProp
        duration: root.animateDuration / 2
    }
}
