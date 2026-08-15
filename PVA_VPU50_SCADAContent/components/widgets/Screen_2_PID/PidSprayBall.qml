import QtQuick
import QtQuick.Shapes

Item {
    id: sprayRoot
    width: 36
    height: 52

    property string tag: "X 165 501"
    property bool isSpraying: false
    property real sprayAngle: 0.0 // 0 = straight down, -35 = angled right
    property bool showTags: true

    Item {
        id: rotatedHead
        x: (parent.width - width) / 2
        y: 6
        width: 24
        height: 32
        transformOrigin: Item.Top
        rotation: sprayRoot.sprayAngle

        // 1. Pipe Stem
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: -6
            width: 3
            height: 10
            color: "#52a5ec"
        }

        // 2. Collar Coupling Ring
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 4
            width: 8
            height: 4
            color: "#1e293b"
            border.color: "#38bdf8"
            border.width: 1
            radius: 1
        }

        // 3. Bell-Shaped Slotted Spray Head
        Rectangle {
            id: headBody
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 8
            width: 16
            height: 16
            radius: 8
            color: sprayRoot.isSpraying ? "#4ade80" : "#ffffff"
            border.color: "#1b4c7c"
            border.width: 1.5

            // Vertical discharge slit grooves
            Row {
                anchors.centerIn: parent
                spacing: 3
                Repeater {
                    model: 3
                    Rectangle {
                        width: 1.2
                        height: 9
                        radius: 0.6
                        color: sprayRoot.isSpraying ? "#15803d" : "#94a3b8"
                    }
                }
            }
        }
    }

    // Tag text below the head (e.g. X 165 501)
    Text {
        visible: sprayRoot.showTags
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 2
        anchors.horizontalCenter: parent.horizontalCenter
        text: sprayRoot.tag
        color: "#8cb5dc"
        font.pixelSize: 7
        font.bold: true
    }
}
