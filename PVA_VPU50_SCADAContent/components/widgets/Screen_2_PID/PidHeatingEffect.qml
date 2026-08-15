import QtQuick
import QtQuick.Shapes

Item {
    id: heatEffectRoot
    width: 360
    height: 440
    clip: false

    property bool isHeating: false
    property bool isCooling: false
    property real levelPercent: 50.0

    // 1. Thermal Pulsing Animation for Jacket Glow
    property real heatPulse: 0.6

    SequentialAnimation on heatPulse {
        running: heatEffectRoot.isHeating || heatEffectRoot.isCooling
        loops: Animation.Infinite
        NumberAnimation { to: 0.95; duration: 900; easing.type: Easing.InOutQuad }
        NumberAnimation { to: 0.45; duration: 900; easing.type: Easing.InOutQuad }
    }

    // 2. Outer Thermal Jacket Radiant Glow Perimeter (Declarative Shape - 100% Qt Design Studio Visibility)
    Shape {
        id: jacketGlowShape
        anchors.fill: parent
        visible: heatEffectRoot.isHeating || heatEffectRoot.isCooling
        opacity: heatEffectRoot.heatPulse
        preferredRendererType: Shape.CurveRenderer

        // Outer glow
        ShapePath {
            strokeWidth: 14.0
            strokeColor: heatEffectRoot.isHeating ? "#73f97316" : "#7306b6d4"
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin

            startX: 14; startY: 138
            PathLine { x: 14; y: 348 }
            PathCubic { control1X: 14; control1Y: 400; control2X: 70; control2Y: 432; x: 158; y: 432 }
            PathLine { x: 202; y: 432 }
            PathCubic { control1X: 290; control1Y: 432; control2X: 346; control2Y: 400; x: 346; y: 348 }
            PathLine { x: 346; y: 138 }
        }

        // Inner core line
        ShapePath {
            strokeWidth: 5.0
            strokeColor: heatEffectRoot.isHeating ? "#fb923c" : "#38bdf8"
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin

            startX: 14; startY: 138
            PathLine { x: 14; y: 348 }
            PathCubic { control1X: 14; control1Y: 400; control2X: 70; control2Y: 432; x: 158; y: 432 }
            PathLine { x: 202; y: 432 }
            PathCubic { control1X: 290; control1Y: 432; control2X: 346; control2Y: 400; x: 346; y: 348 }
            PathLine { x: 346; y: 138 }
        }
    }

    // 3. Rising Thermal Convection Micro-Bubbles inside Liquid
    Item {
        id: bubbleZone
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40
        width: parent.width - 60
        height: Math.max(40, (parent.height - 180) * (heatEffectRoot.levelPercent / 100.0))
        clip: true
        visible: heatEffectRoot.isHeating

        Repeater {
            model: 8
            Item {
                id: bubbleItem
                property real initialX: (index * 34 + 18) % (bubbleZone.width - 20)
                property real speedOffset: 1600 + index * 260
                property real currentY: bubbleZone.height

                x: initialX + Math.sin(currentY / 25) * 4
                y: currentY

                Rectangle {
                    width: 3 + (index % 3)
                    height: width
                    radius: width / 2
                    color: "#fed7aa"
                    opacity: 0.3 + (index % 4) * 0.15
                    border.color: "#fb923c"
                    border.width: 0.6
                }

                NumberAnimation on currentY {
                    from: bubbleZone.height + 10
                    to: 0
                    duration: bubbleItem.speedOffset
                    loops: Animation.Infinite
                    running: heatEffectRoot.isHeating
                }
            }
        }
    }
}
