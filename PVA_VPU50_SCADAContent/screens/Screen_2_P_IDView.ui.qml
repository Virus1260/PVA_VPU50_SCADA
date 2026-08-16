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
    property alias pipingLayer: pipingLayer
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
    property alias vK143002: vK143002
    property alias vK143001: vK143001
    property alias vK163002: vK163002
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
        width: 1180
        height: 680
        scale: pidViewRoot.worldScale
        x: pidViewRoot.worldX
        y: pidViewRoot.worldY
        transformOrigin: Item.TopLeft

        // ---------------------------------------------------------------------
        // 1. UNIFIED DEDICATED PIPING LAYER (z: 5 - Pixel-Perfect Straight Sets)
        // ---------------------------------------------------------------------
        PidPipingLayer {
            id: pipingLayer
            z: 5
            anchors.fill: parent
        }

        // ---------------------------------------------------------------------
        // 2. MAIN PROCESS VESSEL, JACKET, AGITATOR & HEATING (z: 1, z: 2, z: 3)
        // ---------------------------------------------------------------------
        PidVessel {
            id: mainVessel
            x: 358
            y: 75
            z: 2
            vesselName: "Unimix 50"
            showTags: pidViewRoot.showTags
        }

        PidHeatingEffect {
            id: heatingEffect
            anchors.fill: mainVessel
            z: 2
            opacity: 0.85
        }

        PidAgitator {
            id: agitator
            anchors.horizontalCenter: mainVessel.horizontalCenter
            anchors.top: mainVessel.top
            anchors.topMargin: -69
            z: 3
            showTags: pidViewRoot.showTags
        }

        // ---------------------------------------------------------------------
        // 3. TOP CIP CLEANING SPRAY BALLS & LEVEL GAUGE (z: 9, z: 10)
        // ---------------------------------------------------------------------
        PidSprayBall { id: sprayBall1; z: 10; x: 429; y: 155; tag: "X 165 501"; showTags: pidViewRoot.showTags }
        PidSprayBall { id: sprayBall2; z: 10; x: 532; y: 155; tag: "X 165 502"; showTags: pidViewRoot.showTags }
        PidSprayBall { id: sprayBall3; z: 10; x: 617; y: 155; tag: "X 165 503"; sprayAngle: -35; showTags: pidViewRoot.showTags }

        PidLevelGauge {
            id: levelGauge
            z: 9
            x: 596
            y: 238
            showTags: pidViewRoot.showTags
        }

        // ---------------------------------------------------------------------
        // 4. LEFT UTILITY APPARATUS: PUMP, INLINE HEATER & VALVES (z: 6, z: 7)
        // ---------------------------------------------------------------------
        PidCirculationPump { id: circPump1; z: 7; x: 100; y: 456; tag: "P 168 001"; showTags: pidViewRoot.showTags }
        PidInlineHeater { id: inlineHeater; z: 7; x: 145; y: 458; tag: "W 168 001"; showTags: pidViewRoot.showTags }

        PidValve { id: vK168201; z: 7; x: 46; y: 535; tag: "K 168 201"; isVertical: true; valveType: "diaphragm"; showTags: pidViewRoot.showTags }
        PidValve { id: vK168202; z: 7; x: 106; y: 535; tag: "K 168 202"; isVertical: true; valveType: "diaphragm"; showTags: pidViewRoot.showTags }
        PidValve { id: vK168204; z: 7; x: 70; y: 466; tag: "K 168 204"; valveType: "diaphragm"; showTags: pidViewRoot.showTags }

        // Jacket Nozzle Flanges
        Rectangle { z: 6; x: 402; y: 316; width: 6; height: 8; color: "#1e293b"; border.color: "#ef4444"; border.width: 1 }
        Rectangle { z: 6; x: 402; y: 206; width: 6; height: 8; color: "#1e293b"; border.color: "#3b82f6"; border.width: 1 }

        // ---------------------------------------------------------------------
        // 5. MECHANICAL SEAL COOLING & SEAL POT BUFFER TANK (z: 7)
        // ---------------------------------------------------------------------
        PidSealPot {
            id: sealPot
            z: 7
            x: 675
            y: 430
            tag: "B 171 001"
            tempTag: "TI 171 001"
            showTags: pidViewRoot.showTags
        }

        // ---------------------------------------------------------------------
        // 6. BOTTOM HOMOGENIZER ASSEMBLY & SUCTION/STATOR VALVES (z: 6, z: 7)
        // ---------------------------------------------------------------------
        PidHomogenizer {
            id: bottomHomog
            x: 320
            y: 458
            z: 6
            showTags: pidViewRoot.showTags
        }

        // Left Suction Butterfly Valves
        PidValve { id: vK143002; z: 7; x: 472; y: 486; tag: "K 143 002"; subLabel: "Solids"; valveType: "butterfly"; showTags: pidViewRoot.showTags }
        PidValve { id: vK143001; z: 7; x: 472; y: 522; tag: "K 143 001"; subLabel: "Liquids"; valveType: "butterfly"; showTags: pidViewRoot.showTags }

        // Right Recirculation Outlet Butterfly Valve
        PidValve { id: vK163002; z: 7; x: 610; y: 493; tag: "K 163 002"; valveType: "butterfly"; showTags: pidViewRoot.showTags }

        // ---------------------------------------------------------------------
        // 7. RECIRCULATION LOOP RISER VALVES (z: 7)
        // ---------------------------------------------------------------------
        PidValve { id: vK165002; z: 7; x: 826; y: 493; tag: "K 165 002"; valveType: "butterfly"; isVertical: true; showTags: pidViewRoot.showTags }
        PidValve { id: vK165003; z: 7; x: 745; y: 191; tag: "K 165 003"; valveType: "butterfly"; showTags: pidViewRoot.showTags }

        // ---------------------------------------------------------------------
        // 8. LID LIFTER MECHANICAL DRIVE MOTOR (z: 8)
        // ---------------------------------------------------------------------
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
