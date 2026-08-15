import QtQuick

Item {
    id: pipeRoot

    property real startX: 0
    property real startY: 0
    property real endX: 100
    property real endY: 0
    property real pipeWidth: 2.5
    property color baseColor: "#2164a6"
    property color flowColor: "#38ef7d"
    property bool isActive: false
    property bool reverseFlow: false
    property real flowSpeed: 1000

    x: Math.min(startX, endX) - pipeWidth - 2
    y: Math.min(startY, endY) - pipeWidth - 2
    width: Math.abs(endX - startX) + (pipeWidth + 2) * 2
    height: Math.abs(endY - startY) + (pipeWidth + 2) * 2

    Canvas {
        id: pipeCanvas
        anchors.fill: parent

        property real offset: 0

        NumberAnimation on offset {
            from: 0
            to: pipeRoot.reverseFlow ? -20 : 20
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

            // Base pipe
            ctx.beginPath();
            ctx.moveTo(lx1, ly1);
            ctx.lineTo(lx2, ly2);
            ctx.lineWidth = pipeRoot.isActive ? 3.0 : pipeRoot.pipeWidth;
            ctx.strokeStyle = pipeRoot.isActive ? "#14532d" : pipeRoot.baseColor;
            ctx.lineCap = "round";
            ctx.stroke();

            // Active animated fluid dashes
            if (pipeRoot.isActive) {
                ctx.save();
                ctx.beginPath();
                ctx.moveTo(lx1, ly1);
                ctx.lineTo(lx2, ly2);
                ctx.lineWidth = 3.0;
                ctx.strokeStyle = pipeRoot.flowColor;
                ctx.setLineDash([6, 6]);
                ctx.lineDashOffset = -offset;
                ctx.lineCap = "round";
                ctx.stroke();
                ctx.restore();
            }
        }
    }
}
