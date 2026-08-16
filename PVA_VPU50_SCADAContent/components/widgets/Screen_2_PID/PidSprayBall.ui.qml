/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML.
*/
import QtQuick
import QtQuick.Shapes

Item {
    id: sprayRoot
    width: 36
    height: 48

    property string tag: "X 165 501"
    property bool isSpraying: false
    property real sprayAngle: 0.0 // 0 = straight down, -35 = angled right
    property bool showTags: true

    Item {
        id: rotatedHead
        x: (parent.width - width) / 2
        y: 0
        width: 24
        height: 32
        transformOrigin: Item.Top
        rotation: sprayRoot.sprayAngle

        Shape {
            id: sprayShape
            anchors.fill: parent

            // 1. Outer Bell & Castle Slotted Teeth (Professional Metallic Stainless Fill / CIP Glow)
            ShapePath {
                strokeWidth: 1.5
                strokeColor: sprayRoot.isSpraying ? "#4ade80" : "#cbd5e1"
                fillColor: sprayRoot.isSpraying ? "#4022c55e" : "#1e293b"
                capStyle: ShapePath.RoundCap
                joinStyle: ShapePath.RoundJoin

                PathSvg {
                    path: "M 2 11 A 10 10 0 0 1 22 11 L 22 23 L 19 23 L 19 16 L 16.5 16 L 16.5 23 L 13.5 23 L 13.5 16 L 10.5 16 L 10.5 23 L 7.5 23 L 7.5 16 L 5 16 L 5 23 L 2 23 L 2 11 Z"
                }
            }

            // 2. Inner Concentric Horseshoe Arch Ring (Polished Steel Arc)
            ShapePath {
                strokeWidth: 1.2
                strokeColor: sprayRoot.isSpraying ? "#86efac" : "#64748b"
                fillColor: sprayRoot.isSpraying ? "#6622c55e" : "#0f172a"
                capStyle: ShapePath.RoundCap
                joinStyle: ShapePath.RoundJoin

                PathSvg {
                    path: "M 2 11 L 4.5 11 A 7.5 7.5 0 0 1 19.5 11 L 22 11"
                }
            }

            // 3. Top Pipe Connection Flange & Stem
            ShapePath {
                strokeWidth: 1.6
                strokeColor: sprayRoot.isSpraying ? "#4ade80" : "#52a5ec"
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap

                startX: 12; startY: 0
                PathLine { x: 12; y: 1 }
            }
        }
    }

    // Tag text below the head (e.g. X 165 501)
    Text {
        visible: sprayRoot.showTags
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        text: sprayRoot.tag
        color: "#8cb5dc"
        font.pixelSize: 7
        font.bold: true
    }
}
