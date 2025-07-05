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

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 30

            Clock {
                anchors.centerIn: parent
            }

            Workspaces {

                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                    leftMargin: 16
                }

                spacing: 8
            }

        }
    }
}
