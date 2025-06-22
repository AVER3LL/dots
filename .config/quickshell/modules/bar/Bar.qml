import Quickshell
import Quickshell.Io
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

        }
    }
}
