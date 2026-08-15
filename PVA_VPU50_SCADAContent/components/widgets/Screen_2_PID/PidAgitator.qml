import QtQuick
import QtQuick.Layouts

Item {
    id: agitatorRoot
    width: 280
    height: 480

    property string motorTag: "M 162 001"
    property string speedTag: "SCR 162001"
    property real speedRpm: 10.0
    property bool isRunning: true
    property bool showTags: true

    property real rotationAngle: 0.0

    // Smooth Dynamic Rotation Animation Linked to SCADA State
    NumberAnimation {
        id: rotAnim
        target: agitatorRoot
        property: "rotationAngle"
        from: 0
        to: 360
        duration: Math.max(400, Math.min(10000, (60.0 / Math.max(1.0, agitatorRoot.speedRpm)) * 1000))
        loops: Animation.Infinite
        running: agitatorRoot.isRunning && agitatorRoot.speedRpm > 0
    }

    onIsRunningChanged: {
        if (!isRunning) {
            rotAnim.stop();
            rotationAngle = 0;
        } else {
            rotAnim.restart();
        }
    }

    // 1. TOP DRIVE MOTOR & SENSORS (Pixel-perfect EKATO Layout)
    ColumnLayout {
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 1

        Text {
            visible: agitatorRoot.showTags
            text: agitatorRoot.speedTag
            color: "#8cb5dc"
            font.bold: true
            font.pixelSize: 8
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            visible: agitatorRoot.showTags
            text: agitatorRoot.speedRpm.toFixed(1) + "rpm"
            color: "#ffffff"
            font.bold: true
            font.pixelSize: 8
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            visible: agitatorRoot.showTags
            text: agitatorRoot.motorTag
            color: "#8cb5dc"
            font.bold: true
            font.pixelSize: 8
            Layout.alignment: Qt.AlignHCenter
        }

        Item { Layout.preferredHeight: 2 }

        // Motor Symbol 'M' with Vibrant EKATO Green Ring
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            width: 24
            height: 24
            radius: 12
            color: agitatorRoot.isRunning ? "#4ade80" : "#0d2847"
            border.color: agitatorRoot.isRunning ? "#22c55e" : "#3b82f6"
            border.width: 1.6

            Text {
                anchors.centerIn: parent
                text: "M"
                color: agitatorRoot.isRunning ? "#052e16" : "#ffffff"
                font.bold: true
                font.pixelSize: 12
            }
        }
    }

    // 2. PROXIMITY SENSOR GZ 161501 ON DOME WITH VERTICAL LABEL
    Item {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: 24
        anchors.top: parent.top
        anchors.topMargin: 46
        width: 16
        height: 40
        visible: agitatorRoot.showTags

        Text {
            anchors.bottom: sensorDot.top
            anchors.bottomMargin: 2
            anchors.horizontalCenter: parent.horizontalCenter
            text: "GZ 161501"
            color: "#8cb5dc"
            font.pixelSize: 7
            font.bold: true
            rotation: -90
            transformOrigin: Item.BottomRight
        }

        Rectangle {
            id: sensorDot
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: 8
            height: 8
            radius: 4
            color: "#4ade80"
            border.color: "#22c55e"
            border.width: 1
        }
    }

    // 3. CENTRAL ROTATING SHAFT (Extended down through vessel)
    Rectangle {
        id: shaft
        anchors.top: parent.top
        anchors.topMargin: 63
        anchors.horizontalCenter: parent.horizontalCenter
        width: 10
        height: 330
        color: "#ffffff"
    }

    // 4. AUTHENTIC THICK EKATO PARAVISC DOUBLE X-BRACE IMPELLER (Positioned well below spray balls)
    Item {
        id: impellerContainer
        anchors.top: shaft.top
        anchors.topMargin: 152
        anchors.horizontalCenter: parent.horizontalCenter
        width: 250
        height: 180

        // 3D Perspective Rotation Transform
        transform: Rotation {
            origin.x: 125
            origin.y: 90
            axis { x: 0; y: 1; z: 0 }
            angle: agitatorRoot.rotationAngle
        }

        Canvas {
            id: bladeCanvas
            anchors.fill: parent

            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);

                var cx = width / 2;
                var hw = 84;
                var topY = 6;
                var botY = 172;

                ctx.beginPath();
                // Outer Paravisc Boundary (with bottom central arch)
                ctx.moveTo(cx - hw, topY);
                ctx.lineTo(cx - hw, botY - 24);
                ctx.quadraticCurveTo(cx - hw * 0.5, botY + 2, cx - 20, botY - 6);
                // Center Arch Cutout above neck
                ctx.quadraticCurveTo(cx, botY - 20, cx + 20, botY - 6);
                ctx.quadraticCurveTo(cx + hw * 0.5, botY + 2, cx + hw, botY - 24);
                ctx.lineTo(cx + hw, topY);

                // Double Diagonal X-Braces
                ctx.moveTo(cx - hw, topY);
                ctx.lineTo(cx + hw, botY - 24);

                ctx.moveTo(cx + hw, topY);
                ctx.lineTo(cx - hw, botY - 24);

                // Top cross link
                ctx.moveTo(cx - hw, topY);
                ctx.lineTo(cx + hw, topY);

                ctx.strokeStyle = "#ffffff";
                ctx.lineWidth = 10.0;
                ctx.lineCap = "round";
                ctx.lineJoin = "round";
                ctx.stroke();
            }
        }
    }
}
