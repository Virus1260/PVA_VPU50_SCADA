import QtQuick
import QtQuick.Layouts

Item {
    id: agitatorRoot
    width: 260
    height: 330

    property string motorTag: "M 162 001"
    property string speedTag: "SCR 162001"
    property real speedRpm: 10.0
    property bool isRunning: true

    // 1. TOP DRIVE MOTOR & SENSORS
    ColumnLayout {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 1

        Text { text: agitatorRoot.speedTag; color: "#8cb5dc"; font.pixelSize: 8; Layout.alignment: Qt.AlignHCenter }
        Text { text: agitatorRoot.speedRpm.toFixed(1) + "rpm"; color: agitatorRoot.isRunning ? "#4ade80" : "#94a3b8"; font.bold: true; font.pixelSize: 9; Layout.alignment: Qt.AlignHCenter }
        Text { text: agitatorRoot.motorTag; color: "#8cb5dc"; font.pixelSize: 8; Layout.alignment: Qt.AlignHCenter }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 6

            // Motor Symbol 'M'
            Rectangle {
                width: 22
                height: 22
                radius: 11
                color: agitatorRoot.isRunning ? "#16a34a" : "#0d2847"
                border.color: agitatorRoot.isRunning ? "#4ade80" : "#3b82f6"
                border.width: 1.2

                Text {
                    anchors.centerIn: parent
                    text: "M"
                    color: "#ffffff"
                    font.bold: true
                    font.pixelSize: 10
                }
            }

            // GZ 161501 Sensor
            Rectangle {
                width: 8
                height: 8
                radius: 4
                color: "#eab308"
            }
        }
    }

    // 2. CENTRAL ROTATING SHAFT
    Rectangle {
        id: shaft
        anchors.top: parent.top
        anchors.topMargin: 56
        anchors.horizontalCenter: parent.horizontalCenter
        width: 4
        height: 180
        color: "#ffffff"
    }

    // 3. AUTHENTIC EKATO PARAVISC DOUBLE X-BRACE IMPELLER
    Canvas {
        id: bladeCanvas
        anchors.top: shaft.top
        anchors.topMargin: 50
        anchors.horizontalCenter: parent.horizontalCenter
        width: 230
        height: 210

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            var cx = width / 2;
            var cy = height / 2;
            var hw = 85;
            var topY = 10;
            var botY = 175;

            ctx.beginPath();
            // Outer Paravisc Boundary (with bottom central arch)
            ctx.moveTo(cx - hw, topY);
            ctx.lineTo(cx - hw, botY - 30);
            ctx.quadraticCurveTo(cx - hw * 0.5, botY, cx - 18, botY - 10);
            // Center Arch Cutout
            ctx.quadraticCurveTo(cx, botY - 26, cx + 18, botY - 10);
            ctx.quadraticCurveTo(cx + hw * 0.5, botY, cx + hw, botY - 30);
            ctx.lineTo(cx + hw, topY);

            // Double Diagonal X-Braces
            ctx.moveTo(cx - hw, topY);
            ctx.lineTo(cx + hw, botY - 30);

            ctx.moveTo(cx + hw, topY);
            ctx.lineTo(cx - hw, botY - 30);

            // Top cross link
            ctx.moveTo(cx - hw, topY);
            ctx.lineTo(cx + hw, topY);

            ctx.strokeStyle = "#ffffff";
            ctx.lineWidth = 3.0;
            ctx.lineCap = "round";
            ctx.lineJoin = "round";
            ctx.stroke();
        }
    }
}
