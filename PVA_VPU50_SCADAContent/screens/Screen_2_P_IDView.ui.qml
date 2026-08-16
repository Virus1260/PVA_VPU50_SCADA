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
    width: 1180
    height: 680
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
    property alias electricHeater: electricHeater
    property alias circPump1: circPump1

    // =========================================================================
    // ZOOMABLE & PANNABLE WORLD CANVAS (Interactive in Qt Design Studio Canvas)
    // =========================================================================
    Item {
        id: worldContainer
        x: pidViewRoot.worldX
        y: pidViewRoot.worldY
        width: 1180
        height: 680
        scale: pidViewRoot.worldScale
        transformOrigin: Item.TopLeft

        // ---------------------------------------------------------------------
        // 1. HERO PROCESS VESSEL (UNIMIX 50) - BACKGROUND LAYER (z: 1)
        // ---------------------------------------------------------------------
        PidVessel {
            id: mainVessel
            x: 370
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
            anchors.horizontalCenter: mainVessel.horizontalCenter
            anchors.top: mainVessel.top
            anchors.topMargin: -69
            z: 3
            showTags: pidViewRoot.showTags
        }

        // ---------------------------------------------------------------------
        // 3. TOP-LEFT FLOATING SCADA PID TELEMETRY BOX (z: 12 - Clean Space)
        // ---------------------------------------------------------------------
        PidControlBox {
            id: controlBox
            x: 20
            y: 65
            z: 12
            visible: pidViewRoot.showTags
        }

        // ---------------------------------------------------------------------
        // 4. LEFT-SIDE UTILITY MANIFOLD GRID & THERMAL JACKET LOOPS (z: 5, z: 6, z: 7)
        // ---------------------------------------------------------------------
        Text { z: 9; visible: pidViewRoot.showTags; x: 16; y: 246; text: "CW IN"; color: "#8cb5dc"; font.pixelSize: 8; font.bold: true }
        Text { z: 9; visible: pidViewRoot.showTags; x: 16; y: 306; text: "CW OUT"; color: "#8cb5dc"; font.pixelSize: 8; font.bold: true }
        Text { z: 9; visible: pidViewRoot.showTags; x: 16; y: 366; text: "HW IN"; color: "#8cb5dc"; font.pixelSize: 8; font.bold: true }
        Text { z: 9; visible: pidViewRoot.showTags; x: 16; y: 436; text: "HW OUT"; color: "#8cb5dc"; font.pixelSize: 8; font.bold: true }

        // Vertical Manifold Utility Headers (Green HW Line & Blue CW Line)
        PidPipe { z: 5; startX: 60; startY: 240; endX: 60; endY: 620; baseColor: "#22c55e" }
        PidPipe { z: 5; startX: 130; startY: 210; endX: 130; endY: 630; baseColor: "#3b82f6" }

        // Left Isolation Valves
        PidValve { id: vK168201; z: 6; x: 47; y: 245; tag: "K 168 201"; showTags: pidViewRoot.showTags }
        PidValve { id: vK168202; z: 6; x: 117; y: 245; tag: "K 168 202"; showTags: pidViewRoot.showTags }
        PidValve { id: vK168204; z: 6; x: 47; y: 305; tag: "K 168 204"; showTags: pidViewRoot.showTags }
        PidValve { id: vK168206; z: 6; x: 117; y: 305; tag: "K 168 206"; showTags: pidViewRoot.showTags }
        PidValve { id: vK168208; z: 6; x: 47; y: 365; tag: "K 168 208"; showTags: pidViewRoot.showTags }
        PidValve { id: vK168205; z: 6; x: 117; y: 365; tag: "K 168 205"; showTags: pidViewRoot.showTags }
        PidValve { id: vK168207; z: 6; x: 47; y: 435; tag: "K 168 207"; showTags: pidViewRoot.showTags }

        // Upper Jacket Blue Return Line (from top-left jacket nozzle at y=210 left to manifold)
        Rectangle { z: 6; x: 402; y: 206; width: 6; height: 8; color: "#1e293b"; border.color: "#3b82f6"; border.width: 1 }
        PidPipe { id: pipeJacketReturn; z: 5; startX: 408; startY: 210; endX: 130; endY: 210; baseColor: "#3b82f6" }

        // Lower Jacket Red Supply Line (from lower-left jacket nozzle at y=320 to circulation pump)
        Rectangle { z: 6; x: 402; y: 316; width: 6; height: 8; color: "#1e293b"; border.color: "#ef4444"; border.width: 1 }
        PidPipe { id: pipeJacketSupply1; z: 5; startX: 408; startY: 320; endX: 60; endY: 320; baseColor: "#ef4444" }
        PidPipe { id: pipeJacketSupply2; z: 5; startX: 60; startY: 320; endX: 60; endY: 410; baseColor: "#ef4444" }
        PidPipe { id: pipeJacketSupply3; z: 5; startX: 60; startY: 410; endX: 98; endY: 410; baseColor: "#ef4444" }
        PidPipe { id: pipeJacketSupply4; z: 5; startX: 98; startY: 410; endX: 98; endY: 460; baseColor: "#ef4444" }

        // Dedicated Modular Inline Circulation Pump (P 168 001)
        PidCirculationPump {
            id: circPump1
            z: 7
            x: 80
            y: 460
            tag: "P 168 001"
            showTags: pidViewRoot.showTags
        }

        // ---------------------------------------------------------------------
        // 5. BOTTOM-LEFT MODULAR ELECTRIC HEATER UNIT (W 171 001) (z: 7)
        // ---------------------------------------------------------------------
        PidElectricHeater {
            id: electricHeater
            z: 7
            x: 195
            y: 440
            tag: "W 171 001"
            tempTag: "TI 171 001"
            showTags: pidViewRoot.showTags
        }

        // Jacket Temperature Sensor Callout (TIC 163 001)
        Rectangle {
            z: 8
            x: 290
            y: 420
            width: 58
            height: 24
            radius: 3
            color: "#08213b"
            border.color: "#38bdf8"
            border.width: 1
            Column {
                anchors.centerIn: parent
                Text { text: "TIC 163 001"; color: "#8cb5dc"; font.pixelSize: 7; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter }
                Text { text: "35.8 °C"; color: "#ffffff"; font.pixelSize: 8; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter }
            }
        }
        PidPipe { z: 7; startX: 348; startY: 432; endX: 408; endY: 432; baseColor: "#38bdf8" }

        // Pump Cross-Connect Valve (K 172 002)
        PidValve { id: vK172002; z: 6; x: 295; y: 495; tag: "K 172 002"; showTags: pidViewRoot.showTags }
        PidPipe { z: 5; startX: 263; startY: 507; endX: 410; endY: 507; baseColor: "#1b538c" }

        // Homogenizer Seal Mechanical Cooling Circuit (Red & Blue Lines to Left-Bottom Heater)
        PidPipe { z: 5; startX: 532; startY: 530; endX: 250; endY: 530; baseColor: "#ef4444" }
        PidPipe { z: 5; startX: 250; startY: 530; endX: 250; endY: 525; baseColor: "#ef4444" }

        PidPipe { z: 5; startX: 532; startY: 538; endX: 240; endY: 538; baseColor: "#3b82f6" }
        PidPipe { z: 5; startX: 240; startY: 538; endX: 240; endY: 525; baseColor: "#3b82f6" }

        // Bottom Full-Span Utility Headers (Green HW Line & Blue CW Line)
        PidPipe { z: 5; startX: 220; startY: 525; endX: 220; endY: 620; baseColor: "#22c55e" }
        PidPipe { z: 5; startX: 20; startY: 620; endX: 680; endY: 620; baseColor: "#22c55e" }

        PidPipe { z: 5; startX: 210; startY: 525; endX: 210; endY: 630; baseColor: "#3b82f6" }
        PidPipe { z: 5; startX: 20; startY: 630; endX: 680; endY: 630; baseColor: "#3b82f6" }

        // ---------------------------------------------------------------------
        // 6. GAS INLET & RELIEF LINES (z: 8)
        // ---------------------------------------------------------------------
        PidPipe { z: 8; startX: 20; startY: 180; endX: 300; endY: 180; baseColor: "#1b538c" }
        PidPipe { z: 8; startX: 300; startY: 180; endX: 300; endY: 125; baseColor: "#1b538c" }
        PidPipe { z: 8; startX: 300; startY: 125; endX: 440; endY: 125; baseColor: "#1b538c" }
        Text { z: 9; visible: pidViewRoot.showTags; x: 25; y: 164; text: "gas inlet"; color: "#8cb5dc"; font.pixelSize: 8 }
        PidValve { id: vK166002; z: 9; x: 287; y: 166; tag: "K 166 002"; showTags: pidViewRoot.showTags }

        // Top Left Dome Relief Vent Column
        Rectangle {
            z: 8
            x: 415
            y: 110
            width: 12
            height: 24
            radius: 3
            color: "#8ec4f0"
            border.color: "#1b4c7c"
            border.width: 1.2
        }
        PidPipe { z: 8; startX: 421; startY: 15; endX: 421; endY: 110; baseColor: "#52a5ec" }

        // ---------------------------------------------------------------------
        // 7. TOP CIP CLEANING HIGH ARCH HEADER & SPRAY BALLS (z: 8, z: 10)
        // ---------------------------------------------------------------------
        PidPipe { z: 8; startX: 240; startY: 15; endX: 625; endY: 15; baseColor: "#52a5ec" }
        PidPipe { z: 8; startX: 240; startY: 15; endX: 240; endY: 125; baseColor: "#52a5ec" }

        // Spray Ball 1 Vertical Drop Pipe (Left)
        PidPipe { z: 8; startX: 465; startY: 15; endX: 465; endY: 190; baseColor: "#52a5ec" }

        // Spray Ball 2 Vertical Drop Pipe (Middle-Right)
        PidPipe { z: 8; startX: 595; startY: 15; endX: 595; endY: 190; baseColor: "#52a5ec" }

        // Spray Ball 3 Seamless Continuous Dogleg Drop Pipe (Far-Right Angled)
        PidPipe { z: 8; startX: 625; startY: 15; endX: 625; endY: 172; baseColor: "#52a5ec" }
        PidPipe { z: 8; startX: 625; startY: 172; endX: 634; endY: 190; baseColor: "#52a5ec" }

        // 3 Dedicated Modular Spray Balls in Top Dome (z: 10 - Elevated over Agitator)
        PidSprayBall {
            id: sprayBall1
            z: 10
            x: 447
            y: 190
            tag: "X 165 501"
            showTags: pidViewRoot.showTags
        }
        PidSprayBall {
            id: sprayBall2
            z: 10
            x: 577
            y: 190
            tag: "X 165 502"
            showTags: pidViewRoot.showTags
        }
        PidSprayBall {
            id: sprayBall3
            z: 10
            x: 619
            y: 184
            width: 35
            height: 48
            tag: "X 165 503"
            sprayAngle: -35
            showTags: pidViewRoot.showTags
        }

        // ---------------------------------------------------------------------
        // 8. DEDICATED ELEVATED LEVEL GAUGE (z: 9 - Elevated over Agitator)
        // ---------------------------------------------------------------------
        PidLevelGauge {
            id: levelGauge
            z: 9
            x: 596
            y: 238
            showTags: pidViewRoot.showTags
        }

        // ---------------------------------------------------------------------
        // 9. SOLIDS HOPPER, INLET VALVES & LID LIFTER BRACKET (z: 7, z: 8, z: 9)
        // ---------------------------------------------------------------------
        PidHopper {
            id: solidsHopper
            z: 8
            x: 688
            y: 25
        }
        Text {
            z: 9
            visible: pidViewRoot.showTags
            x: 718
            y: 28
            text: "B 141 001"
            color: "#8cb5dc"
            font.pixelSize: 8
            font.bold: true
        }
        PidPipe {
            z: 8
            startX: 700
            startY: 46
            endX: 700
            endY: 135
            baseColor: "#52a5ec"
        }
        PidValve {
            id: vK141001
            z: 9
            x: 687
            y: 80
            tag: "K 141 001"
            showTags: pidViewRoot.showTags
        }

        // Hopper Purge Line
        PidPipe {
            z: 8
            startX: 700
            startY: 135
            endX: 790
            endY: 135
            baseColor: "#52a5ec"
        }
        PidValve {
            id: vK161001
            z: 9
            x: 740
            y: 121
            tag: "K 161 001"
            showTags: pidViewRoot.showTags
        }

        // Horizontal Lid Lifter Bracket Hinge Bar
        Rectangle {
            z: 7
            x: 710
            y: 155
            width: 175
            height: 7
            radius: 2
            color: "#334155"
            border.color: "#475569"
            border.width: 1
        }

        // ---------------------------------------------------------------------
        // 10. BOTTOM HOMOGENIZER & SUCTION BRANCH (z: 6, z: 7)
        // ---------------------------------------------------------------------
        PidHomogenizer {
            id: bottomHomog
            x: 320
            y: 458
            z: 6
            showTags: pidViewRoot.showTags
        }

        PidPipe {
            z: 6
            startX: 610
            startY: 438
            endX: 620
            endY: 462
            baseColor: "#52a5ec"
        }
        PidValve {
            id: vV142201
            z: 7
            x: 608
            y: 450
            tag: "V 142 201"
            subLabel: "Suction Bottom"
            showTags: pidViewRoot.showTags
        }

        // Suction Valves (K 143 002 Solids & K 143 001 Liquids)
        PidValve { id: vK143002; z: 7; x: 420; y: 475; tag: "K 143 002"; showTags: pidViewRoot.showTags }
        PidValve { id: vK143001; z: 7; x: 420; y: 520; tag: "K 143 001"; showTags: pidViewRoot.showTags }

        // Stator Discharge Valve (K 163 002)
        PidValve { id: vK163002; z: 7; x: 580; y: 495; tag: "K 163 002"; showTags: pidViewRoot.showTags }

        // ---------------------------------------------------------------------
        // 11. RECIRCULATION LOOP & RISER (z: 6, z: 7, z: 8 - 100% Free of Overlaps)
        // ---------------------------------------------------------------------
        PidPipe {
            id: pipeRecirc1
            z: 6
            startX: 600
            startY: 507
            endX: 830
            endY: 507
        }
        PidPipe {
            id: pipeRecirc2
            z: 6
            startX: 830
            startY: 507
            endX: 830
            endY: 205
            reverseFlow: true
        }
        PidPipe {
            id: pipeRecirc3
            z: 6
            startX: 830
            startY: 205
            endX: 680
            endY: 205
        }

        PidValve {
            id: vK165002
            z: 7
            x: 820
            y: 495
            tag: "K 165 002"
            showTags: pidViewRoot.showTags
        }
        PidValve {
            id: vK165003
            z: 7
            x: 745
            y: 191
            tag: "K 165 003"
            showTags: pidViewRoot.showTags
        }

        Rectangle {
            id: sensorGos172601
            z: 8
            x: 838
            y: 480
            width: 8
            height: 8
            radius: 4
            color: "#475569"
            Text {
                visible: pidViewRoot.showTags
                x: 12
                y: -2
                text: "GOS 172 601"
                color: "#8cb5dc"
                font.pixelSize: 7
            }
        }

        // ---------------------------------------------------------------------
        // 12. LID LIFTER MOTOR & POSITION SENSORS (z: 6, z: 8)
        // ---------------------------------------------------------------------
        PidLidLifter {
            id: lidLifter
            x: 805
            y: 100
            z: 6
            showTags: pidViewRoot.showTags
        }
    }
}
