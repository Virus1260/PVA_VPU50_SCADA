import QtQuick
import QtQuick.Shapes

Item {
    id: pumpRoot
    width: 36
    height: 52

    property string tag: "P 168 001"
    property string pressTag: "PI 168 001"
    property real pressureBar: 2.8
    property bool isRunning: false
    property bool showTags: true

    signal clicked()

    // 1. DIAL PRESSURE GAUGE (AutoCAD Top-Right Dial)
    Item {
        anchors.top: parent.top
        anchors.right: parent.right
        width: 16
        height: 16

        Rectangle {
            anchors.fill: parent
            radius: width / 2
            color: "#08213b"
            border.color: "#38bdf8"
            border.width: 1

            // Diagonal needle pointer
            Rectangle {
                anchors.centerIn: parent
                width: 1
                height: 5
                color: "#38bdf8"
                rotation: 45
            }
        }
    }

    // 2. INLINE CENTRIFUGAL PUMP HOUSING (AutoCAD Volute Circle with Impeller Wedge)
    Rectangle {
        id: pumpCircle
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 8
        width: 22
        height: 22
        radius: width / 2
        color: pumpRoot.isRunning ? "#0f4229" : "#08213b"
        border.color: pumpRoot.isRunning ? "#4ade80" : "#38bdf8"
        border.width: 1.4

        // Internal Directional Triangle Wedge
        Shape {
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                strokeWidth: 1
                strokeColor: pumpRoot.isRunning ? "#4ade80" : "#38bdf8"
                fillColor: pumpRoot.isRunning ? "#22c55e" : "#0284c7"
                startX: 11; startY: 3
                PathLine { x: 19; y: 11 }
                PathLine { x: 11; y: 19 }
                PathLine { x: 11; y: 3 }
            }
        }
    }

    // 3. ELECTRIC MOTOR BADGE (M)
    Rectangle {
        id: motorBadge
        anchors.horizontalCenter: pumpCircle.horizontalCenter
        anchors.top: pumpCircle.bottom
        anchors.topMargin: 2
        width: 14
        height: 14
        radius: 7
        color: pumpRoot.isRunning ? "#22c55e" : "#0a284a"
        border.color: pumpRoot.isRunning ? "#4ade80" : "#38bdf8"
        border.width: 1

        Text {
            anchors.centerIn: parent
            text: "M"
            color: pumpRoot.isRunning ? "#000000" : "#8cb5dc"
            font.bold: true
            font.pixelSize: 8
        }
    }

    // 4. TAG TEXT
    Text {
        visible: pumpRoot.showTags
        anchors.top: motorBadge.bottom
        anchors.topMargin: 1
        anchors.horizontalCenter: motorBadge.horizontalCenter
        text: pumpRoot.tag
        color: "#8cb5dc"
        font.pixelSize: 7
        font.bold: true
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: pumpRoot.clicked()
    }
}
