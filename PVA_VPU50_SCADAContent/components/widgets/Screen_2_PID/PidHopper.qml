import QtQuick
import QtQuick.Shapes

Item {
    id: hopperRoot
    width: 24
    height: 24

    property color fillColor: "#8ec4f0"
    property color strokeColor: "#1b4c7c"

    Shape {
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            strokeWidth: 1.2
            strokeColor: hopperRoot.strokeColor
            fillColor: hopperRoot.fillColor
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.MiterJoin

            startX: 2
            startY: 2
            PathLine { x: 22; y: 2 }
            PathLine { x: 15; y: 20 }
            PathLine { x: 9; y: 20 }
            PathLine { x: 2; y: 2 }
        }
    }
}
