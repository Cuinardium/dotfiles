pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import qs.services
import qs.components
import qs.style
import qs.style.motions

StyledRect {
    id: root

    // ── MPRIS ─────────────────────────────────────────────────────────────
    property int playerIndex: 0
    readonly property var activePlayer: Mpris.players.values?.[playerIndex] ?? null
    readonly property bool isActive: activePlayer != null
    readonly property int playerCount: Mpris.players.values?.length ?? 0
    readonly property bool canTogglePlaying: isActive && activePlayer.canTogglePlaying
    readonly property bool canSeek: isActive && activePlayer.canSeek
    readonly property bool hasProgress: isActive && activePlayer.lengthSupported
        && activePlayer.positionSupported && activePlayer.length > 0

    // ── Source strip config ───────────────────────────────────────────────
    readonly property int maxSources: 6
    readonly property real maxDotsStripWidth: maxSources * 12 + (maxSources - 1) * 4  // 92px

    // ── Audio ─────────────────────────────────────────────────────────────
    property real animatedVolume: Audio.volume
    Behavior on animatedVolume {
        Anim { type: Anim.Type.StandardSmall }
    }

    implicitWidth: layout.implicitWidth + Tokens.appearance.padding.small * 2
    implicitHeight: layout.implicitHeight + Tokens.appearance.padding.small
    Layout.alignment: Qt.AlignVCenter

    Connections {
        target: Mpris.players
        function onValuesChanged() {
            const count = Mpris.players.values?.length ?? 0
            if (root.playerIndex >= count)
                root.playerIndex = Math.max(0, count - 1)
        }
    }

    Timer {
        running: root.activePlayer?.playbackState === MprisPlaybackState.Playing
        interval: 1000
        repeat: true
        onTriggered: root.activePlayer?.positionChanged()
    }

    RowLayout {
        id: layout
        anchors.left: parent.left
        anchors.leftMargin: Tokens.appearance.padding.small
        anchors.right: parent.right
        anchors.rightMargin: Tokens.appearance.padding.small
        anchors.verticalCenter: parent.verticalCenter
        spacing: Tokens.appearance.spacing.smaller

        // ── Left knob: volume ─────────────────────────────────────────────
        ProgressIcon {
            id: volumeKnob

            clickable: true
            progress: root.animatedVolume
            iconPointSize: 12
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24

            readonly property bool hasVolume: root.animatedVolume > 0
            readonly property bool isLowVolume: root.animatedVolume <= 0.4
            iconName: Audio.muted ? "volume_off"
                : (!hasVolume ? "volume_mute" : (isLowVolume ? "volume_down" : "volume_up"))
            color: Audio.muted ? Theme.error : Theme.primary

            Behavior on color { Anim { type: Anim.Type.StandardSmall } }

            onClicked: Audio.toggleMute()
            onWheeled: wheel => {
                if (wheel.angleDelta.y > 0)
                    Audio.adjustVolume(0.02)
                else
                    Audio.adjustVolume(-0.02)
            }
        }

        // ── Center display ─────────────────────────────────────────────────
        Rectangle {
            id: display

            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: Math.max(
                (titleRowLoader.item?.implicitWidth ?? 0) + Tokens.appearance.padding.small * 2,
                root.maxDotsStripWidth + Tokens.appearance.padding.small * 2
            )
            Layout.preferredHeight: 24

            clip: true
            radius: Tokens.appearance.rounding.full
            color: Qt.alpha(Theme.primary, root.isActive ? 0.12 : 0.05)

            Behavior on Layout.preferredWidth {
                Anim { type: Anim.Standard }
            }
            Behavior on color {
                Anim { type: Anim.Type.StandardSmall }
            }

            // Standby: animated equalizer bars
            Item {
                id: standbyDisplay
                anchors.fill: parent
                opacity: root.isActive ? 0 : 1

                Behavior on opacity { Anim { type: Anim.Standard } }

                property int activeDash: 0

                Timer {
                    running: !root.isActive
                    interval: 800
                    repeat: true
                    onTriggered: standbyDisplay.activeDash = (standbyDisplay.activeDash + 1) % 5
                }

                Row {
                    anchors.centerIn: parent
                    spacing: 8
                    // bridge outer id into Row so delegate can reach it via parent
                    property int activeDash: standbyDisplay.activeDash

                    Repeater {
                        model: 5
                        StyledText {
                            required property int index
                            text: "—"
                            color: Theme.primary
                            font.pointSize: 10
                            opacity: index === parent.activeDash ? 0.7 : 0.15

                            Behavior on opacity { Anim { type: Anim.Type.StandardSmall } }
                        }
                    }
                }
            }

            Loader {
                id: titleRowLoader
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                // Keep alive during fade-out so opacity animation completes before destruction
                active: root.isActive || opacity > 0
                opacity: root.isActive ? 1 : 0

                Behavior on opacity {
                    Anim { type: Anim.Standard }
                }

                sourceComponent: Component {
                    RowLayout {
                        MarqueeText {
                            title: root.activePlayer?.trackTitle ?? ""
                            Layout.maximumWidth: maxWidth
                            textPointSize: 10
                            scrollEnabled: root.playerCount > 1
                            onWheeled: wheel => {
                                const count = root.playerCount
                                var newIndex = root.playerIndex + (wheel.angleDelta.y > 0 ? 1 : -1)
                                if (newIndex < 0)
                                    newIndex = count - 1
                                else if (newIndex >= count)
                                    newIndex = 0
                                root.playerIndex = newIndex
                            }
                        }
                    }
                }
            }

            // Source indicators: one LED per player, capped at maxSources
            Row {
                id: sourceStrip
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 2
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 4
                height: root.isActive && root.playerCount > 1 ? 3 : 0
                opacity: root.isActive && root.playerCount > 1 ? 1 : 0
                // bridge outer id into Row so delegate can reach it via parent
                property int playerIndex: root.playerIndex

                Behavior on height { Anim { type: Anim.Standard } }
                Behavior on opacity {
                    Anim { type: Anim.Standard }
                }

                Repeater {
                    model: Math.min(root.playerCount, root.maxSources)
                    Rectangle {
                        required property int index
                        width: 12
                        height: 3
                        radius: 1.5
                        color: index === parent.playerIndex
                            ? Theme.primary : Qt.alpha(Theme.primary, 0.2)
                        Behavior on color { Anim { type: Anim.Type.StandardSmall } }
                    }
                }
            }
        }

        // ── Right knob: play/pause ────────────────────────────────────────
        ProgressIcon {
            id: playPauseKnob

            clickable: root.canTogglePlaying || root.canSeek
            verticalOffset: 1
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
            opacity: root.isActive ? 1 : 0.25
            color: Theme.primary

            Behavior on opacity { Anim { type: Anim.Standard } }

            progress: root.hasProgress
                ? root.activePlayer.position / root.activePlayer.length : 0

            Behavior on progress {
                Anim { type: Anim.Standard }
            }

            // maintained imperatively by Connections handlers below
            property bool debouncedPlaying: false

            Timer {
                id: debounceTimer
                interval: 200
                onTriggered: playPauseKnob.debouncedPlaying = false
            }

            Connections {
                target: root
                function onActivePlayerChanged() {
                    debounceTimer.stop()
                    playPauseKnob.debouncedPlaying = root.activePlayer?.isPlaying ?? false
                }
            }

            Connections {
                target: root.activePlayer
                enabled: root.activePlayer != null
                function onPlaybackStateChanged() {
                    if (!root.activePlayer)
                        return
                    if (root.activePlayer.isPlaying) {
                        debounceTimer.stop()
                        playPauseKnob.debouncedPlaying = true
                    } else {
                        debounceTimer.restart()
                    }
                }
            }

            iconName: root.isActive
                ? (playPauseKnob.debouncedPlaying ? "pause" : "play_arrow")
                : "music_note"

            onClicked: root.activePlayer?.togglePlaying()
            onWheeled: wheel => {
                if (!root.canSeek)
                    return
                const notches = wheel.angleDelta.y / 120
                root.activePlayer?.seek(notches * 5)
            }
        }
    }
}
