import QtQuick
import QtQuick.Layouts
import qs.components
import qs.services
import qs.style
import qs.style.motions

ProgressIcon {
    id: root

    Layout.alignment: Qt.AlignVCenter
    Layout.preferredWidth: 24
    Layout.preferredHeight: 24

    iconPointSize: 12

    property real animatedVolume: Audio.volume
    Behavior on animatedVolume {
        Anim {
            type: Anim.Type.StandardSmall
        }
    }

    // Set properties based on audio state
    clickable: true
    progress: root.animatedVolume
    readonly property bool hasVolume: root.animatedVolume > 0
    readonly property bool isLowVolume: root.animatedVolume <= 0.4
    iconName: Audio.muted ? "volume_off" : (!hasVolume ? "volume_mute" : (isLowVolume ? "volume_down" : "volume_up"))
    color: Audio.muted ? Theme.error : Theme.primary

    // Animate the color transition when muting/unmuting
    Behavior on color {
        Anim {
            type: Anim.Type.StandardSmall
        }
    }

    onClicked: Audio.toggleMute()

    onWheeled: wheel => {
        if (wheel.angleDelta.y > 0)
            Audio.adjustVolume(0.02);
        else
            Audio.adjustVolume(-0.02);
    }
}
