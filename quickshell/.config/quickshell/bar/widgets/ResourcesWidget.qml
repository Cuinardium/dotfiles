import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import qs.style
import qs.components
import qs.services

StyledRect {
    id: root

    property color widgetColor: Theme.primary
    property int iconSize: 24

    readonly property var batteryDevice: UPower.displayDevice
    readonly property bool hasBattery: batteryDevice.isLaptopBattery
    readonly property real batteryPct: batteryDevice.percentage
    readonly property bool batteryCharging: batteryDevice.state === UPowerDeviceState.Charging
                                         || batteryDevice.state === UPowerDeviceState.PendingCharge
    readonly property color batteryIconColor: batteryPct <= 0.2 ? Theme.error : Theme.primary

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
            visible: Resources.cpuTemp > 0
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: root.iconSize
            Layout.preferredHeight: root.iconSize
            progress: Math.max(0, Math.min(1.0, Resources.cpuTemp / 100))
            iconName: "device_thermostat"
            color: root.widgetColor
            iconPointSize: 11
        }

        ProgressIcon {
            visible: root.hasBattery
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: root.iconSize
            Layout.preferredHeight: root.iconSize
            progress: root.batteryPct
            iconName: root.batteryCharging ? "battery_charging_full" : "battery_full"
            color: root.batteryIconColor
            iconPointSize: 11
        }
    }
}
