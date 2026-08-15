import QtQuick

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

    // 2. Outer Thermal Jacket Radiant Glow Perimeter
    Canvas {
        id: jacketGlowCanvas
        anchors.fill: parent
        visible: heatEffectRoot.isHeating || heatEffectRoot.isCooling
        opacity: heatEffectRoot.heatPulse

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            var cx = width / 2;
            var w = width;
            var h = height;

            ctx.beginPath();
            // Start at jacket upper left
            ctx.moveTo(14, 138);
            ctx.lineTo(14, 348);
            // Torispherical bottom dish jacket curve
            ctx.bezierCurveTo(14, 400, cx - 110, 428, cx - 22, 432);
            ctx.lineTo(cx + 22, 432);
            ctx.bezierCurveTo(cx + 110, 428, w - 14, 400, w - 14, 348);
            ctx.lineTo(w - 14, 138);

            ctx.lineWidth = 14.0;
            ctx.strokeStyle = heatEffectRoot.isHeating ? "rgba(249, 115, 22, 0.45)" : "rgba(6, 182, 212, 0.45)";
            ctx.lineCap = "round";
            ctx.stroke();

            // Inner intense core heat line
            ctx.lineWidth = 5.0;
            ctx.strokeStyle = heatEffectRoot.isHeating ? "#fb923c" : "#38bdf8";
            ctx.stroke();
        }
    }

    Connections {
        target: heatEffectRoot
        function onIsHeatingChanged() { jacketGlowCanvas.requestPaint(); }
        function onIsCoolingChanged() { jacketGlowCanvas.requestPaint(); }
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
