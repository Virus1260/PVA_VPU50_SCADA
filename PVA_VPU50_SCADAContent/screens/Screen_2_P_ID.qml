import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../components/widgets/Screen_2_PID"
import "../config"

Rectangle {
    id: pidScreenRoot
    color: "#081d33"

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

    // Top Right Header Label
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
    // 2. MODULAR PIPELINE GRID (With Traveling Active Fluid Flow)
    // =========================================================================
    // (A) Gas Inlet Line (Left -> Top Dome)
    PidPipe { startX: 40; startY: 170; endX: 280; endY: 170; isActive: false }
    PidPipe { startX: 280; startY: 170; endX: 280; endY: 140; isActive: false }
    PidPipe { startX: 280; startY: 140; endX: 480; endY: 140; isActive: false }
    Text { x: 42; y: 154; text: "gas inlet"; color: "#8cb5dc"; font.pixelSize: 9 }
    PidValve { x: 264; y: 154; tag: "K 166 002"; isOpen: false; onClicked: pidScreenRoot.componentTapped(tag) }

    // (B) Top CIP Cleaning Line (Top Manifold -> Spray Balls)
    PidPipe { startX: 340; startY: 100; endX: 520; endY: 100; isActive: isFilling }
    PidPipe { startX: 380; startY: 100; endX: 380; endY: 145; isActive: isFilling }
    PidPipe { startX: 440; startY: 100; endX: 440; endY: 145; isActive: isFilling }
    PidPipe { startX: 520; startY: 100; endX: 520; endY: 145; isActive: isFilling }
    PidValve { x: 364; y: 84; tag: "K 161 002"; isOpen: isFilling; onClicked: pidScreenRoot.componentTapped(tag) }
    PidValve { x: 424; y: 84; tag: "K 161 003"; isOpen: isFilling; onClicked: pidScreenRoot.componentTapped(tag) }

    // (C) EXTERNAL HOMOGENIZATION RECIRCULATION LOOP (Bottom -> Top Dome)
    // Horizontal branch from bottom cone to right
    PidPipe { startX: 560; startY: 485; endX: 680; endY: 485; isActive: isHomogenizing; flowColor: "#22c55e" }
    // Vertical riser pipe up to vessel shoulder
    PidPipe { startX: 680; startY: 485; endX: 680; endY: 215; isActive: isHomogenizing; flowColor: "#22c55e"; reverseFlow: true }
    // Return bend into top dome
    PidPipe { startX: 680; startY: 215; endX: 580; endY: 215; isActive: isHomogenizing; flowColor: "#22c55e" }

    PidValve { x: 484; y: 469; tag: "Z 163 001"; isOpen: isHomogenizing; onClicked: pidScreenRoot.componentTapped(tag) }
    PidValve { x: 574; y: 469; tag: "K 163 002"; isOpen: isHomogenizing; onClicked: pidScreenRoot.componentTapped(tag) }
    PidValve { x: 664; y: 469; tag: "K 165 002"; isOpen: isHomogenizing; onClicked: pidScreenRoot.componentTapped(tag) }
    PidValve { x: 624; y: 199; tag: "K 165 003"; isOpen: isHomogenizing; onClicked: pidScreenRoot.componentTapped(tag) }

    // (D) Solids & Liquids Vacuum Suction Ports
    PidPipe { startX: 380; startY: 465; endX: 470; endY: 465; isActive: false }
    PidPipe { startX: 380; startY: 495; endX: 470; endY: 495; isActive: false }
    PidValve { x: 414; y: 449; tag: "K 143 002"; subLabel: "Solids"; isOpen: false; onClicked: pidScreenRoot.componentTapped(tag) }
    PidValve { x: 414; y: 479; tag: "K 143 001"; subLabel: "Liquids"; isOpen: false; onClicked: pidScreenRoot.componentTapped(tag) }

    // (E) Bottom Product Discharge Valve
    PidPipe { startX: 540; startY: 535; endX: 640; endY: 535; isActive: isDraining }
    PidValve { x: 604; y: 519; tag: "V 142 201"; subLabel: "Bottom"; isOpen: isDraining; onClicked: pidScreenRoot.componentTapped(tag) }

    // =========================================================================
    // 3. MAIN PROCESS VESSEL (Unimix 50 / B1)
    // =========================================================================
    PidVessel {
        id: mainVessel
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 10
        vesselName: "B1"
        levelPercent: pidScreenRoot.vesselLevel
        vesselTemp: pidScreenRoot.vesselTemp
        jacketTemp: pidScreenRoot.jacketTemp
        vacuumPressure: pidScreenRoot.vacuumPressure
        isHeating: pidScreenRoot.isHeating
        isCooling: pidScreenRoot.isCooling
        isFilling: pidScreenRoot.isFilling
        isVacuum: pidScreenRoot.isVacuumActive
    }

    // =========================================================================
    // 4. TOP AGITATOR DRIVE & BOTTOM HOMOGENIZER
    // =========================================================================
    // Top Agitator Drive
    PidAgitator {
        anchors.horizontalCenter: mainVessel.horizontalCenter
        anchors.bottom: mainVessel.verticalCenter
        anchors.bottomMargin: -40
        speedRpm: pidScreenRoot.agitatorSpeed
        isRunning: true
    }

    // Bottom High-Shear Homogenizer
    PidHomogenizer {
        anchors.horizontalCenter: mainVessel.horizontalCenter
        anchors.top: mainVessel.bottom
        anchors.topMargin: -35
        speedRpm: pidScreenRoot.homogenizerSpeed
        isRunning: pidScreenRoot.isHomogenizing
    }

    // Spray Balls inside Dome
    PidSprayBall { x: 430; y: 148; isSpraying: isFilling }
    PidSprayBall { x: 510; y: 148; isSpraying: isFilling }
    PidSprayBall { x: 570; y: 154; isSpraying: isHomogenizing }

    // =========================================================================
    // 5. HYDRAULIC LID LIFTER & SWIVELLING CYLINDER
    // =========================================================================
    PidLidLifter {
        anchors.left: mainVessel.right
        anchors.leftMargin: 30
        anchors.verticalCenter: mainVessel.verticalCenter
    }

    // =========================================================================
    // 6. LIVE PID TEMPERATURE CONTROL TELEMETRY
    // =========================================================================
    PidControlBox {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 20
        setpointTemp: 95.0
        gradientSp: 20.7
        processVal: pidScreenRoot.vesselTemp
    }
}
