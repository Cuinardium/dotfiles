pragma ComponentBehavior: Bound

import QtQuick

import qs.components
import qs.style
import qs.style.motions

Item {
    id: root

    required property string label
    property bool available: true

    signal activated()

    implicitHeight: 30
    implicitWidth: labelText.implicitWidth + Tokens.appearance.padding.normal * 2

    StyledText {
        id: labelText

        anchors.left: parent.left
        anchors.leftMargin: Tokens.appearance.padding.normal
        anchors.verticalCenter: parent.verticalCenter
        text: root.label
        color: root.available ? Theme.on_surface : Theme.outline
        font.pointSize: Tokens.appearance.fontSize.normal
    }

    StateLayer {
        anchors.fill: parent
        radius: Tokens.appearance.rounding.small
        effectColor: Theme.primary
        enabled: root.available
        onClicked: root.activated()
    }
}
