import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../components/widgets/Screen_2_PID"
import "../config"

Rectangle {
    id: pidScreenRoot
    color: "#0a2d52"

    ScadaConfig { id: scadaConfig }

    // Live Process Simulation / Telemetry Bindings
    property bool isHomogenizing: true
    property bool isHeating: false
    property bool isCooling: false
    property bool isFilling: false
    property bool isDraining: false
    property bool isVacuumActive: true

    property real vesselLevel: 65.0
    property real vesselTemp: 34.4
    property real jacketTemp: 35.8
    property real vacuumPressure: -179.0
    property real agitatorSpeed: 10.0
    property real homogenizerSpeed: isHomogenizing ? 4800.0 : 0.0

    signal componentTapped(string tagName)

    // =========================================================================
    // 1. TOP-LEFT OVERVIEW NAVIGATOR & MINIMAP
    // =========================================================================
    PidMinimap {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 14
        z: 10
    }

    // Top Right EKATO Watermark Brand
    Text {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 16
        text: "EKATO"
        color: "#ffffff"
        font.bold: true
        font.pixelSize: 22
        font.letterSpacing: 2
    }

    // =========================================================================
    // 2. ACTIVE PHASE BANNER ("HOMOGENIZATION")
    // =========================================================================
    Rectangle {
        anchors.top: parent.top
        anchors.topMargin: 18
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: -20
        width: 320
        height: 44
        radius: 4
        color: "#163b65"
        border.color: "#38bdf8"
        border.width: 1.5
        z: 20
        visible: pidScreenRoot.isHomogenizing

        Text {
            anchors.centerIn: parent
            text: "HOMOGENIZATION"
            color: "#ffffff"
            font.bold: true
            font.pixelSize: 22
            font.letterSpacing: 2
        }
    }

    // =========================================================================
    // 3. LEFT-SIDE PROCESS VALVE MANIFOLD (Utility Steam, Water, Gas)
    // =========================================================================
    // Vertical Manifold Backbone Lines
    PidPipe { startX: 30; startY: 340; endX: 30; endY: 590; baseColor: "#1d5891" }
    PidPipe { startX: 90; startY: 340; endX: 90; endY: 590; baseColor: "#1d5891" }

    // Manifold Cross Valves
    PidValve { x: 16; y: 350; tag: "K 168 201"; isOpen: false; onClicked: pidScreenRoot.componentTapped(tag) }
    PidValve { x: 76; y: 350; tag: "K 168 202"; isOpen: false; onClicked: pidScreenRoot.componentTapped(tag) }
    PidValve { x: 16; y: 400; tag: "K 168 204"; isOpen: false; onClicked: pidScreenRoot.componentTapped(tag) }
    PidValve { x: 76; y: 400; tag: "K 168 206"; isOpen: false; onClicked: pidScreenRoot.componentTapped(tag) }
    PidValve { x: 16; y: 450; tag: "K 168 208"; isOpen: false; onClicked: pidScreenRoot.componentTapped(tag) }
    PidValve { x: 76; y: 450; tag: "K 168 205"; isOpen: false; onClicked: pidScreenRoot.componentTapped(tag) }
    PidValve { x: 16; y: 530; tag: "K 168 207"; isOpen: false; onClicked: pidScreenRoot.componentTapped(tag) }

    // Bottom Thermal Jacket Interconnects
    PidPipe { startX: 90; startY: 414; endX: 470; endY: 414; baseColor: "#1d5891" }
    PidPipe { startX: 90; startY: 544; endX: 380; endY: 544; baseColor: "#1d5891" }
    PidPipe { startX: 380; startY: 544; endX: 380; endY: 480; baseColor: "#1d5891" }
    PidPipe { startX: 380; startY: 480; endX: 470; endY: 480; baseColor: "#1d5891" }
    PidValve { x: 366; y: 530; tag: "K 172 002"; isOpen: false; onClicked: pidScreenRoot.componentTapped(tag) }

    // =========================================================================
    // 4. TOP UTILITY LINES (Gas Inlet, Venting, CIP Washing)
    // =========================================================================
    // Gas Inlet Line (Left -> Top Dome)
    PidPipe { startX: 20; startY: 200; endX: 380; endY: 200; baseColor: "#1d5891" }
    PidPipe { startX: 380; startY: 200; endX: 380; endY: 155; baseColor: "#1d5891" }
    PidPipe { startX: 380; startY: 155; endX: 530; endY: 155; baseColor: "#1d5891" }
    Text { x: 25; y: 184; text: "gas inlet"; color: "#8cb5dc"; font.pixelSize: 8 }
    PidValve { x: 366; y: 186; tag: "K 166 002"; isOpen: false; onClicked: pidScreenRoot.componentTapped(tag) }

    // CIP Washing Line (Top Manifold -> Spray Nozzles)
    PidPipe { startX: 400; startY: 90; endX: 680; endY: 90; isActive: isFilling }
    PidPipe { startX: 430; startY: 90; endX: 430; endY: 145; isActive: isFilling }
    PidPipe { startX: 500; startY: 90; endX: 500; endY: 145; isActive: isFilling }
    PidPipe { startX: 640; startY: 90; endX: 640; endY: 145; isActive: isFilling }
    PidPipe { startX: 680; startY: 90; endX: 680; endY: 145; isActive: isFilling }

    PidValve { x: 416; y: 76; tag: "K 161 002"; isOpen: isFilling; onClicked: pidScreenRoot.componentTapped(tag) }
    PidValve { x: 486; y: 76; tag: "K 161 003"; isOpen: isFilling; onClicked: pidScreenRoot.componentTapped(tag) }
    PidValve { x: 626; y: 120; tag: "K 141 001"; isVertical: true; isOpen: false; onClicked: pidScreenRoot.componentTapped(tag) }

    // Spray Ball Heads inside Top Dome
    PidSprayBall { x: 520; y: 155; tag: "X 161 001"; isSpraying: isFilling }
    PidSprayBall { x: 610; y: 155; tag: "X 161 002"; isSpraying: isFilling }
    PidSprayBall { x: 650; y: 155; tag: "X 161 003"; isSpraying: isHomogenizing }

    // Vacuum Line & Extraction Valve
    PidValve { x: 470; y: 110; tag: "K 171 001"; isVertical: true; isOpen: isVacuumActive; onClicked: pidScreenRoot.componentTapped(tag) }

    // =========================================================================
    // 5. MAIN PROCESS VESSEL (UNIMIX 50 / B1)
    // =========================================================================
    PidVessel {
        id: mainVessel
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: -20
        anchors.top: parent.top
        anchors.topMargin: 110
        vesselName: "Unimix 50"
        levelPercent: pidScreenRoot.vesselLevel
        vesselTemp: pidScreenRoot.vesselTemp
        jacketTemp: pidScreenRoot.jacketTemp
        vacuumPressure: pidScreenRoot.vacuumPressure
        isHeating: pidScreenRoot.isHeating
        isCooling: pidScreenRoot.isCooling
    }

    // Top Agitator Drive & Double X-Braced Paravisc Impeller
    PidAgitator {
        anchors.horizontalCenter: mainVessel.horizontalCenter
        anchors.top: mainVessel.top
        anchors.topMargin: -15
        speedRpm: pidScreenRoot.agitatorSpeed
        isRunning: true
    }

    // Bottom Homogenizer Rotor/Stator Chamber & Drive Motor
    PidHomogenizer {
        anchors.horizontalCenter: mainVessel.horizontalCenter
        anchors.top: mainVessel.bottom
        anchors.topMargin: -15
        speedRpm: pidScreenRoot.homogenizerSpeed
        isRunning: pidScreenRoot.isHomogenizing
    }

    // =========================================================================
    // 6. EXTERNAL HOMOGENIZATION RECIRCULATION LOOP (Bottom -> Top Dome)
    // =========================================================================
    // Horizontal branch from bottom cone to right
    PidPipe { startX: 600; startY: 480; endX: 740; endY: 480; isActive: isHomogenizing; flowColor: "#38ef7d" }
    // Vertical riser pipe up to vessel shoulder
    PidPipe { startX: 740; startY: 480; endX: 740; endY: 175; isActive: isHomogenizing; flowColor: "#38ef7d"; reverseFlow: true }
    // Return bend into top dome
    PidPipe { startX: 740; startY: 175; endX: 660; endY: 175; isActive: isHomogenizing; flowColor: "#38ef7d" }

    // Recirculation Valves
    PidValve { x: 575; y: 466; tag: "K 163 002"; isOpen: isHomogenizing; onClicked: pidScreenRoot.componentTapped(tag) }
    PidValve { x: 670; y: 466; tag: "K 165 002"; isOpen: isHomogenizing; onClicked: pidScreenRoot.componentTapped(tag) }
    PidValve { x: 680; y: 161; tag: "K 165 003"; isOpen: isHomogenizing; onClicked: pidScreenRoot.componentTapped(tag) }

    // Sensor Indicator GOS 172 601 on Vertical Riser
    Rectangle {
        x: 748
        y: 450
        width: 8
        height: 8
        radius: 4
        color: isHomogenizing ? "#22c55e" : "#475569"
        Text { x: 12; y: -2; text: "GOS 172 601"; color: "#8cb5dc"; font.pixelSize: 7 }
    }

    // =========================================================================
    // 7. SUCTION INLET VALVES (Solids & Liquids with Foot Switch)
    // =========================================================================
    PidPipe { startX: 470; startY: 450; endX: 555; endY: 450; baseColor: "#1d5891" }
    PidPipe { startX: 470; startY: 480; endX: 555; endY: 480; baseColor: "#1d5891" }

    PidValve { x: 495; y: 436; tag: "K 143 002"; subLabel: "Solids"; isOpen: false; onClicked: pidScreenRoot.componentTapped(tag) }
    PidValve { x: 495; y: 466; tag: "K 143 001"; subLabel: "Liquids"; isOpen: false; onClicked: pidScreenRoot.componentTapped(tag) }

    // Foot Switch Indicator
    RowLayout {
        x: 440
        y: 496
        spacing: 4
        Rectangle { width: 8; height: 8; radius: 4; color: "#ffffff" }
        Text { text: "foot switch"; color: "#cbd5e1"; font.pixelSize: 7 }
    }

    // Bottom Discharge Valve
    PidPipe { startX: 630; startY: 430; endX: 670; endY: 430; baseColor: "#1d5891" }
    PidValve { x: 645; y: 416; tag: "V 142 201"; subLabel: "Suction Bottom"; isOpen: false; onClicked: pidScreenRoot.componentTapped(tag) }

    // =========================================================================
    // 8. HYDRAULIC LID LIFTER & SWIVELLING DEVICE
    // =========================================================================
    PidLidLifter {
        anchors.left: mainVessel.right
        anchors.leftMargin: 20
        anchors.top: mainVessel.top
        anchors.topMargin: 40
    }

    // =========================================================================
    // 9. LIVE PID TEMPERATURE CONTROL TELEMETRY
    // =========================================================================
    PidControlBox {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 14
        setpointTemp: 95.0
        gradientSp: 20.7
        processVal: pidScreenRoot.vesselTemp
    }
}
