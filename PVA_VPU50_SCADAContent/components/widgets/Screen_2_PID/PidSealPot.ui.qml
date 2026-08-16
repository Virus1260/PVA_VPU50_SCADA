
/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML.
*/
import QtQuick
import QtQuick.Shapes

Item {
    id: sealPotRoot
    width: 60
    height: 130

    property string tag: "B 171 001"
    property string tempTag: "TI 171 001"
    property real currentTemp: 45.0
    property bool isHeating: false
    property bool showTags: true

    property alias mouseArea: sealPotMouseArea

    signal clicked

    // 1. TOP PROCESS GAUGE (Separate Reusable PidPressureGauge Component - Vertical)
    PidPressureGauge {
        id: dialGauge
        z: 4
        anchors.top: parent.top
        anchors.horizontalCenter: potBody.horizontalCenter
        tag: sealPotRoot.tempTag
        pressureBar: sealPotRoot.currentTemp
        maxPressureBar: 100.0
        isVertical: true
        showTags: sealPotRoot.showTags
    }

    // 2. MAIN SEAL POT VESSEL (Vertical Insulated Cylinder)
    Rectangle {
        id: potBody
        anchors.left: parent.left
        anchors.leftMargin: 4
        anchors.top: parent.top
        anchors.topMargin: 46
        width: 34
        height: 75
        radius: 3
        color: "#0b2e52"
        border.color: sealPotRoot.isHeating ? "#ec4899" : "#1d5b94"
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

        // 3. INTERNAL ELECTRIC ZIGZAG COIL (AutoCAD Magenta #ec4899)
        Shape {
            id: coilShape
            anchors.fill: parent
            anchors.margins: 4

            ShapePath {
                strokeWidth: 2
                strokeColor: sealPotRoot.isHeating ? "#f43f5e" : "#ec4899"
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                joinStyle: ShapePath.MiterJoin

                startX: 13
                startY: 6
                PathLine {
                    x: 18
                    y: 14
                }
                PathLine {
                    x: 8
                    y: 22
                }
                PathLine {
                    x: 18
                    y: 30
                }
                PathLine {
                    x: 8
                    y: 38
                }
                PathLine {
                    x: 18
                    y: 46
                }
                PathLine {
                    x: 8
                    y: 54
                }
                PathLine {
                    x: 13
                    y: 62
                }
            }
        }
    }

    // 4. TAG & READOUT LABELS
    Column {
        visible: sealPotRoot.showTags
        anchors.top: potBody.bottom
        anchors.topMargin: -63
        anchors.horizontalCenterOffset: 42
        anchors.horizontalCenter: potBody.horizontalCenter
        spacing: 1

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: sealPotRoot.tag
            color: "#ffffff"
            font.pixelSize: 8
            font.bold: true
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: sealPotRoot.currentTemp.toFixed(1) + "°C"
            color: "#8cb5dc"
            font.pixelSize: 7
            font.bold: true
        }
    }

    MouseArea {
        id: sealPotMouseArea
        anchors.fill: parent
        anchors.topMargin: -10
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
    }
}
