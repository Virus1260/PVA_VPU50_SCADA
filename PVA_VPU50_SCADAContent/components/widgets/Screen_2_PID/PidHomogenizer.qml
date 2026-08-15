import QtQuick
import QtQuick.Layouts

Item {
    id: homogRoot
    width: 320
    height: 170

    property string motorTag: "M 163 001"
    property string speedTag: "SCR 163001"
    property real speedRpm: 4800.0
    property bool isRunning: true
    property bool showTags: true

    signal suctionSolidsClicked()
    signal suctionLiquidsClicked()
    signal statorValveClicked()
    signal recircValveClicked()
    signal suctionBottomClicked()

    // 1. STATOR CHAMBER (Lime Green with Two Glowing Dots)
    Rectangle {
        id: statorChamber
        x: 135
        y: 20
        width: 50
        height: 20
        radius: 2
        color: homogRoot.isRunning ? "#7dfb24" : "#0d2847"
        border.color: homogRoot.isRunning ? "#22c55e" : "#3b82f6"
        border.width: 1.2

        Row {
            anchors.centerIn: parent
            spacing: 10
            Rectangle { width: 5; height: 5; radius: 2.5; color: homogRoot.isRunning ? "#ffffff" : "#4a90d9" }
            Rectangle { width: 5; height: 5; radius: 2.5; color: homogRoot.isRunning ? "#ffffff" : "#4a90d9" }
        }

        Text {
            visible: homogRoot.showTags
            anchors.left: parent.right
            anchors.leftMargin: 4
            anchors.bottom: parent.top
            anchors.bottomMargin: 1
            text: "Z 163 001"
            color: "#8cb5dc"
            font.pixelSize: 8
        }
    }

    // 2. STATOR VALVE (Right of Chamber)
    PidValve {
        x: 185
        y: 17
        tag: "Z 163 001"
        showTags: false
        isOpen: homogRoot.isRunning
        onClicked: homogRoot.statorValveClicked()
    }

    // 3. SUCTION INLETS (Solids & Liquids on Left)
    // Solids Valve K 143 002
    PidPipe { startX: 85; startY: 30; endX: 135; endY: 30; baseColor: "#1b538c" }
    PidValve {
        x: 85
        y: 17
        tag: "K 143 002"
        subLabel: "Solids"
        showTags: homogRoot.showTags
        isOpen: false
        onClicked: homogRoot.suctionSolidsClicked()
    }

    // Liquids Valve K 143 001
    PidPipe { startX: 85; startY: 65; endX: 135; endY: 65; baseColor: "#1b538c" }
    PidValve {
        x: 85
        y: 52
        tag: "K 143 001"
        subLabel: "Liquids"
        showTags: homogRoot.showTags
        isOpen: false
        onClicked: homogRoot.suctionLiquidsClicked()
    }

    // Foot Switch Indicator
    RowLayout {
        x: 35
        y: 92
        spacing: 5
        visible: homogRoot.showTags
        Rectangle { width: 10; height: 10; radius: 5; color: "#ffffff" }
        Text { text: "foot switch"; color: "#cbd5e1"; font.pixelSize: 8 }
    }

    // 4. RECIRCULATION VALVE K 163 002 (Right Lower Neck)
    PidPipe { startX: 185; startY: 55; endX: 250; endY: 55; baseColor: "#1b538c"; isActive: homogRoot.isRunning; flowColor: "#38ef7d" }
    PidValve {
        x: 210
        y: 42
        tag: "K 163 002"
        showTags: homogRoot.showTags
        isOpen: homogRoot.isRunning
        onClicked: homogRoot.recircValveClicked()
    }

    // 5. BOTTOM SUCTION VALVE V 142 201 (Lower Right of Vessel Dish)
    PidPipe { startX: 260; startY: 0; endX: 260; endY: 20; baseColor: "#1b538c" }
    PidValve {
        x: 247
        y: 8
        tag: "V 142 201"
        subLabel: "Suction Bottom"
        showTags: homogRoot.showTags
        isOpen: false
        onClicked: homogRoot.suctionBottomClicked()
    }

    // 6. MOTOR POWER CABLES (Orange/Brown Double Trace on Left)
    Canvas {
        x: 105
        y: 95
        width: 35
        height: 50
        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);
            ctx.beginPath();
            ctx.moveTo(30, 15);
            ctx.lineTo(10, 15);
            ctx.lineTo(10, 45);
            ctx.strokeStyle = "#c26d2e";
            ctx.lineWidth = 1.5;
            ctx.stroke();

            ctx.beginPath();
            ctx.moveTo(30, 20);
            ctx.lineTo(6, 20);
            ctx.lineTo(6, 45);
            ctx.strokeStyle = "#92400e";
            ctx.lineWidth = 1.5;
            ctx.stroke();
        }
    }

    // 7. BOTTOM DRIVE MOTOR M 163 001 & SPEED READOUT
    Item {
        x: 147
        y: 105
        width: 130
        height: 45

        // Glowing Motor 'M'
        Rectangle {
            id: mCircle
            anchors.left: parent.left
            anchors.top: parent.top
            width: 26
            height: 26
            radius: 13
            color: homogRoot.isRunning ? "#7dfb24" : "#0d2847"
            border.color: homogRoot.isRunning ? "#22c55e" : "#3b82f6"
            border.width: 1.8

            Text {
                anchors.centerIn: parent
                text: "M"
                color: homogRoot.isRunning ? "#052e16" : "#ffffff"
                font.bold: true
                font.pixelSize: 12
            }
        }

        // Speed Tag (SCR 163001 \n 4800rpm)
        ColumnLayout {
            anchors.left: mCircle.right
            anchors.leftMargin: 8
            anchors.verticalCenter: mCircle.verticalCenter
            spacing: 0
            visible: homogRoot.showTags

            Text { text: homogRoot.speedTag; color: "#8cb5dc"; font.pixelSize: 8 }
            Text {
                text: homogRoot.speedRpm.toFixed(0) + "rpm"
                color: homogRoot.isRunning ? "#7dfb24" : "#94a3b8"
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
            font.pixelSize: 7
        }
    }
}
