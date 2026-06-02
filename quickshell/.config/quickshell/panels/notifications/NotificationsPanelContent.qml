pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications
import qs.style
import qs.services
import qs.components

Item {
    id: root

    ColumnLayout {
        anchors.fill: parent
        spacing: Tokens.appearance.spacing.small

        RowLayout {
            Layout.fillWidth: true
            Layout.topMargin: Tokens.appearance.spacing.small
            Layout.bottomMargin: Tokens.appearance.spacing.small
            visible: notifList.count > 0

            StyledText {
                Layout.fillWidth: true
                text: "Notifications"
                font.pointSize: Tokens.appearance.fontSize.larger
                color: Theme.primary
            }

            Item {
                implicitWidth: 28
                implicitHeight: 28

                MaterialIcon {
                    anchors.centerIn: parent
                    text: "delete_sweep"
                    color: Theme.error
                }

                StateLayer {
                    radius: Tokens.appearance.rounding.full
                    onClicked: {
                        for (var i = notifList.count - 1; i >= 0; i--) {
                            var card = notifList.itemAtIndex(i)
                            if (card) card.startDismiss((notifList.count - 1 - i) * 80)
                        }
                    }
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ListView {
                id: notifList
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: Math.min(contentHeight, parent.height)
                model: Notifications.trackedNotifications
                verticalLayoutDirection: ListView.BottomToTop
                spacing: Tokens.appearance.spacing.smaller

                remove: Transition {
                    ParallelAnimation {
                        NumberAnimation { property: "opacity"; to: 0; duration: 200; easing.type: Easing.OutCubic }
                        NumberAnimation { property: "_heightFactor"; to: 0; duration: 200; easing.type: Easing.InCubic }
                    }
                }
                displaced: Transition {
                    NumberAnimation {
                        properties: "y"
                        duration: 250
                        easing.type: Easing.OutCubic
                    }
                }

                delegate: NotificationCard {
                    required property Notification modelData
                    width: notifList.width
                    notification: modelData
                }
            }
        }
    }

    StyledText {
        anchors.centerIn: parent
        visible: notifList.count === 0
        text: "No notifications"
        color: Theme.on_surface_variant
    }
}
