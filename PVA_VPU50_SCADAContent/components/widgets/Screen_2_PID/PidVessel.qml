import QtQuick
import QtQuick.Layouts

Item {
    id: vesselRoot
    width: 270
    height: 360

    property string vesselName: "Unimix 50"
    property real levelPercent: 65.0
    property real vesselTemp: 20.7
    property real jacketTemp: 21.2
    property real vacuumPressure: -179.0
    property real weightKg: 154.4
    property bool isHeating: false
    property bool isCooling: false

    Canvas {
        id: vesselCanvas
        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            var cx = width / 2;
            var w = 240;
            var leftX = cx - w / 2;
            var rightX = cx + w / 2;
            var domeTop = 30;
            var bodyTop = 70;
            var bodyBottom = 270;
            var coneBottom = 320;
            var neckW = 34;

            // 1. OUTER THERMAL JACKET
            ctx.beginPath();
            ctx.moveTo(leftX - 10, bodyTop + 20);
            ctx.lineTo(leftX - 10, bodyBottom);
            ctx.quadraticCurveTo(cx - 40, coneBottom + 10, cx - neckW / 2 - 6, coneBottom + 12);
            ctx.lineTo(cx + neckW / 2 + 6, coneBottom + 12);
            ctx.quadraticCurveTo(cx + 40, coneBottom + 10, rightX + 10, bodyBottom);
            ctx.lineTo(rightX + 10, bodyTop + 20);
            ctx.strokeStyle = vesselRoot.isHeating ? "#f97316" : (vesselRoot.isCooling ? "#06b6d4" : "#1a5188");
            ctx.lineWidth = 2.0;
            ctx.fillStyle = vesselRoot.isHeating ? "#25f97316" : (vesselRoot.isCooling ? "#2506b6d4" : "transparent");
            ctx.fill();
            ctx.stroke();

            // 2. MAIN VESSEL INTERIOR BODY
            ctx.beginPath();
            // Top Dome
            ctx.moveTo(leftX, bodyTop);
            ctx.quadraticCurveTo(cx, domeTop - 10, rightX, bodyTop);
            // Cylindrical walls
            ctx.lineTo(rightX, bodyBottom);
            // Bottom Cone
            ctx.quadraticCurveTo(cx + 35, coneBottom, cx + neckW / 2, coneBottom + 5);
            ctx.lineTo(cx - neckW / 2, coneBottom + 5);
            ctx.quadraticCurveTo(cx - 35, coneBottom, leftX, bodyBottom);
            ctx.closePath();

            ctx.fillStyle = "#0c335b";
            ctx.fill();
            ctx.strokeStyle = "#3b82f6";
            ctx.lineWidth = 2.2;
            ctx.stroke();

            // 3. CENTER DISCHARGE NECK
            ctx.beginPath();
            ctx.rect(cx - neckW / 2, coneBottom + 5, neckW, 30);
            ctx.fillStyle = "#0a2a4c";
            ctx.fill();
            ctx.strokeStyle = "#3b82f6";
            ctx.lineWidth = 1.8;
            ctx.stroke();
        }
    }

    Connections {
        target: vesselRoot
        function onIsHeatingChanged() { vesselCanvas.requestPaint(); }
        function onIsCoolingChanged() { vesselCanvas.requestPaint(); }
    }

    // 4. RIGHT LEVEL GAUGE COLUMN (0.0 to 1000.0 with Green Liquid Fill)
    Item {
        anchors.right: parent.right
        anchors.rightMargin: 18
        anchors.top: parent.top
        anchors.topMargin: 90
        width: 32
        height: 190

        // Background Track
        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 8
            color: "#081d33"
            border.color: "#388be3"
            border.width: 1
            radius: 2

            // Active Green Liquid Fill
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 1
                height: (parent.height - 2) * (Math.max(0, Math.min(100, vesselRoot.levelPercent)) / 100)
                color: "#22c55e"
                radius: 1
            }
        }

        // Scale Labels
        Column {
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            spacing: 34

            Repeater {
                model: ["1000.0", "750.0", "500.0", "250.0", "0.0"]
                Text {
                    text: modelData
                    color: "#7fa5cb"
                    font.pixelSize: 8
                    font.family: "Monospace"
                }
            }
        }
    }

    // 5. PROCESS INSTRUMENT CALLOUTS
    // Vacuum (PIC 161001)
    Column {
        anchors.left: parent.left
        anchors.leftMargin: 14
        anchors.top: parent.top
        anchors.topMargin: 55
        spacing: 1

        Text { text: "PIC 161001"; color: "#8cb5dc"; font.pixelSize: 8 }
        Text { text: vesselRoot.vacuumPressure.toFixed(0) + "mbar"; color: "#93c5fd"; font.bold: true; font.pixelSize: 9 }
    }

    // Vessel Temperature (TIC 162001)
    Column {
        anchors.left: parent.left
        anchors.leftMargin: 14
        anchors.top: parent.top
        anchors.topMargin: 82
        spacing: 1

        Text { text: "TIC 162001"; color: "#8cb5dc"; font.pixelSize: 8 }
        Text { text: vesselRoot.vesselTemp.toFixed(1) + "°C"; color: vesselRoot.isHeating ? "#f97316" : "#4ade80"; font.bold: true; font.pixelSize: 9 }
    }

    // Jacket Temperature (TIC 163001)
    Column {
        anchors.left: parent.left
        anchors.leftMargin: -25
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        spacing: 1

        Text { text: "TIC 163001"; color: "#8cb5dc"; font.pixelSize: 8 }
        Text { text: vesselRoot.jacketTemp.toFixed(1) + "°C"; color: "#38bdf8"; font.bold: true; font.pixelSize: 9 }
    }

    // Weight Indicator (WIRAH 161001)
    Column {
        anchors.right: parent.right
        anchors.rightMargin: -30
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 40
        spacing: 1

        Text { text: "WIRAH 161001"; color: "#8cb5dc"; font.pixelSize: 8 }
        Text { text: vesselRoot.weightKg.toFixed(1) + "kg"; color: "#38bdf8"; font.bold: true; font.pixelSize: 9 }
    }
}
