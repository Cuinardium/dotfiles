import QtQuick
import qs.style

SequentialAnimation {
    id: root

    property var target
    property color fromColor: Theme.primary
    property color toColor: Theme.error
    property int pulseDuration: 900
    property real minOpacity: 0.45

    loops: Animation.Infinite

    onRunningChanged: {
        if (!running && target) {
            target.color = fromColor;
            target.opacity = 1.0;
        }
    }

    ParallelAnimation {
        ColorAnimation {
            target: root.target
            property: "color"
            to: root.toColor
            duration: root.pulseDuration
            easing.type: Easing.InOutSine
        }
        NumberAnimation {
            target: root.target
            property: "opacity"
            to: root.minOpacity
            duration: root.pulseDuration
            easing.type: Easing.InOutSine
        }
    }
    ParallelAnimation {
        ColorAnimation {
            target: root.target
            property: "color"
            to: root.fromColor
            duration: root.pulseDuration
            easing.type: Easing.InOutSine
        }
        NumberAnimation {
            target: root.target
            property: "opacity"
            to: 1.0
            duration: root.pulseDuration
            easing.type: Easing.InOutSine
        }
    }
}
