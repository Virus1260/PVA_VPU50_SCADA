/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML.
*/
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

    // 1. Thermal Pulsing Animation for Active Jacket Glow
    property real heatPulse: 0.6

    SequentialAnimation on heatPulse {
        running: heatEffectRoot.isHeating || heatEffectRoot.isCooling
        loops: Animation.Infinite
        NumberAnimation { to: 0.95; duration: 900; easing.type: Easing.InOutQuad }
        NumberAnimation { to: 0.45; duration: 900; easing.type: Easing.InOutQuad }
    }

    // 2. Outer Thermal Jacket Radiant Glow Perimeter (Pixel-Perfect Matching Vessel Contour)
    Shape {
        id: jacketGlowShape
        anchors.fill: parent
        opacity: (heatEffectRoot.isHeating || heatEffectRoot.isCooling) ? heatEffectRoot.heatPulse : 0.35

        // Outer glow
        ShapePath {
            strokeWidth: 12.0
            strokeColor: heatEffectRoot.isHeating ? "#73f97316" : (heatEffectRoot.isCooling ? "#7306b6d4" : "#2038bdf8")
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin

            PathSvg {
                path: "M 32 135 L 32 310 C 32 354 112 376 150 376 L 210 376 C 248 376 328 354 328 310 L 328 135"
            }
        }

        // Inner core contour
        ShapePath {
            strokeWidth: 4.0
            strokeColor: heatEffectRoot.isHeating ? "#fb923c" : (heatEffectRoot.isCooling ? "#38bdf8" : "#38bdf8")
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin

            PathSvg {
                path: "M 32 135 L 32 310 C 32 354 112 376 150 376 L 210 376 C 248 376 328 354 328 310 L 328 135"
            }
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
