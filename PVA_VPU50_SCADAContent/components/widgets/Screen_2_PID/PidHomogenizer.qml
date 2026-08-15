import QtQuick
import QtQuick.Layouts

Item {
    id: homogRoot
    width: 360
    height: 175

    property string motorTag: "M 163 001"
    property string speedTag: "SCR 163001"
    property real speedRpm: 4800.0
    property bool isRunning: true
    property bool showTags: true

    signal suctionSolidsClicked()
    signal suctionLiquidsClicked()
    signal recircValveClicked()

    // 1. DISCHARGE NECK & STEPPED COLLAR CANVAS (With Smooth Metallic Shading)
    Canvas {
        id: neckCanvas
        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            var cx = 180;

            // (A) Upper Metallic Neck (Width: 46px, Height: 74px)
            var upperLeft = cx - 23;
            var upperRight = cx + 23;

            // Flared transition from vessel dish
            ctx.beginPath();
            ctx.moveTo(cx - 30, 0);
            ctx.quadraticCurveTo(upperLeft, 6, upperLeft, 14);
            ctx.lineTo(upperLeft, 74);
            ctx.lineTo(upperRight, 74);
            ctx.lineTo(upperRight, 14);
            ctx.quadraticCurveTo(cx + 30, 6, cx + 30, 0);
            ctx.closePath();

            var uGrad = ctx.createLinearGradient(upperLeft - 7, 0, upperRight + 7, 0);
            uGrad.addColorStop(0, "rgba(255, 255, 255, 0.7)");
            uGrad.addColorStop(0.25, "#b5d8f7");
            uGrad.addColorStop(0.65, "#82b6e6");
            uGrad.addColorStop(1.0, "#609cd4");
            ctx.fillStyle = uGrad;
            ctx.fill();
            ctx.strokeStyle = "#1b4c7c";
            ctx.lineWidth = 1.8;
            ctx.stroke();

            // (B) Lower Stepped Collar (Width: 32px, Height: 38px)
            var lowerLeft = cx - 16;
            var lowerRight = cx + 16;

            ctx.beginPath();
            ctx.rect(lowerLeft, 74, 32, 38);
            var lGrad = ctx.createLinearGradient(lowerLeft, 0, lowerRight, 0);
            lGrad.addColorStop(0, "rgba(255, 255, 255, 0.8)");
            lGrad.addColorStop(0.3, "#aed5f8");
            lGrad.addColorStop(0.7, "#79b0e2");
            lGrad.addColorStop(1.0, "#5b95cb");
            ctx.fillStyle = lGrad;
            ctx.fill();
            ctx.strokeStyle = "#1b4c7c";
            ctx.lineWidth = 1.6;
            ctx.stroke();

            // (C) Dual Copper/Orange Motor Power Cables on Left
            ctx.beginPath();
            ctx.moveTo(lowerLeft, 86);
            ctx.lineTo(cx - 52, 86);
            ctx.lineTo(cx - 52, 145);
            ctx.strokeStyle = "#c26d2e";
            ctx.lineWidth = 1.8;
            ctx.stroke();

            ctx.beginPath();
            ctx.moveTo(lowerLeft, 92);
            ctx.lineTo(cx - 58, 92);
            ctx.lineTo(cx - 58, 145);
            ctx.strokeStyle = "#92400e";
            ctx.lineWidth = 1.8;
            ctx.stroke();
        }
    }

    // 2. STATOR CHAMBER Z 163 001 (Clean Neon Lime Green Box with Glowing Dots)
    Rectangle {
        id: statorBox
        x: 180 - 23
        y: 18
        width: 46
        height: 20
        radius: 2
        color: homogRoot.isRunning ? "#63fa1e" : "#0d2847"
        border.color: homogRoot.isRunning ? "#3ec40c" : "#3b82f6"
        border.width: 1.2

        Row {
            anchors.centerIn: parent
            spacing: 8
            Rectangle {
                width: 7
                height: 7
                radius: 3.5
                color: homogRoot.isRunning ? "#ffffff" : "#4a90d9"
            }
            Rectangle {
                width: 7
                height: 7
                radius: 3.5
                color: homogRoot.isRunning ? "#ffffff" : "#4a90d9"
            }
        }

        // Tag: Z 163 001
        Text {
            visible: homogRoot.showTags
            anchors.left: parent.right
            anchors.leftMargin: 6
            anchors.verticalCenter: parent.verticalCenter
            text: "Z 163 001"
            color: "#8cb5dc"
            font.pixelSize: 8
            font.bold: true
        }
    }

    // 3. LEFT SUCTION PORTS (Solids & Liquids Valves with Diagonal Stem Arrows)
    // (A) Upper Solids Port
    Item {
        x: 75
        y: 18
        width: 81
        height: 24

        // Feed pipe
        Rectangle {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: 48
            height: 2.5
            color: "#52a5ec"
        }

        // Valve with Diagonal Actuator Arrow
        Canvas {
            id: solidsValveCanvas
            width: 26
            height: 24
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter

            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);

                // Triangles
                ctx.beginPath();
                ctx.moveTo(2, 6);
                ctx.lineTo(2, 18);
                ctx.lineTo(12, 12);
                ctx.closePath();
                ctx.moveTo(22, 6);
                ctx.lineTo(22, 18);
                ctx.lineTo(12, 12);
                ctx.closePath();
                ctx.fillStyle = "#ffffff";
                ctx.fill();
                ctx.strokeStyle = "#1b4c7c";
                ctx.lineWidth = 1.2;
                ctx.stroke();

                // Diagonal Stem
                ctx.beginPath();
                ctx.moveTo(12, 12);
                ctx.lineTo(6, 21);
                ctx.strokeStyle = "#ffffff";
                ctx.lineWidth = 1.5;
                ctx.stroke();

                // Small arrow cap
                ctx.beginPath();
                ctx.arc(5, 22, 2, 0, 2 * Math.PI);
                ctx.fillStyle = "#ffffff";
                ctx.fill();
            }
        }

        MouseArea {
            anchors.fill: solidsValveCanvas
            cursorShape: Qt.PointingHandCursor
            onClicked: homogRoot.suctionSolidsClicked()
        }

        // Label: K 143 002 \n Solids
        ColumnLayout {
            anchors.right: solidsValveCanvas.left
            anchors.rightMargin: 4
            anchors.verticalCenter: solidsValveCanvas.verticalCenter
            spacing: 0
            visible: homogRoot.showTags

            Text { text: "K 143 002"; color: "#8cb5dc"; font.pixelSize: 8; font.bold: true; Layout.alignment: Qt.AlignRight }
            Text { text: "Solids"; color: "#cbd5e1"; font.pixelSize: 7; Layout.alignment: Qt.AlignRight }
        }
    }

    // (B) Lower Liquids Port
    Item {
        x: 75
        y: 48
        width: 81
        height: 24

        // Feed pipe
        Rectangle {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: 48
            height: 2.5
            color: "#52a5ec"
        }

        // Valve with Diagonal Actuator Arrow
        Canvas {
            id: liquidsValveCanvas
            width: 26
            height: 24
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter

            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);

                // Triangles
                ctx.beginPath();
                ctx.moveTo(2, 6);
                ctx.lineTo(2, 18);
                ctx.lineTo(12, 12);
                ctx.closePath();
                ctx.moveTo(22, 6);
                ctx.lineTo(22, 18);
                ctx.lineTo(12, 12);
                ctx.closePath();
                ctx.fillStyle = "#ffffff";
                ctx.fill();
                ctx.strokeStyle = "#1b4c7c";
                ctx.lineWidth = 1.2;
                ctx.stroke();

                // Diagonal Stem
                ctx.beginPath();
                ctx.moveTo(12, 12);
                ctx.lineTo(6, 21);
                ctx.strokeStyle = "#ffffff";
                ctx.lineWidth = 1.5;
                ctx.stroke();

                // Small arrow cap
                ctx.beginPath();
                ctx.arc(5, 22, 2, 0, 2 * Math.PI);
                ctx.fillStyle = "#ffffff";
                ctx.fill();
            }
        }

        MouseArea {
            anchors.fill: liquidsValveCanvas
            cursorShape: Qt.PointingHandCursor
            onClicked: homogRoot.suctionLiquidsClicked()
        }

        // Label: K 143 001 \n Liquids
        ColumnLayout {
            anchors.right: liquidsValveCanvas.left
            anchors.rightMargin: 4
            anchors.verticalCenter: liquidsValveCanvas.verticalCenter
            spacing: 0
            visible: homogRoot.showTags

            Text { text: "K 143 001"; color: "#8cb5dc"; font.pixelSize: 8; font.bold: true; Layout.alignment: Qt.AlignRight }
            Text { text: "Liquids"; color: "#cbd5e1"; font.pixelSize: 7; Layout.alignment: Qt.AlignRight }
        }
    }

    // (C) Foot Switch Indicator
    RowLayout {
        x: 20
        y: 84
        spacing: 6
        visible: homogRoot.showTags

        Rectangle {
            width: 12
            height: 12
            radius: 6
            color: "#ffffff"
        }
        Text {
            text: "foot switch"
            color: "#cbd5e1"
            font.pixelSize: 8
            font.bold: true
        }
    }

    // 4. RECIRCULATION PIPE & VALVE K 163 002 (Right Lower Neck)
    Item {
        x: 180 + 23
        y: 45
        width: 140
        height: 30

        // Multi-layered Glowing Pipeline
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            height: 4
            color: "#38bdf8"

            Rectangle {
                anchors.fill: parent
                anchors.margins: 1
                color: homogRoot.isRunning ? "#63fa1e" : "#0d2847"
            }
        }

        // Valve K 163 002
        Canvas {
            id: recircValveCanvas
            width: 28
            height: 20
            anchors.left: parent.left
            anchors.leftMargin: 38
            anchors.verticalCenter: parent.verticalCenter

            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);
                var fill = homogRoot.isRunning ? "#63fa1e" : "#0a284a";
                var stroke = homogRoot.isRunning ? "#ffffff" : "#cbd5e1";

                ctx.beginPath();
                ctx.moveTo(2, 2);
                ctx.lineTo(2, 18);
                ctx.lineTo(14, 10);
                ctx.closePath();
                ctx.moveTo(26, 2);
                ctx.lineTo(26, 18);
                ctx.lineTo(14, 10);
                ctx.closePath();
                ctx.fillStyle = fill;
                ctx.fill();
                ctx.strokeStyle = stroke;
                ctx.lineWidth = 1.2;
                ctx.stroke();
            }
        }

        MouseArea {
            anchors.fill: recircValveCanvas
            cursorShape: Qt.PointingHandCursor
            onClicked: homogRoot.recircValveClicked()
        }

        Text {
            visible: homogRoot.showTags
            anchors.top: recircValveCanvas.bottom
            anchors.topMargin: 2
            anchors.horizontalCenter: recircValveCanvas.horizontalCenter
            text: "K 163 002"
            color: homogRoot.isRunning ? "#63fa1e" : "#cbd5e1"
            font.pixelSize: 8
            font.bold: true
        }
    }

    // 5. BOTTOM DRIVE MOTOR M 163 001 & SPEED READOUT
    Item {
        x: 180 - 14
        y: 112
        width: 140
        height: 55

        // Glowing Motor 'M' Circle
        Rectangle {
            id: mCircle
            anchors.left: parent.left
            anchors.top: parent.top
            width: 28
            height: 28
            radius: 14
            color: homogRoot.isRunning ? "#63fa1e" : "#0d2847"
            border.color: homogRoot.isRunning ? "#3ec40c" : "#3b82f6"
            border.width: 1.8

            Text {
                anchors.centerIn: parent
                text: "M"
                color: homogRoot.isRunning ? "#052e16" : "#ffffff"
                font.bold: true
                font.pixelSize: 13
            }
        }

        // Speed Tag (SCR 163001 \n 4800rpm)
        ColumnLayout {
            anchors.left: mCircle.right
            anchors.leftMargin: 8
            anchors.verticalCenter: mCircle.verticalCenter
            spacing: 0
            visible: homogRoot.showTags

            Text { text: homogRoot.speedTag; color: "#8cb5dc"; font.pixelSize: 8; font.bold: true }
            Text {
                text: homogRoot.speedRpm.toFixed(0) + "rpm"
                color: homogRoot.isRunning ? "#63fa1e" : "#94a3b8"
                font.bold: true
                font.pixelSize: 9
            }
        }

        // Motor Tag M 163 001 below
        Text {
            visible: homogRoot.showTags
            anchors.top: mCircle.bottom
            anchors.topMargin: 2
            anchors.horizontalCenter: mCircle.horizontalCenter
            text: homogRoot.motorTag
            color: "#8cb5dc"
            font.pixelSize: 8
            font.bold: true
        }
    }
}
