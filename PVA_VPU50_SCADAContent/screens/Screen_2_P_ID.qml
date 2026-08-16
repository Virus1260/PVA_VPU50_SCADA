import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../components/widgets/Screen_2_PID"
import "../config"

Rectangle {
    id: pidScreenRoot
    color: "#0a2d52"
    clip: true

    ScadaConfig { id: scadaConfig }
    ScadaStateMiddleware { id: scadaBridge }
    property alias scadaBridge: scadaBridge

    // Base Coordinate Canvas Dimensions (Full P&ID System Canvas)
    readonly property real worldWidth: 1440
    readonly property real worldHeight: 840

    // Zoom & Pan State
    property real zoomScale: 1.0
    property real minZoom: 0.65
    property real maxZoom: 2.5
    property real rawPanX: 0
    property real rawPanY: 0
    property bool showTags: true

    readonly property real actualContentWidth: worldWidth * zoomScale
    readonly property real actualContentHeight: worldHeight * zoomScale

    // Padding Margins for Panning (Allows reaching all outer pipes & valves comfortably)
    readonly property real edgeMarginX: 80
    readonly property real edgeMarginY: 60

    // Intelligent Centering & Strict Viewport Boundary Clamping
    readonly property real minAllowedPanX: actualContentWidth <= width ? (width - actualContentWidth) / 2 : (width - actualContentWidth - edgeMarginX)
    readonly property real maxAllowedPanX: actualContentWidth <= width ? (width - actualContentWidth) / 2 : edgeMarginX

    readonly property real minAllowedPanY: actualContentHeight <= height ? (height - actualContentHeight) / 2 : (height - actualContentHeight - edgeMarginY)
    readonly property real maxAllowedPanY: actualContentHeight <= height ? (height - actualContentHeight) / 2 : edgeMarginY

    readonly property real displayX: actualContentWidth <= width ? (width - actualContentWidth) / 2 : Math.max(minAllowedPanX, Math.min(maxAllowedPanX, rawPanX))
    readonly property real displayY: actualContentHeight <= height ? (height - actualContentHeight) / 2 : Math.max(minAllowedPanY, Math.min(maxAllowedPanY, rawPanY))

    Component.onCompleted: {
        rawPanX = (width - actualContentWidth) / 2;
        rawPanY = (height - actualContentHeight) / 2;
    }

    signal componentTapped(string tagName)

    // =========================================================================
    // 1. TOP-LEFT OVERVIEW NAVIGATOR & LIVE INTERACTIVE MINIMAP
    // =========================================================================
    PidMinimap {
        id: pidMinimap
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 14
        z: 100
        contentWidth: pidScreenRoot.worldWidth
        contentHeight: pidScreenRoot.worldHeight
        viewX: pidScreenRoot.displayX
        viewY: pidScreenRoot.displayY
        viewWidth: pidScreenRoot.width
        viewHeight: pidScreenRoot.height
        zoomScale: pidScreenRoot.zoomScale
        isLegendActive: pidScreenRoot.showTags
        targetSourceItem: ui.worldContainer

        onLegendToggled: {
            pidScreenRoot.showTags = !pidScreenRoot.showTags;
        }

        onPanRequested: function(tx, ty) {
            pidScreenRoot.rawPanX = Math.max(pidScreenRoot.minAllowedPanX, Math.min(pidScreenRoot.maxAllowedPanX, tx));
            pidScreenRoot.rawPanY = Math.max(pidScreenRoot.minAllowedPanY, Math.min(pidScreenRoot.maxAllowedPanY, ty));
        }
    }

    // =========================================================================
    // 2. TOUCHSCREEN & MOUSE MULTI-TOUCH PAN & ZOOM ENGINE
    // =========================================================================
    PinchArea {
        id: pinchArea
        anchors.fill: parent

        property real initialZoom: 1.0

        onPinchStarted: {
            initialZoom = pidScreenRoot.zoomScale;
        }

        onPinchUpdated: function(pinch) {
            var newZoom = Math.max(pidScreenRoot.minZoom, Math.min(pidScreenRoot.maxZoom, initialZoom * pinch.scale));
            pidScreenRoot.zoomScale = newZoom;
            pidScreenRoot.rawPanX += pinch.previousCenter.x - pinch.center.x;
            pidScreenRoot.rawPanY += pinch.previousCenter.y - pinch.center.y;
        }

        MouseArea {
            id: dragMouseArea
            anchors.fill: parent
            hoverEnabled: true

            property real lastX: 0
            property real lastY: 0
            property bool isDragging: false

            onPressed: function(mouse) {
                lastX = mouse.x;
                lastY = mouse.y;
                isDragging = true;
            }

            onPositionChanged: function(mouse) {
                if (isDragging && (mouse.buttons & Qt.LeftButton)) {
                    var dx = mouse.x - lastX;
                    var dy = mouse.y - lastY;
                    lastX = mouse.x;
                    lastY = mouse.y;

                    pidScreenRoot.rawPanX = Math.max(pidScreenRoot.minAllowedPanX, Math.min(pidScreenRoot.maxAllowedPanX, pidScreenRoot.rawPanX + dx));
                    pidScreenRoot.rawPanY = Math.max(pidScreenRoot.minAllowedPanY, Math.min(pidScreenRoot.maxAllowedPanY, pidScreenRoot.rawPanY + dy));
                }
            }

            onReleased: {
                isDragging = false;
            }

            onWheel: function(wheel) {
                var factor = wheel.angleDelta.y > 0 ? 1.12 : 0.88;
                var oldZoom = pidScreenRoot.zoomScale;
                var newZoom = Math.max(pidScreenRoot.minZoom, Math.min(pidScreenRoot.maxZoom, oldZoom * factor));

                if (newZoom !== oldZoom) {
                    var curX = pidScreenRoot.displayX;
                    var curY = pidScreenRoot.displayY;
                    var mouseWorldX = (wheel.x - curX) / oldZoom;
                    var mouseWorldY = (wheel.y - curY) / oldZoom;

                    pidScreenRoot.zoomScale = newZoom;
                    pidScreenRoot.rawPanX = wheel.x - mouseWorldX * newZoom;
                    pidScreenRoot.rawPanY = wheel.y - mouseWorldY * newZoom;
                }
            }
        }
    }

    // =========================================================================
    // 3. DECLARATIVE QT DESIGNER FORM VIEW INSTANCE & RUNTIME BINDINGS
    // =========================================================================
    Screen_2_P_IDView {
        id: ui
        anchors.fill: parent
        showTags: pidScreenRoot.showTags
        worldScale: pidScreenRoot.zoomScale
        worldX: pidScreenRoot.displayX
        worldY: pidScreenRoot.displayY

        // Process Vessel Live Telemetry
        mainVessel.levelPercent: scadaBridge.vesselLevelPercent
        mainVessel.vesselTemp: scadaBridge.vesselTemp
        mainVessel.jacketTemp: scadaBridge.jacketTemp
        mainVessel.vacuumPressure: scadaBridge.vacuumPressure
        mainVessel.weightKg: scadaBridge.vesselWeightKg
        mainVessel.isHeating: scadaBridge.isHeating
        mainVessel.isCooling: scadaBridge.isCooling

        // Thermal Jacket Effects
        heatingEffect.isHeating: scadaBridge.isHeating
        heatingEffect.isCooling: scadaBridge.isCooling
        heatingEffect.levelPercent: scadaBridge.vesselLevelPercent

        // Agitator State & Direction Linkage
        agitator.speedRpm: scadaBridge.agitatorSpeed
        agitator.isRunning: scadaBridge.isAgitatorRunning
        agitator.rotationMode: scadaBridge.agitatorMode

        // Elevated Level Gauge
        levelGauge.levelPercent: scadaBridge.vesselLevelPercent

        // CIP Spray Balls (Dynamic Green during CIP)
        sprayBall1.isSpraying: scadaBridge.isCipActive
        sprayBall2.isSpraying: scadaBridge.isCipActive
        sprayBall3.isSpraying: scadaBridge.isCipActive

        // Unified Dedicated Piping Layer Flow Dynamics
        pipingLayer.isRecirculating: scadaBridge.isRecirculating
        pipingLayer.isHeating: scadaBridge.isHeating
        pipingLayer.isCooling: scadaBridge.isCooling
        pipingLayer.isSprayingCIP: scadaBridge.isCipActive
        pipingLayer.isHomogRunning: scadaBridge.isHomogenizerRunning

        // Bottom Homogenizer
        bottomHomog.speedRpm: scadaBridge.homogenizerSpeed
        bottomHomog.isRunning: scadaBridge.isHomogenizerRunning
        bottomHomog.onMotorClicked: pidScreenRoot.componentTapped("M 163 001")

        // Inline Heater, Circulation Pump & Seal Pot
        inlineHeater.isHeating: scadaBridge.isHeating
        circPump1.isRunning: scadaBridge.isHeating || scadaBridge.isCooling
        sealPot.isHeating: scadaBridge.isHeating
        sealPot.currentTemp: scadaBridge.jacketTemp

        // Valve Runtime State & Click Handlers
        vK163002.isOpen: scadaBridge.isHomogenizerRunning
        vK165001.isOpen: scadaBridge.isCipActive
        vK165002.isOpen: scadaBridge.isRecirculating || scadaBridge.isCipActive
        vK165003.isOpen: scadaBridge.isRecirculating
        vK168201.isOpen: false
        vK168202.isOpen: false
        vK168204.isOpen: scadaBridge.isHeating || scadaBridge.isCooling || scadaBridge.isCirculationRunning

        vK143002.mouseArea.onClicked: pidScreenRoot.componentTapped("K 143 002")
        vK143001.mouseArea.onClicked: pidScreenRoot.componentTapped("K 143 001")
        vK163002.mouseArea.onClicked: pidScreenRoot.componentTapped("K 163 002")
        vK165001.mouseArea.onClicked: pidScreenRoot.componentTapped("K 165 001")
        vK165002.mouseArea.onClicked: pidScreenRoot.componentTapped("K 165 002")
        vK165003.mouseArea.onClicked: pidScreenRoot.componentTapped("K 165 003")
        vK165004.mouseArea.onClicked: pidScreenRoot.componentTapped("K 165 004")
        vK168201.mouseArea.onClicked: pidScreenRoot.componentTapped("K 168 201")
        vK168202.mouseArea.onClicked: pidScreenRoot.componentTapped("K 168 202")
        vK168204.mouseArea.onClicked: pidScreenRoot.componentTapped("K 168 204")
    }
}
