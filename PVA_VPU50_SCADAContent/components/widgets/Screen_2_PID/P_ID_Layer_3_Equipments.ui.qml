
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
    // LAYER 2 & LAYER 1: UNDERLYING INSTRUMENTATION & PIPING (z: 1)
    // =========================================================================
    P_ID_Layer_2_Instrumentation {
        id: instrumentationLayer
        z: 1
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

    // Pass-through Direct Instrumentation Aliases (Layer 2)
    property alias vK143002: instrumentationLayer.vK143002
    property alias vK143001: instrumentationLayer.vK143001
    property alias vK163002: instrumentationLayer.vK163002
    property alias vK168201: instrumentationLayer.vK168201
    property alias vK168202: instrumentationLayer.vK168202
    property alias vK168204: instrumentationLayer.vK168204
    property alias vK165002: instrumentationLayer.vK165002
    property alias vK165003: instrumentationLayer.vK165003
    property alias pressGauge1: instrumentationLayer.pressGauge1
    property alias sprayBall1: instrumentationLayer.sprayBall1
    property alias sprayBall2: instrumentationLayer.sprayBall2
    property alias sprayBall3: instrumentationLayer.sprayBall3
    property alias levelGauge: instrumentationLayer.levelGauge

    // =========================================================================
    // LAYER 3: MAJOR PLANT EQUIPMENT (z: 4 - Placed directly over Layer 1 & 2)
    // =========================================================================
    // 1. Main Process Vessel & Thermal Jacket Glow
    PidVessel {
        id: mainVessel
        z: 4
        x: 654
        y: 113
        vesselName: "Unimix 50"
        showTags: equipmentLayerRoot.showTags
    }

    PidHeatingEffect {
        id: heatingEffect
        z: 4
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
        y: 481
        tag: "W 168 001"
        showTags: equipmentLayerRoot.showTags
    }

    // Jacket Nozzle Flange Collars

    // 4. Mechanical Seal Buffer Pot (B 171 001)
    PidSealPot {
        id: sealPot
        z: 4
        x: 311
        y: 661
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
}
