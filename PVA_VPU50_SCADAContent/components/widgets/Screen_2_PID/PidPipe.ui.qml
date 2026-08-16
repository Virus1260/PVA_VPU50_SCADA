/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML.
*/
import QtQuick
import QtQuick.Shapes

Item {
    id: pipeRoot

    // Geometry Properties
    property real startX: 0
    property real startY: 0
    property real endX: 0
    property real endY: 0
    property real pipeWidth: 2.5
    property real zoomScale: 1.0

    // Style & State Properties
    property string section: ""
    property color baseColor: "#1b538c"
    property color flowColor: "#38ef7d"
    property bool isActive: false
    property bool reverseFlow: false
    property real flowSpeed: 800

    // Bounding Box Calculation (Seamlessly supports both absolute startX/endX and Designer x/y/w/h)
    readonly property bool hasAbsoluteCoordinates: (startX !== 0 || startY !== 0 || endX !== 0 || endY !== 0)
    readonly property real pad: pipeWidth + 2

    x: hasAbsoluteCoordinates ? (Math.min(startX, endX) - pad) : 0
    y: hasAbsoluteCoordinates ? (Math.min(startY, endY) - pad) : 0
    width: hasAbsoluteCoordinates ? (Math.max(1, Math.abs(endX - startX)) + 2 * pad) : 100
    height: hasAbsoluteCoordinates ? (Math.max(1, Math.abs(endY - startY)) + 2 * pad) : pad * 2

    // Local Drawing Points (Guaranteed to stay strictly inside the visual bounding box)
    readonly property real localX1: hasAbsoluteCoordinates ? (startX <= endX ? pad : width - pad) : 0
    readonly property real localY1: hasAbsoluteCoordinates ? (startY <= endY ? pad : height - pad) : (height / 2)
    readonly property real localX2: hasAbsoluteCoordinates ? (startX <= endX ? width - pad : pad) : width
    readonly property real localY2: hasAbsoluteCoordinates ? (startY <= endY ? height - pad : pad) : (height / 2)

    // Dynamic AutoCAD Constant-Screen-Pixel Width Compensation
    readonly property real dynamicStrokeWidth: Math.max(0.8, (pipeRoot.isActive ? (pipeRoot.pipeWidth + 0.8) : pipeRoot.pipeWidth) / Math.max(0.3, Math.min(3.0, pipeRoot.zoomScale)))

    // 1. BASE STATIC PIPE PATH (Native Declarative Shape - 100% Visible in Qt Design Studio 2D Canvas)
    Shape {
        id: basePipeShape
        anchors.fill: parent

        ShapePath {
            strokeWidth: pipeRoot.dynamicStrokeWidth
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

        property real flowOffset: 0.0

        NumberAnimation on flowOffset {
            from: 0.0
            to: pipeRoot.reverseFlow ? -24.0 : 24.0
            duration: pipeRoot.flowSpeed
            loops: Animation.Infinite
            running: pipeRoot.isActive
        }

        ShapePath {
            strokeWidth: Math.max(0.7, pipeRoot.pipeWidth / Math.max(0.3, Math.min(3.0, pipeRoot.zoomScale)))
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
