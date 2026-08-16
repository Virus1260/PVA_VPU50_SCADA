import QtQuick
import QtQuick.Shapes

Item {
    id: heaterRoot
    width: 68
    height: 140

    property string tag: "W 171 001"
    property string tempTag: "TI 171 001"
    property real currentTemp: 85.0
    property real powerKw: 12.5
    property bool isHeating: false
    property bool showTags: true

    signal clicked()

    // 1. TOP DIAL TEMPERATURE GAUGE (AutoCAD TI 171 001)
    Item {
        id: dialGauge
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.rightMargin: 4
        width: 24
        height: 24

        // Stem down to heater vessel
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -6
            anchors.horizontalCenter: parent.horizontalCenter
            width: 2
            height: 10
            color: "#64748b"
        }

        // Circular Dial Housing
        Rectangle {
            anchors.fill: parent
            radius: width / 2
            color: "#08213b"
            border.color: "#38bdf8"
            border.width: 1.2

            // Needle Pointer (Rotates with Temperature)
            Rectangle {
                anchors.centerIn: parent
                width: 1.5
                height: 8
                color: "#f43f5e"
                transformOrigin: Item.Bottom
                rotation: -45 + Math.min(180, (heaterRoot.currentTemp / 120.0) * 180)
            }

            // Center Pin
            Rectangle {
                anchors.centerIn: parent
                width: 3
                height: 3
                radius: 1.5
                color: "#ffffff"
            }
        }
    }

    // 2. MAIN ELECTRIC HEATER VESSEL (Vertical Insulated Cylinder)
    Rectangle {
        id: heaterBody
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.top: parent.top
        anchors.topMargin: 20
        width: 38
        height: 85
        radius: 3
        color: "#0b2e52"
        border.color: heaterRoot.isHeating ? "#ec4899" : "#1d5b94"
        border.width: 1.6

        // Bottom Mounting Base Flange
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width + 10
            height: 4
            radius: 1
            color: "#1e293b"
            border.color: "#64748b"
            border.width: 1
        }

        // 3. INTERNAL ELECTRIC ZIGZAG HEATING ELEMENT COIL (Magenta AutoCAD #ec4899)
        Shape {
            id: coilShape
            anchors.fill: parent
            anchors.margins: 6
            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                strokeWidth: 2.2
                strokeColor: heaterRoot.isHeating ? "#f43f5e" : "#ec4899"
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                joinStyle: ShapePath.MiterJoin

                startX: 13; startY: 8
                PathLine { x: 18; y: 16 }
                PathLine { x: 8; y: 26 }
                PathLine { x: 18; y: 36 }
                PathLine { x: 8; y: 46 }
                PathLine { x: 18; y: 56 }
                PathLine { x: 13; y: 64 }
            }
        }

        // Subtle Glow Pulse when actively heating
        SequentialAnimation on opacity {
            running: heaterRoot.isHeating
            loops: Animation.Infinite
            NumberAnimation { to: 0.75; duration: 600 }
            NumberAnimation { to: 1.0; duration: 600 }
        }
    }

    // 4. TAG & READOUT LABELS
    Column {
        visible: heaterRoot.showTags
        anchors.top: heaterBody.bottom
        anchors.topMargin: 8
        anchors.horizontalCenter: heaterBody.horizontalCenter
        spacing: 1

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: heaterRoot.tag
            color: "#ffffff"
            font.pixelSize: 8
            font.bold: true
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: heaterRoot.currentTemp.toFixed(1) + "°C"
            color: heaterRoot.isHeating ? "#f43f5e" : "#8cb5dc"
            font.pixelSize: 8
            font.bold: true
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: heaterRoot.clicked()
    }
}
