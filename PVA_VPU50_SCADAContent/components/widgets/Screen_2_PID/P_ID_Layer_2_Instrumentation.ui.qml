
/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML.
*/
import QtQuick

Item {
    id: instrumentationLayerRoot
    width: 1440
    height: 840

    property bool showTags: true

    // =========================================================================
    // LAYER 1: UNDERLYING PIPING NETWORK (z: 1 - Visible in Qt Design Studio Canvas)
    // =========================================================================
    P_ID_Layer_1_Piping {
        id: pipingLayer
        z: 1
        anchors.fill: parent
    }

    // Aliases for Direct Property Inspection & Screen Wiring
    property alias pipingLayer: pipingLayer
    property alias vK168201: vK168201
    property alias vK168202: vK168202
    property alias vK168204: vK168204
    property alias vK143002: vK143002
    property alias vK143001: vK143001
    property alias vK163002: vK163002
    property alias vK165001: vK165001
    property alias vK165002: vK165002
    property alias vK165003: vK165003
    property alias vK165004: vK165004
    property alias pressGauge1: pressGauge1
    property alias sprayBall1: sprayBall1
    property alias sprayBall2: sprayBall2
    property alias sprayBall3: sprayBall3
    property alias levelGauge: levelGauge

    // =========================================================================
    // LAYER 2: INSTRUMENTATION & VALVES (z: 3 - Placed directly over Layer 1 pipes)
    // =========================================================================
    // 1. Utility Header Diaphragm Valves (Spacious Left Placement)
    PidValve {
        id: vK168201
        z: 3
        x: 65
        y: 688
        tag: "K 168 201"
        isVertical: true
        valveType: "diaphragm"
        showTags: instrumentationLayerRoot.showTags
    }

    PidValve {
        id: vK168202
        z: 3
        x: 123
        y: 688
        tag: "K 168 202"
        isVertical: true
        valveType: "diaphragm"
        showTags: instrumentationLayerRoot.showTags
    }

    PidValve {
        id: vK168204
        z: 3
        x: 91
        y: 621
        tag: "K 168 204"
        valveType: "diaphragm"
        showTags: instrumentationLayerRoot.showTags
    }

    // 2. In-Line Pressure Gauge (Between Pump & Inline Heater - Horizontal Mounting)
    PidPressureGauge {
        id: pressGauge1
        z: 4
        x: 194
        y: 554
        tag: "PI 168 001"
        pressureBar: 2.4
        isVertical: false
        showTags: instrumentationLayerRoot.showTags
    }

    // 3. Suction Charging Butterfly Valves
    PidValve {
        id: vK143002
        z: 3
        x: 664
        y: 532
        tag: "K 143 002"
        subLabel: "Solids"
        valveType: "butterfly"
        showTags: instrumentationLayerRoot.showTags
    }

    PidValve {
        id: vK143001
        z: 3
        x: 664
        y: 569
        tag: "K 143 001"
        subLabel: "Liquids"
        valveType: "butterfly"
        showTags: instrumentationLayerRoot.showTags
    }

    // 4. Stator & Recirculation Butterfly Valves
    PidValve {
        id: vK163002
        z: 3
        x: 971
        y: 490
        tag: "K 163 002"
        valveType: "butterfly"
        showTags: instrumentationLayerRoot.showTags
    }

    PidValve {
        id: vK165001
        z: 3
        x: 1148
        y: 110
        tag: "K 165 001"
        valveType: "butterfly"
        isVertical: true
        showTags: instrumentationLayerRoot.showTags
    }

    PidValve {
        id: vK165002
        z: 3
        x: 1148
        y: 336
        tag: "K 165 002"
        valveType: "butterfly"
        isVertical: true
        showTags: instrumentationLayerRoot.showTags
    }

    PidValve {
        id: vK165003
        z: 3
        x: 1009
        y: 193
        tag: "K 165 003"
        valveType: "butterfly"
        showTags: instrumentationLayerRoot.showTags
    }

    // 45 Degree Diagonal Elbow Drain / Discharge Butterfly Valve
    PidValve {
        id: vK165004
        z: 3
        x: 1172
        y: 513
        rotation: 45
        tag: "K 165 004"
        valveType: "butterfly"
        showTags: instrumentationLayerRoot.showTags
    }

    // 5. CIP Spray Balls & Dome Level Gauge
    PidSprayBall {
        id: sprayBall1
        z: 5
        x: 717
        y: 193
        tag: "X 165 501"
        showTags: instrumentationLayerRoot.showTags
    }

    PidSprayBall {
        id: sprayBall2
        z: 5
        x: 848
        y: 193
        tag: "X 165 502"
        showTags: instrumentationLayerRoot.showTags
    }

    PidSprayBall {
        id: sprayBall3
        z: 5
        x: 885
        y: 193
        tag: "X 165 503"
        sprayAngle: -35
        showTags: instrumentationLayerRoot.showTags
    }

    PidLevelGauge {
        id: levelGauge
        z: 10
        x: 1004
        y: 252
        showTags: instrumentationLayerRoot.showTags
    }
}
