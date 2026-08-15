import QtQuick
import QtQuick.Layouts

Item {
    id: agitatorRoot
    width: 200
    height: 260

    property string motorTag: "M 162 001"
    property string speedTag: "SCR 162001"
    property real speedRpm: 10.0
    property bool isRunning: true

    // 1. TOP DRIVE MOTOR (M 162 001)
    Rectangle {
        id: motorBadge
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: 30
        height: 30
        radius: 15
        color: agitatorRoot.isRunning ? "#166534" : "#0d2847"
        border.color: agitatorRoot.isRunning ? "#22c55e" : "#4a90d9"
        border.width: 1.5

        Text {
            anchors.centerIn: parent
            text: "M"
            color: "#ffffff"
            font.bold: true
            font.pixelSize: 12
        }
    }

    // Speed & Motor Tag Readout
    ColumnLayout {
        anchors.bottom: motorBadge.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 4
        spacing: 0

        Text { text: agitatorRoot.speedTag; color: "#8cb5dc"; font.pixelSize: 8; Layout.alignment: Qt.AlignHCenter }
        Text { text: agitatorRoot.speedRpm.toFixed(1) + " rpm"; color: agitatorRoot.isRunning ? "#22c55e" : "#94a3b8"; font.bold: true; font.pixelSize: 10; Layout.alignment: Qt.AlignHCenter }
        Text { text: agitatorRoot.motorTag; color: "#94a3b8"; font.pixelSize: 8; Layout.alignment: Qt.AlignHCenter }
    }

    // 2. CENTRAL SHAFT
    Rectangle {
        id: shaft
        anchors.top: motorBadge.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: 4
        height: 120
        color: agitatorRoot.isRunning ? "#22c55e" : "#4a90d9"
    }

    // 3. PARAVISC / ANCHOR IMPELLER (Matching EKATO Authentic Geometry)
    Canvas {
        id: bladeCanvas
        anchors.top: shaft.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: -50
        width: 160
        height: 130

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            var cx = width / 2;
            var cy = 65;
            var hw = 68; // fixed half-width

            ctx.beginPath();
            // Outer Anchor U-shape
            ctx.moveTo(cx - hw, cy - 45);
            ctx.lineTo(cx - hw, cy + 30);
            ctx.quadraticCurveTo(cx, cy + 50, cx + hw, cy + 30);
            ctx.lineTo(cx + hw, cy - 45);

            // Double X-Bracing (Authentic EKATO Paravisc)
            ctx.moveTo(cx - hw, cy - 45);
            ctx.lineTo(cx + hw, cy + 30);

            ctx.moveTo(cx + hw, cy - 45);
            ctx.lineTo(cx - hw, cy + 30);

            // Bottom horizontal support
            ctx.moveTo(cx - hw * 0.7, cy + 35);
            ctx.lineTo(cx + hw * 0.7, cy + 35);

            ctx.strokeStyle = agitatorRoot.isRunning ? "#22c55e" : "#4a90d9";
            ctx.lineWidth = 2.5;
            ctx.lineCap = "round";
            ctx.lineJoin = "round";
            ctx.stroke();

            // Center Hub
            ctx.beginPath();
            ctx.arc(cx, cy - 7, 4, 0, 2 * Math.PI);
            ctx.fillStyle = agitatorRoot.isRunning ? "#22c55e" : "#4a90d9";
            ctx.fill();
        }
    }
}
