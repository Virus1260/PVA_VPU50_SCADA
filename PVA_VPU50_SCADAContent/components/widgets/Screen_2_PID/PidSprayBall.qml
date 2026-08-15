import QtQuick

Item {
    id: sprayRoot
    width: 24
    height: 24

    property string tag: "K 161 001"
    property bool isSpraying: false

    Canvas {
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            var cx = width / 2;
            // Nozzle Stem
            ctx.beginPath();
            ctx.moveTo(cx, 0);
            ctx.lineTo(cx, 8);
            ctx.strokeStyle = "#4a90d9";
            ctx.lineWidth = 2;
            ctx.stroke();

            // Spray Ball Head
            ctx.beginPath();
            ctx.arc(cx, 12, 5, 0, 2 * Math.PI);
            ctx.fillStyle = sprayRoot.isSpraying ? "#22c55e" : "#0d2847";
            ctx.fill();
            ctx.strokeStyle = sprayRoot.isSpraying ? "#4ade80" : "#4a90d9";
            ctx.lineWidth = 1.2;
            ctx.stroke();
        }
    }
}
