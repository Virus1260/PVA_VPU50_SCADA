/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML.
*/
import QtQuick

Item {
    id: pipingLayerRoot
    width: 1180
    height: 680

    // Dynamic Flow State Flags (Exposed for Live SCADA State Simulation)
    property bool isRecirculating: false
    property bool isHeating: false
    property bool isCooling: false
    property bool isSprayingCIP: false
    property bool isSuctionSolids: false
    property bool isSuctionLiquids: false
    property bool isHomogRunning: false

    // =========================================================================
    // SET 1: SUCTION & CHARGING LINES (Powder Funnel & Liquids Port -> Homogenizer)
    // =========================================================================
    Item {
        id: setSuctionPipes

        // Upper Solids Charging Line (through Butterfly Valve K 143 002)
        PidPipe {
            id: pipeSuctionSolids
            startX: 462
            startY: 500
            endX: 520
            endY: 500
            baseColor: "#52a5ec"
            flowColor: "#38ef7d"
            isActive: pipingLayerRoot.isSuctionSolids
            section: "Suction Solids"
        }

        // Lower Liquids Charging Line (through Butterfly Valve K 143 001)
        PidPipe {
            id: pipeSuctionLiquids
            startX: 462
            startY: 536
            endX: 520
            endY: 536
            baseColor: "#52a5ec"
            flowColor: "#38ef7d"
            isActive: pipingLayerRoot.isSuctionLiquids
            section: "Suction Liquids"
        }
    }

    // =========================================================================
    // SET 2: RECIRCULATION LOOP & RISER (Homogenizer Stator -> Top Vessel Dome)
    // =========================================================================
    Item {
        id: setRecirculationPipes

        // Stator Discharge Outlet (through Butterfly Valve K 163 002)
        PidPipe {
            id: pipeRecircOutlet
            startX: 580
            startY: 507
            endX: 840
            endY: 507
            baseColor: "#00d2ff"
            flowColor: "#38ef7d"
            isActive: pipingLayerRoot.isRecirculating || pipingLayerRoot.isHomogRunning
            section: "Recirculation Outlet"
        }

        // Vertical Recirculation Riser (through Butterfly Valve K 165 002)
        PidPipe {
            id: pipeRecircRiser
            startX: 840
            startY: 507
            endX: 840
            endY: 205
            baseColor: "#00d2ff"
            flowColor: "#38ef7d"
            flowDirection: "reverse" // Upward flow to dome
            isActive: pipingLayerRoot.isRecirculating
            section: "Recirculation Riser"
        }

        // Top Return to Vessel Dome (through Butterfly Valve K 165 003)
        PidPipe {
            id: pipeRecircReturn
            startX: 840
            startY: 205
            endX: 680
            endY: 205
            baseColor: "#00d2ff"
            flowColor: "#38ef7d"
            flowDirection: "reverse" // Leftward flow into vessel
            isActive: pipingLayerRoot.isRecirculating
            section: "Recirculation Return"
        }
    }

    // =========================================================================
    // SET 3: JACKET THERMAL UTILITY CIRCUITS (Pump, Inline Heater & Jacket)
    // =========================================================================
    Item {
        id: setJacketUtilityPipes

        // Vertical Green Supply Header (through Diaphragm Valve K 168 201)
        PidPipe {
            id: pipeGreenHeader
            startX: 60
            startY: 480
            endX: 60
            endY: 635
            baseColor: "#22c55e"
            section: "Green Utility Header"
        }

        // Vertical Blue CW Return Header (through Diaphragm Valve K 168 202)
        PidPipe {
            id: pipeBlueHeader
            startX: 120
            startY: 210
            endX: 120
            endY: 645
            baseColor: "#3b82f6"
            section: "Blue Utility Return"
        }

        // Horizontal Bridge Valve & Pump Supply (through K 168 204)
        PidPipe {
            id: pipePumpSupplyBridge
            startX: 60
            startY: 480
            endX: 180
            endY: 480
            baseColor: "#22c55e"
            flowColor: "#ef4444"
            isActive: pipingLayerRoot.isHeating
            section: "Pump Supply Bridge"
        }

        // Hot Water Supply: Heater Discharge -> Lower Jacket Nozzle (y=320)
        PidPipe {
            id: pipeJacketSupplyRiser
            startX: 180
            startY: 480
            endX: 180
            endY: 320
            baseColor: "#ef4444"
            flowColor: "#f97316"
            flowDirection: "reverse"
            isActive: pipingLayerRoot.isHeating
            section: "Jacket Supply Riser"
        }
        PidPipe {
            id: pipeJacketSupplyInlet
            startX: 180
            startY: 320
            endX: 408
            endY: 320
            baseColor: "#ef4444"
            flowColor: "#f97316"
            isActive: pipingLayerRoot.isHeating
            section: "Jacket Lower Nozzle"
        }

        // Cold Water Return: Upper Jacket Nozzle (y=210) -> Blue Return Header
        PidPipe {
            id: pipeJacketReturnOutlet
            startX: 408
            startY: 210
            endX: 120
            endY: 210
            baseColor: "#3b82f6"
            flowColor: "#38bdf8"
            flowDirection: "reverse"
            isActive: pipingLayerRoot.isCooling || pipingLayerRoot.isHeating
            section: "Jacket Upper Return"
        }
    }

    // =========================================================================
    // SET 4: MECHANICAL SEAL COOLING CIRCUIT (Collar -> Seal Pot B 171 001)
    // =========================================================================
    Item {
        id: setSealCoolingPipes

        // Red Supply Line (Upper Seal Port -> Pot Base)
        PidPipe {
            id: pipeSealRedH
            startX: 580
            startY: 546
            endX: 685
            endY: 546
            baseColor: "#ef4444"
            section: "Seal Red Supply H"
        }
        PidPipe {
            id: pipeSealRedV
            startX: 685
            startY: 546
            endX: 685
            endY: 500
            baseColor: "#ef4444"
            section: "Seal Red Supply V"
        }

        // Blue Return Line (Lower Seal Port -> Pot Base)
        PidPipe {
            id: pipeSealBlueH
            startX: 580
            startY: 556
            endX: 695
            endY: 556
            baseColor: "#3b82f6"
            section: "Seal Blue Return H"
        }
        PidPipe {
            id: pipeSealBlueV
            startX: 695
            startY: 556
            endX: 695
            endY: 500
            baseColor: "#3b82f6"
            section: "Seal Blue Return V"
        }
    }

    // =========================================================================
    // SET 5: BOTTOM UTILITY HEADERS (Running Cleanly Below Motor at y=635, 645)
    // =========================================================================
    Item {
        id: setBottomUtilityPipes

        // Green Utility Header (HW Line running below motor)
        PidPipe {
            id: pipeBottomGreenH
            startX: 20
            startY: 635
            endX: 705
            endY: 635
            baseColor: "#22c55e"
            section: "Bottom Green Main"
        }
        PidPipe {
            id: pipeBottomGreenV
            startX: 705
            startY: 635
            endX: 705
            endY: 500
            baseColor: "#22c55e"
            section: "Bottom Green Seal Pot Feed"
        }

        // Blue Utility Header (CW Line running below motor)
        PidPipe {
            id: pipeBottomBlueH
            startX: 20
            startY: 645
            endX: 715
            endY: 645
            baseColor: "#3b82f6"
            section: "Bottom Blue Main"
        }
        PidPipe {
            id: pipeBottomBlueV
            startX: 715
            startY: 645
            endX: 715
            endY: 500
            baseColor: "#3b82f6"
            section: "Bottom Blue Seal Pot Feed"
        }
    }

    // =========================================================================
    // SET 6: UPPER CIP SPRAY BALL & VENT MANIFOLD
    // =========================================================================
    Item {
        id: setUpperUtilityPipes

        // Left Spray Ball 1 Feed
        PidPipe {
            id: pipeSpray1Feed
            startX: 395
            startY: 155
            endX: 440
            endY: 155
            baseColor: "#38bdf8"
            flowColor: "#4ade80"
            isActive: pipingLayerRoot.isSprayingCIP
            section: "Spray 1 Feed"
        }

        // Center Spray Ball 2 Feed
        PidPipe {
            id: pipeSpray2Feed
            startX: 550
            startY: 120
            endX: 550
            endY: 184
            baseColor: "#38bdf8"
            flowColor: "#4ade80"
            isActive: pipingLayerRoot.isSprayingCIP
            section: "Spray 2 Feed"
        }

        // Right Spray Ball 3 Feed
        PidPipe {
            id: pipeSpray3Feed
            startX: 635
            startY: 120
            endX: 635
            endY: 184
            baseColor: "#38bdf8"
            flowColor: "#4ade80"
            isActive: pipingLayerRoot.isSprayingCIP
            section: "Spray 3 Feed"
        }
    }

    // =========================================================================
    // SET 7: LID LIFTER MECHANICAL SUPPORT ARM & GUIDE
    // =========================================================================
    Item {
        id: setLidLifterPipes

        // Top Support Arm
        PidPipe {
            id: pipeLifterArm
            startX: 680
            startY: 155
            endX: 920
            endY: 155
            baseColor: "#00d2ff"
            section: "Lifter Arm"
        }

        // Vertical Guide Column
        PidPipe {
            id: pipeLifterColumn
            startX: 920
            startY: 120
            endX: 920
            endY: 560
            baseColor: "#00d2ff"
            section: "Lifter Column"
        }
    }
}
