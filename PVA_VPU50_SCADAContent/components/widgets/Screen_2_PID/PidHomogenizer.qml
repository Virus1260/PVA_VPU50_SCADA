import QtQuick
import QtQuick.Layouts

Item {
    id: homogRoot
    width: 460
    height: 205

    property string motorTag: "M 163 001"
    property string speedTag: "SCR 163001"
    property real speedRpm: 4800.0
    property bool isRunning: false
    property bool showTags: true

    signal suctionSolidsClicked()
    signal suctionLiquidsClicked()
    signal recircValveClicked()
    signal motorClicked()

    // 1. High-Frequency Micro-Vibration when running (matching VPU10 SCADA)
    property real vibX: 0
    property real vibY: 0

    SequentialAnimation {
        running: homogRoot.isRunning
        loops: Animation.Infinite
        NumberAnimation { target: homogRoot; property: "vibX"; to: 1.0; duration: 35 }
        NumberAnimation { target: homogRoot; property: "vibY"; to: -1.0; duration: 35 }
        NumberAnimation { target: homogRoot; property: "vibX"; to: -1.0; duration: 35 }
        NumberAnimation { target: homogRoot; property: "vibY"; to: 1.0; duration: 35 }
        NumberAnimation { target: homogRoot; property: "vibX"; to: 0.0; duration: 35 }
        NumberAnimation { target: homogRoot; property: "vibY"; to: 0.0; duration: 35 }
    }

    transform: Translate {
        x: homogRoot.vibX
        y: homogRoot.vibY
    }

    // 2. MAIN METALLIC SHAFT COLUMN & COPPER POWER FEEDERS
    Canvas {
        id: homogCanvas
        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            var cx = width / 2; // 230

            // (A) Upper Flared Transition from Vessel Bottom Dish
            var gradTop = ctx.createLinearGradient(cx - 24, 0, cx + 24, 0);
            gradTop.addColorStop(0.0, "#60a5fa");
            gradTop.addColorStop(0.5, "#dbeafe");
            gradTop.addColorStop(1.0, "#60a5fa");

            ctx.beginPath();
            ctx.moveTo(cx - 24, 0);
            ctx.bezierCurveTo(cx - 24, 10, cx - 22, 16, cx - 22, 25);
            ctx.lineTo(cx + 22, 25);
            ctx.bezierCurveTo(cx + 22, 16, cx + 24, 10, cx + 24, 0);
            ctx.closePath();
            ctx.fillStyle = gradTop;
            ctx.fill();
            ctx.strokeStyle = "#1b4c7c";
            ctx.lineWidth = 1.6;
            ctx.stroke();

            // (B) Main Cylindrical Column (Width: 44, from Y = 25 to Y = 110)
            var gradMid = ctx.createLinearGradient(cx - 22, 0, cx + 22, 0);
            gradMid.addColorStop(0.0, "#60a5fa");
            gradMid.addColorStop(0.5, "#dbeafe");
            gradMid.addColorStop(1.0, "#60a5fa");

            ctx.beginPath();
            ctx.rect(cx - 22, 25, 44, 85);
            ctx.fillStyle = gradMid;
            ctx.fill();
            ctx.strokeStyle = "#1b4c7c";
            ctx.lineWidth = 1.6;
            ctx.stroke();

            // (C) Lower Step-Down Collar (Width: 28, from Y = 110 to Y = 142)
            var gradCollar = ctx.createLinearGradient(cx - 14, 0, cx + 14, 0);
            gradCollar.addColorStop(0.0, "#60a5fa");
            gradCollar.addColorStop(0.5, "#dbeafe");
            gradCollar.addColorStop(1.0, "#60a5fa");

            ctx.beginPath();
            ctx.rect(cx - 14, 110, 28, 32);
            ctx.fillStyle = gradCollar;
            ctx.fill();
            ctx.strokeStyle = "#1b4c7c";
            ctx.lineWidth = 1.6;
            ctx.stroke();

            // (D) Dual Copper Power Cables
            ctx.beginPath();
            ctx.moveTo(cx - 50, 155);
            ctx.lineTo(cx - 50, 120);
            ctx.lineTo(cx - 14, 120);

            ctx.moveTo(cx - 58, 155);
            ctx.lineTo(cx - 58, 128);
            ctx.lineTo(cx - 14, 128);

            ctx.strokeStyle = "#d97706";
            ctx.lineWidth = 2.2;
            ctx.lineCap = "round";
            ctx.stroke();
        }
    }

    Connections {
        target: homogRoot
        function onIsRunningChanged() { homogCanvas.requestPaint(); }
    }

    // 3. STATOR CHAMBER (Z 163 001) - Horizontal Band with Direct Right Valve
    Rectangle {
        id: statorBand
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 25
        width: 44
        height: 22
        radius: 2
        color: homogRoot.isRunning ? "#4ade80" : "#0e3054"
        border.color: homogRoot.isRunning ? "#22c55e" : "#1d609e"
        border.width: 1.5

        // Dual Glowing Indicator Rectangles
        Row {
            anchors.centerIn: parent
            spacing: 8
            Repeater {
                model: 2
                Rectangle {
                    width: 7
                    height: 9
                    radius: 2
                    color: homogRoot.isRunning ? "#ffffff" : "#cbd5e1"
                }
            }
        }
    }

    // Right Stator Direct Valve Symbol (Z 163 001)
    Canvas {
        id: statorValveCanvas
        anchors.left: statorBand.right
        anchors.verticalCenter: statorBand.verticalCenter
        width: 22
        height: 18

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            ctx.beginPath();
            ctx.moveTo(0, 1);
            ctx.lineTo(18, 9);
            ctx.lineTo(0, 17);
            ctx.closePath();

            ctx.fillStyle = homogRoot.isRunning ? "#4ade80" : "#0e3054";
            ctx.fill();
            ctx.strokeStyle = homogRoot.isRunning ? "#22c55e" : "#1d609e";
            ctx.lineWidth = 1.4;
            ctx.stroke();
        }
    }

    Text {
        visible: homogRoot.showTags
        anchors.left: statorValveCanvas.right
        anchors.leftMargin: 4
        anchors.bottom: statorValveCanvas.top
        anchors.bottomMargin: -4
        text: "Z 163 001"
        color: "#8cb5dc"
        font.pixelSize: 8
        font.bold: true
    }

    // 4. LEFT SUCTION PORTS (K 143 002 Solids & K 143 001 Liquids)
    // Upper Solids Line
    PidPipe { startX: 140; startY: 56; endX: 208; endY: 56; baseColor: "#52a5ec" }
    PidValve {
        x: 142; y: 42; tag: "K 143 002"; subLabel: "Solids"
        showTags: homogRoot.showTags
        onClicked: homogRoot.suctionSolidsClicked()
    }

    // Lower Liquids Line
    PidPipe { startX: 140; startY: 92; endX: 208; endY: 92; baseColor: "#52a5ec" }
    PidValve {
        x: 142; y: 78; tag: "K 143 001"; subLabel: "Liquids"
        showTags: homogRoot.showTags
        onClicked: homogRoot.suctionLiquidsClicked()
    }

    // Solid White Foot Switch Indicator
    Rectangle {
        x: 95; y: 132; width: 14; height: 14; radius: 7; color: "#ffffff"
        Text {
            visible: homogRoot.showTags
            anchors.left: parent.right; anchors.leftMargin: 6; anchors.verticalCenter: parent.verticalCenter
            text: "foot switch"; color: "#8cb5dc"; font.pixelSize: 8; font.bold: true
        }
    }

    // 5. RIGHT RECIRCULATION LINE (K 163 002)
    PidPipe { startX: 252; startY: 74; endX: 380; endY: 74; baseColor: "#52a5ec"; isActive: homogRoot.isRunning; flowColor: "#38ef7d" }
    PidValve {
        x: 290; y: 60; tag: "K 163 002"
        showTags: homogRoot.showTags
        isOpen: homogRoot.isRunning
        onClicked: homogRoot.recircValveClicked()
    }

    // 6. BOTTOM DRIVE MOTOR (M 163 001) - Centered Directly Below Homogenizer Column
    Item {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 142
        width: 180
        height: 55

        // Circular Motor Symbol 'M' (Centered Directly on Shaft Center)
        Rectangle {
            id: motorCircle
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 2
            width: 24
            height: 24
            radius: 12
            color: homogRoot.isRunning ? "#4ade80" : "#0d2847"
            border.color: homogRoot.isRunning ? "#22c55e" : "#3b82f6"
            border.width: 1.6

            Text {
                anchors.centerIn: parent
                text: "M"
                color: homogRoot.isRunning ? "#052e16" : "#ffffff"
                font.bold: true
                font.pixelSize: 12
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: homogRoot.motorClicked()
            }
        }

        // Speed Readout (Right of Motor)
        ColumnLayout {
            anchors.left: motorCircle.right
            anchors.leftMargin: 8
            anchors.verticalCenter: motorCircle.verticalCenter
            spacing: 0
            visible: homogRoot.showTags

            Text {
                text: homogRoot.speedTag
                color: "#8cb5dc"
                font.bold: true
                font.pixelSize: 8
            }
            Text {
                text: homogRoot.speedRpm.toFixed(0) + "rpm"
                color: homogRoot.isRunning ? "#4ade80" : "#ffffff"
                font.bold: true
                font.pixelSize: 8
            }
        }

        // Motor Tag Below Motor Circle
        Text {
            visible: homogRoot.showTags
            anchors.top: motorCircle.bottom
            anchors.topMargin: 3
            anchors.horizontalCenter: motorCircle.horizontalCenter
            text: homogRoot.motorTag
            color: "#8cb5dc"
            font.bold: true
            font.pixelSize: 8
        }
    }
}
