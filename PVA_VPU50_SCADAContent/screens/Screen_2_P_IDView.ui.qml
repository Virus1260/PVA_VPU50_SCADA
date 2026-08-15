/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML.
*/

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../components/widgets/Screen_2_PID"

Rectangle {
    id: pidViewRoot
    width: 1060
    height: 630
    color: "#0a2d52"
    clip: true

    // Visual State Properties (Exposed for Qt Design Studio Property Inspector)
    property bool showTags: true
    property real worldScale: 1.0
    property real worldX: 0
    property real worldY: 0

    // Component Aliases for Direct Selection & Editing in Qt Designer
    property alias worldContainer: worldContainer
    property alias mainVessel: mainVessel
    property alias heatingEffect: heatingEffect
    property alias agitator: agitator
    property alias levelGauge: levelGauge
    property alias bottomHomog: bottomHomog
    property alias lidLifter: lidLifter
    property alias controlBox: controlBox
    property alias sprayBall1: sprayBall1
    property alias sprayBall2: sprayBall2
    property alias sprayBall3: sprayBall3

    // =========================================================================
    // ZOOMABLE & PANNABLE WORLD CANVAS (Interactive in Qt Design Studio Canvas)
    // =========================================================================
    Item {
        id: worldContainer
        x: pidViewRoot.worldX
        y: pidViewRoot.worldY
        width: 1060
        height: 630
        scale: pidViewRoot.worldScale
        transformOrigin: Item.TopLeft

        // ---------------------------------------------------------------------
        // 1. HERO PROCESS VESSEL (UNIMIX 50) - BACKGROUND LAYER (z: 1)
        // ---------------------------------------------------------------------
        PidVessel {
            id: mainVessel
            x: 350
            y: 110
            z: 1
            vesselName: "Unimix 50"
            showTags: pidViewRoot.showTags
        }

        // Modular Thermal Jacket Radiant Glow (z: 2)
        PidHeatingEffect {
            id: heatingEffect
            x: mainVessel.x
            y: mainVessel.y
            z: 2
        }

        // ---------------------------------------------------------------------
        // 2. 3D ROTATING AGITATOR & TOP DRIVE MOTOR (z: 3)
        // ---------------------------------------------------------------------
        PidAgitator {
            id: agitator
            x: 390
            y: 41
            anchors.horizontalCenter: mainVessel.horizontalCenter
            anchors.top: mainVessel.top
            anchors.topMargin: -70
            z: 3
            showTags: pidViewRoot.showTags
        }

        // ---------------------------------------------------------------------
        // 3. LEFT-SIDE UTILITY MANIFOLD GRID (z: 5, z: 6)
        // ---------------------------------------------------------------------
        Text { z: 9; visible: pidViewRoot.showTags; x: 16; y: 256; text: "CW IN"; color: "#8cb5dc"; font.pixelSize: 8; font.bold: true }
        Text { z: 9; visible: pidViewRoot.showTags; x: 16; y: 316; text: "CW OUT"; color: "#8cb5dc"; font.pixelSize: 8; font.bold: true }
        Text { z: 9; visible: pidViewRoot.showTags; x: 16; y: 370; text: "HW IN"; color: "#8cb5dc"; font.pixelSize: 8; font.bold: true }
        Text { z: 9; visible: pidViewRoot.showTags; x: 16; y: 510; text: "HW OUT"; color: "#8cb5dc"; font.pixelSize: 8; font.bold: true }

        PidPipe { z: 5; startX: 60; startY: 250; endX: 60; endY: 580; baseColor: "#1b538c" }
        PidPipe { z: 5; startX: 130; startY: 250; endX: 130; endY: 580; baseColor: "#1b538c" }

        PidValve { id: vK168201; z: 6; x: 47; y: 260; tag: "K 168 201"; showTags: pidViewRoot.showTags }
        PidValve { id: vK168202; z: 6; x: 117; y: 260; tag: "K 168 202"; showTags: pidViewRoot.showTags }
        PidValve { id: vK168204; z: 6; x: 47; y: 320; tag: "K 168 204"; showTags: pidViewRoot.showTags }
        PidValve { id: vK168206; z: 6; x: 117; y: 320; tag: "K 168 206"; showTags: pidViewRoot.showTags }
        PidValve { id: vK168208; z: 6; x: 47; y: 380; tag: "K 168 208"; showTags: pidViewRoot.showTags }
        PidValve { id: vK168205; z: 6; x: 117; y: 380; tag: "K 168 205"; showTags: pidViewRoot.showTags }
        PidValve { id: vK168207; z: 6; x: 47; y: 460; tag: "K 168 207"; showTags: pidViewRoot.showTags }

        // Live Thermal Jacket Feed / Return Pipes
        PidPipe { id: pipeHwIn1; z: 5; startX: 20; startY: 374; endX: 130; endY: 374; baseColor: "#1b538c" }
        PidPipe { id: pipeHwIn2; z: 5; startX: 130; startY: 374; endX: 385; endY: 374; baseColor: "#1b538c" }
        PidPipe { id: pipeHwOut1; z: 5; startX: 385; startY: 460; endX: 330; endY: 460; baseColor: "#1b538c"; reverseFlow: true }
        PidPipe { id: pipeHwOut2; z: 5; startX: 330; startY: 460; endX: 330; endY: 514; baseColor: "#1b538c"; reverseFlow: true }
        PidPipe { id: pipeHwOut3; z: 5; startX: 330; startY: 514; endX: 20; endY: 514; baseColor: "#1b538c"; reverseFlow: true }
        PidValve { id: vK172002; z: 6; x: 317; y: 500; tag: "K 172 002"; showTags: pidViewRoot.showTags }

        // ---------------------------------------------------------------------
        // 4. GAS INLET & RELIEF LINES (z: 8)
        // ---------------------------------------------------------------------
        PidPipe { z: 8; startX: 20; startY: 180; endX: 300; endY: 180; baseColor: "#1b538c" }
        PidPipe { z: 8; startX: 300; startY: 180; endX: 300; endY: 125; baseColor: "#1b538c" }
        PidPipe { z: 8; startX: 300; startY: 125; endX: 420; endY: 125; baseColor: "#1b538c" }
        Text { z: 9; visible: pidViewRoot.showTags; x: 25; y: 164; text: "gas inlet"; color: "#8cb5dc"; font.pixelSize: 8 }
        PidValve { id: vK166002; z: 9; x: 287; y: 166; tag: "K 166 002"; showTags: pidViewRoot.showTags }

        // Top Left Dome Relief Vent Column
        Rectangle {
            z: 8
            x: 395
            y: 110
            width: 12
            height: 24
            radius: 3
            color: "#8ec4f0"
            border.color: "#1b4c7c"
            border.width: 1.2
        }
        PidPipe { z: 8; startX: 401; startY: 15; endX: 401; endY: 110; baseColor: "#52a5ec" }

        // ---------------------------------------------------------------------
        // 5. TOP CIP CLEANING HIGH ARCH HEADER & SPRAY BALLS (z: 8, z: 10)
        // ---------------------------------------------------------------------
        PidPipe { z: 8; startX: 240; startY: 15; endX: 605; endY: 15; baseColor: "#52a5ec" }
        PidPipe { z: 8; startX: 240; startY: 15; endX: 240; endY: 125; baseColor: "#52a5ec" }

        // Spray Ball 1 Vertical Drop Pipe (Left)
        PidPipe { z: 8; startX: 445; startY: 15; endX: 445; endY: 190; baseColor: "#52a5ec" }

        // Spray Ball 2 Vertical Drop Pipe (Middle-Right)
        PidPipe { z: 8; startX: 575; startY: 15; endX: 575; endY: 190; baseColor: "#52a5ec" }

        // Spray Ball 3 Seamless Continuous Dogleg Drop Pipe (Far-Right Angled)

        // 3 Dedicated Modular Spray Balls in Top Dome (z: 10 - Elevated over Agitator)
        PidSprayBall {
            id: sprayBall1
            z: 10
            x: 427
            y: 190
            tag: "X 165 501"
            showTags: pidViewRoot.showTags
        }
        PidSprayBall {
            id: sprayBall2
            z: 10
            x: 557
            y: 190
            tag: "X 165 502"
            showTags: pidViewRoot.showTags
        }
        PidSprayBall {
            id: sprayBall3
            z: 10
            x: 588
            y: 190
            tag: "X 165 503"
            sprayAngle: -35
            showTags: pidViewRoot.showTags
        }

        // ---------------------------------------------------------------------
        // 6. DEDICATED ELEVATED LEVEL GAUGE (z: 9 - Elevated over Agitator)
        // ---------------------------------------------------------------------
        PidLevelGauge {
            id: levelGauge
            z: 9
            x: 576
            y: 238
            showTags: pidViewRoot.showTags
        }

        // ---------------------------------------------------------------------
        // 7. SOLIDS HOPPER, INLET VALVES & LID LIFTER BRACKET (z: 7, z: 8, z: 9)
        // ---------------------------------------------------------------------
        // Top Solids Charging Hopper / Funnel (B 141 001)
        PidHopper {
            id: solidsHopper
            z: 8
            x: 668
            y: 25
        }
        Text { z: 9; visible: pidViewRoot.showTags; x: 698; y: 28; text: "B 141 001"; color: "#8cb5dc"; font.pixelSize: 8; font.bold: true }
        PidPipe { z: 8; startX: 680; startY: 46; endX: 680; endY: 135; baseColor: "#52a5ec" }
        PidValve { id: vK141001; z: 9; x: 667; y: 65; tag: "K 141 001"; isVertical: true; showTags: pidViewRoot.showTags }

        PidPipe { z: 8; startX: 695; startY: 135; endX: 770; endY: 135; baseColor: "#52a5ec" }
        PidValve { id: vK161001; z: 9; x: 720; y: 121; tag: "K 161 001"; showTags: pidViewRoot.showTags }

        // Horizontal Lid Lifter Bracket Hinge Bar
        Rectangle {
            z: 7
            x: 690
            y: 155
            width: 175
            height: 7
            radius: 2
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#334155" }
                GradientStop { position: 1.0; color: "#0f172a" }
            }
            border.color: "#475569"
            border.width: 1
        }

        // ---------------------------------------------------------------------
        // 8. BOTTOM HOMOGENIZER & SUCTION BRANCH (z: 6, z: 7)
        // ---------------------------------------------------------------------
        PidHomogenizer {
            id: bottomHomog
            x: 300
            y: 458
            z: 6
            showTags: pidViewRoot.showTags
        }

        PidPipe { z: 6; startX: 590; startY: 438; endX: 600; endY: 462; baseColor: "#52a5ec" }
        PidValve {
            id: vV142201
            z: 7
            x: 588
            y: 450
            tag: "V 142 201"
            subLabel: "Suction Bottom"
            showTags: pidViewRoot.showTags
        }

        // ---------------------------------------------------------------------
        // 9. RECIRCULATION LOOP & RISER (z: 6, z: 7, z: 8)
        // ---------------------------------------------------------------------
        PidPipe { id: pipeRecirc1; z: 6; startX: 680; startY: 532; endX: 810; endY: 532 }
        PidPipe { id: pipeRecirc2; z: 6; startX: 810; startY: 532; endX: 810; endY: 205; reverseFlow: true }
        PidPipe { id: pipeRecirc3; z: 6; startX: 810; startY: 205; endX: 660; endY: 205 }

        PidValve { id: vK165002; z: 7; x: 800; y: 520; tag: "K 165 002"; showTags: pidViewRoot.showTags }
        PidValve { id: vK165003; z: 7; x: 725; y: 191; tag: "K 165 003"; showTags: pidViewRoot.showTags }

        Rectangle {
            id: sensorGos172601
            z: 8
            x: 818
            y: 500
            width: 8
            height: 8
            radius: 4
            color: "#475569"
            Text { visible: pidViewRoot.showTags; x: 12; y: -2; text: "GOS 172 601"; color: "#8cb5dc"; font.pixelSize: 7 }
        }

        // ---------------------------------------------------------------------
        // 10. LID LIFTER & CONTROL TELEMETRY BOX (z: 6, z: 15)
        // ---------------------------------------------------------------------
        PidLidLifter {
            id: lidLifter
            x: 785
            y: 100
            z: 6
            showTags: pidViewRoot.showTags
        }

        PidControlBox {
                id: controlBox
                x: 35
                y: 500
                z: 15
                visible: pidViewRoot.showTags
        }

        PidPipe {
                x: 600
                y: 10
                z: 8
                startY: 15
                startX: 575
                endY: 190
                endX: 575
                baseColor: "#52a5ec"
        }
    }
}
