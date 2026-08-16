
/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML.
*/
import QtQuick

Item {
    id: equipmentLayerRoot
    width: 1440
    height: 840

    property bool showTags: true

    // =========================================================================
    // 0. SOLID SCADA BACKGROUND CANVAS (z: 0)
    // =========================================================================
    Rectangle {
        id: bgCanvas
        anchors.fill: parent
        color: "#0a2d52"
        z: 0
    }

    // =========================================================================
    // LAYER 2 & LAYER 1: INSTRUMENTATION & PIPING (z: 6 - Placed ON TOP of Vessel)
    // =========================================================================
    P_ID_Layer_2_Instrumentation {
        id: instrumentationLayer
        z: 6
        anchors.fill: parent
        showTags: equipmentLayerRoot.showTags
    }

    // Pass-through Layer Aliases
    property alias instrumentationLayer: instrumentationLayer
    property alias pipingLayer: instrumentationLayer.pipingLayer

    // Direct Equipment Aliases (Layer 3)
    property alias mainVessel: mainVessel
    property alias heatingEffect: heatingEffect
    property alias agitator: agitator
    property alias circPump1: circPump1
    property alias inlineHeater: inlineHeater
    property alias sealPot: sealPot
    property alias bottomHomog: bottomHomog
    property alias boxSealPot: boxSealPot
    property alias boxHeating: boxHeating
    property alias boxVesselJacket: boxVesselJacket

    // Pass-through Direct Instrumentation Aliases (Layer 2)
    property alias vK143002: instrumentationLayer.vK143002
    property alias vK143001: instrumentationLayer.vK143001
    property alias vK163002: instrumentationLayer.vK163002
    property alias vK168201: instrumentationLayer.vK168201
    property alias vK168202: instrumentationLayer.vK168202
    property alias vK168204: instrumentationLayer.vK168204
    property alias vK165001: instrumentationLayer.vK165001
    property alias vK165002: instrumentationLayer.vK165002
    property alias vK165003: instrumentationLayer.vK165003
    property alias vK165004: instrumentationLayer.vK165004
    property alias pressGauge1: instrumentationLayer.pressGauge1
    property alias sprayBall1: instrumentationLayer.sprayBall1
    property alias sprayBall2: instrumentationLayer.sprayBall2
    property alias sprayBall3: instrumentationLayer.sprayBall3
    property alias levelGauge: instrumentationLayer.levelGauge

    // =========================================================================
    // LAYER 3: MAJOR PLANT EQUIPMENT (z: 1, 2, 3 - Below Instrumentation & Sprayballs)
    // =========================================================================
    // 1. Main Process Vessel & Thermal Jacket Glow
    PidVessel {
        id: mainVessel
        z: 1
        x: 654
        y: 113
        vesselName: "Unimix 50"
        showTags: equipmentLayerRoot.showTags
    }

    PidHeatingEffect {
        id: heatingEffect
        z: 1
        anchors.fill: mainVessel
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        anchors.topMargin: 0
        anchors.bottomMargin: 0
        opacity: 0.85
    }

    // 2. Agitator Planetary Drive
    PidAgitator {
        id: agitator
        z: 5
        anchors.horizontalCenter: mainVessel.horizontalCenter
        anchors.top: mainVessel.top
        anchors.topMargin: -58
        anchors.horizontalCenterOffset: 0
        showTags: equipmentLayerRoot.showTags
    }

    // 3. Left Utility: Circulation Pump & In-line Electric Heater (Spacious Placement)
    PidCirculationPump {
        id: circPump1
        z: 4
        x: 169
        y: 606
        tag: "P 168 001"
        showTags: equipmentLayerRoot.showTags
    }

    PidInlineHeater {
        id: inlineHeater
        z: 4
        x: 177
        y: 478
        tag: "W 168 001"
        showTags: equipmentLayerRoot.showTags
    }

    // Jacket Nozzle Flange Collars

    // 4. Mechanical Seal Buffer Pot (B 171 001)
    PidSealPot {
        id: sealPot
        z: 4
        x: 311
        y: 629
        tag: "B 171 001"
        tempTag: "TI 171 001"
        showTags: equipmentLayerRoot.showTags
    }

    // 5. Bottom Homogenizer Assembly
    PidHomogenizer {
        id: bottomHomog
        z: 4
        x: 604
        y: 489
        showTags: equipmentLayerRoot.showTags
    }

    // 6. Lid Lifter Guide Motor
    Rectangle {
        z: 4
        x: 1356
        y: 598
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

    // 7. Dynamic Process & Diagnostic Telemetry Control Boxes
    // 7a. Vessel & Jacket Telemetry Box (Near Left Jacket Profile)
    PidControlBox {
        id: boxVesselJacket
        z: 5
        x: 500
        y: 166
        title: "Vessel & Jacket"
        tag: "B 161 001"
        accentColor: "#22c55e"
        showTags: equipmentLayerRoot.showTags
        row1Label: "Product Temp:"
        row1Value: "20.7"
        row1Unit: "°C"
        row1Color: "#ffffff"
        row2Label: "Jacket Temp:"
        row2Value: "21.2"
        row2Unit: "°C"
        row2Color: "#38bdf8"
        row3Label: "Vacuum Press:"
        row3Value: "-179.0"
        row3Unit: "mbar"
        row3Color: "#c084fc"
        row4Label: "Batch Weight:"
        row4Value: "154.4"
        row4Unit: "kg"
        row4Color: "#22c55e"
        row5Label: "Vessel Level:"
        row5Value: "65.0"
        row5Unit: "%"
        row5Color: "#38bdf8"
        row6Label: "Jacket Press:"
        row6Value: "1.2"
        row6Unit: "bar"
        row6Color: "#34d399"
    }

    // 7b. Heating Loop PID Control Box (Near In-Line Heater & Pump)
    PidControlBox {
        id: boxHeating
        z: 5
        x: 277
        y: 467
        title: "Heating Loop"
        tag: "W 168 001"
        accentColor: "#f97316"
        showTags: equipmentLayerRoot.showTags
        row1Label: "SP Temp:"
        row1Value: "95.0"
        row1Unit: "°C"
        row1Color: "#22c55e"
        row2Label: "PV Temp:"
        row2Value: "21.2"
        row2Unit: "°C"
        row2Color: "#f97316"
        row3Label: "In-line Press:"
        row3Value: "2.4"
        row3Unit: "bar"
        row3Color: "#38bdf8"
        row4Label: "Heater Power:"
        row4Value: "45.0"
        row4Unit: "%"
        row4Color: "#fb923c"
        row5Label: "Circ. Flow:"
        row5Value: "14.2"
        row5Unit: "L/min"
        row5Color: "#4ade80"
        row6Label: "Loop State:"
        row6Value: "Active"
        row6Unit: ""
        row6Color: "#f8fafc"
    }

    // 7c. Mechanical Seal Buffer Pot Telemetry Box (Near Seal Pot)
    PidControlBox {
        id: boxSealPot
        z: 5
        x: 406
        y: 661
        title: "Seal Pot"
        tag: "B 171 001"
        accentColor: "#38bdf8"
        showTags: equipmentLayerRoot.showTags
        row1Label: "Seal Temp:"
        row1Value: "24.2"
        row1Unit: "°C"
        row1Color: "#38bdf8"
        row2Label: "Seal Press:"
        row2Value: "1.8"
        row2Unit: "bar"
        row2Color: "#22c55e"
        row3Label: "Buffer Level:"
        row3Value: "85.0"
        row3Unit: "%"
        row3Color: "#cbd5e1"
        row4Label: "Barrier Flow:"
        row4Value: "Normal"
        row4Unit: ""
        row4Color: "#22c55e"
    }
}
