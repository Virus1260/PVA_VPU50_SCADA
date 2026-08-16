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
    property alias sprayBall1: sprayBall1
    property alias sprayBall2: sprayBall2
    property alias sprayBall3: sprayBall3
    property alias circPump1: circPump1
    property alias inlineHeater: inlineHeater
    property alias sealPot: sealPot
    property alias vK168201: vK168201
    property alias vK168202: vK168202
    property alias vK168204: vK168204
    property alias vK165002: vK165002
    property alias vK165003: vK165003

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
        // 3. TOP CIP CLEANING DISTRIBUTION ARCH & 3 SPRAY BALLS (z: 8, z: 10 - Yellow)
        // ---------------------------------------------------------------------
        // Top CIP Horizontal Supply Header
        PidPipe { z: 8; startX: 200; startY: 15; endX: 635; endY: 15; baseColor: "#eab308" }

        // Spray Ball 1 Vertical Drop Pipe (Left)
        PidPipe { z: 8; startX: 447; startY: 15; endX: 447; endY: 190; baseColor: "#eab308" }

        // Spray Ball 2 Vertical Drop Pipe (Middle)
        PidPipe { z: 8; startX: 577; startY: 15; endX: 577; endY: 190; baseColor: "#eab308" }

        // Spray Ball 3 Vertical Drop Pipe (Right Angled)
        PidPipe { z: 8; startX: 635; startY: 15; endX: 635; endY: 172; baseColor: "#eab308" }
        PidPipe { z: 8; startX: 635; startY: 172; endX: 642; endY: 190; baseColor: "#eab308" }

        // 3 Modular Spray Balls inside Dome
        PidSprayBall { id: sprayBall1; z: 10; x: 429; y: 190; tag: "X 165 501"; showTags: pidViewRoot.showTags }
        PidSprayBall { id: sprayBall2; z: 10; x: 559; y: 190; tag: "X 165 502"; showTags: pidViewRoot.showTags }
        PidSprayBall { id: sprayBall3; z: 10; x: 625; y: 184; tag: "X 165 503"; sprayAngle: -35; showTags: pidViewRoot.showTags }

        // Dedicated Elevated Level Gauge inside Dome (z: 9)
        PidLevelGauge {
            id: levelGauge
            z: 9
            x: 596
            y: 238
            showTags: pidViewRoot.showTags
        }

        // ---------------------------------------------------------------------
        // 4. LEFT-SIDE UTILITY MANIFOLD, CIRCULATION PUMP & INLINE HEATER (z: 5, z: 6, z: 7)
        // ---------------------------------------------------------------------
        // Vertical Green Header & Blue CW Return Line with Diaphragm Isolation Valves
        PidPipe { z: 5; startX: 60; startY: 480; endX: 60; endY: 615; baseColor: "#22c55e" }
        PidValve { id: vK168201; z: 6; x: 46; y: 535; tag: "K 168 201"; isVertical: true; valveType: "diaphragm"; showTags: pidViewRoot.showTags }

        PidPipe { z: 5; startX: 120; startY: 210; endX: 120; endY: 625; baseColor: "#3b82f6" }
        PidValve { id: vK168202; z: 6; x: 106; y: 535; tag: "K 168 202"; isVertical: true; valveType: "diaphragm"; showTags: pidViewRoot.showTags }

        // Horizontal Bridge Valve
        PidPipe { z: 5; startX: 60; startY: 480; endX: 180; endY: 480; baseColor: "#22c55e" }
        PidValve { id: vK168204; z: 6; x: 70; y: 468; tag: "K 168 204"; valveType: "diaphragm"; showTags: pidViewRoot.showTags }

        // Dedicated Modular Inline Circulation Pump (P 168 001)
        PidCirculationPump {
            id: circPump1
            z: 7
            x: 100
            y: 456
            tag: "P 168 001"
            showTags: pidViewRoot.showTags
        }

        // Dedicated Modular Inline Heater (W 168 001)
        PidInlineHeater {
            id: inlineHeater
            z: 7
            x: 145
            y: 458
            tag: "W 168 001"
            showTags: pidViewRoot.showTags
        }

        // Hot Water Red Supply Pipe (from Inline Heater up to lower jacket nozzle at y=320)
        Rectangle { z: 6; x: 402; y: 316; width: 6; height: 8; color: "#1e293b"; border.color: "#ef4444"; border.width: 1 }
        PidPipe { id: pipeJacketSupply1; z: 5; startX: 180; startY: 480; endX: 180; endY: 320; baseColor: "#ef4444" }
        PidPipe { id: pipeJacketSupply2; z: 5; startX: 180; startY: 320; endX: 408; endY: 320; baseColor: "#ef4444" }

        // Cold Water Blue Return Pipe (from upper jacket nozzle at y=210 left to blue header)
        Rectangle { z: 6; x: 402; y: 206; width: 6; height: 8; color: "#1e293b"; border.color: "#3b82f6"; border.width: 1 }
        PidPipe { id: pipeJacketReturn1; z: 5; startX: 408; startY: 210; endX: 120; endY: 210; baseColor: "#3b82f6" }

        // ---------------------------------------------------------------------
        // 5. MECHANICAL SEAL COOLING CIRCUIT & SEAL POT BUFFER TANK (z: 6, z: 7)
        // ---------------------------------------------------------------------
        // Homogenizer Seal Cooling Lines (Red & Blue from collar to Seal Pot)
        PidPipe { z: 5; startX: 532; startY: 530; endX: 532; endY: 560; baseColor: "#ef4444" }
        PidPipe { z: 5; startX: 532; startY: 560; endX: 685; endY: 560; baseColor: "#ef4444" }
        PidPipe { z: 5; startX: 685; startY: 560; endX: 685; endY: 520; baseColor: "#ef4444" }

        PidPipe { z: 5; startX: 540; startY: 538; endX: 540; endY: 568; baseColor: "#3b82f6" }
        PidPipe { z: 5; startX: 540; startY: 568; endX: 695; endY: 568; baseColor: "#3b82f6" }
        PidPipe { z: 5; startX: 695; startY: 568; endX: 695; endY: 520; baseColor: "#3b82f6" }

        // Dedicated Modular Seal Pot (B 171 001)
        PidSealPot {
            id: sealPot
            z: 7
            x: 675
            y: 430
            tag: "B 171 001"
            tempTag: "TI 171 001"
            showTags: pidViewRoot.showTags
        }

        // Seal Pot Bottom Utility Headers (Green HW Line & Blue CW Line)
        PidPipe { z: 5; startX: 705; startY: 520; endX: 705; endY: 615; baseColor: "#22c55e" }
        PidPipe { z: 5; startX: 20; startY: 615; endX: 705; endY: 615; baseColor: "#22c55e" }

        PidPipe { z: 5; startX: 715; startY: 520; endX: 715; endY: 625; baseColor: "#3b82f6" }
        PidPipe { z: 5; startX: 20; startY: 625; endX: 715; endY: 625; baseColor: "#3b82f6" }

        // ---------------------------------------------------------------------
        // 6. BOTTOM HOMOGENIZER (z: 6, z: 7)
        // ---------------------------------------------------------------------
        PidHomogenizer {
            id: bottomHomog
            x: 320
            y: 458
            z: 6
            showTags: pidViewRoot.showTags
        }

        // ---------------------------------------------------------------------
        // 7. RECIRCULATION LOOP & RISER (z: 6, z: 7, z: 8 - Cyan)
        // ---------------------------------------------------------------------
        PidPipe {
            id: pipeRecirc1
            z: 6
            startX: 600
            startY: 507
            endX: 840
            endY: 507
            baseColor: "#00d2ff"
        }
        PidPipe {
            id: pipeRecirc2
            z: 6
            startX: 840
            startY: 507
            endX: 840
            endY: 205
            baseColor: "#00d2ff"
            reverseFlow: true
        }
        PidPipe {
            id: pipeRecirc3
            z: 6
            startX: 840
            startY: 205
            endX: 680
            endY: 205
            baseColor: "#00d2ff"
        }

        // Recirculation Butterfly Valves
        PidValve { id: vK165002; z: 7; x: 830; y: 495; tag: "K 165 002"; valveType: "butterfly"; isVertical: true; showTags: pidViewRoot.showTags }
        PidValve { id: vK165003; z: 7; x: 745; y: 191; tag: "K 165 003"; valveType: "butterfly"; showTags: pidViewRoot.showTags }

        // ---------------------------------------------------------------------
        // 8. LID LIFTER MECHANICAL SUPPORT & MOTOR (z: 6, z: 8)
        // ---------------------------------------------------------------------
        // Top Support Arm
        PidPipe { z: 5; startX: 680; startY: 155; endX: 920; endY: 155; baseColor: "#00d2ff" }

        // Vertical Guide Column
        PidPipe { z: 5; startX: 920; startY: 120; endX: 920; endY: 560; baseColor: "#00d2ff" }

        // Bottom Lifter Drive Motor (M)
        Rectangle {
            z: 8
            x: 906
            y: 560
            width: 28
            height: 28
            radius: 4
            color: "#08213b"
            border.color: "#38bdf8"
            border.width: 1.4

            Rectangle {
                anchors.centerIn: parent
                width: 18
                height: 18
                radius: 9
                color: "#22c55e"

                Text {
                    anchors.centerIn: parent
                    text: "M"
                    color: "#000000"
                    font.bold: true
                    font.pixelSize: 10
                }
            }
        }
    }
}
