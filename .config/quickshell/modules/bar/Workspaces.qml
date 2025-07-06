import "../../shared"

import QtQuick
import Quickshell
import Quickshell.Hyprland

Row {
    id: workspacesRow

    Repeater {
        model: Hyprland.workspaces

        Rectangle {
            width: modelData.active ? 53 : 32
            height: 24
            radius: modelData.active ? 8 : 15
            color: modelData.active ? Colors.primaryFixedDim : Colors.surfaceContainerLow
            border.color: Colors.outline
            border.width: 0

            Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.InOutCubic } }
            Behavior on radius { NumberAnimation { duration: 200; easing.type: Easing.InOutCubic } }
            Behavior on color { ColorAnimation { duration: 200; easing.type: Easing.InOutCubic } }

            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch("workspace " + modelData.id)
            }

            Text {
                text: modelData.id
                anchors.centerIn: parent
                color: modelData.active ? Colors._onPrimaryFixed : Colors.outline
                font.pixelSize: 12
                font.family: "JetBrainsMono NF, Inter, sans-serif"
                font.bold: modelData.active

                Behavior on color { ColorAnimation { duration: 200; easing.type: Easing.InOutCubic } }
            }
        }
    }
}
