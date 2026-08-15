import QtQuick
import QtQuick.Shapes

Item {
    id: valveRoot
    width: 26
    height: 26

    property string tag: "V101"
    property string subLabel: ""
    property bool isOpen: false
    property bool isVertical: false
    property bool isSolenoid: true
    property bool showTags: true

    signal clicked()

    // Declarative Valve Symbol (Two Opposing Triangles - 100% Visible in Qt Design Studio 2D Canvas)
    Shape {
        id: valveShape
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        // 1. Horizontal Valve (Left Triangle & Right Triangle)
        ShapePath {
            strokeWidth: 1.2
            strokeColor: valveRoot.isOpen ? "#4ade80" : "#ffffff"
            fillColor: valveRoot.isOpen ? "#22c55e" : "#0a284a"
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.MiterJoin

            startX: valveRoot.isVertical ? (valveRoot.width / 2 - 5.5) : (valveRoot.width / 2 - 6.5)
            startY: valveRoot.isVertical ? (valveRoot.height / 2 - 6.5) : (valveRoot.height / 2 - 5.5)

            // Triangle 1
            PathLine {
                x: valveRoot.isVertical ? (valveRoot.width / 2 + 5.5) : (valveRoot.width / 2 - 6.5)
                y: valveRoot.isVertical ? (valveRoot.height / 2 - 6.5) : (valveRoot.height / 2 + 5.5)
            }
            PathLine {
                x: valveRoot.width / 2
                y: valveRoot.height / 2
            }
            PathLine {
                x: valveRoot.isVertical ? (valveRoot.width / 2 - 5.5) : (valveRoot.width / 2 - 6.5)
                y: valveRoot.isVertical ? (valveRoot.height / 2 - 6.5) : (valveRoot.height / 2 - 5.5)
            }
        }

        // Triangle 2
        ShapePath {
            strokeWidth: 1.2
            strokeColor: valveRoot.isOpen ? "#4ade80" : "#ffffff"
            fillColor: valveRoot.isOpen ? "#22c55e" : "#0a284a"
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.MiterJoin

            startX: valveRoot.isVertical ? (valveRoot.width / 2 - 5.5) : (valveRoot.width / 2 + 6.5)
            startY: valveRoot.isVertical ? (valveRoot.height / 2 + 6.5) : (valveRoot.height / 2 - 5.5)

            PathLine {
                x: valveRoot.isVertical ? (valveRoot.width / 2 + 5.5) : (valveRoot.width / 2 + 6.5)
                y: valveRoot.isVertical ? (valveRoot.height / 2 + 6.5) : (valveRoot.height / 2 + 5.5)
            }
            PathLine {
                x: valveRoot.width / 2
                y: valveRoot.height / 2
            }
            PathLine {
                x: valveRoot.isVertical ? (valveRoot.width / 2 - 5.5) : (valveRoot.width / 2 + 6.5)
                y: valveRoot.isVertical ? (valveRoot.height / 2 + 6.5) : (valveRoot.height / 2 - 5.5)
            }
        }
    }

    // Tag Label
    Text {
        visible: valveRoot.showTags
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.top
        anchors.bottomMargin: 1
        text: valveRoot.tag
        color: valveRoot.isOpen ? "#4ade80" : "#cbd5e1"
        font.pixelSize: 8
        font.bold: valveRoot.isOpen
    }

    // Sub-Label
    Text {
        visible: valveRoot.showTags && valveRoot.subLabel.length > 0
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
        anchors.topMargin: 1
        text: valveRoot.subLabel
        color: "#94a3b8"
        font.pixelSize: 7
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: valveRoot.clicked()
    }
}
