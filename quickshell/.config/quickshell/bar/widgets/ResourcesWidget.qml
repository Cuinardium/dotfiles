import QtQuick
import QtQuick.Layouts
import qs.style
import qs.components
import qs.services

StyledRect {
    id: root

    property color widgetColor: Theme.primary

    property int iconSize: 24

    implicitWidth: layout.implicitWidth + (Tokens.appearance.padding.small * 2)
    implicitHeight: layout.implicitHeight + Tokens.appearance.padding.small

    RowLayout {
        id: layout
        spacing: Tokens.appearance.spacing.smaller
        anchors.left: parent.left
        anchors.leftMargin: Tokens.appearance.padding.small
        anchors.verticalCenter: parent.verticalCenter


        ProgressIcon {
            id: memoryProgress
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: root.iconSize
            Layout.preferredHeight: root.iconSize
            progress: Resources.memoryUsedPercentage
            iconName: "memory_alt"
            color: root.widgetColor
            iconPointSize: 11
        }

        ProgressIcon {
            id: cpuProgress
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: root.iconSize
            Layout.preferredHeight: root.iconSize
            progress: Resources.cpuUsage
            iconName: "memory"
            color: root.widgetColor
            iconPointSize: 12
        }

        ProgressIcon {
            id: tempProgress
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: root.iconSize
            Layout.preferredHeight: root.iconSize
            progress: Math.max(0, Math.min(1.0, Resources.cpuTemp / 100))
            iconName: "device_thermostat"
            color: root.widgetColor
            iconPointSize: 11
        }
    }
}
