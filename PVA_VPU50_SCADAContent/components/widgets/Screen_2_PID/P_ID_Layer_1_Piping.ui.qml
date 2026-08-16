
/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML.
*/
import QtQuick

Item {
    id: pipingLayerRoot
    width: 1440
    height: 840

    // Dynamic Flow State Flags (Exposed for Live SCADA State Simulation)
    property bool isRecirculating: false
    property bool isHeating: false
    property bool isCooling: false
    property bool isSprayingCIP: false
    property bool isSuctionSolids: false
    property bool isSuctionLiquids: false
    property bool isHomogRunning: false

    // =========================================================================
    // SET 1: TOP CIP SPRAY MANIFOLD & VERTICAL DROPS (Yellow #eab308)
    // =========================================================================
    Item {
        id: setUpperCIPManifold
        z: 2

        // Top Main CIP Feed Header

        // Spray Ball 1 Vertical Drop (Left)
        PidPipe {
            id: pipeSpray1Drop
            x: 733
            y: 42
            startX: 527
            startY: 30
            endX: 527
            endY: 190
            baseColor: "#00d2ff"
            flowColor: "#4ade80"
            isActive: pipingLayerRoot.isSprayingCIP
            section: "Spray 1 Drop"
        }

        // Spray Ball 2 Vertical Drop (Middle)
        PidPipe {
            id: pipeSpray2Drop
            x: 863
            y: 45
            width: 5
            height: 157
            startX: 657
            startY: 30
            endX: 657
            endY: 190
            baseColor: "#00d2ff"
            flowColor: "#4ade80"
            isActive: pipingLayerRoot.isSprayingCIP
            section: "Spray 2 Drop"
        }

        PidPipe {
            id: pipeSpray2Drop1
            x: 902
            y: 45
            width: 5
            height: 157
            startY: 30
            startX: 657
            section: "Spray 2 Drop"
            isActive: pipingLayerRoot.isSprayingCIP
            flowColor: "#4ade80"
            endY: 190
            endX: 657
            baseColor: "#00d2ff"
        }

        PidPipe {
            id: pipeSpray2Drop2
            x: 1160
            y: 41
            width: 5
            height: 162
            startY: 30
            startX: 657
            section: "Spray 2 Drop"
            isActive: pipingLayerRoot.isSprayingCIP
            flowColor: "#4ade80"
            endY: 190
            endX: 657
            baseColor: "#00d2ff"
        }

        PidPipe {
            id: pipeCipHeader1
            x: 733
            y: 41
            width: 428
            height: 5
            startY: 30
            startX: 280
            section: "CIP Main Header"
            isActive: pipingLayerRoot.isSprayingCIP
            flowColor: "#4ade80"
            endY: 30
            endX: 715
            baseColor: "#00d2ff"
        }

        // Spray Ball 3 Vertical Drop & Angled Dogleg (Right)
    }

    // =========================================================================
    // SET 2: LEFT UTILITY MANIFOLD, CIRCULATION PUMP & JACKET CIRCUITS
    // =========================================================================
    Item {
        id: setJacketUtilityPipes
        z: 2

        // Vertical Green Supply Header (HW) - Spacious Left Position at x=140
        PidPipe {
            id: pipeGreenHeader
            x: 74
            y: 635
            width: 5
            height: 179
            startX: 140
            startY: 480
            endX: 140
            endY: 700
            baseColor: "#22c55e"
            section: "Green Utility Header"
        }

        // Vertical Blue CW Return Header - Spacious Left Position at x=200

        // Horizontal Bridge Valve Line
        PidPipe {
            id: pipeBridgeLine
            x: 75
            y: 635
            width: 94
            height: 5
            startX: 140
            startY: 480
            endX: 260
            endY: 480
            baseColor: "#3b82f6"
            flowColor: "#ef4444"
            isActive: pipingLayerRoot.isHeating
            section: "Bridge Valve Line"
        }

        // Hot Water Supply Riser (from Inline Heater up to lower jacket nozzle at y=320)
        PidPipe {
            id: pipeJacketSupplyRiser
            x: 194
            y: 318
            width: 5
            height: 160
            startX: 260
            startY: 480
            endX: 260
            endY: 320
            baseColor: "#ef4444"
            flowColor: "#f97316"
            flowDirection: "reverse"
            isActive: pipingLayerRoot.isHeating
            section: "Jacket Supply Riser"
        }
        PidPipe {
            id: pipeJacketSupplyInlet
            x: 194
            y: 318
            width: 486
            height: 5
            startX: 260
            startY: 320
            endX: 488
            endY: 320
            baseColor: "#ef4444"
            flowColor: "#f97316"
            isActive: pipingLayerRoot.isHeating
            section: "Jacket Lower Nozzle"
        }

        // Cold Water Return (from upper jacket nozzle at y=210 left to blue header)
        PidPipe {
            id: pipeJacketReturnOutlet
            x: 74
            y: 296
            width: 606
            height: 5
            startX: 488
            startY: 210
            endX: 200
            endY: 210
            baseColor: "#3b82f6"
            flowColor: "#38bdf8"
            flowDirection: "reverse"
            isActive: pipingLayerRoot.isCooling || pipingLayerRoot.isHeating
            section: "Jacket Upper Return"
        }
    }

    // =========================================================================
    // SET 3: SUCTION & CHARGING LINES (Powder Funnel & Liquids Port -> Homogenizer)
    // =========================================================================
    Item {
        id: setSuctionPipes
        z: 2

        // Upper Solids Charging Line (through Butterfly Valve K 143 002)
        PidPipe {
            id: pipeSuctionSolids
            x: 658
            y: 544
            width: 154
            height: 5
            startX: 542
            startY: 500
            endX: 600
            endY: 500
            baseColor: "#52a5ec"
            flowColor: "#38ef7d"
            isActive: pipingLayerRoot.isSuctionSolids
            section: "Suction Solids"
        }

        // Lower Liquids Charging Line (through Butterfly Valve K 143 001)
        PidPipe {
            id: pipeSuctionLiquids
            x: 658
            y: 580
            width: 154
            height: 5
            startX: 542
            startY: 536
            endX: 600
            endY: 536
            baseColor: "#52a5ec"
            flowColor: "#38ef7d"
            isActive: pipingLayerRoot.isSuctionLiquids
            section: "Suction Liquids"
        }

        PidPipe {
            id: pipeSuctionSolids1
            x: 857
            y: 564
            width: 219
            height: 5
            startY: 500
            startX: 542
            section: "Suction Solids"
            isActive: pipingLayerRoot.isSuctionSolids
            flowColor: "#38ef7d"
            endY: 500
            endX: 600
            baseColor: "#3b82f6"
        }

        PidPipe {
            id: pipeSuctionSolids2
            x: 857
            y: 578
            width: 207
            height: 5
            startY: 500
            startX: 542
            section: "Suction Solids"
            isActive: pipingLayerRoot.isSuctionSolids
            flowColor: "#38ef7d"
            endY: 500
            endX: 600
            baseColor: "#ef4444"
        }
    }

    // =========================================================================
    // SET 4: MECHANICAL SEAL COOLING CIRCUIT (Collar -> Seal Pot B 171 001)
    // =========================================================================
    Item {
        id: setSealCoolingPipes
        z: 2

        // Red Supply Line (Upper Seal Port -> Pot Base at x=295, y=520)
        PidPipe {
            id: pipeSealRedH
            x: 346
            y: 785
            width: 718
            height: 5
            startX: 612
            startY: 560
            endX: 295
            endY: 560
            baseColor: "#ef4444"
            section: "Seal Red H"
        }
        PidPipe {
            id: pipeSealRedV
            x: 346
            y: 750
            startX: 295
            startY: 560
            endX: 295
            endY: 520
            baseColor: "#ef4444"
            section: "Seal Red V"
        }

        // Blue Return Line (Lower Seal Port -> Pot Base at x=305, y=520)
        PidPipe {
            id: pipeSealBlueH
            x: 335
            y: 796
            width: 741
            height: 5
            startX: 620
            startY: 568
            endX: 305
            endY: 568
            baseColor: "#3b82f6"
            section: "Seal Blue H"
        }
        PidPipe {
            id: pipeSealBlueV
            x: 335
            y: 750
            width: 5
            height: 51
            startX: 305
            startY: 568
            endX: 305
            endY: 520
            baseColor: "#3b82f6"
            section: "Seal Blue V"
        }

        PidPipe {
            id: pipeSealBlueV1
            x: 194
            y: 542
            width: 5
            height: 77
            startY: 568
            startX: 305
            section: "Seal Blue V"
            endY: 520
            endX: 305
            baseColor: "#3b82f6"
        }

        PidPipe {
            id: pipeSealBlueV2
            x: 1071
            y: 565
            width: 5
            height: 236
            startY: 568
            startX: 305
            section: "Seal Blue V"
            endY: 520
            endX: 305
            baseColor: "#3b82f6"
        }

        PidPipe {
            id: pipeSealBlueV3
            x: 1059
            y: 579
            width: 5
            height: 211
            startY: 568
            startX: 305
            section: "Seal Blue V"
            endY: 520
            endX: 305
            baseColor: "#ef4444"
        }
    }

    // =========================================================================
    // SET 5: BOTTOM UTILITY HEADERS (Spacious Bottom Clearance at y=700, 710)
    // =========================================================================
    Item {
        id: setBottomUtilityPipes
        z: 2

        // Green HW Header
        PidPipe {
            id: pipeBottomGreenH
            x: 13
            y: 810
            width: 305
            height: 5
            startX: 60
            startY: 700
            endX: 315
            endY: 700
            baseColor: "#22c55e"
            section: "Bottom Green H"
        }

        // Blue CW Header
        PidPipe {
            id: pipeBottomBlueV
            x: 132
            y: 635
            startX: 325
            startY: 520
            endX: 325
            endY: 710
            baseColor: "#3b82f6"
            section: "Bottom Blue V"
        }
        PidPipe {
            id: pipeBottomBlueH
            x: 8
            y: 820
            width: 321
            height: 5
            startX: 60
            startY: 710
            endX: 325
            endY: 710
            baseColor: "#3b82f6"
            section: "Bottom Blue H"
        }

        PidPipe {
            id: pipeBottomBlueH1
            x: 324
            y: 750
            width: 5
            height: 75
            startY: 520
            startX: 325
            section: "Bottom Blue V"
            endY: 710
            endX: 325
            baseColor: "#3b82f6"
        }

        PidPipe {
            id: pipeBottomBlueH2
            x: 74
            y: 297
            width: 5
            height: 339
            startY: 520
            startX: 325
            section: "Jacket Vertical Return Header"
            endY: 710
            endX: 325
            baseColor: "#3b82f6"
            flowColor: "#38bdf8"
            isActive: pipingLayerRoot.isCooling || pipingLayerRoot.isHeating
        }

        PidPipe {
            id: pipeBottomGreenH1
            x: 313
            y: 750
            width: 5
            height: 61
            startY: 520
            startX: 315
            section: "Bottom Green V"
            endY: 700
            endX: 315
            baseColor: "#22c55e"
        }
    }

    // =========================================================================
    // SET 6: RECIRCULATION LOOP & RISER (Homogenizer Stator -> Top Vessel Dome)
    // =========================================================================
    Item {
        id: setRecirculationPipes
        z: 2

        // Stator Discharge Outlet (through Butterfly Valve K 163 002)
        PidPipe {
            id: pipeRecircOutlet
            x: 857
            y: 501
            width: 308
            height: 5
            startX: 680
            startY: 507
            endX: 920
            endY: 507
            baseColor: "#00d2ff"
            flowColor: "#38ef7d"
            isActive: pipingLayerRoot.isRecirculating
                      || pipingLayerRoot.isHomogRunning
            section: "Recirculation Outlet"
        }

        // Vertical Recirculation Riser (through Butterfly Valve K 165 002)
        PidPipe {
            id: pipeRecircRiser
            x: 1160
            y: 203
            width: 5
            height: 299
            startX: 920
            startY: 507
            endX: 920
            endY: 205
            baseColor: "#00d2ff"
            flowColor: "#38ef7d"
            flowDirection: "reverse"
            isActive: pipingLayerRoot.isRecirculating
            section: "Recirculation Riser"
        }

        // Top Return to Vessel Dome (through Butterfly Valve K 165 003)
        PidPipe {
            id: pipeRecircReturn
            x: 965
            y: 203
            width: 196
            height: 5
            startX: 920
            startY: 205
            endX: 760
            endY: 205
            baseColor: "#00d2ff"
            flowColor: "#38ef7d"
            flowDirection: "reverse"
            isActive: pipingLayerRoot.isRecirculating
            section: "Recirculation Return"
        }

        // 45 Degree Diagonal Elbow Drain Pipe
        PidPipe {
            id: pipeRecircDrain45
            x: 1164
            y: 501
            width: 70
            height: 5
            rotation: 45
            transformOrigin: Item.TopLeft
            baseColor: "#00d2ff"
            flowColor: "#38ef7d"
            section: "Recirculation 45 Deg Drain"
        }
    }

    // =========================================================================
    // SET 7: LID LIFTER MECHANICAL SUPPORT ARM & GUIDE
    // =========================================================================
    Item {
        id: setLidLifterPipes
        z: 2

        // Top Support Arm
        PidPipe {
            id: pipeLifterArm
            x: 959
            y: 161
            width: 414
            height: 5
            startX: 760
            startY: 155
            endX: 1000
            endY: 155
            baseColor: "#00d2ff"
            section: "Lifter Arm"
        }

        // Vertical Guide Column
        PidPipe {
            id: pipeLifterColumn
            x: 1368
            y: 161
            width: 5
            height: 439
            startX: 1000
            startY: 120
            endX: 1000
            endY: 600
            baseColor: "#00d2ff"
            section: "Lifter Column"
        }
    }
}
