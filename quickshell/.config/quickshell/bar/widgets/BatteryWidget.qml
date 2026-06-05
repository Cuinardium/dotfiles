import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower

import qs.components
import qs.style

StyledRect {
    id: root

    readonly property var device: UPower.displayDevice
    readonly property bool hasBattery: device.isLaptopBattery
    readonly property real pct: device.percentage * 100
    readonly property bool charging: device.state === UPowerDeviceState.Charging
                                  || device.state === UPowerDeviceState.PendingCharge
    readonly property bool full: device.state === UPowerDeviceState.FullyCharged

    visible: hasBattery

    implicitWidth: layout.implicitWidth + Tokens.appearance.padding.small * 2
    implicitHeight: layout.implicitHeight + Tokens.appearance.padding.small
    Layout.alignment: Qt.AlignVCenter

    readonly property string icon: {
        if (charging) return "battery_charging_full";
        if (full || pct >= 95) return "battery_full";
        if (pct >= 83) return "battery_6_bar";
        if (pct >= 67) return "battery_5_bar";
        if (pct >= 50) return "battery_4_bar";
        if (pct >= 33) return "battery_3_bar";
        if (pct >= 17) return "battery_2_bar";
        if (pct >= 8)  return "battery_1_bar";
        return "battery_alert";
    }

    readonly property color iconColor: (!charging && !full && pct <= 20) ? Theme.error : Theme.primary

    RowLayout {
        id: layout
        anchors.left: parent.left
        anchors.leftMargin: Tokens.appearance.padding.small
        anchors.verticalCenter: parent.verticalCenter
        spacing: Tokens.appearance.spacing.smaller

        MaterialIcon {
            text: root.icon
            color: root.iconColor
            Layout.alignment: Qt.AlignVCenter
        }

        StyledText {
            text: Math.round(root.pct) + "%"
            Layout.alignment: Qt.AlignVCenter
        }
    }
}
