import QtQuick
import QtQuick.Layouts

import qs.style
import qs.components
import qs.services

StyledRect {
    id: root

    property bool showDate: true

    implicitWidth: layout.implicitWidth + Tokens.appearance.padding.small * 2
    implicitHeight: 24 + Tokens.appearance.padding.small
    Layout.alignment: Qt.AlignVCenter

    RowLayout {
        id: layout
        anchors.left: parent.left
        anchors.leftMargin: Tokens.appearance.padding.small
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        spacing: Tokens.appearance.spacing.smaller

        StyledText {
            text: Time.time
            color: Theme.primary
            font.bold: true
            Layout.fillHeight: true
            verticalAlignment: Text.AlignVCenter
        }

        SeparatorDot {
            visible: root.showDate
        }

        StyledText {
            text: Time.date
            font.pointSize: Tokens.appearance.fontSize.smaller
            Layout.fillHeight: true
            verticalAlignment: Text.AlignVCenter
            visible: root.showDate
        }
    }
}
