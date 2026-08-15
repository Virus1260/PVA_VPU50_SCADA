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
    property string rotationMode: "agitator_cw" // "agitator_cw", "agitator_ccw", "agitator_reversing"

    property real currentFrame: 0.0
    readonly property int totalFrames: 36
    property bool isIntervalForward: true
    readonly property int activeFrameIndex: ((Math.floor(currentFrame) % totalFrames) + totalFrames) % totalFrames

    function isForwardDirection() {
        if (rotationMode === "agitator_ccw") return false;
        if (rotationMode === "agitator_reversing") return isIntervalForward;
        return true;
    }

    // 10-Second Interval Reversing Timer for "agitator_reversing" Mode
    Timer {
        id: intervalTimer
        interval: 10000 // 10 seconds
        running: agitatorRoot.isRunning && agitatorRoot.speedRpm > 0 && agitatorRoot.rotationMode === "agitator_reversing"
        repeat: true
        onTriggered: {
            agitatorRoot.isIntervalForward = !agitatorRoot.isIntervalForward;
            updateAnimation();
        }
    }

    onRotationModeChanged: {
        isIntervalForward = true;
        updateAnimation();
    }

    onIsRunningChanged: updateAnimation()
    onSpeedRpmChanged: updateAnimation()

    function updateAnimation() {
        if (!isRunning || speedRpm <= 0) {
            frameAnim.stop();
            currentFrame = 0.0;
            return;
        }
        var forward = isForwardDirection();
        frameAnim.stop();
        frameAnim.from = forward ? 0.0 : agitatorRoot.totalFrames;
        frameAnim.to = forward ? agitatorRoot.totalFrames : 0.0;
        frameAnim.duration = Math.max(100, Math.min(3000, (30.0 / Math.max(1.0, agitatorRoot.speedRpm)) * 1000));
        frameAnim.restart();
    }

    // Dynamic Multi-Frame SVG Rotation Animation (Speed Proportional to Control Screen Target RPM)
    NumberAnimation {
        id: frameAnim
        target: agitatorRoot
        property: "currentFrame"
        from: 0.0
        to: agitatorRoot.totalFrames
        duration: Math.max(100, Math.min(3000, (30.0 / Math.max(1.0, agitatorRoot.speedRpm)) * 1000))
        loops: Animation.Infinite
        running: agitatorRoot.isRunning && agitatorRoot.speedRpm > 0
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

    // 3. DRIVE SHAFT (Connecting Motor to Top Dome Flange)
    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 46
        anchors.bottom: impellerContainer.top
        anchors.bottomMargin: -6
        width: 14
        radius: 2
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: "#64748b" }
            GradientStop { position: 0.35; color: "#94a3b8" }
            GradientStop { position: 0.65; color: "#cbd5e1" }
            GradientStop { position: 1.0; color: "#475569" }
        }
        border.color: "#334155"
        border.width: 1
    }

    // 4. 3D ROTATING AGITATOR IMPELLER & SHAFT (Pre-warmed GPU Vector Cache - Zero Lag on Start)
    Item {
        id: impellerContainer
        anchors.top: parent.top
        anchors.topMargin: 120
        anchors.horizontalCenter: parent.horizontalCenter
        width: 240
        height: 285

        // Pre-warm and cache all 36 vector SVG frames into GPU memory at startup
        Repeater {
            model: agitatorRoot.totalFrames
            Image {
                anchors.fill: parent
                source: Qt.resolvedUrl("../../../assets/agitator_sequence/agitator_frame_" + (index < 10 ? "0" + index : "" + index) + ".svg")
                sourceSize: Qt.size(215, 285)
                fillMode: Image.PreserveAspectFit
                smooth: true
                mipmap: true
                asynchronous: false
                cache: true
                visible: true
                opacity: agitatorRoot.activeFrameIndex === index ? 1.0 : 0.0
            }
        }
    }
}
