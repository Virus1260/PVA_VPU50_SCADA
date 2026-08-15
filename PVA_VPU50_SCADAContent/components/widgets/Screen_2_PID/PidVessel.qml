import QtQuick
import QtQuick.Layouts

Item {
    id: vesselRoot
    width: 360
    height: 440

    property string vesselName: "Unimix 50"
    property real levelPercent: 65.0
    property real vesselTemp: 20.7
    property real jacketTemp: 21.2
    property real vacuumPressure: -179.0
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

            var cx = 180;
            var r = 130; // Outer shell radius (D0 = 260px)
            var leftX = cx - r;   // 50
            var rightX = cx + r;  // 310
            var domeTop = 28;     // Peak of top torispherical dome
            var seamY = 65;       // Straight flange tangent line
            var bodyBottom = 310; // Lower tangent line
            var dishBottom = 348; // Bottom torispherical dish apex
            var neckW = 46;       // Bottom discharge neck width

            // -----------------------------------------------------------------
            // 1. CONCENTRIC THERMAL JACKET (Wrapping lower shell & bottom dish snugly)
            // -----------------------------------------------------------------
            var jLeft = leftX - 12;   // 38
            var jRight = rightX + 12; // 322
            var jTop = 120;

            ctx.beginPath();
            ctx.moveTo(jLeft, jTop);
            ctx.lineTo(jLeft, bodyBottom);
            // Outer concentric torispherical curve
            ctx.bezierCurveTo(jLeft, bodyBottom + 26, cx - 55, dishBottom + 12, cx - neckW / 2 - 4, dishBottom + 12);
            ctx.lineTo(cx + neckW / 2 + 4, dishBottom + 12);
            ctx.bezierCurveTo(cx + 55, dishBottom + 12, jRight, bodyBottom + 26, jRight, bodyBottom);
            ctx.lineTo(jRight, jTop);
            // Inner contour (flush against vessel outer shell)
            ctx.lineTo(rightX, jTop);
            ctx.lineTo(rightX, bodyBottom);
            ctx.bezierCurveTo(rightX, bodyBottom + 24, cx + 55, dishBottom, cx + neckW / 2, dishBottom);
            ctx.lineTo(cx - neckW / 2, dishBottom);
            ctx.bezierCurveTo(cx - 55, dishBottom, leftX, bodyBottom + 24, leftX, bodyBottom);
            ctx.lineTo(leftX, jTop);
            ctx.closePath();

            ctx.fillStyle = vesselRoot.isHeating ? "#e06c28" : (vesselRoot.isCooling ? "#0284c7" : "#5b95c9");
            ctx.fill();
            ctx.strokeStyle = "#1b4c7c";
            ctx.lineWidth = 1.6;
            ctx.stroke();

            // -----------------------------------------------------------------
            // 2. MAIN SOLID SKY-BLUE VESSEL BODY (DIN 28011 Torispherical Profile)
            // -----------------------------------------------------------------
            ctx.beginPath();
            // (A) Top Torispherical Dome
            ctx.moveTo(leftX, seamY);
            ctx.bezierCurveTo(leftX, seamY - 24, cx - 75, domeTop, cx, domeTop);
            ctx.bezierCurveTo(cx + 75, domeTop, rightX, seamY - 24, rightX, seamY);

            // (B) Cylindrical Shell Walls
            ctx.lineTo(rightX, bodyBottom);

            // (C) Bottom Torispherical Dish to Bottom Neck
            ctx.bezierCurveTo(rightX, bodyBottom + 24, cx + 55, dishBottom, cx + neckW / 2, dishBottom);
            ctx.lineTo(cx - neckW / 2, dishBottom);
            ctx.bezierCurveTo(cx - 55, dishBottom, leftX, bodyBottom + 24, leftX, bodyBottom);
            ctx.closePath();

            // Solid sky-blue fill
            ctx.fillStyle = "#79b2e2";
            ctx.fill();
            ctx.strokeStyle = "#1b4c7c";
            ctx.lineWidth = 2.2;
            ctx.stroke();

            // Top Seam Line
            ctx.beginPath();
            ctx.moveTo(leftX, seamY);
            ctx.lineTo(rightX, seamY);
            ctx.strokeStyle = "rgba(27, 76, 124, 0.45)";
            ctx.lineWidth = 1.2;
            ctx.stroke();
        }
    }

    Connections {
        target: vesselRoot
        function onIsHeatingChanged() { vesselCanvas.requestPaint(); }
        function onIsCoolingChanged() { vesselCanvas.requestPaint(); }
    }

    // -------------------------------------------------------------------------
    // 3. WIDE CAPSULE LEVEL GAUGE (Exact EKATO Semi-Transparent Design)
    // -------------------------------------------------------------------------
    Item {
        anchors.right: parent.right
        anchors.rightMargin: 52
        anchors.top: parent.top
        anchors.topMargin: 105
        width: 80
        height: 205
        visible: vesselRoot.showTags

        // Scale Labels on Left of Gauge (1000.0 to 0.0)
        Column {
            anchors.right: gaugeTrack.left
            anchors.rightMargin: 6
            anchors.top: gaugeTrack.top
            anchors.bottom: gaugeTrack.bottom
            anchors.topMargin: 4
            anchors.bottomMargin: 4
            spacing: 34

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

        // Wide Capsule Track
        Rectangle {
            id: gaugeTrack
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 24
            radius: 12
            color: "#07203b"
            border.color: "#1b4c7c"
            border.width: 1.5
            clip: true

            // Fine Center Tick Line
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 8
                anchors.bottomMargin: 8
                width: 1
                color: "#1d4ed8"
                opacity: 0.6
            }

            // Active Green Liquid Fill
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 1
                height: (parent.height - 2) * (Math.max(0, Math.min(100, vesselRoot.levelPercent)) / 100)
                radius: 11
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#4ade80" }
                    GradientStop { position: 1.0; color: "#16a34a" }
                }
            }
        }
    }

    // -------------------------------------------------------------------------
    // 4. TELEMETRY BADGES
    // -------------------------------------------------------------------------
    // Product Temperature (TIC 162001) - Top-Left Dome
    Rectangle {
        anchors.left: parent.left
        anchors.leftMargin: 55
        anchors.top: parent.top
        anchors.topMargin: 38
        width: 72
        height: 24
        radius: 3
        color: "#0b2e54"
        border.color: "#1d609e"
        border.width: 1
        visible: vesselRoot.showTags

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 0
            Text { text: "TIC 162001"; color: "#8cb5dc"; font.pixelSize: 7; font.bold: true; Layout.alignment: Qt.AlignHCenter }
            Text { text: vesselRoot.vesselTemp.toFixed(1) + "°C"; color: "#ffffff"; font.bold: true; font.pixelSize: 8; Layout.alignment: Qt.AlignHCenter }
        }
    }

    // Jacket Temperature (TIC 163001) - Lower-Left Dish with Leader Line
    Canvas {
        anchors.fill: parent
        visible: vesselRoot.showTags
        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);
            ctx.beginPath();
            ctx.moveTo(35, 345);
            ctx.lineTo(75, 335);
            ctx.strokeStyle = "#38bdf8";
            ctx.lineWidth = 1.5;
            ctx.stroke();
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.leftMargin: -32
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 85
        width: 74
        height: 24
        radius: 3
        color: "#0b2e54"
        border.color: "#1d609e"
        border.width: 1
        visible: vesselRoot.showTags

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 0
            Text { text: "TIC 163001"; color: "#8cb5dc"; font.pixelSize: 7; font.bold: true; Layout.alignment: Qt.AlignHCenter }
            Text { text: vesselRoot.jacketTemp.toFixed(1) + "°C"; color: "#38bdf8"; font.bold: true; font.pixelSize: 8; Layout.alignment: Qt.AlignHCenter }
        }
    }

    // Weight Indicator (WIRAH 161001) - Right Vessel Wall Load Cell Bracket
    Item {
        anchors.right: parent.right
        anchors.rightMargin: -65
        anchors.top: parent.top
        anchors.topMargin: 235
        width: 86
        height: 28
        visible: vesselRoot.showTags

        // Load Cell Bracket
        Rectangle {
            anchors.left: parent.left
            anchors.leftMargin: -10
            anchors.verticalCenter: parent.verticalCenter
            width: 12
            height: 12
            color: "#1e293b"
            border.color: "#64748b"
            border.width: 1.2
            radius: 2
        }

        // Telemetry Badge
        Rectangle {
            anchors.fill: parent
            radius: 3
            color: "#0b2e54"
            border.color: "#1d609e"
            border.width: 1

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 0
                Text { text: "WIRAH 161001"; color: "#8cb5dc"; font.pixelSize: 7; font.bold: true; Layout.alignment: Qt.AlignHCenter }
                Text { text: vesselRoot.weightKg.toFixed(1) + "kg"; color: "#38bdf8"; font.bold: true; font.pixelSize: 8; Layout.alignment: Qt.AlignHCenter }
            }
        }
    }
}
