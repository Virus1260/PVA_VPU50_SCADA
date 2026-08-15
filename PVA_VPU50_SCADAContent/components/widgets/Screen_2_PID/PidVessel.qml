import QtQuick
import QtQuick.Layouts

Item {
    id: vesselRoot
    width: 240
    height: 340

    property string vesselName: "B1"
    property real levelPercent: 65.0 // 0 to 100%
    property real vesselTemp: 79.8
    property real jacketTemp: 83.2
    property real vacuumPressure: -450.0 // mbar
    property real weightKg: 154.4
    property bool isHeating: false
    property bool isCooling: false
    property bool isFilling: false
    property bool isVacuum: false

    // 1. THERMAL HEATING / COOLING JACKET
    Rectangle {
        id: jacketRect
        anchors.centerIn: parent
        width: parent.width + 24
        height: parent.height + 16
        radius: 20
        color: vesselRoot.isHeating ? "#25f97316" : (vesselRoot.isCooling ? "#2506b6d4" : "transparent")
        border.color: vesselRoot.isHeating ? "#f97316" : (vesselRoot.isCooling ? "#06b6d4" : "#1a4070")
        border.width: 2
        opacity: vesselRoot.isHeating || vesselRoot.isCooling ? 0.9 : 0.4
    }

    // 2. MAIN VESSEL BODY & BOTTOM CONE
    Rectangle {
        id: bodyRect
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        height: parent.height - 40
        radius: 16
        color: "#091a2a"
        border.color: "#4a90d9"
        border.width: 2
        clip: true

        // Liquid Level Box
        Rectangle {
            id: liquidRect
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 3
            height: (parent.height - 6) * (Math.max(0, Math.min(100, vesselRoot.levelPercent)) / 100)
            radius: 12
            color: "#352563eb"
            border.color: "#60a5fa"
            border.width: 1.5

            // Animated Surface Wave
            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 3
                color: "#93c5fd"
                opacity: 0.8
            }
        }

        // Center Percentage Watermark
        Text {
            anchors.centerIn: parent
            text: vesselRoot.levelPercent.toFixed(0) + "%"
            color: "#ffffff"
            font.bold: true
            font.pixelSize: 22
            font.family: "Monospace"
            opacity: 0.7
        }
    }

    // 3. BOTTOM CONICAL DISCHARGE
    Canvas {
        id: coneCanvas
        anchors.top: bodyRect.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: -4
        width: parent.width
        height: 44

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            var cx = width / 2;
            ctx.beginPath();
            ctx.moveTo(8, 0);
            ctx.lineTo(width - 8, 0);
            ctx.lineTo(cx + 20, height);
            ctx.lineTo(cx - 20, height);
            ctx.closePath();
            ctx.fillStyle = "#091a2a";
            ctx.fill();
            ctx.strokeStyle = "#4a90d9";
            ctx.lineWidth = 2;
            ctx.stroke();

            // Liquid in Cone
            if (vesselRoot.levelPercent > 0) {
                ctx.beginPath();
                ctx.moveTo(10, 2);
                ctx.lineTo(width - 10, 2);
                ctx.lineTo(cx + 18, height - 2);
                ctx.lineTo(cx - 18, height - 2);
                ctx.closePath();
                ctx.fillStyle = "#352563eb";
                ctx.fill();
            }
        }
    }

    // 4. LEVEL SCALE MARKINGS (0, 250, 500, 750, 1000)
    Column {
        anchors.right: bodyRect.right
        anchors.rightMargin: 8
        anchors.verticalCenter: bodyRect.verticalCenter
        spacing: 50

        Repeater {
            model: ["1000.0", "750.0", "500.0", "250.0", "0.0"]
            Row {
                spacing: 4
                Rectangle { width: 8; height: 1; color: "#4a90d9"; anchors.verticalCenter: parent.verticalCenter }
                Text { text: modelData; color: "#6b8fbb"; font.pixelSize: 9 }
            }
        }
    }

    // 5. INSTRUMENT CALLOUT TAGS
    // Vacuum Transmitter (PIC 161001)
    Rectangle {
        anchors.left: bodyRect.left
        anchors.leftMargin: -85
        anchors.top: bodyRect.top
        anchors.topMargin: 20
        width: 78
        height: 30
        color: "#08213b"
        border.color: "#184d7e"
        border.width: 1
        radius: 4

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 0
            Text { text: "PIC 161001"; color: "#8cb5dc"; font.pixelSize: 8; Layout.alignment: Qt.AlignHCenter }
            Text { text: vesselRoot.vacuumPressure.toFixed(0) + " mbar"; color: "#a78bfa"; font.bold: true; font.pixelSize: 10; Layout.alignment: Qt.AlignHCenter }
        }
    }

    // Vessel Temp Transmitter (TIC 162001)
    Rectangle {
        anchors.left: bodyRect.left
        anchors.leftMargin: -85
        anchors.top: bodyRect.top
        anchors.topMargin: 65
        width: 78
        height: 30
        color: "#08213b"
        border.color: "#184d7e"
        border.width: 1
        radius: 4

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 0
            Text { text: "TIC 162001"; color: "#8cb5dc"; font.pixelSize: 8; Layout.alignment: Qt.AlignHCenter }
            Text { text: vesselRoot.vesselTemp.toFixed(1) + " °C"; color: vesselRoot.isHeating ? "#f97316" : "#22c55e"; font.bold: true; font.pixelSize: 10; Layout.alignment: Qt.AlignHCenter }
        }
    }

    // Weight Indicator (WIRAH 161001)
    Rectangle {
        anchors.right: bodyRect.right
        anchors.rightMargin: -85
        anchors.verticalCenter: bodyRect.verticalCenter
        width: 78
        height: 30
        color: "#08213b"
        border.color: "#184d7e"
        border.width: 1
        radius: 4

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 0
            Text { text: "WIRAH 161001"; color: "#8cb5dc"; font.pixelSize: 8; Layout.alignment: Qt.AlignHCenter }
            Text { text: vesselRoot.weightKg.toFixed(1) + " kg"; color: "#38bdf8"; font.bold: true; font.pixelSize: 10; Layout.alignment: Qt.AlignHCenter }
        }
    }
}
