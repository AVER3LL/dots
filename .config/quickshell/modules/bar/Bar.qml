import "../../shared"

import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick

Scope {

    Variants {
        model: Quickshell.screens;

        PanelWindow {
            property var modelData
            screen: modelData
            color: "transparent"

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 40

            margins {
                top: 5
                left: 12
                right: 12
            }

            Rectangle {
                id: bar
                anchors.fill: parent
                color: Colors.surfaceContainer
                radius: 5
                border.color: Colors.outline
                border.width: 1

                Clock {
                    anchors.centerIn: parent
                }

                Workspaces {

                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        leftMargin: 16
                    }

                    // spacing: 8
                }

            }

        }
    }
}
