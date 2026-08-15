import QtQuick
import QtQuick.Layouts

Item {
    id: agitatorRoot
    width: 280
    height: 480

    property string motorTag: "M 162 001"
    property string speedTag: "SCR 162001"
    property real speedRpm: 0.0
    property bool isRunning: false
    property bool showTags: true

    property int currentFrame: 0
    readonly property int totalFrames: 36

    // Dynamic Multi-Frame SVG Rotation Animation (Speed Proportional to Control Screen Target RPM)
    NumberAnimation {
        id: frameAnim
        target: agitatorRoot
        property: "currentFrame"
        from: 0
        to: agitatorRoot.totalFrames
        duration: Math.max(100, Math.min(3000, (30.0 / Math.max(1.0, agitatorRoot.speedRpm)) * 1000))
        loops: Animation.Infinite
        running: agitatorRoot.isRunning && agitatorRoot.speedRpm > 0
    }

    onIsRunningChanged: {
        if (!isRunning) {
            frameAnim.stop();
            currentFrame = 0;
        } else {
            frameAnim.restart();
        }
    }

    // 1. TOP DRIVE MOTOR (Standard Reusable SCADA Motor)
    PidMotor {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        motorTag: agitatorRoot.motorTag
        speedTag: agitatorRoot.speedTag
        speedRpm: agitatorRoot.speedRpm
        isRunning: agitatorRoot.isRunning
        showTags: agitatorRoot.showTags
        showSpeedAbove: true
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
            color: agitatorRoot.isRunning ? "#4ade80" : "#475569"
            border.color: agitatorRoot.isRunning ? "#22c55e" : "#64748b"
            border.width: 1
        }
    }

    // 3. 3D ROTATING AGITATOR IMPELLER & SHAFT (Pre-warmed GPU Vector Cache - Zero Lag on Start)
    Item {
        id: impellerContainer
        anchors.top: parent.top
        anchors.topMargin: 65
        anchors.horizontalCenter: parent.horizontalCenter
        width: 250
        height: 320

        // Pre-warm and cache all 18 vector SVG frames into GPU memory at startup
        Repeater {
            model: agitatorRoot.totalFrames
            Image {
                anchors.fill: parent
                source: Qt.resolvedUrl("../../../assets/agitator_sequence/agitator_frame_" + (index < 10 ? "0" + index : "" + index) + ".svg")
                sourceSize: Qt.size(250, 320)
                fillMode: Image.PreserveAspectFit
                smooth: true
                mipmap: true
                asynchronous: false
                cache: true
                visible: true
                opacity: Math.floor(agitatorRoot.currentFrame) === index ? 1.0 : 0.0
            }
        }
    }
}
