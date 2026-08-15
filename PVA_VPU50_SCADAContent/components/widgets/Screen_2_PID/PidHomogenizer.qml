import QtQuick
import QtQuick.Layouts

Item {
    id: homogRoot
    width: 460
    height: 180

    property string motorTag: "M 163 001"
    property string speedTag: "SCR 163001"
    property real speedRpm: 0.0
    property bool isRunning: false
    property bool showTags: true

    signal suctionSolidsClicked()
    signal suctionLiquidsClicked()
    signal recircValveClicked()
    signal motorClicked()

    // 1. High-Frequency Micro-Vibration when running (VPU10 SCADA pattern)
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

    // 2. AXISYMMETRIC METALLIC STATOR & ROTOR ASSEMBLY
    Canvas {
        id: homogCanvas
        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            var cx = width / 2; // 230

            // (A) Top Flared Neck (Seamless Flange Connection to Vessel Bottom Dish)
            var gradTop = ctx.createLinearGradient(cx - 24, 0, cx + 24, 0);
            gradTop.addColorStop(0.0, "#4a7fa8");
            gradTop.addColorStop(0.5, "#93c5fd");
            gradTop.addColorStop(1.0, "#4a7fa8");

            ctx.beginPath();
            ctx.moveTo(cx - 24, 0);
            ctx.bezierCurveTo(cx - 24, 12, cx - 18, 20, cx - 18, 28);
            ctx.lineTo(cx + 18, 28);
            ctx.bezierCurveTo(cx + 18, 20, cx + 24, 12, cx + 24, 0);
            ctx.closePath();
            ctx.fillStyle = gradTop;
            ctx.fill();
            ctx.strokeStyle = "#1b4c7c";
            ctx.lineWidth = 1.6;
            ctx.stroke();

            // (B) Lower Shaft Housing / Rotor Stator Neck
            var gradBot = ctx.createLinearGradient(cx - 16, 52, cx + 16, 52);
            gradBot.addColorStop(0.0, "#4a7fa8");
            gradBot.addColorStop(0.5, "#93c5fd");
            gradBot.addColorStop(1.0, "#4a7fa8");

            ctx.beginPath();
            ctx.rect(cx - 16, 52, 32, 40);
            ctx.fillStyle = gradBot;
            ctx.fill();
            ctx.strokeStyle = "#1b4c7c";
            ctx.lineWidth = 1.6;
            ctx.stroke();

            // (C) Dual Copper Motor Power Feeder Cables
            ctx.beginPath();
            ctx.moveTo(cx - 48, 120);
            ctx.lineTo(cx - 48, 68);
            ctx.lineTo(cx - 16, 68);

            ctx.moveTo(cx - 54, 120);
            ctx.lineTo(cx - 54, 76);
            ctx.lineTo(cx - 16, 76);

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

    // 3. CENTRAL STATOR CHAMBER (Z 163 001) - Normal Blue when OFF, Green when ON
    Rectangle {
        id: statorBox
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 28
        width: 44
        height: 24
        radius: 3
        color: homogRoot.isRunning ? "#4ade80" : "#0e3054"
        border.color: homogRoot.isRunning ? "#22c55e" : "#1d609e"
        border.width: 1.5

        // Dual Glowing Indicator Dots
        Row {
            anchors.centerIn: parent
            spacing: 10
            Repeater {
                model: 2
                Rectangle {
                    width: 6
                    height: 6
                    radius: 3
                    color: homogRoot.isRunning ? "#ffffff" : "#cbd5e1"
                }
            }
        }
    }

    Text {
        visible: homogRoot.showTags
        anchors.left: statorBox.right
        anchors.leftMargin: 8
        anchors.verticalCenter: statorBox.verticalCenter
        text: "Z 163 001"
        color: "#8cb5dc"
        font.pixelSize: 8
        font.bold: true
    }

    // 4. BOTTOM DRIVE MOTOR (M 163 001 / SCR 163001) - Standard SCADA Motor
    PidMotor {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 94
        motorTag: homogRoot.motorTag
        speedTag: homogRoot.speedTag
        speedRpm: homogRoot.speedRpm
        isRunning: homogRoot.isRunning
        showTags: homogRoot.showTags
        showSpeedAbove: false
        enableVibration: true
        onClicked: homogRoot.motorClicked()
    }

    // 5. LEFT SUCTION LINES (K 143 002 Solids & K 143 001 Liquids)
    // Solids Port
    PidPipe { startX: 160; startY: 48; endX: 214; endY: 48; baseColor: "#52a5ec" }
    PidValve {
        x: 138; y: 34; tag: "K 143 002"; subLabel: "Solids"
        showTags: homogRoot.showTags
        onClicked: homogRoot.suctionSolidsClicked()
    }

    // Liquids Port
    PidPipe { startX: 160; startY: 74; endX: 214; endY: 74; baseColor: "#52a5ec" }
    PidValve {
        x: 138; y: 60; tag: "K 143 001"; subLabel: "Liquids"
        showTags: homogRoot.showTags
        onClicked: homogRoot.suctionLiquidsClicked()
    }

    // Solid White Foot Switch
    Rectangle {
        x: 120; y: 105; width: 14; height: 14; radius: 7; color: "#ffffff"
        Text {
            visible: homogRoot.showTags
            anchors.left: parent.right; anchors.leftMargin: 6; anchors.verticalCenter: parent.verticalCenter
            text: "foot switch"; color: "#8cb5dc"; font.pixelSize: 8; font.bold: true
        }
    }

    // 6. RIGHT RECIRCULATION LINE (K 163 002)
    PidPipe { startX: 246; startY: 74; endX: 350; endY: 74; baseColor: "#52a5ec"; isActive: homogRoot.isRunning; flowColor: "#38ef7d" }
    PidValve {
        x: 270; y: 60; tag: "K 163 002"
        showTags: homogRoot.showTags
        isOpen: homogRoot.isRunning
        onClicked: homogRoot.recircValveClicked()
    }
}
