import QtQuick
import QtQuick.Layouts

import Quickshell.Networking
import Quickshell.Bluetooth
import Quickshell.Widgets

import qs.components
import qs.style
import qs.style.motions

StyledRect {
    id: root

    implicitWidth: layout.implicitWidth + Tokens.appearance.padding.small * 2
    implicitHeight: layout.implicitHeight + Tokens.appearance.padding.small
    Layout.alignment: Qt.AlignVCenter

    // Network
    readonly property var networkDevices: Networking.devices.values
    property var currentNetworkDevice: null

    function updateNetworkDevice() {
        currentNetworkDevice = networkDevices.find(d => d.connected) ?? null
    }

    Component.onCompleted: updateNetworkDevice()
    onNetworkDevicesChanged: updateNetworkDevice()

    readonly property bool isWifi: !!currentNetworkDevice && currentNetworkDevice.type === DeviceType.Wifi

    readonly property var activeWifiNetwork: {
        if (!isWifi) return null
        return currentNetworkDevice.networks.values.find(n => n.connected) ?? null
    }

    readonly property string networkIcon: {
        if (!currentNetworkDevice) return "signal_wifi_off"
        if (!isWifi) return "lan"
        const s = activeWifiNetwork?.signalStrength ?? 0
        if (s > 0.66) return "wifi"
        if (s > 0.33) return "wifi_2_bar"
        if (s > 0) return "wifi_1_bar"
        return "signal_wifi_0_bar"
    }

    // Bluetooth
    readonly property BluetoothDevice btDevice: Bluetooth.devices.values.find(d => d.connected)
    readonly property BluetoothAdapter btAdapter: Bluetooth.adapters.values.find(a => a.enabled)
    readonly property bool btEnabled: btAdapter ? btAdapter.enabled : false
    readonly property bool btScanning: btAdapter ? btAdapter.discovering : false
    readonly property bool btConnected: btDevice ? btDevice.connected : false

    readonly property string btIcon: {
        if (!btEnabled) return "bluetooth_disabled"
        if (btConnected) return "bluetooth_connected"
        if (btScanning) return "bluetooth_searching"
        return "bluetooth"
    }

    RowLayout {
        id: layout
        anchors.left: parent.left
        anchors.leftMargin: Tokens.appearance.padding.small
        anchors.verticalCenter: parent.verticalCenter
        spacing: Tokens.appearance.spacing.smaller

        Item {
            Layout.alignment: Qt.AlignVCenter
            implicitWidth: networkFg.implicitWidth
            implicitHeight: networkFg.implicitHeight

            MaterialIcon {
                text: "wifi"
                fill: 0
                color: Theme.outline_variant
                visible: root.isWifi
            }

            MaterialIcon {
                id: networkFg
                text: root.networkIcon
                fill: root.isWifi ? 1 : 0
                color: root.currentNetworkDevice ? Theme.primary : Theme.outline
            }
        }

        SeparatorDot {}

        MaterialIcon {
            id: btIcon
            text: root.btIcon
            color: root.btConnected || root.btEnabled ? Theme.primary : Theme.outline_variant
            Layout.alignment: Qt.AlignVCenter

            BeepMotion {
                id: btMotion
                running: root.btScanning
                toColor: Theme.outline_variant
                minOpacity: 1
                target: btIcon
            }
        }
    }
}
