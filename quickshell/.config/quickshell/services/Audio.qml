pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    property var activeSink: null
    readonly property var sinkAudio: activeSink ? activeSink.audio : null

    // Safe bindings that react to the tracker
    readonly property real volume: sinkAudio ? sinkAudio.volume : 0
    readonly property bool muted: sinkAudio ? sinkAudio.muted : false

    readonly property var programs: programsTracker.objects

    function refreshDefaultSink() {
        activeSink = Pipewire.defaultAudioSink ?? null;
    }

    PwObjectTracker {
        id: sinkTracker
        objects: root.activeSink ? [root.activeSink] : []
    }

    PwObjectTracker {
        id: programsTracker
        objects: Pipewire.nodes.values.filter(node => node.isStream)
    }

    Connections {
        target: Pipewire

        function onDefaultAudioSinkChanged() {
            root.refreshDefaultSink();
        }
    }

    Component.onCompleted: {
        root.refreshDefaultSink();
        Qt.callLater(root.refreshDefaultSink);
    }

    function toggleMute() {
        if (sinkAudio) {
            sinkAudio.muted = !sinkAudio.muted;
        }
    }

    function adjustVolume(delta) {
        if (sinkAudio) {
            let newVol = sinkAudio.volume + delta;
            sinkAudio.volume = Math.max(0, Math.min(newVol, 1.0));
        }
    }
}
