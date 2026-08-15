import QtQuick
import QtQuick.Shapes

Item {
    id: pipeRoot

    property string section: ""
    property real startX: 0
    property real startY: 0
    property real endX: 100
    property real endY: 0
    property real pipeWidth: 2.5
    property color baseColor: "#1b538c"
    property color flowColor: "#38ef7d"
    property bool isActive: false
    property bool reverseFlow: false
    property real flowSpeed: 800

    x: Math.min(startX, endX) - pipeWidth - 3
    y: Math.min(startY, endY) - pipeWidth - 3
    width: Math.max(1, Math.abs(endX - startX)) + (pipeWidth + 3) * 2
    height: Math.max(1, Math.abs(endY - startY)) + (pipeWidth + 3) * 2

    property real localX1: startX - x
    property real localY1: startY - y
    property real localX2: endX - x
    property real localY2: endY - y

    // 1. BASE STATIC PIPE PATH (Native Declarative Shape - 100% Visible in Qt Design Studio 2D Canvas)
    Shape {
        id: basePipeShape
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            strokeWidth: pipeRoot.isActive ? (pipeRoot.pipeWidth + 1.2) : pipeRoot.pipeWidth
            strokeColor: pipeRoot.isActive ? Qt.darker(pipeRoot.flowColor, 2.0) : pipeRoot.baseColor
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            startX: pipeRoot.localX1
            startY: pipeRoot.localY1
            PathLine { x: pipeRoot.localX2; y: pipeRoot.localY2 }
        }
    }

    // 2. LIVE ACTIVE ANIMATED FLOW STREAM (Dashed Particle Overlay)
    Shape {
        id: activeFlowShape
        anchors.fill: parent
        visible: pipeRoot.isActive
        preferredRendererType: Shape.CurveRenderer

        property real flowOffset: 0.0

        NumberAnimation on flowOffset {
            from: 0.0
            to: pipeRoot.reverseFlow ? -24.0 : 24.0
            duration: pipeRoot.flowSpeed
            loops: Animation.Infinite
            running: pipeRoot.isActive
        }

        ShapePath {
            strokeWidth: pipeRoot.pipeWidth
            strokeColor: pipeRoot.flowColor
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            strokeStyle: ShapePath.DashLine
            dashPattern: [4, 3]
            dashOffset: activeFlowShape.flowOffset
            startX: pipeRoot.localX1
            startY: pipeRoot.localY1
            PathLine { x: pipeRoot.localX2; y: pipeRoot.localY2 }
        }
    }
}
