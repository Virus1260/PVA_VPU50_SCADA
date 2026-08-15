import QtQuick
import QtQuick.Layouts

Item {
    id: vesselRoot
    width: 320
    height: 420

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
            var domeTop = 38;
            var bodyTop = 78;
            var bodyBottom = 300;
            var coneBottom = 345;
            var neckW = 40;

            // 1. OUTER THERMAL JACKET (Wrapping lower sides & bottom dish)
            ctx.beginPath();
            ctx.moveTo(leftX - 12, bodyTop + 40);
            ctx.lineTo(leftX - 12, bodyBottom);
            ctx.quadraticCurveTo(cx - 50, coneBottom + 12, cx - neckW / 2 - 8, coneBottom + 14);
            ctx.lineTo(cx + neckW / 2 + 8, coneBottom + 14);
            ctx.quadraticCurveTo(cx + 50, coneBottom + 12, rightX + 12, bodyBottom);
            ctx.lineTo(rightX + 12, bodyTop + 40);
            ctx.lineTo(rightX, bodyTop + 40);
            ctx.lineTo(rightX, bodyBottom - 5);
            ctx.quadraticCurveTo(cx + 45, coneBottom + 2, cx + neckW / 2 + 4, coneBottom + 4);
            ctx.lineTo(cx - neckW / 2 - 4, coneBottom + 4);
            ctx.quadraticCurveTo(cx - 45, coneBottom + 2, leftX, bodyBottom - 5);
            ctx.lineTo(leftX, bodyTop + 40);
            ctx.closePath();

            ctx.fillStyle = vesselRoot.isHeating ? "#e06c28" : (vesselRoot.isCooling ? "#0284c7" : "#5b95c9");
            ctx.fill();
            ctx.strokeStyle = "#1b4c7c";
            ctx.lineWidth = 1.8;
            ctx.stroke();

            // 2. MAIN SOLID LIGHT-BLUE REACTOR BODY (Authentic EKATO EPOS Palette)
            ctx.beginPath();
            // Top Dome
            ctx.moveTo(leftX, bodyTop);
            ctx.quadraticCurveTo(cx, domeTop - 12, rightX, bodyTop);
            // Cylindrical Walls
            ctx.lineTo(rightX, bodyBottom);
            // Bottom Conical Dish
            ctx.quadraticCurveTo(cx + 45, coneBottom, cx + neckW / 2, coneBottom + 5);
            ctx.lineTo(cx - neckW / 2, coneBottom + 5);
            ctx.quadraticCurveTo(cx - 45, coneBottom, leftX, bodyBottom);
            ctx.closePath();

            // Light sky-blue solid body
            ctx.fillStyle = "#76b0e0";
            ctx.fill();
            ctx.strokeStyle = "#1b4c7c";
            ctx.lineWidth = 2.2;
            ctx.stroke();

            // Subtle inner highlight gradient
            var grad = ctx.createLinearGradient(leftX, bodyTop, rightX, bodyTop);
            grad.addColorStop(0, "rgba(255,255,255,0.18)");
            grad.addColorStop(0.3, "rgba(255,255,255,0.02)");
            grad.addColorStop(0.7, "rgba(0,0,0,0.02)");
            grad.addColorStop(1, "rgba(0,0,0,0.12)");
            ctx.fillStyle = grad;
            ctx.fill();

            // 3. BOTTOM CYLINDRICAL NECK
            ctx.beginPath();
            ctx.rect(cx - neckW / 2, coneBottom + 5, neckW, 35);
            ctx.fillStyle = "#8ec4f0";
            ctx.fill();
            ctx.strokeStyle = "#1b4c7c";
            ctx.lineWidth = 1.8;
            ctx.stroke();
        }
    }

    Connections {
        target: vesselRoot
        function onIsHeatingChanged() { vesselCanvas.requestPaint(); }
        function onIsCoolingChanged() { vesselCanvas.requestPaint(); }
    }

    // 4. RIGHT LEVEL GAUGE COLUMN (0.0 to 1000.0 with Green Liquid Column)
    Item {
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.top: parent.top
        anchors.topMargin: 100
        width: 36
        height: 195
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

        // Scale Labels (1000.0, 750.0, 500.0, 250.0, 0.0)
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

    // 5. PROCESS INSTRUMENT CALLOUT PILLS (Spaced cleanly without overlapping)
    // Vacuum Transmitter (PIC 161001)
    Rectangle {
        anchors.left: parent.left
        anchors.leftMargin: -30
        anchors.top: parent.top
        anchors.topMargin: 65
        width: 76
        height: 28
        radius: 3
        color: "#0b2e54"
        border.color: "#1d609e"
        border.width: 1
        visible: vesselRoot.showTags

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 0
            Text { text: "PIC 161001"; color: "#8cb5dc"; font.pixelSize: 7; Layout.alignment: Qt.AlignHCenter }
            Text { text: vesselRoot.vacuumPressure.toFixed(0) + "mbar"; color: "#93c5fd"; font.bold: true; font.pixelSize: 9; Layout.alignment: Qt.AlignHCenter }
        }
    }

    // Product Temperature (TIC 162001)
    Rectangle {
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 60
        width: 76
        height: 28
        radius: 3
        color: "#0b2e54"
        border.color: "#1d609e"
        border.width: 1
        visible: vesselRoot.showTags

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 0
            Text { text: "TIC 162001"; color: "#8cb5dc"; font.pixelSize: 7; Layout.alignment: Qt.AlignHCenter }
            Text { text: vesselRoot.vesselTemp.toFixed(1) + "°C"; color: "#ffffff"; font.bold: true; font.pixelSize: 9; Layout.alignment: Qt.AlignHCenter }
        }
    }

    // Jacket Temperature (TIC 163001)
    Rectangle {
        anchors.left: parent.left
        anchors.leftMargin: -25
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 42
        width: 76
        height: 28
        radius: 3
        color: "#0b2e54"
        border.color: "#1d609e"
        border.width: 1
        visible: vesselRoot.showTags

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 0
            Text { text: "TIC 163001"; color: "#8cb5dc"; font.pixelSize: 7; Layout.alignment: Qt.AlignHCenter }
            Text { text: vesselRoot.jacketTemp.toFixed(1) + "°C"; color: "#38bdf8"; font.bold: true; font.pixelSize: 9; Layout.alignment: Qt.AlignHCenter }
        }
    }

    // Weight Indicator (WIRAH 161001)
    Rectangle {
        anchors.right: parent.right
        anchors.rightMargin: -48
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 35
        width: 78
        height: 28
        radius: 3
        color: "#0b2e54"
        border.color: "#1d609e"
        border.width: 1
        visible: vesselRoot.showTags

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 0
            Text { text: "WIRAH 161001"; color: "#8cb5dc"; font.pixelSize: 7; Layout.alignment: Qt.AlignHCenter }
            Text { text: vesselRoot.weightKg.toFixed(1) + "kg"; color: "#38bdf8"; font.bold: true; font.pixelSize: 9; Layout.alignment: Qt.AlignHCenter }
        }
    }
}
