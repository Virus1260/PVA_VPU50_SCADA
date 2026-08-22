import QtQuick
import QtQuick.Layouts

RowLayout {
    id: machineClusterRoot
    spacing: 8

    property string activeBatchId: "B1"
    property string vesselName: "VPU 50"
    property string plantModeText: "(A)"

    signal plantModeRequested()

    // B1 System Identifier Badge (40px circle)
    Rectangle {
        width: 40
        height: 40
        radius: 20
        color: "#0c345a"
        border.color: "#1d5b94"
        border.width: 1.5

        Text {
            anchors.centerIn: parent
            text: machineClusterRoot.activeBatchId
            color: "#ffffff"
            font.bold: true
            font.pixelSize: 14
        }
    }

    // Auto (A) / Manual (M) Mode Badge (40px circle - Clickable)
    Rectangle {
        width: 40
        height: 40
        radius: 20
        color: machineClusterRoot.plantModeText === "(A)" ? "#0c345a" : "#4a3512"
        border.color: machineClusterRoot.plantModeText === "(A)" ? "#1d5b94" : "#f5d033"
        border.width: 1.5

        Text {
            anchors.centerIn: parent
            text: machineClusterRoot.plantModeText
            color: machineClusterRoot.plantModeText === "(A)" ? "#ffffff" : "#f5d033"
            font.bold: true
            font.pixelSize: 14
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: machineClusterRoot.plantModeRequested()
        }
    }

    // Status Green LED (12px)
    Rectangle {
        width: 12
        height: 12
        radius: 6
        color: "#78dc20"
        border.color: "#ffffff"
        border.width: 1.5
    }

    // VPU 50 Vessel Capsule Pill (50px height, rounded - Clickable)
    Rectangle {
        id: vesselPill
        width: 156
        height: 50
        radius: 25
        color: pillMouse.pressed ? "#07203a" : (pillMouse.containsMouse ? "#164d80" : "#0d365e")
        border.color: pillMouse.containsMouse ? "#3892e6" : "#1d5b94"
        border.width: 1.5

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 14
            spacing: 8

            Text {
                text: machineClusterRoot.activeBatchId + " - " + machineClusterRoot.vesselName
                color: "#ffffff"
                font.bold: true
                font.pixelSize: 14
                Layout.fillWidth: true
            }

            Item {
                width: 22
                height: 22
                Image {
                    anchors.fill: parent
                    source: "../../../assets/icons/header/lightbulb.svg"
                    fillMode: Image.PreserveAspectFit
                    mipmap: true
                    smooth: true
                }
            }
        }

        MouseArea {
            id: pillMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: machineClusterRoot.plantModeRequested()
        }
    }
}
