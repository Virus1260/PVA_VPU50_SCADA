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

    // Dynamic Centering Calculation
    readonly property real actualContentWidth: worldWidth * zoomScale
    readonly property real actualContentHeight: worldHeight * zoomScale

    readonly property real displayX: actualContentWidth < width
                                      ? (width - actualContentWidth) / 2
                                      : Math.max(width - actualContentWidth, Math.min(0, rawPanX))

    readonly property real displayY: actualContentHeight < height
                                      ? (height - actualContentHeight) / 2
                                      : Math.max(height - actualContentHeight, Math.min(0, rawPanY))

    signal componentTapped(string tagName)

    // =========================================================================
    // 1. TOP-LEFT OVERVIEW NAVIGATOR & INTERACTIVE MINIMAP
    // =========================================================================
    PidMinimap {
        id: pidMinimap
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 14
        z: 30
        contentWidth: pidScreenRoot.worldWidth
        contentHeight: pidScreenRoot.worldHeight
        viewX: pidScreenRoot.displayX
        viewY: pidScreenRoot.displayY
        viewWidth: pidScreenRoot.width
        viewHeight: pidScreenRoot.height
        zoomScale: pidScreenRoot.zoomScale
        isLegendActive: pidScreenRoot.showTags

        onLegendToggled: {
            pidScreenRoot.showTags = !pidScreenRoot.showTags;
        }

        onPanRequested: function(tx, ty) {
            if (pidScreenRoot.actualContentWidth > pidScreenRoot.width) {
                pidScreenRoot.rawPanX = Math.max(pidScreenRoot.width - pidScreenRoot.actualContentWidth, Math.min(0, tx));
            }
            if (pidScreenRoot.actualContentHeight > pidScreenRoot.height) {
                pidScreenRoot.rawPanY = Math.max(pidScreenRoot.height - pidScreenRoot.actualContentHeight, Math.min(0, ty));
            }
        }
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
        z: 30
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

                    pidScreenRoot.rawPanX += dx;
                    pidScreenRoot.rawPanY += dy;
                }
            }

            onReleased: {
                isDragging = false;
            }

            // Mouse Wheel Relative Zooming at Current Cursor Location
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
    // 3. ZOOMABLE & PANNABLE WORLD CONTAINER (Authentic EKATO Schematic)
    // =========================================================================
    Item {
        id: worldContainer
        x: pidScreenRoot.displayX
        y: pidScreenRoot.displayY
        width: pidScreenRoot.worldWidth
        height: pidScreenRoot.worldHeight
        scale: pidScreenRoot.zoomScale
        transformOrigin: Item.TopLeft

        // ---------------------------------------------------------------------
        // (A) LEFT-SIDE UTILITY MANIFOLD GRID (Steam, Water, Gas, Venting)
        // ---------------------------------------------------------------------
        // Vertical Headers
        PidPipe { startX: 60; startY: 250; endX: 60; endY: 580; baseColor: "#1b538c" }
        PidPipe { startX: 130; startY: 250; endX: 130; endY: 580; baseColor: "#1b538c" }

        // Manifold Valves
        PidValve { x: 47; y: 260; tag: "K 168 201"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isValveOpen("K 168 201"); onClicked: pidScreenRoot.componentTapped(tag) }
        PidValve { x: 117; y: 260; tag: "K 168 202"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isValveOpen("K 168 202"); onClicked: pidScreenRoot.componentTapped(tag) }
        PidValve { x: 47; y: 320; tag: "K 168 204"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isValveOpen("K 168 204"); onClicked: pidScreenRoot.componentTapped(tag) }
        PidValve { x: 117; y: 320; tag: "K 168 206"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isValveOpen("K 168 206"); onClicked: pidScreenRoot.componentTapped(tag) }
        PidValve { x: 47; y: 380; tag: "K 168 208"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isValveOpen("K 168 208"); onClicked: pidScreenRoot.componentTapped(tag) }
        PidValve { x: 117; y: 380; tag: "K 168 205"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isValveOpen("K 168 205"); onClicked: pidScreenRoot.componentTapped(tag) }
        PidValve { x: 47; y: 460; tag: "K 168 207"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isValveOpen("K 168 207"); onClicked: pidScreenRoot.componentTapped(tag) }

        // Thermal Jacket Feed Pipes
        PidPipe { startX: 130; startY: 334; endX: 410; endY: 334; baseColor: "#1b538c"; isActive: scadaBridge.isHeating || scadaBridge.isCooling; flowColor: scadaBridge.isHeating ? "#f97316" : "#06b6d4" }
        PidPipe { startX: 130; startY: 474; endX: 340; endY: 474; baseColor: "#1b538c" }
        PidPipe { startX: 340; startY: 474; endX: 340; endY: 420; baseColor: "#1b538c" }
        PidPipe { startX: 340; startY: 420; endX: 410; endY: 420; baseColor: "#1b538c" }
        PidValve { x: 327; y: 460; tag: "K 172 002"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isValveOpen("K 172 002"); onClicked: pidScreenRoot.componentTapped(tag) }

        // ---------------------------------------------------------------------
        // (B) GAS INLET & TOP DOME FEED LINES
        // ---------------------------------------------------------------------
        PidPipe { startX: 20; startY: 170; endX: 330; endY: 170; baseColor: "#1b538c" }
        PidPipe { startX: 330; startY: 170; endX: 330; endY: 125; baseColor: "#1b538c" }
        PidPipe { startX: 330; startY: 125; endX: 460; endY: 125; baseColor: "#1b538c" }
        Text { visible: pidScreenRoot.showTags; x: 25; y: 154; text: "gas inlet"; color: "#8cb5dc"; font.pixelSize: 8 }
        PidValve { x: 317; y: 156; tag: "K 166 002"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isValveOpen("K 166 002"); onClicked: pidScreenRoot.componentTapped(tag) }

        // Top CIP Spray Cleaning Line
        PidPipe { startX: 340; startY: 60; endX: 620; endY: 60; baseColor: "#1b538c" }
        PidPipe { startX: 370; startY: 60; endX: 370; endY: 115; baseColor: "#1b538c" }
        PidPipe { startX: 430; startY: 60; endX: 430; endY: 115; baseColor: "#1b538c" }
        PidPipe { startX: 570; startY: 60; endX: 570; endY: 115; baseColor: "#1b538c" }
        PidPipe { startX: 620; startY: 60; endX: 620; endY: 115; baseColor: "#1b538c" }

        PidValve { x: 357; y: 46; tag: "K 161 002"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isValveOpen("K 161 002"); onClicked: pidScreenRoot.componentTapped(tag) }
        PidValve { x: 417; y: 46; tag: "K 161 003"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isValveOpen("K 161 003"); onClicked: pidScreenRoot.componentTapped(tag) }
        PidValve { x: 557; y: 85; tag: "K 141 001"; isVertical: true; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isValveOpen("K 141 001"); onClicked: pidScreenRoot.componentTapped(tag) }

        // Top Solids Charging Hopper / Funnel
        Canvas {
            x: 557; y: 55; width: 26; height: 26
            onPaint: {
                var ctx = getContext("2d");
                ctx.beginPath();
                ctx.moveTo(3, 3);
                ctx.lineTo(23, 3);
                ctx.lineTo(15, 20);
                ctx.lineTo(11, 20);
                ctx.closePath();
                ctx.fillStyle = "#8ec4f0";
                ctx.fill();
                ctx.strokeStyle = "#1b4c7c";
                ctx.stroke();
            }
        }

        // Vacuum Extraction Valve
        PidValve { x: 417; y: 80; tag: "K 171 001"; isVertical: true; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isVacuumActive; onClicked: pidScreenRoot.componentTapped(tag) }

        // Spray Ball Heads inside Top Dome
        PidSprayBall { x: 445; y: 118; tag: "X 161 001"; isSpraying: false }
        PidSprayBall { x: 515; y: 118; tag: "X 161 002"; isSpraying: false }
        PidSprayBall { x: 550; y: 118; tag: "X 161 003"; isSpraying: scadaBridge.isHomogenizerRunning }

        // ---------------------------------------------------------------------
        // (C) HERO PROCESS VESSEL (UNIMIX 50 / B1)
        // ---------------------------------------------------------------------
        PidVessel {
            id: mainVessel
            x: 390
            y: 70
            vesselName: "Unimix 50"
            levelPercent: scadaBridge.vesselLevelPercent
            vesselTemp: scadaBridge.vesselTemp
            jacketTemp: scadaBridge.jacketTemp
            vacuumPressure: scadaBridge.vacuumPressure
            weightKg: scadaBridge.vesselWeightKg
            isHeating: scadaBridge.isHeating
            isCooling: scadaBridge.isCooling
            showTags: pidScreenRoot.showTags
        }

        // Top Drive Motor & Paravisc Double X-Braced Impeller
        PidAgitator {
            anchors.horizontalCenter: mainVessel.horizontalCenter
            anchors.top: mainVessel.top
            anchors.topMargin: -12
            speedRpm: scadaBridge.agitatorSpeed
            isRunning: scadaBridge.isAgitatorRunning
            showTags: pidScreenRoot.showTags
        }

        // Bottom High-Shear Homogenizer Rotor/Stator Chamber
        PidHomogenizer {
            anchors.horizontalCenter: mainVessel.horizontalCenter
            anchors.top: mainVessel.bottom
            anchors.topMargin: -32
            speedRpm: scadaBridge.homogenizerSpeed
            isRunning: scadaBridge.isHomogenizerRunning
            showTags: pidScreenRoot.showTags
        }

        // ---------------------------------------------------------------------
        // (D) EXTERNAL HOMOGENIZATION RECIRCULATION LOOP (Bottom -> Top Dome)
        // ---------------------------------------------------------------------
        PidPipe { startX: 570; startY: 435; endX: 680; endY: 435; isActive: scadaBridge.isHomogenizerRunning; flowColor: "#38ef7d" }
        PidPipe { startX: 680; startY: 435; endX: 680; endY: 135; isActive: scadaBridge.isHomogenizerRunning; flowColor: "#38ef7d"; reverseFlow: true }
        PidPipe { startX: 680; startY: 135; endX: 580; endY: 135; isActive: scadaBridge.isHomogenizerRunning; flowColor: "#38ef7d" }

        PidValve { x: 545; y: 421; tag: "K 163 002"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isHomogenizerRunning; onClicked: pidScreenRoot.componentTapped(tag) }
        PidValve { x: 615; y: 421; tag: "K 165 002"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isHomogenizerRunning; onClicked: pidScreenRoot.componentTapped(tag) }
        PidValve { x: 620; y: 121; tag: "K 165 003"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isHomogenizerRunning; onClicked: pidScreenRoot.componentTapped(tag) }

        // Sensor Indicator GOS 172 601 on Vertical Riser
        Rectangle {
            x: 688
            y: 410
            width: 8
            height: 8
            radius: 4
            color: scadaBridge.isHomogenizerRunning ? "#22c55e" : "#475569"
            Text { visible: pidScreenRoot.showTags; x: 12; y: -2; text: "GOS 172 601"; color: "#8cb5dc"; font.pixelSize: 7 }
        }

        // ---------------------------------------------------------------------
        // (E) SUCTION INLETS (Solids, Liquids, Foot Switch & Bottom Drain)
        // ---------------------------------------------------------------------
        PidPipe { startX: 420; startY: 415; endX: 530; endY: 415; baseColor: "#1b538c" }
        PidPipe { startX: 420; startY: 445; endX: 530; endY: 445; baseColor: "#1b538c" }

        PidValve { x: 440; y: 401; tag: "K 143 002"; subLabel: "Solids"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isValveOpen("K 143 002"); onClicked: pidScreenRoot.componentTapped(tag) }
        PidValve { x: 440; y: 431; tag: "K 143 001"; subLabel: "Liquids"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isValveOpen("K 143 001"); onClicked: pidScreenRoot.componentTapped(tag) }

        RowLayout {
            x: 395
            y: 460
            spacing: 4
            visible: pidScreenRoot.showTags
            Rectangle { width: 8; height: 8; radius: 4; color: "#ffffff" }
            Text { text: "foot switch"; color: "#cbd5e1"; font.pixelSize: 7 }
        }

        PidPipe { startX: 580; startY: 390; endX: 620; endY: 390; baseColor: "#1b538c" }
        PidValve { x: 590; y: 376; tag: "V 142 201"; subLabel: "Suction Bottom"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isValveOpen("V 142 201"); onClicked: pidScreenRoot.componentTapped(tag) }

        // ---------------------------------------------------------------------
        // (F) HYDRAULIC LID LIFTER & SWIVELLING DEVICE
        // ---------------------------------------------------------------------
        PidLidLifter {
            x: 690
            y: 100
            showTags: pidScreenRoot.showTags
        }

        // ---------------------------------------------------------------------
        // (G) LIVE PID TEMPERATURE CONTROL TELEMETRY BOX
        // ---------------------------------------------------------------------
        PidControlBox {
            x: 35
            y: 500
            visible: pidScreenRoot.showTags
            setpointTemp: scadaBridge.targetTemp
            gradientSp: 20.7
            processVal: scadaBridge.vesselTemp
        }
    }
}
