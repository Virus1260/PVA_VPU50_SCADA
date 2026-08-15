import QtQuick

Item {
    id: sprayRoot
    width: 24
    height: 32

    property string tag: "X 161 001"
    property bool isSpraying: false
    property real sprayAngle: 0 // 0 = straight down, -30 = angled left, 30 = angled right

    Canvas {
        id: sprayCanvas
        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            var cx = width / 2;
            var cy = height / 2;

            ctx.save();
            ctx.translate(cx, 8);
            ctx.rotate(sprayRoot.sprayAngle * Math.PI / 180);

            // 1. Supply Pipe Stem
            ctx.beginPath();
            ctx.moveTo(0, -8);
            ctx.lineTo(0, 6);
            ctx.strokeStyle = "#8ec4f0";
            ctx.lineWidth = 2.0;
            ctx.stroke();

            // 2. Collar Coupling Ring
            ctx.beginPath();
            ctx.rect(-4, 4, 8, 3);
            ctx.fillStyle = "#ffffff";
            ctx.fill();
            ctx.strokeStyle = "#1b4c7c";
            ctx.lineWidth = 1;
            ctx.stroke();

            // 3. Spherical Slotted Spray Ball Head
            ctx.beginPath();
            ctx.arc(0, 13, 6, 0, 2 * Math.PI);
            ctx.fillStyle = sprayRoot.isSpraying ? "#4ade80" : "#ffffff";
            ctx.fill();
            ctx.strokeStyle = "#1b4c7c";
            ctx.lineWidth = 1.2;
            ctx.stroke();

            // Slit nozzles on spray head
            ctx.beginPath();
            ctx.moveTo(-3, 11);
            ctx.lineTo(3, 11);
            ctx.moveTo(-4, 14);
            ctx.lineTo(4, 14);
            ctx.strokeStyle = sprayRoot.isSpraying ? "#15803d" : "#94a3b8";
            ctx.lineWidth = 1;
            ctx.stroke();

            ctx.restore();
        }
    }
}
