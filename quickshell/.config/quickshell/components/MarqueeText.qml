import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

import qs.style
import qs.style.motions

Item {
    id: marqueeRoot

    required property string title
    property color textColor: Theme.primary
    property real textOpacity: 1
    property bool scrollEnabled: false
    property real textPointSize: Tokens.appearance.fontSize.small
    readonly property int gap: Tokens.appearance.spacing.large
    readonly property int maxWidth: 200

    readonly property bool shouldScroll: text1.width > maxWidth

    // Exposed so the scroll Component can compute its animation target
    // without depending on text1's id across a Component boundary.
    readonly property real singleTextWidth: text1.width

    Layout.preferredWidth: Math.min(text1.width, maxWidth)
    Layout.fillHeight: true
    clip: true

    SwapMotion on title {
        item: text1
        enabled: text1.text !== ""
    }

    signal wheeled(var wheel)
    StateLayer {
        visible: marqueeRoot.scrollEnabled
        onWheeled: wheel => {
            marqueeRoot.wheeled(wheel);
        }
        effectColor: "transparent"
    }

    // --- Static display (not scrolling) ---
    StyledText {
        id: text1
        anchors.verticalCenter: parent.verticalCenter
        visible: !marqueeRoot.shouldScroll
        text: marqueeRoot.title
        color: marqueeRoot.textColor
        opacity: marqueeRoot.textOpacity
        font.pointSize: marqueeRoot.textPointSize
    }

    // --- Scroll display: fully self-contained, lazy loaded ---
    Loader {
        id: scrollLoader
        anchors.fill: parent
        active: marqueeRoot.shouldScroll
        sourceComponent: scrollComponent
    }

    Component {
        id: scrollComponent

        Item {
            clip: true

            // Source item for OpacityMask. layer.enabled forces FBO population
            // even with visible: false, so the mask shader has a valid texture.
            Item {
                id: scrollSource
                anchors.fill: parent
                visible: false
                layer.enabled: true

                Row {
                    id: scrollRow
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: marqueeRoot.gap

                    StyledText {
                        text: marqueeRoot.title
                        color: marqueeRoot.textColor
                        opacity: marqueeRoot.textOpacity
                        font.pointSize: marqueeRoot.textPointSize
                    }
                    StyledText {
                        text: marqueeRoot.title
                        color: marqueeRoot.textColor
                        opacity: marqueeRoot.textOpacity
                        font.pointSize: marqueeRoot.textPointSize
                    }
                }
            }

            NumberAnimation {
                id: scrollAnim
                target: scrollRow
                property: "x"
                from: 0
                to: -(marqueeRoot.singleTextWidth + marqueeRoot.gap)
                duration: 13000
                loops: Animation.Infinite
                running: true
            }

            Rectangle {
                id: localGradient
                anchors.fill: parent
                visible: false
                layer.enabled: true
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0;  color: "transparent" }
                    GradientStop { position: 0.08; color: "black" }
                    GradientStop { position: 0.85; color: "black" }
                    GradientStop { position: 1.0;  color: "transparent" }
                }
            }

            MultiEffect {
                anchors.fill: parent
                source: scrollSource
                maskEnabled: true
                maskSource: localGradient
            }

            Connections {
                target: marqueeRoot
                enabled: marqueeRoot != null
                function onTitleChanged() {
                    scrollRow.x = 0;
                    scrollAnim.restart();
                }
            }
        }
    }
}
