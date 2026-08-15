import QtQuick

Item {
    id: sprayRoot
    width: 36
    height: 52

    property string tag: "X 165 501"
    property bool isSpraying: false
    property real sprayAngle: 0.0 // 0 = straight down, 40 = angled right
    property bool showTags: true

    Canvas {
        id: sprayCanvas
        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            var cx = width / 2;

            ctx.save();
            ctx.translate(cx, 6);
            ctx.rotate(sprayRoot.sprayAngle * Math.PI / 180);

            // 1. Pipe Stem
            ctx.beginPath();
            ctx.moveTo(0, -6);
            ctx.lineTo(0, 4);
            ctx.strokeStyle = "#52a5ec";
            ctx.lineWidth = 2.5;
            ctx.stroke();

            // 2. Collar Coupling Ring (Dark bracket)
            ctx.beginPath();
            ctx.rect(-4, 4, 8, 4);
            ctx.fillStyle = "#1e293b";
            ctx.fill();
            ctx.strokeStyle = "#38bdf8";
            ctx.lineWidth = 1;
            ctx.stroke();

            // 3. Bell-Shaped Slotted Spray Head (Exact EKATO silhouette)
            ctx.beginPath();
            ctx.moveTo(-6.5, 9);
            ctx.lineTo(6.5, 9);
            ctx.lineTo(8, 16);
            ctx.arc(0, 16, 8, 0, Math.PI, false);
            ctx.lineTo(-8, 16);
            ctx.closePath();

            ctx.fillStyle = sprayRoot.isSpraying ? "#4ade80" : "#ffffff";
            ctx.fill();
            ctx.strokeStyle = "#1b4c7c";
            ctx.lineWidth = 1.6;
            ctx.stroke();

            // 3 Vertical discharge slit grooves
            ctx.beginPath();
            ctx.moveTo(-3.5, 13);
            ctx.lineTo(-3.5, 21);
            ctx.moveTo(0, 12);
            ctx.lineTo(0, 22);
            ctx.moveTo(3.5, 13);
            ctx.lineTo(3.5, 21);
            ctx.strokeStyle = sprayRoot.isSpraying ? "#15803d" : "#94a3b8";
            ctx.lineWidth = 1.3;
            ctx.lineCap = "round";
            ctx.stroke();

            ctx.restore();
        }
    }

    Connections {
        target: sprayRoot
        function onIsSprayingChanged() { sprayCanvas.requestPaint(); }
    }

    // Tag text below the head (e.g. X 165 501)
    Text {
        visible: sprayRoot.showTags
        anchors.top: sprayCanvas.bottom
        anchors.topMargin: -12
        anchors.horizontalCenter: parent.horizontalCenter
        text: sprayRoot.tag
        color: "#8cb5dc"
        font.pixelSize: 7
        font.bold: true
    }
}
