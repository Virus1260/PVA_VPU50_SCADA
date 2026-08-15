import QtQuick

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
    width: Math.abs(endX - startX) + (pipeWidth + 3) * 2
    height: Math.abs(endY - startY) + (pipeWidth + 3) * 2

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

            // (A) Static Outer Pipe Wall
            ctx.beginPath();
            ctx.moveTo(lx1, ly1);
            ctx.lineTo(lx2, ly2);
            ctx.lineWidth = pipeRoot.isActive ? (pipeRoot.pipeWidth + 1.2) : pipeRoot.pipeWidth;
            ctx.strokeStyle = pipeRoot.isActive ? Qt.darker(pipeRoot.flowColor, 2.0) : pipeRoot.baseColor;
            ctx.lineCap = "round";
            ctx.stroke();

            // (B) Live Animated Core Fluid Stream with Directional Particles
            if (pipeRoot.isActive) {
                ctx.save();
                ctx.beginPath();
                ctx.moveTo(lx1, ly1);
                ctx.lineTo(lx2, ly2);
                ctx.lineWidth = pipeRoot.pipeWidth;
                ctx.strokeStyle = pipeRoot.flowColor;
                ctx.setLineDash([8, 6]);
                ctx.lineDashOffset = -offset;
                ctx.lineCap = "round";
                ctx.stroke();
                ctx.restore();
            }
        }
    }
}
