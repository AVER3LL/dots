pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

/**
 * A nice wrapper for default Pipewire audio sink and source.
 */
Singleton {
    id: root

    property bool ready: Pipewire.defaultAudioSink?.ready ?? false
    property PwNode sink: Pipewire.defaultAudioSink
    property PwNode source: Pipewire.defaultAudioSource

    signal sinkProtectionTriggered(string reason);

    PwObjectTracker {
        objects: [root.sink, root.source]
    }

    Connections { // Protection against sudden volume changes
        target: root.sink?.audio ?? null
        property bool lastReady: false
        property real lastVolume: 0
        function onVolumeChanged() {
            // if (!Config.options.audio.protection.enable) return;
            if (!lastReady) {
                lastVolume = root.sink.audio.volume;
                lastReady = true;
                return;
            }
            const newVolume = root.sink.audio.volume;
            const maxAllowedIncrease = 10 / 100;
            const maxAllowed = 90 / 100;

            if (newVolume - lastVolume > maxAllowedIncrease) {
                root.sink.audio.volume = lastVolume;
                root.sinkProtectionTriggered("Illegal increment");
            } else if (newVolume > maxAllowed) {
                root.sinkProtectionTriggered("Exceeded max allowed");
                root.sink.audio.volume = Math.min(lastVolume, maxAllowed);
            }
            if (root.sink.ready && (isNaN(root.sink.audio.volume) || root.sink.audio.volume === undefined || root.sink.audio.volume === null)) {
                root.sink.audio.volume = 0;
            }
            lastVolume = root.sink.audio.volume;
        }

    }

}
