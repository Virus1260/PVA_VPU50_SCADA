import QtQuick
import QtQuick.Layouts

Item {
    id: vesselRoot
    width: 320
    height: 440

    property string vesselName: "Unimix 50"
    property real levelPercent: 65.0
    property real vesselTemp: 35.9
    property real jacketTemp: 34.4
    property real vacuumPressure: -11.0
    property real weightKg: 154.4
    property bool isHeating: false
    property bool isCooling: false
    property bool showTags: true

    Canvas {
        id: vesselCanvas
        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            var cx = width / 2;
            var w = 270;
            var leftX = cx - w / 2;
            var rightX = cx + w / 2;
            var domeTop = 20;
            var bodyTop = 60;
            var bodyBottom = 300;
            var coneBottom = 345;
            var neckW = 44;

            // 1. OUTER THERMAL JACKET
            ctx.beginPath();
            ctx.moveTo(leftX - 12, bodyTop + 40);
            ctx.lineTo(leftX - 12, bodyBottom);
            ctx.quadraticCurveTo(cx - 50, coneBottom + 12, cx - neckW / 2 - 8, coneBottom + 14);
            ctx.lineTo(cx + neckW / 2 + 8, coneBottom + 14);
            ctx.quadraticCurveTo(cx + 50, coneBottom + 12, rightX + 12, bodyBottom);
            ctx.lineTo(rightX + 12, bodyTop + 40);
            ctx.lineTo(rightX, bodyTop + 40);
            ctx.lineTo(rightX, bodyBottom - 4);
            ctx.quadraticCurveTo(cx + 45, coneBottom + 2, cx + neckW / 2 + 4, coneBottom + 4);
            ctx.lineTo(cx - neckW / 2 - 4, coneBottom + 4);
            ctx.quadraticCurveTo(cx - 45, coneBottom + 2, leftX, bodyBottom - 4);
            ctx.lineTo(leftX, bodyTop + 40);
            ctx.closePath();

            ctx.fillStyle = vesselRoot.isHeating ? "#e06c28" : (vesselRoot.isCooling ? "#0284c7" : "#5b95c9");
            ctx.fill();
            ctx.strokeStyle = "#1b4c7c";
            ctx.lineWidth = 1.8;
            ctx.stroke();

            // 2. MAIN SOLID LIGHT SKY-BLUE REACTOR BODY (Authentic EKATO EPOS)
            ctx.beginPath();
            // Top Dome
            ctx.moveTo(leftX, bodyTop);
            ctx.quadraticCurveTo(cx, domeTop - 10, rightX, bodyTop);
            // Cylindrical Walls
            ctx.lineTo(rightX, bodyBottom);
            // Bottom Conical Dish
            ctx.quadraticCurveTo(cx + 45, coneBottom, cx + neckW / 2, coneBottom + 5);
            ctx.lineTo(cx - neckW / 2, coneBottom + 5);
            ctx.quadraticCurveTo(cx - 45, coneBottom, leftX, bodyBottom);
            ctx.closePath();

            ctx.fillStyle = "#79b2e2";
            ctx.fill();
            ctx.strokeStyle = "#1b4c7c";
            ctx.lineWidth = 2.2;
            ctx.stroke();

            // Inner Dome Seam Line
            ctx.beginPath();
            ctx.moveTo(leftX, bodyTop);
            ctx.lineTo(rightX, bodyTop);
            ctx.strokeStyle = "rgba(27, 76, 124, 0.35)";
            ctx.lineWidth = 1.2;
            ctx.stroke();

            // 3. BOTTOM CYLINDRICAL STAINLESS DISCHARGE NECK
            ctx.beginPath();
            ctx.rect(cx - neckW / 2, coneBottom + 5, neckW, 80);
            ctx.fillStyle = "#8ec4f0";
            ctx.fill();
            ctx.strokeStyle = "#1b4c7c";
            ctx.lineWidth = 1.8;
            ctx.stroke();

            // Neck highlights
            var nGrad = ctx.createLinearGradient(cx - neckW / 2, 0, cx + neckW / 2, 0);
            nGrad.addColorStop(0, "rgba(255,255,255,0.4)");
            nGrad.addColorStop(0.3, "rgba(255,255,255,0.0)");
            nGrad.addColorStop(0.8, "rgba(0,0,0,0.1)");
            ctx.fillStyle = nGrad;
            ctx.fillRect(cx - neckW / 2, coneBottom + 5, neckW, 80);
        }
    }

    Connections {
        target: vesselRoot
        function onIsHeatingChanged() { vesselCanvas.requestPaint(); }
        function onIsCoolingChanged() { vesselCanvas.requestPaint(); }
    }

    // 4. RIGHT LEVEL GAUGE COLUMN & READOUTS (Spaced cleanly without overlapping)
    Item {
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.top: parent.top
        anchors.topMargin: 80
        width: 38
        height: 200
        visible: vesselRoot.showTags

        // Background Track
        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 7
            color: "#08213b"
            border.color: "#1b4c7c"
            border.width: 1
            radius: 1

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
            anchors.leftMargin: 10
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            spacing: 36

            Repeater {
                model: ["1000.0", "750.0", "500.0", "250.0", "0.0"]
                Text {
                    text: modelData
                    color: "#1e3a5f"
                    font.pixelSize: 8
                    font.bold: true
                    font.family: "Arial"
                }
            }
        }
    }

    // 5. PROCESS INSTRUMENT CALLOUT PILLS (Spaced cleanly with zero overlapping)
    // Product Temperature (TIC 162001) inside Dome
    Rectangle {
        anchors.left: parent.left
        anchors.leftMargin: 35
        anchors.top: parent.top
        anchors.topMargin: 38
        width: 72
        height: 26
        radius: 3
        color: "#0b2e54"
        border.color: "#1d609e"
        border.width: 1
        visible: vesselRoot.showTags

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 0
            Text { text: "TIC 162001"; color: "#8cb5dc"; font.pixelSize: 7; Layout.alignment: Qt.AlignHCenter }
            Text { text: vesselRoot.vesselTemp.toFixed(1) + "°C"; color: "#ffffff"; font.bold: true; font.pixelSize: 8; Layout.alignment: Qt.AlignHCenter }
        }
    }

    // Jacket Temperature (TIC 163001) placed cleanly on left of bottom cone with leader line
    Canvas {
        anchors.fill: parent
        visible: vesselRoot.showTags
        onPaint: {
            var ctx = getContext("2d");
            ctx.beginPath();
            ctx.moveTo(35, 360);
            ctx.lineTo(85, 340);
            ctx.strokeStyle = "#38bdf8";
            ctx.lineWidth = 1.5;
            ctx.stroke();
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.leftMargin: -32
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 70
        width: 74
        height: 26
        radius: 3
        color: "#0b2e54"
        border.color: "#1d609e"
        border.width: 1
        visible: vesselRoot.showTags

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 0
            Text { text: "TIC 163001"; color: "#8cb5dc"; font.pixelSize: 7; Layout.alignment: Qt.AlignHCenter }
            Text { text: vesselRoot.jacketTemp.toFixed(1) + "°C"; color: "#38bdf8"; font.bold: true; font.pixelSize: 8; Layout.alignment: Qt.AlignHCenter }
        }
    }

    // Weight Indicator (WIRAH 161001) placed cleanly to right of level gauge
    Rectangle {
        anchors.right: parent.right
        anchors.rightMargin: -50
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 60
        width: 76
        height: 26
        radius: 3
        color: "#0b2e54"
        border.color: "#1d609e"
        border.width: 1
        visible: vesselRoot.showTags

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 0
            Text { text: "WIRAH 161001"; color: "#8cb5dc"; font.pixelSize: 7; Layout.alignment: Qt.AlignHCenter }
            Text { text: vesselRoot.weightKg.toFixed(1) + "kg"; color: "#38bdf8"; font.bold: true; font.pixelSize: 8; Layout.alignment: Qt.AlignHCenter }
        }
    }
}
