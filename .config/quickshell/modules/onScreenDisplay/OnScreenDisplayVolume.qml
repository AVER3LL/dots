import "root:/services/"
import "../../shared"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Widgets

Scope {
    id: root
    property bool showOsdValues: false
    property string protectionMessage: ""
    property var focusedScreen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name)

    function triggerOsd() {
        showOsdValues = true
        osdTimeout.restart()
    }

    Timer {
        id: osdTimeout
        interval: 1000
        repeat: false
        running: false
        onTriggered: {
            root.showOsdValues = false
            root.protectionMessage = ""
        }
    }

    Connections { // Listen to volume changes
        target: Audio.sink?.audio ?? null
        function onVolumeChanged() {
            if (!Audio.ready) return
            root.triggerOsd()
        }
        function onMutedChanged() {
            if (!Audio.ready) return
            root.triggerOsd()
        }
    }

    Connections { // Listen to protection triggers
        target: Audio
        function onSinkProtectionTriggered(reason) {
            root.protectionMessage = reason;
            root.triggerOsd()
        }
    }

    LazyLoader {
        active: root.showOsdValues
        PanelWindow {
            // Since the panel's screen is unset, it will be picked by the compositor
            // when the window is created. Most compositors pick the current active monitor.
            anchors.bottom: true
            margins.bottom: screen.height / 5
            implicitWidth: 400
            implicitHeight: 50
            color: "transparent"
            // An empty click mask prevents the window from blocking mouse events.
            mask: Region {}

            Rectangle {
                anchors.fill: parent
                radius: height / 2
                // color: Colors.surfaceContainer
                // color: "#80000000"
                color: "#FF" + Colors.surfaceContainer.toString().slice(1)

                scale: root.showOsdValues ? 1.0 : 0.8
                opacity: root.showOsdValues ? 1.0 : 0.0

                Behavior on scale {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.OutBack
                        easing.overshoot: 1.2
                    }
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: 150
                        easing.type: Easing.OutQuad
                    }
                }

                RowLayout {
                    anchors {
                        fill: parent
                        leftMargin: 10
                        rightMargin: 15
                    }

                    IconImage {
                        implicitSize: 30
                        source: {
                            if (!Audio.ready || !Audio.sink?.audio) {
                                return Quickshell.iconPath("audio-volume-muted-symbolic")
                            }
                            if (Audio.sink.audio.muted) {
                                return Quickshell.iconPath("audio-volume-muted-symbolic")
                            }
                            const volume = Audio.sink.audio.volume
                            if (volume === 0) {
                                return Quickshell.iconPath("audio-volume-muted-symbolic")
                            } else if (volume < 0.33) {
                                return Quickshell.iconPath("audio-volume-low-symbolic")
                            } else if (volume < 0.66) {
                                return Quickshell.iconPath("audio-volume-medium-symbolic")
                            } else {
                                return Quickshell.iconPath("audio-volume-high-symbolic")
                            }
                        }
                    }

                    Rectangle {
                        // Stretches to fill all left-over space
                        Layout.fillWidth: true
                        implicitHeight: 10
                        radius: 20
                        color: "#50ffffff"

                        Rectangle {
                            anchors {
                                left: parent.left
                                top: parent.top
                                bottom: parent.bottom
                            }
                            // Fixed: Use Audio singleton instead of Pipewire directly
                            implicitWidth: parent.width * (Audio.sink?.audio.volume ?? 0)
                            radius: parent.radius
                            color: Audio.sink?.audio.muted ? Colors.errorContainer : Colors.primary
                        }
                    }

                    // Show protection message if any
                    Text {
                        visible: root.protectionMessage !== ""
                        text: root.protectionMessage
                        color: "#ff4444"
                        font.pixelSize: 12
                    }

                    // Show volume percentage
                    Text {
                        text: Audio.ready && Audio.sink?.audio ?
                              Math.round((Audio.sink.audio.volume * 100)) + "%" :
                              "N/A"
                        color: Colors._onSurface
                        font.pixelSize: 14
                        font.bold: true
                    }
                }
            }
        }
    }
}
