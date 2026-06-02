pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    property bool barVisible: true

    property QtObject menus: QtObject {
        property bool powerMenu: false
        property bool runMenu: false
        property bool notificationsOpen: false
    }

    property Notification currentNotification: null
    property bool _autoDismissToast: false

    function showToast(notification, autoDismiss) {
        // dismiss previous before replacing — otherwise timer fires on new one and old one is never dismissed
        if (_autoDismissToast && currentNotification) currentNotification.dismiss()
        currentNotification = notification
        _autoDismissToast = autoDismiss ?? false
        toastTimer.restart()
    }

    function dismissToast() {
        if (_autoDismissToast && currentNotification) currentNotification.dismiss()
        currentNotification = null
        _autoDismissToast = false
        toastTimer.stop()
    }

    Timer {
        id: toastTimer
        interval: 5000
        repeat: false
        onTriggered: root.dismissToast()
    }
}
