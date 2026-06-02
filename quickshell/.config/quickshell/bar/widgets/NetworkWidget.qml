import QtQuick
import QtQuick.Layouts

import Quickshell.Networking

import qs.components
import qs.style

StyledRect {
    id: root

    implicitWidth: layout.implicitWidth + Tokens.appearance.padding.small * 2
    implicitHeight: layout.implicitHeight + Tokens.appearance.padding.small
    Layout.alignment: Qt.AlignVCenter

    readonly property var devices: Networking.devices.values
    property var currentDevice: null
    property var connectivity: Networking.connectivity

    function updateCurrentDevice() {
        currentDevice = devices.find(device => device.connected) ?? null
    }

    Component.onCompleted: updateCurrentDevice()
    onDevicesChanged: updateCurrentDevice()

    property string icon: !currentDevice ? "wifi" : (currentDevice.type === DeviceType.Wired ? "lan" : "wifi")

    RowLayout {
        id: layout
        anchors.left: parent.left
        anchors.leftMargin: Tokens.appearance.padding.small
        anchors.verticalCenter: parent.verticalCenter
        spacing: Tokens.appearance.spacing.smaller

        MaterialIcon {
            color: Theme.primary
            text: root.icon
            Layout.alignment: Qt.AlignVCenter
            visible: !!root.currentDevice
        }

        StyledText {
            text: root.currentDevice?.name ?? ""
            Layout.alignment: Qt.AlignVCenter
            visible: !!root.currentDevice
        }
    }
}
