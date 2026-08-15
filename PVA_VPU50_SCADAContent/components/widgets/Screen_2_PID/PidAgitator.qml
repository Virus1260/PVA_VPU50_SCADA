import QtQuick
import QtQuick.Layouts

Item {
    id: agitatorRoot
    width: 280
    height: 380

    property string motorTag: "M 162 001"
    property string speedTag: "SCR 162001"
    property real speedRpm: 10.0
    property bool isRunning: true
    property bool showTags: true

    // 1. TOP DRIVE MOTOR & SENSORS
    ColumnLayout {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 1

        Text {
            visible: agitatorRoot.showTags
            text: agitatorRoot.speedTag + " " + agitatorRoot.speedRpm.toFixed(1) + "rpm"
            color: "#ffffff"
            font.bold: true
            font.pixelSize: 8
            Layout.alignment: Qt.AlignHCenter
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 6

            // Motor Symbol 'M' with Authentic EKATO Green Ring
            Rectangle {
                width: 22
                height: 22
                radius: 11
                color: agitatorRoot.isRunning ? "#4ade80" : "#0d2847"
                border.color: agitatorRoot.isRunning ? "#22c55e" : "#3b82f6"
                border.width: 1.5

                Text {
                    anchors.centerIn: parent
                    text: "M"
                    color: agitatorRoot.isRunning ? "#052e16" : "#ffffff"
                    font.bold: true
                    font.pixelSize: 11
                }
            }

            // GZ 161501 Sensor
            Rectangle {
                visible: agitatorRoot.showTags
                width: 7
                height: 7
                radius: 3.5
                color: "#eab308"
            }
        }
    }

    // 2. CENTRAL ROTATING SHAFT
    Rectangle {
        id: shaft
        anchors.top: parent.top
        anchors.topMargin: 46
        anchors.horizontalCenter: parent.horizontalCenter
        width: 4
        height: 220
        color: "#ffffff"
    }

    // 3. AUTHENTIC EKATO PARAVISC DOUBLE X-BRACE IMPELLER
    Canvas {
        id: bladeCanvas
        anchors.top: shaft.top
        anchors.topMargin: 65
        anchors.horizontalCenter: parent.horizontalCenter
        width: 260
        height: 250

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            var cx = width / 2;
            var hw = 95;
            var topY = 10;
            var botY = 205;

            ctx.beginPath();
            // Outer Paravisc Boundary (with bottom central arch)
            ctx.moveTo(cx - hw, topY);
            ctx.lineTo(cx - hw, botY - 32);
            ctx.quadraticCurveTo(cx - hw * 0.5, botY + 2, cx - 22, botY - 10);
            // Center Arch Cutout
            ctx.quadraticCurveTo(cx, botY - 30, cx + 22, botY - 10);
            ctx.quadraticCurveTo(cx + hw * 0.5, botY + 2, cx + hw, botY - 32);
            ctx.lineTo(cx + hw, topY);

            // Double Diagonal X-Braces
            ctx.moveTo(cx - hw, topY);
            ctx.lineTo(cx + hw, botY - 32);

            ctx.moveTo(cx + hw, topY);
            ctx.lineTo(cx - hw, botY - 32);

            // Top cross link
            ctx.moveTo(cx - hw, topY);
            ctx.lineTo(cx + hw, topY);

            ctx.strokeStyle = "#ffffff";
            ctx.lineWidth = 4.0;
            ctx.lineCap = "round";
            ctx.lineJoin = "round";
            ctx.stroke();
        }
    }
}
