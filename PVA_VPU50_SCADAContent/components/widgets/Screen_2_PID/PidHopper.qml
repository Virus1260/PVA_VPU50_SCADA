import QtQuick

Item {
    id: hopperRoot
    width: 24
    height: 24

    property color fillColor: "#8ec4f0"
    property color strokeColor: "#1b4c7c"

    Canvas {
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);
            ctx.beginPath();
            ctx.moveTo(2, 2);
            ctx.lineTo(22, 2);
            ctx.lineTo(15, 20);
            ctx.lineTo(9, 20);
            ctx.closePath();
            ctx.fillStyle = hopperRoot.fillColor;
            ctx.fill();
            ctx.strokeStyle = hopperRoot.strokeColor;
            ctx.lineWidth = 1.2;
            ctx.stroke();
        }
    }
}
