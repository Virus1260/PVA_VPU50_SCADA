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
        PidPipe { startX: 60; startY: 250; endX: 60; endY: 580; baseColor: "#1b538c" }
        PidPipe { startX: 130; startY: 250; endX: 130; endY: 580; baseColor: "#1b538c" }

        PidValve { x: 47; y: 260; tag: "K 168 201"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isValveOpen("K 168 201"); onClicked: pidScreenRoot.componentTapped(tag) }
        PidValve { x: 117; y: 260; tag: "K 168 202"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isValveOpen("K 168 202"); onClicked: pidScreenRoot.componentTapped(tag) }
        PidValve { x: 47; y: 320; tag: "K 168 204"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isValveOpen("K 168 204"); onClicked: pidScreenRoot.componentTapped(tag) }
        PidValve { x: 117; y: 320; tag: "K 168 206"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isValveOpen("K 168 206"); onClicked: pidScreenRoot.componentTapped(tag) }
        PidValve { x: 47; y: 380; tag: "K 168 208"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isValveOpen("K 168 208"); onClicked: pidScreenRoot.componentTapped(tag) }
        PidValve { x: 117; y: 380; tag: "K 168 205"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isValveOpen("K 168 205"); onClicked: pidScreenRoot.componentTapped(tag) }
        PidValve { x: 47; y: 460; tag: "K 168 207"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isValveOpen("K 168 207"); onClicked: pidScreenRoot.componentTapped(tag) }

        // Thermal Jacket Feed Pipes
        PidPipe { startX: 130; startY: 334; endX: 395; endY: 334; baseColor: "#1b538c"; isActive: scadaBridge.isHeating || scadaBridge.isCooling; flowColor: scadaBridge.isHeating ? "#f97316" : "#06b6d4" }
        PidPipe { startX: 130; startY: 474; endX: 330; endY: 474; baseColor: "#1b538c" }
        PidPipe { startX: 330; startY: 474; endX: 330; endY: 420; baseColor: "#1b538c" }
        PidPipe { startX: 330; startY: 420; endX: 395; endY: 420; baseColor: "#1b538c" }
        PidValve { x: 317; y: 460; tag: "K 172 002"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isValveOpen("K 172 002"); onClicked: pidScreenRoot.componentTapped(tag) }

        // ---------------------------------------------------------------------
        // (B) GAS INLET & TOP DOME FEED LINES
        // ---------------------------------------------------------------------
        PidPipe { startX: 20; startY: 180; endX: 300; endY: 180; baseColor: "#1b538c" }
        PidPipe { startX: 300; startY: 180; endX: 300; endY: 125; baseColor: "#1b538c" }
        PidPipe { startX: 300; startY: 125; endX: 430; endY: 125; baseColor: "#1b538c" }
        Text { visible: pidScreenRoot.showTags; x: 25; y: 164; text: "gas inlet"; color: "#8cb5dc"; font.pixelSize: 8 }
        PidValve { x: 287; y: 166; tag: "K 166 002"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isValveOpen("K 166 002"); onClicked: pidScreenRoot.componentTapped(tag) }

        // Vacuum Transmitter Pill PIC 161001 (Spaced cleanly outside dome)
        Rectangle {
            x: 230
            y: 95
            width: 76
            height: 26
            radius: 3
            color: "#0b2e54"
            border.color: "#1d609e"
            border.width: 1
            visible: pidScreenRoot.showTags

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 0
                Text { text: "PIC 161001"; color: "#8cb5dc"; font.pixelSize: 7; Layout.alignment: Qt.AlignHCenter }
                Text { text: scadaBridge.vacuumPressure.toFixed(0) + "mbar"; color: "#93c5fd"; font.bold: true; font.pixelSize: 8; Layout.alignment: Qt.AlignHCenter }
            }
        }

        // Top CIP Spray Cleaning Header Line
        PidPipe { startX: 330; startY: 40; endX: 610; endY: 40; baseColor: "#1b538c" }
        PidPipe { startX: 360; startY: 40; endX: 360; endY: 95; baseColor: "#1b538c" }
        PidPipe { startX: 430; startY: 40; endX: 430; endY: 95; baseColor: "#1b538c" }
        PidPipe { startX: 490; startY: 40; endX: 490; endY: 95; baseColor: "#1b538c" }
        PidPipe { startX: 600; startY: 40; endX: 600; endY: 95; baseColor: "#1b538c" }

        PidValve { x: 347; y: 26; tag: "K 161 002"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isValveOpen("K 161 002"); onClicked: pidScreenRoot.componentTapped(tag) }
        PidValve { x: 417; y: 26; tag: "K 161 003"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isValveOpen("K 161 003"); onClicked: pidScreenRoot.componentTapped(tag) }

        // Vacuum Extraction Valve
        PidValve { x: 477; y: 55; tag: "K 171 001"; isVertical: true; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isVacuumActive; onClicked: pidScreenRoot.componentTapped(tag) }

        // Top Solids Charging Hopper / Funnel
        Canvas {
            x: 638; y: 15; width: 26; height: 26
            onPaint: {
                var ctx = getContext("2d");
                ctx.beginPath();
                ctx.moveTo(2, 2);
                ctx.lineTo(24, 2);
                ctx.lineTo(16, 22);
                ctx.lineTo(10, 22);
                ctx.closePath();
                ctx.fillStyle = "#8ec4f0";
                ctx.fill();
                ctx.strokeStyle = "#1b4c7c";
                ctx.lineWidth = 1.2;
                ctx.stroke();
            }
        }
        PidPipe { startX: 651; startY: 38; endX: 651; endY: 100; baseColor: "#1b538c" }
        PidValve { x: 638; y: 55; tag: "K 141 001"; isVertical: true; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isValveOpen("K 141 001"); onClicked: pidScreenRoot.componentTapped(tag) }

        // ---------------------------------------------------------------------
        // (C) HERO PROCESS VESSEL (UNIMIX 50 / B1)
        // ---------------------------------------------------------------------
        PidVessel {
            id: mainVessel
            x: 370
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
            anchors.topMargin: -32
            speedRpm: scadaBridge.agitatorSpeed
            isRunning: scadaBridge.isAgitatorRunning
            showTags: pidScreenRoot.showTags
        }

        // 3 Authentic Hanging Spray Balls in Top Dome
        PidSprayBall {
            x: 440
            y: 145
            tag: "X 161 001"
            isSpraying: false
        }
        PidSprayBall {
            x: 588
            y: 145
            tag: "X 161 002"
            isSpraying: false
        }
        PidSprayBall {
            x: 630
            y: 158
            tag: "X 161 003"
            sprayAngle: 30
            isSpraying: scadaBridge.isHomogenizerRunning
        }

        // ---------------------------------------------------------------------
        // (D) BOTTOM HIGH-SHEAR HOMOGENIZER ROTOR/STATOR CHAMBER
        // ---------------------------------------------------------------------
        PidHomogenizer {
            id: bottomHomog
            x: 350
            y: 415
            speedRpm: scadaBridge.homogenizerSpeed
            isRunning: scadaBridge.isHomogenizerRunning
            showTags: pidScreenRoot.showTags
            onSuctionSolidsClicked: pidScreenRoot.componentTapped("K 143 002")
            onSuctionLiquidsClicked: pidScreenRoot.componentTapped("K 143 001")
            onStatorValveClicked: pidScreenRoot.componentTapped("Z 163 001")
            onRecircValveClicked: pidScreenRoot.componentTapped("K 163 002")
        }

        // Bottom Right Suction Branch V 142 201 (Suction Bottom)
        PidPipe { startX: 595; startY: 395; endX: 625; endY: 425; baseColor: "#52a5ec" }
        PidValve {
            x: 615
            y: 412
            tag: "V 142 201"
            subLabel: "Suction Bottom"
            showTags: pidScreenRoot.showTags
            isOpen: scadaBridge.isValveOpen("V 142 201")
            onClicked: pidScreenRoot.componentTapped(tag)
        }

        // ---------------------------------------------------------------------
        // (E) EXTERNAL HOMOGENIZATION RECIRCULATION LOOP (Bottom -> Top Dome)
        // ---------------------------------------------------------------------
        PidPipe { startX: 690; startY: 460; endX: 790; endY: 460; isActive: scadaBridge.isHomogenizerRunning; flowColor: "#38ef7d" }
        PidPipe { startX: 790; startY: 460; endX: 790; endY: 140; isActive: scadaBridge.isHomogenizerRunning; flowColor: "#38ef7d"; reverseFlow: true }
        PidPipe { startX: 790; startY: 140; endX: 642; endY: 140; isActive: scadaBridge.isHomogenizerRunning; flowColor: "#38ef7d" }

        PidValve { x: 777; y: 446; tag: "K 165 002"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isHomogenizerRunning; onClicked: pidScreenRoot.componentTapped(tag) }
        PidValve { x: 715; y: 126; tag: "K 165 003"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isHomogenizerRunning; onClicked: pidScreenRoot.componentTapped(tag) }

        // Sensor Indicator GOS 172 601 on Vertical Riser
        Rectangle {
            x: 798
            y: 430
            width: 8
            height: 8
            radius: 4
            color: scadaBridge.isHomogenizerRunning ? "#22c55e" : "#475569"
            Text { visible: pidScreenRoot.showTags; x: 12; y: -2; text: "GOS 172 601"; color: "#8cb5dc"; font.pixelSize: 7 }
        }

        // ---------------------------------------------------------------------
        // (F) ELECTRIC MOTOR DRIVEN LID LIFTER SCREW MECHANISM
        // ---------------------------------------------------------------------
        PidLidLifter {
            x: 690
            y: 70
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
