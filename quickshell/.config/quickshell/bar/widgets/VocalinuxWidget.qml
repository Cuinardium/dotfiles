pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import qs.bar.widgets.vocalinux
import qs.components
import qs.services
import qs.style
import qs.style.motions

StyledRect {
    id: root

    Layout.alignment: Qt.AlignVCenter
    implicitWidth: 32
    implicitHeight: 32
    visible: Vocalinux.running

    property bool menuOpen: false

    color: Vocalinux.active ? Qt.alpha(Theme.primary, 0.24) : Qt.alpha(Theme.background, 0.24)

    Accessible.role: Accessible.Button
    Accessible.name: qsTr("Voice typing")

    MaterialIcon {
        id: icon

        anchors.centerIn: parent
        text: Vocalinux.processing ? "graphic_eq" : "mic"
        color: Vocalinux.active ? Theme.primary : Theme.outline
        fill: Vocalinux.listening ? 1 : 0

        Behavior on color {
            Anim { type: Anim.StandardSmall }
        }

        SwapMotion on text {
            item: icon
        }
    }

    // SwapMotion already owns icon.opacity, so the busy pulse drives scale.
    SequentialAnimation {
        running: Vocalinux.processing
        loops: Animation.Infinite

        onRunningChanged: {
            if (!running)
                icon.scale = 1;
        }

        NumberAnimation {
            target: icon
            property: "scale"
            to: 0.82
            duration: Tokens.appearance.animDurations.expressiveSlowSpatial
            easing.type: Easing.InOutSine
        }
        NumberAnimation {
            target: icon
            property: "scale"
            to: 1
            duration: Tokens.appearance.animDurations.expressiveSlowSpatial
            easing.type: Easing.InOutSine
        }
    }

    StateLayer {
        anchors.fill: parent
        radius: Tokens.appearance.rounding.full
        effectColor: Theme.primary
        onClicked: Vocalinux.toggle()
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton

        onPressed: root.menuOpen = !root.menuOpen
    }

    VocalinuxMenu {
        anchorItem: root
        open: root.menuOpen
        onCloseRequested: root.menuOpen = false
    }
}
