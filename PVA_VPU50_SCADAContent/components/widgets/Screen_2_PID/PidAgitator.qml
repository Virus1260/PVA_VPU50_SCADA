import QtQuick
import QtQuick.Layouts
import QtQuick3D
import "../../../assets/3d" as Assets3D

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

    property real currentAngle: 0.0
    property bool isIntervalForward: true

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
        }
    }

    onRotationModeChanged: {
        isIntervalForward = true;
    }

    onIsRunningChanged: {
        if (!isRunning) {
            isIntervalForward = true;
        }
    }

    // Smooth Continuous 60fps Rotation Engine
    FrameAnimation {
        running: agitatorRoot.isRunning && agitatorRoot.speedRpm > 0
        onTriggered: {
            var degPerSec = (agitatorRoot.speedRpm * 360.0) / 60.0;
            var deltaDeg = (degPerSec * frameTime);
            if (agitatorRoot.isForwardDirection()) {
                agitatorRoot.currentAngle = (agitatorRoot.currentAngle + deltaDeg) % 360.0;
            } else {
                agitatorRoot.currentAngle = (agitatorRoot.currentAngle - deltaDeg + 360.0) % 360.0;
            }
        }
    }

    // 1. TOP DRIVE MOTOR (Standard Reusable SCADA Motor)
    PidMotor {
        id: topMotor
        z: 2
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

    // 3. DRIVE SHAFT (Seamless Stainless Steel Specular Highlight Match)
    Rectangle {
        id: driveShaft
        z: 1
        x: (parent.width - width) / 2
        y: 66
        width: 14
        height: 56
        radius: 1
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: "#64748b" }
            GradientStop { position: 0.25; color: "#94a3b8" }
            GradientStop { position: 0.55; color: "#f8fafc" }
            GradientStop { position: 0.80; color: "#cbd5e1" }
            GradientStop { position: 1.0; color: "#475569" }
        }
        border.color: "#475569"
        border.width: 1
    }

    // 4. 3D HARDWARE-ACCELERATED AGITATOR IMPELLER
    View3D {
        id: impeller3DView
        z: 1
        anchors.top: parent.top
        anchors.topMargin: 116
        anchors.horizontalCenter: parent.horizontalCenter
        width: 254
        height: 295

        environment: SceneEnvironment {
            backgroundMode: SceneEnvironment.Transparent
            antialiasingMode: SceneEnvironment.MSAA
            antialiasingQuality: SceneEnvironment.High
        }

        // Orthographic Camera (CAD 1:1 Parallel Perspective)
        OrthographicCamera {
            id: camera
            position: Qt.vector3d(0, 500, 2000)
            horizontalMagnification: 0.192
            verticalMagnification: 0.192
            clipNear: 10
            clipFar: 5000
        }

        // 1. Frontal Headlight: Subtle fill without washing out
        DirectionalLight {
            eulerRotation.x: 0
            eulerRotation.y: 0
            brightness: 1.5
            color: "#ffffff"
        }

        // 2. Key Light: Top-Right Metallic Glint
        DirectionalLight {
            eulerRotation.x: -25
            eulerRotation.y: 35
            brightness: 1.8
            color: "#ffffff"
        }

        // 3. Fill Light: Soft Front-Left Cool Accent
        DirectionalLight {
            eulerRotation.x: 18
            eulerRotation.y: -42
            brightness: 1.3
            color: "#e2e8f0"
        }

        // 4. Rim Light Right: Crisp Metallic Blade Contours
        DirectionalLight {
            eulerRotation.x: 25
            eulerRotation.y: 135
            brightness: 1.6
            color: "#ffffff"
        }

        // 5. Rim Light Left: Rear Blade Outer Highlights
        DirectionalLight {
            eulerRotation.x: -25
            eulerRotation.y: -135
            brightness: 1.4
            color: "#cbd5e1"
        }

        // 6. Top-Down Light: Upper Hub & Flange Reflections
        DirectionalLight {
            eulerRotation.x: -80
            eulerRotation.y: 0
            brightness: 1.3
            color: "#ffffff"
        }

        // 7. Bottom Uplight: Lower Scraper & Dish Wiper Highlights
        DirectionalLight {
            eulerRotation.x: 60
            eulerRotation.y: 0
            brightness: 1.1
            color: "#e2e8f0"
        }

        Node {
            id: agitatorNode
            eulerRotation.y: agitatorRoot.currentAngle

            Assets3D.Agitator {
                id: agitator3D
            }
        }
    }
}
