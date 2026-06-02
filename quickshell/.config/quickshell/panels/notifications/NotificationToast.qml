pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Services.Notifications;
import qs
import qs.style.motions

PanelWindow {
    id: toast

    anchors.top: true
    anchors.right: true

    readonly property bool shouldShow: ShellState.currentNotification !== null && !ShellState.menus.notificationsOpen

    // Holds the last non-null notification so the card keeps rendering it
    // during the slide-out animation (currentNotification is nulled immediately on dismiss).
    property Notification _lastNotification: null

    Connections {
        target: ShellState
        function onCurrentNotificationChanged() {
            if (ShellState.currentNotification !== null)
                toast._lastNotification = ShellState.currentNotification
        }
    }

    property int cardWidth: 320
    property int cardMargin: 48

    implicitWidth: cardWidth
    implicitHeight: card.implicitHeight + cardMargin * 2

    exclusionMode: ExclusionMode.Ignore
    color: "transparent"
    visible: shouldShow || slider.x < cardWidth

    Item {
        anchors.fill: parent
        clip: true

        Item {
            id: slider
            width: toast.cardWidth
            height: parent.height
            x: toast.shouldShow ? 0 : toast.cardWidth

            onXChanged: if (x >= toast.cardWidth && !toast.shouldShow) toast._lastNotification = null

            Behavior on x {
                Anim { id: slideAnim; type: Anim.DefaultSpatial }
            }

            NotificationCard {
                id: card
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    margins: toast.cardMargin
                    rightMargin: 24
                }
                notification: toast._lastNotification
                onDismissed: ShellState.dismissToast()
            }
        }
    }
}
