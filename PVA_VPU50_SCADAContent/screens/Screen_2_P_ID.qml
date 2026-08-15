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

    // Base Coordinate Canvas Dimensions
    readonly property real worldWidth: 1060
    readonly property real worldHeight: 630

    // Zoom & Pan State
    property real zoomScale: 1.0
    property real minZoom: 0.65
    property real maxZoom: 2.5
    property real rawPanX: 0
    property real rawPanY: 0
    property bool showTags: true

    // Padding Margins for Zoomed In Panning & Sliding
    readonly property real marginPadX: 200
    readonly property real marginPadY: 160

    readonly property real actualContentWidth: worldWidth * zoomScale
    readonly property real actualContentHeight: worldHeight * zoomScale

    readonly property real minAllowedPanX: width - actualContentWidth - marginPadX
    readonly property real maxAllowedPanX: marginPadX
    readonly property real minAllowedPanY: height - actualContentHeight - marginPadY
    readonly property real maxAllowedPanY: marginPadY

    readonly property real displayX: actualContentWidth <= width
                                      ? (width - actualContentWidth) / 2
                                      : Math.max(minAllowedPanX, Math.min(maxAllowedPanX, rawPanX))

    readonly property real displayY: actualContentHeight <= height
                                      ? (height - actualContentHeight) / 2
                                      : Math.max(minAllowedPanY, Math.min(maxAllowedPanY, rawPanY))

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

        // Bottom Homogenizer
        bottomHomog.speedRpm: scadaBridge.homogenizerSpeed
        bottomHomog.isRunning: scadaBridge.isHomogenizerRunning
        bottomHomog.onSuctionSolidsClicked: pidScreenRoot.componentTapped("K 143 002")
        bottomHomog.onSuctionLiquidsClicked: pidScreenRoot.componentTapped("K 143 001")
        bottomHomog.onRecircValveClicked: pidScreenRoot.componentTapped("K 163 002")
        bottomHomog.onMotorClicked: pidScreenRoot.componentTapped("M 163 001")

        // Temperature Control Telemetry Box
        controlBox.setpointTemp: scadaBridge.targetTemp
        controlBox.gradientSp: 20.7
        controlBox.processVal: scadaBridge.vesselTemp
    }
}
