pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications
import qs.style
import qs.components

// One notification card. Height is driven by inner content + 24px vertical padding.
// Background color switches to error tint when urgency === Critical.
Item {
    id: root

    required property Notification notification

    readonly property bool isCritical: notification !== null && notification.urgency === NotificationUrgency.Critical

    property real _heightFactor: 1.0
    implicitHeight: (inner.implicitHeight + 24) * _heightFactor
    clip: collapseAnim.running

    property real swipeX: 0
    property real _lastDragX: 0

    onNotificationChanged: {
        if (notification !== null) {
            dismissTimer.stop()
            swipeOutAnim.stop()
            snapBackAnim.stop()
            collapseAnim.stop()
            swipeX = 0
            _lastDragX = 0
            _heightFactor = 1.0
        }
    }

    transform: Translate { x: root.swipeX }
    opacity: Math.max(0.0, 1.0 - Math.abs(swipeX) / (width * 0.6))

    // ── Background ──────────────────────────────────────────────────────────
    Rectangle {
        anchors.fill: parent
        radius: Tokens.appearance.rounding.normal
        color: root.isCritical
            ? Qt.alpha(Theme.error_container, 0.12)
            : Qt.alpha(Theme.primary, 0.12)
    }

    // ── Content column ───────────────────────────────────────────────────────
    // Anchored left/right/top with 12px margins; bottom is left free so the
    // card's implicitHeight can grow with the content instead of clipping it.
    ColumnLayout {
        id: inner
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: 12
        }
        spacing: 4

        // ── Header row: [warning icon?] [app name ···] [✕] ─────────────────
        RowLayout {
            Layout.fillWidth: true
            spacing: 6

            // Warning icon — only visible for Critical urgency
            MaterialIcon {
                visible: root.isCritical
                text: "warning"
                color: Theme.error
                font.pointSize: Tokens.appearance.fontSize.small
            }

            // App name — elides if too long, turns red on Critical
            StyledText {
                Layout.fillWidth: true
                text: root.notification ? root.notification.appName : ""
                color: root.isCritical ? Theme.error : Theme.primary
                font.pointSize: Tokens.appearance.fontSize.smaller
                elide: Text.ElideRight
            }

            // Dismiss button — fixed 20×20 hit target wrapping the close icon
            Item {
                implicitWidth: 20
                implicitHeight: 20

                MaterialIcon {
                    anchors.centerIn: parent
                    text: "close"
                    color: Theme.error
                    font.pointSize: Tokens.appearance.fontSize.small
                }

                StateLayer {
                    radius: Tokens.appearance.rounding.full
                    onClicked: {
                        swipeOutAnim.to = root.width * 1.5
                        swipeOutAnim.start()
                    }
                }
            }
        }

        // ── Summary — main notification title, always present ───────────────
        StyledText {
            Layout.fillWidth: true
            text: root.notification ? root.notification.summary : ""
            color: Theme.on_surface
            font.pointSize: Tokens.appearance.fontSize.normal
            wrapMode: Text.WordWrap
        }

        // ── Body — optional detail text, may contain HTML markup ────────────
        StyledText {
            Layout.fillWidth: true
            visible: root.notification ? root.notification.body !== "" : false
            text: root.notification ? root.notification.body : ""
            color: Theme.on_surface_variant
            font.pointSize: Tokens.appearance.fontSize.small
            wrapMode: Text.WordWrap
            textFormat: Text.StyledText  // allows <b>, <i>, links from the sender
        }

        // ── Actions — pill buttons, hidden when app sends no actions ─────────
        // Flow wraps buttons to next line if they overflow the card width.
        Flow {
            Layout.fillWidth: true
            visible: root.notification ? (root.notification.hasActionIcons && root.notification.actions.length > 0) : false
            spacing: Tokens.appearance.spacing.smaller

            Repeater {
                model: root.notification ? root.notification.actions : null

                NotificationActionButton {
                    required property NotificationAction modelData
                    action: modelData
                }
            }
        }
    }

    DragHandler {
        id: dragger
        yAxis.enabled: false
        onActiveTranslationChanged: {
            if (active) {
                root.swipeX = activeTranslation.x
                root._lastDragX = activeTranslation.x
            }
        }
        onActiveChanged: {
            if (!active) {
                if (Math.abs(root._lastDragX) > root.width * 0.35) {
                    swipeOutAnim.to = root._lastDragX > 0 ? root.width * 1.5 : -root.width * 1.5
                    swipeOutAnim.start()
                } else {
                    snapBackAnim.start()
                }
            }
        }
    }

    NumberAnimation {
        id: snapBackAnim
        target: root
        property: "swipeX"
        to: 0
        duration: 300
        easing.type: Easing.OutBack
        easing.overshoot: 0.8
    }

    signal dismissed()

    NumberAnimation {
        id: swipeOutAnim
        target: root
        property: "swipeX"
        duration: 220
        easing.type: Easing.InCubic
        onFinished: collapseAnim.start()
    }

    NumberAnimation {
        id: collapseAnim
        target: root
        property: "_heightFactor"
        to: 0
        duration: 200
        easing.type: Easing.InCubic
        onFinished: {
            if (root.notification) root.notification.dismiss()
            root.dismissed()
        }
    }

    Timer {
        id: dismissTimer
        repeat: false
        onTriggered: {
            swipeOutAnim.to = root.width * 1.5
            swipeOutAnim.start()
        }
    }

    function startDismiss(delay) {
        dismissTimer.interval = delay
        dismissTimer.start()
    }
}
