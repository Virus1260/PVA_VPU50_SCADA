/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML.
*/
import QtQuick

Item {
    id: pipeRoot

    // =========================================================================
    // 1. GEOMETRY & COORDINATES (Pixel-Perfect Orthogonal Routing)
    // =========================================================================
    property real startX: 0
    property real startY: 0
    property real endX: 0
    property real endY: 0
    property real pipeWidth: 2.0
    property string section: ""

    // =========================================================================
    // 2. FLOW DYNAMICS & VISUAL STATE
    // =========================================================================
    property color baseColor: "#1b538c"
    property color flowColor: "#38ef7d"
    property bool isActive: false
    property string flowDirection: "forward" // "forward", "reverse", "none"
    property bool reverseFlow: (flowDirection === "reverse")
    property real flowSpeed: 800

    // Coordinate Normalization
    readonly property bool isHorizontal: (Math.abs(endY - startY) <= 1.0)
    readonly property real minX: Math.min(startX, endX)
    readonly property real maxX: Math.max(startX, endX)
    readonly property real minY: Math.min(startY, endY)
    readonly property real maxY: Math.max(startY, endY)

    x: isHorizontal ? minX : (minX - pipeWidth / 2)
    y: isHorizontal ? (minY - pipeWidth / 2) : minY
    width: isHorizontal ? Math.max(2, maxX - minX) : pipeWidth
    height: isHorizontal ? pipeWidth : Math.max(2, maxY - minY)

    // =========================================================================
    // 3. NATIVE SOLID PIPE BODY (100% Straight, Zero Shatter, Zero Subpixel Jitter)
    // =========================================================================
    Rectangle {
        id: pipeBody
        anchors.fill: parent
        color: pipeRoot.isActive ? Qt.darker(pipeRoot.flowColor, 1.8) : pipeRoot.baseColor
        radius: 0
    }

    // =========================================================================
    // 4. ANIMATED FLOW STREAM OVERLAY (Active Medium Transportation)
    // =========================================================================
    Item {
        id: flowOverlay
        anchors.fill: parent
        visible: pipeRoot.isActive && pipeRoot.flowDirection !== "none"
        clip: true

        // Pulsing Flow Particles / Chevrons
        Rectangle {
            id: flowPulse
            color: pipeRoot.flowColor
            opacity: 0.85

            // Horizontal Flow Pulse
            x: pipeRoot.isHorizontal ? (pipeRoot.reverseFlow ? (parent.width - width) : 0) : 0
            y: pipeRoot.isHorizontal ? 0 : (pipeRoot.reverseFlow ? (parent.height - height) : 0)
            width: pipeRoot.isHorizontal ? Math.min(parent.width, 32) : parent.width
            height: pipeRoot.isHorizontal ? parent.height : Math.min(parent.height, 32)

            NumberAnimation on x {
                running: pipeRoot.isActive && pipeRoot.isHorizontal
                from: pipeRoot.reverseFlow ? (pipeRoot.width) : -32
                to: pipeRoot.reverseFlow ? -32 : (pipeRoot.width)
                duration: pipeRoot.flowSpeed
                loops: Animation.Infinite
            }

            NumberAnimation on y {
                running: pipeRoot.isActive && !pipeRoot.isHorizontal
                from: pipeRoot.reverseFlow ? (pipeRoot.height) : -32
                to: pipeRoot.reverseFlow ? -32 : (pipeRoot.height)
                duration: pipeRoot.flowSpeed
                loops: Animation.Infinite
            }
        }
    }
}
