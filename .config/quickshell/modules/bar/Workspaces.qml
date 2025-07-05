import QtQuick
import Quickshell
import Quickshell.Hyprland

Row {
    id: workspacesRow

    Repeater {
        model: Hyprland.workspaces

        Rectangle {
            width: 32
            height: 24
            radius: 15
            color: modelData.active ? "#4a9eff" : "#333333"
            border.color: "#555555"
            border.width: 1

            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch("workspace " + modelData.id)
            }

            Text {
                text: modelData.id
                anchors.centerIn: parent
                color: modelData.active ? "#ffffff" : "#cccccc"
                font.pixelSize: 12
                font.family: "JetBrainsMono NF, Inter, sans-serif"
            }
        }
    }
}
