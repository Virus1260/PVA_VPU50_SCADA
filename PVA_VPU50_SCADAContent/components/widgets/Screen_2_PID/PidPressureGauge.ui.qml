/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML.
*/
import QtQuick

Item {
    id: pressRoot
    width: 36
    height: 48

    property string tag: "PI 168 001"
    property real pressureBar: 2.4
    property real maxPressureBar: 6.0
    property bool showTags: true

    // 1. Pipe Mounting Stem & Process Connection Hex Nut
    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        width: 3.0
        height: 16
        color: "#64748b"
    }

    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 2
        width: 7
        height: 4
        radius: 1
        color: "#94a3b8"
        border.color: "#334155"
        border.width: 0.8
    }

    // 2. Circular Process Pressure Dial Gauge
    Rectangle {
        id: dialFace
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 2
        width: 26
        height: 26
        radius: 13
        color: "#ffffff"
        border.color: "#0369a1"
        border.width: 1.4

        // Bezel Inner Shadow Ring
        Rectangle {
            anchors.fill: parent
            anchors.margins: 1.5
            radius: 12
            color: "transparent"
            border.color: "#cbd5e1"
            border.width: 0.8
        }

        // Dial Scale Arc & Tick Marks
        Rectangle {
            anchors.centerIn: parent
            width: 16
            height: 1
            color: "#64748b"
        }
        Rectangle {
            anchors.centerIn: parent
            width: 1
            height: 16
            color: "#64748b"
        }

        // Dynamic Rotating Needle Pointer
        Rectangle {
            anchors.centerIn: parent
            width: 1.2
            height: 9
            color: "#dc2626"
            transformOrigin: Item.Bottom
            rotation: -120 + Math.min(240, (pressRoot.pressureBar / pressRoot.maxPressureBar) * 240)
        }

        // Center Pivot Pin
        Rectangle {
            anchors.centerIn: parent
            width: 3.5
            height: 3.5
            radius: 1.75
            color: "#0f172a"
        }
    }

    // 3. Tag & Value Readout
    Text {
        visible: pressRoot.showTags
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: dialFace.top
        anchors.bottomMargin: 1
        text: pressRoot.tag
        color: "#8cb5dc"
        font.pixelSize: 7
        font.bold: true
    }
}
