import QtQuick
import QtQuick.Effects
import qs.style
import qs.style.motions

Item {
    id: root
    anchors.fill: parent

    // --- Material 3 Standard Opacities ---
    readonly property real hoverOpacity: 0.08
    readonly property real pressOpacity: 0.12

    // --- Theming & Tokens ---
    property color effectColor: Theme.outline
    property int radius: Tokens.appearance.rounding.normal

    // --- Forwarded Signals ---
    signal clicked(var mouse)
    signal pressed(var mouse)
    signal released(var mouse)
    signal wheeled(var wheel)

    // Visual Effects Container — clips hover and ripple to rounded shape
    Rectangle {
        id: maskRect
        anchors.fill: parent
        radius: root.radius
        color: "black"
        opacity: 0
        layer.enabled: true
    }

    Item {
        id: effectContainer
        anchors.fill: parent
        layer.enabled: true
        layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: maskRect
        }

        // Hover State Layer
        Rectangle {
            id: hoverLayer
            anchors.fill: parent
            radius: root.radius
            color: root.effectColor
            opacity: mouseArea.containsMouse && !mouseArea.pressed ? root.hoverOpacity : 0.0

            Behavior on opacity {
                Anim {
                    type: Anim.FastSpatial
                }
            }
        }

        // Ripple State Layer
        Rectangle {
            id: ripple
            property real maxSize: Math.sqrt(Math.pow(root.width, 2) + Math.pow(root.height, 2)) * 2

            width: 0
            height: width
            radius: width / 2
            color: root.effectColor
            opacity: 0

            transform: Translate {
                x: -ripple.width / 2
                y: -ripple.height / 2
            }
        }
    }

    // 3. Interaction Handling
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        cursorShape: Qt.PointingHandCursor

        onPressed: mouse => {
            ripple.x = mouse.x;
            ripple.y = mouse.y;
            ripple.width = 0;
            ripple.opacity = root.pressOpacity;
            pressAnim.restart();
            root.pressed(mouse);
        }

        onReleased: mouse => {
            releaseAnim.restart();
            root.released(mouse);
        }

        onCanceled: {
            releaseAnim.restart();
        }

        onClicked: mouse => {
            root.clicked(mouse);
        }

        onWheel: wheel => {
            root.wheeled(wheel);
        }
    }

    // --- Animations ---
    ParallelAnimation {
        id: pressAnim
        Anim {
            target: ripple
            property: "width"
            to: ripple.maxSize
            type: Anim.Emphasized
        }
    }

    ParallelAnimation {
        id: releaseAnim
        Anim {
            target: ripple
            property: "opacity"
            to: 0
            type: Anim.Standard
        }
    }
}
