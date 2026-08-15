import QtQuick

Item {
    id: pipeRoot

    property real startX: 0
    property real startY: 0
    property real endX: 100
    property real endY: 0
    property real pipeWidth: 3
    property color baseColor: "#285888"
    property color flowColor: "#22c55e"
    property bool isActive: false
    property bool reverseFlow: false
    property real flowSpeed: 1200 // ms per cycle

    x: Math.min(startX, endX) - pipeWidth
    y: Math.min(startY, endY) - pipeWidth
    width: Math.abs(endX - startX) + pipeWidth * 2
    height: Math.abs(endY - startY) + pipeWidth * 2

    // Canvas rendering for crisp, hardware-accelerated pipeline and flow particles
    Canvas {
        id: pipeCanvas
        anchors.fill: parent

        property real offset: 0

        NumberAnimation on offset {
            from: 0
            to: pipeRoot.reverseFlow ? -24 : 24
            duration: pipeRoot.flowSpeed
            loops: Animation.Infinite
            running: pipeRoot.isActive
        }

        onOffsetChanged: requestPaint()

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            var lx1 = pipeRoot.startX - pipeRoot.x;
            var ly1 = pipeRoot.startY - pipeRoot.y;
            var lx2 = pipeRoot.endX - pipeRoot.x;
            var ly2 = pipeRoot.endY - pipeRoot.y;

            // 1. Base Stainless Steel Pipeline
            ctx.beginPath();
            ctx.moveTo(lx1, ly1);
            ctx.lineTo(lx2, ly2);
            ctx.lineWidth = pipeRoot.pipeWidth;
            ctx.strokeStyle = pipeRoot.baseColor;
            ctx.lineCap = "round";
            ctx.stroke();

            // 2. Active Fluid Flow Animation (Dashes & Flow Pulse)
            if (pipeRoot.isActive) {
                ctx.save();
                ctx.beginPath();
                ctx.moveTo(lx1, ly1);
                ctx.lineTo(lx2, ly2);
                ctx.lineWidth = pipeRoot.pipeWidth;
                ctx.strokeStyle = pipeRoot.flowColor;
                ctx.setLineDash([8, 8]);
                ctx.lineDashOffset = -offset;
                ctx.lineCap = "round";
                ctx.stroke();
                ctx.restore();
            }
        }
    }
}
