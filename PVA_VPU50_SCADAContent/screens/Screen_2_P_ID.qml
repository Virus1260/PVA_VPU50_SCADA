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

    // Generous Padding Margins for Zoomed In Panning & Sliding
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
        targetSourceItem: worldContainer

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
    // 3. ZOOMABLE & PANNABLE WORLD CONTAINER
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
        // (A) HERO PROCESS VESSEL (UNIMIX 50 / B1) - BACKGROUND LAYER (z: 1)
        // ---------------------------------------------------------------------
        PidVessel {
            id: mainVessel
            x: 350
            y: 110
            z: 1
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

        // Modular Thermal Jacket Radiant Glow & Convection Micro-Bubbles (z: 2)
        PidHeatingEffect {
            x: mainVessel.x
            y: mainVessel.y
            z: 2
            isHeating: scadaBridge.isHeating
            isCooling: scadaBridge.isCooling
            levelPercent: scadaBridge.vesselLevelPercent
        }

        // ---------------------------------------------------------------------
        // (B) ROTATING AGITATOR & PARAVISC IMPELLER (z: 3)
        // ---------------------------------------------------------------------
        PidAgitator {
            anchors.horizontalCenter: mainVessel.horizontalCenter
            anchors.top: mainVessel.top
            anchors.topMargin: -70
            z: 3
            speedRpm: scadaBridge.agitatorSpeed
            isRunning: scadaBridge.isAgitatorRunning
            rotationMode: scadaBridge.agitatorMode
            showTags: pidScreenRoot.showTags
        }

        // ---------------------------------------------------------------------
        // (C) LEFT-SIDE UTILITY MANIFOLD GRID (HW IN, HW OUT, CW IN, CW OUT) (z: 5)
        // ---------------------------------------------------------------------
        // Manifold Utility Labels
        Text { z: 9; visible: pidScreenRoot.showTags; x: 16; y: 256; text: "CW IN"; color: scadaBridge.isCooling ? "#06b6d4" : "#8cb5dc"; font.pixelSize: 8; font.bold: true }
        Text { z: 9; visible: pidScreenRoot.showTags; x: 16; y: 316; text: "CW OUT"; color: scadaBridge.isCooling ? "#38bdf8" : "#8cb5dc"; font.pixelSize: 8; font.bold: true }
        Text { z: 9; visible: pidScreenRoot.showTags; x: 16; y: 370; text: "HW IN"; color: scadaBridge.isHeating ? "#f97316" : "#8cb5dc"; font.pixelSize: 8; font.bold: true }
        Text { z: 9; visible: pidScreenRoot.showTags; x: 16; y: 510; text: "HW OUT"; color: scadaBridge.isHeating ? "#ea580c" : "#8cb5dc"; font.pixelSize: 8; font.bold: true }

        PidPipe { z: 5; startX: 60; startY: 250; endX: 60; endY: 580; baseColor: "#1b538c" }
        PidPipe { z: 5; startX: 130; startY: 250; endX: 130; endY: 580; baseColor: "#1b538c" }

        PidValve { z: 6; x: 47; y: 260; tag: "K 168 201"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isValveOpen("K 168 201"); onClicked: pidScreenRoot.componentTapped(tag) }
        PidValve { z: 6; x: 117; y: 260; tag: "K 168 202"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isValveOpen("K 168 202"); onClicked: pidScreenRoot.componentTapped(tag) }
        PidValve { z: 6; x: 47; y: 320; tag: "K 168 204"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isValveOpen("K 168 204"); onClicked: pidScreenRoot.componentTapped(tag) }
        PidValve { z: 6; x: 117; y: 320; tag: "K 168 206"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isValveOpen("K 168 206"); onClicked: pidScreenRoot.componentTapped(tag) }
        PidValve { z: 6; x: 47; y: 380; tag: "K 168 208"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isValveOpen("K 168 208"); onClicked: pidScreenRoot.componentTapped(tag) }
        PidValve { z: 6; x: 117; y: 380; tag: "K 168 205"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isValveOpen("K 168 205"); onClicked: pidScreenRoot.componentTapped(tag) }
        PidValve { z: 6; x: 47; y: 460; tag: "K 168 207"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isValveOpen("K 168 207"); onClicked: pidScreenRoot.componentTapped(tag) }

        // Live Thermal Jacket Feed Pipes (Hot Water IN / Cold Water IN)
        PidPipe { z: 5; startX: 20; startY: 374; endX: 130; endY: 374; baseColor: "#1b538c"; isActive: scadaBridge.isHeating; flowColor: "#f97316" }
        PidPipe { z: 5; startX: 130; startY: 374; endX: 385; endY: 374; baseColor: "#1b538c"; isActive: scadaBridge.isHeating || scadaBridge.isCooling; flowColor: scadaBridge.isHeating ? "#f97316" : "#06b6d4" }

        // Live Thermal Jacket Return Pipes (Hot Water OUT / Cold Water OUT)
        PidPipe { z: 5; startX: 385; startY: 460; endX: 330; endY: 460; baseColor: "#1b538c"; isActive: scadaBridge.isHeating; flowColor: "#ea580c"; reverseFlow: true }
        PidPipe { z: 5; startX: 330; startY: 460; endX: 330; endY: 514; baseColor: "#1b538c"; isActive: scadaBridge.isHeating; flowColor: "#ea580c"; reverseFlow: true }
        PidPipe { z: 5; startX: 330; startY: 514; endX: 20; endY: 514; baseColor: "#1b538c"; isActive: scadaBridge.isHeating; flowColor: "#ea580c"; reverseFlow: true }
        PidValve { z: 6; x: 317; y: 500; tag: "K 172 002"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isHeating || scadaBridge.isValveOpen("K 172 002"); onClicked: pidScreenRoot.componentTapped(tag) }

        // ---------------------------------------------------------------------
        // (D) GAS INLET & TOP DOME FEED LINES (z: 8)
        // ---------------------------------------------------------------------
        PidPipe { z: 8; startX: 20; startY: 180; endX: 300; endY: 180; baseColor: "#1b538c" }
        PidPipe { z: 8; startX: 300; startY: 180; endX: 300; endY: 125; baseColor: "#1b538c" }
        PidPipe { z: 8; startX: 300; startY: 125; endX: 420; endY: 125; baseColor: "#1b538c" }
        Text { z: 9; visible: pidScreenRoot.showTags; x: 25; y: 164; text: "gas inlet"; color: "#8cb5dc"; font.pixelSize: 8 }
        PidValve { z: 9; x: 287; y: 166; tag: "K 166 002"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isValveOpen("K 166 002"); onClicked: pidScreenRoot.componentTapped(tag) }

        // Vacuum Transmitter Pill PIC 161001 (z: 10)
        Rectangle {
            z: 10
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
                Text { text: "PIC 161001"; color: "#8cb5dc"; font.pixelSize: 7; font.bold: true; Layout.alignment: Qt.AlignHCenter }
                Text { text: scadaBridge.vacuumPressure.toFixed(0) + "mbar"; color: "#93c5fd"; font.bold: true; font.pixelSize: 8; Layout.alignment: Qt.AlignHCenter }
            }
        }

        // Top Left Dome Relief Vent Column
        Rectangle {
            z: 8
            x: 395
            y: 110
            width: 12
            height: 24
            radius: 3
            color: "#8ec4f0"
            border.color: "#1b4c7c"
            border.width: 1.2
        }
        PidPipe { z: 8; startX: 401; startY: 15; endX: 401; endY: 110; baseColor: "#52a5ec" }

        // ---------------------------------------------------------------------
        // (E) TOP CIP CLEANING HIGH ARCH HEADER & 3 SPRAY BALLS (z: 8, z: 9)
        // ---------------------------------------------------------------------
        PidPipe { z: 8; startX: 240; startY: 15; endX: 605; endY: 15; baseColor: "#52a5ec" }
        PidPipe { z: 8; startX: 240; startY: 15; endX: 240; endY: 125; baseColor: "#52a5ec" }

        // Spray Ball 1 Vertical Drop Pipe (Left)
        PidPipe { z: 8; startX: 445; startY: 15; endX: 445; endY: 190; baseColor: "#52a5ec" }

        // Spray Ball 2 Vertical Drop Pipe (Middle-Right)
        PidPipe { z: 8; startX: 575; startY: 15; endX: 575; endY: 190; baseColor: "#52a5ec" }

        // Spray Ball 3 Dogleg Drop Pipe (Far-Right Angled)
        PidPipe { z: 8; startX: 605; startY: 15; endX: 605; endY: 145; baseColor: "#52a5ec" }
        PidPipe { z: 8; startX: 605; startY: 145; endX: 642; endY: 185; baseColor: "#52a5ec" }

        // 3 Dedicated Modular Spray Balls in Top Dome (z: 9)
        PidSprayBall {
            z: 9
            x: 427
            y: 190
            tag: "X 165 501"
            showTags: pidScreenRoot.showTags
            isSpraying: false
        }
        PidSprayBall {
            z: 9
            x: 557
            y: 190
            tag: "X 165 502"
            showTags: pidScreenRoot.showTags
            isSpraying: false
        }
        PidSprayBall {
            z: 9
            x: 624
            y: 185
            tag: "X 165 503"
            sprayAngle: 42
            showTags: pidScreenRoot.showTags
            isSpraying: scadaBridge.isHomogenizerRunning
        }

        // Top Solids Charging Hopper / Funnel (B 141 001)
        Canvas {
            z: 8
            x: 668; y: 25; width: 24; height: 24
            onPaint: {
                var ctx = getContext("2d");
                ctx.beginPath();
                ctx.moveTo(2, 2);
                ctx.lineTo(22, 2);
                ctx.lineTo(15, 20);
                ctx.lineTo(9, 20);
                ctx.closePath();
                ctx.fillStyle = "#8ec4f0";
                ctx.fill();
                ctx.strokeStyle = "#1b4c7c";
                ctx.lineWidth = 1.2;
                ctx.stroke();
            }
        }
        Text {
            z: 9
            visible: pidScreenRoot.showTags
            x: 698; y: 28
            text: "B 141 001"
            color: "#8cb5dc"
            font.pixelSize: 8
            font.bold: true
        }
        PidPipe { z: 8; startX: 680; startY: 46; endX: 680; endY: 135; baseColor: "#52a5ec" }
        PidValve { z: 9; x: 667; y: 65; tag: "K 141 001"; isVertical: true; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isValveOpen("K 141 001"); onClicked: pidScreenRoot.componentTapped(tag) }

        // Top Right Shoulder Horizontal Inlet Valve (K 161 001)
        PidPipe { z: 8; startX: 695; startY: 135; endX: 770; endY: 135; baseColor: "#52a5ec" }
        PidValve { z: 9; x: 720; y: 121; tag: "K 161 001"; showTags: pidScreenRoot.showTags; isOpen: scadaBridge.isValveOpen("K 161 001"); onClicked: pidScreenRoot.componentTapped(tag) }

        // Horizontal Lid Lifter Bracket Hinge Bar (z: 7)
        Rectangle {
            z: 7
            x: 690
            y: 155
            width: 175
            height: 7
            radius: 2
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#334155" }
                GradientStop { position: 1.0; color: "#0f172a" }
            }
            border.color: "#475569"
            border.width: 1
        }

        // ---------------------------------------------------------------------
        // (F) BOTTOM HIGH-SHEAR HOMOGENIZER (Exact Structure) (z: 6)
        // ---------------------------------------------------------------------
        PidHomogenizer {
            id: bottomHomog
            x: 300
            y: 458
            z: 6
            speedRpm: scadaBridge.homogenizerSpeed
            isRunning: scadaBridge.isHomogenizerRunning
            showTags: pidScreenRoot.showTags
            onSuctionSolidsClicked: pidScreenRoot.componentTapped("K 143 002")
            onSuctionLiquidsClicked: pidScreenRoot.componentTapped("K 143 001")
            onRecircValveClicked: pidScreenRoot.componentTapped("K 163 002")
            onMotorClicked: pidScreenRoot.componentTapped("M 163 001")
        }

        // Bottom Right Suction Branch V 142 201 (Suction Bottom)
        PidPipe { z: 6; startX: 590; startY: 438; endX: 600; endY: 462; baseColor: "#52a5ec" }
        PidValve {
            z: 7
            x: 588
            y: 450
            tag: "V 142 201"
            subLabel: "Suction Bottom"
            showTags: pidScreenRoot.showTags
            isOpen: scadaBridge.isValveOpen("V 142 201")
            onClicked: pidScreenRoot.componentTapped(tag)
        }

        // ---------------------------------------------------------------------
        // (G) EXTERNAL HOMOGENIZATION RECIRCULATION LOOP (z: 6)
        // ---------------------------------------------------------------------
        PidPipe { z: 6; startX: 680; startY: 532; endX: 810; endY: 532; isActive: scadaBridge.isHomogenizerRunning; flowColor: "#38ef7d" }
        PidPipe { z: 6; startX: 810; startY: 532; endX: 810; endY: 205; isActive: scadaBridge.isHomogenizerRunning; flowColor: "#38ef7d"; reverseFlow: true }
        PidPipe { z: 6; startX: 810; startY: 205; endX: 660; endY: 205; isActive: scadaBridge.isHomogenizerRunning; flowColor: "#38ef7d" }

        // Corner Valve K 165 002
        PidValve {
            z: 7
            x: 800
            y: 520
            tag: "K 165 002"
            showTags: pidScreenRoot.showTags
            isOpen: scadaBridge.isHomogenizerRunning
            onClicked: pidScreenRoot.componentTapped(tag)
        }

        // Return Valve K 165 003
        PidValve {
            z: 7
            x: 725
            y: 191
            tag: "K 165 003"
            showTags: pidScreenRoot.showTags
            isOpen: scadaBridge.isHomogenizerRunning
            onClicked: pidScreenRoot.componentTapped(tag)
        }

        // Sensor Indicator GOS 172 601 on Vertical Riser
        Rectangle {
            z: 8
            x: 818
            y: 500
            width: 8
            height: 8
            radius: 4
            color: scadaBridge.isHomogenizerRunning ? "#22c55e" : "#475569"
            Text { visible: pidScreenRoot.showTags; x: 12; y: -2; text: "GOS 172 601"; color: "#8cb5dc"; font.pixelSize: 7 }
        }

        // ---------------------------------------------------------------------
        // (H) ELECTRIC MOTOR DRIVEN LID LIFTER SCREW MECHANISM (z: 6)
        // ---------------------------------------------------------------------
        PidLidLifter {
            x: 785
            y: 100
            z: 6
            showTags: pidScreenRoot.showTags
        }

        // ---------------------------------------------------------------------
        // (I) LIVE PID TEMPERATURE CONTROL TELEMETRY BOX (z: 15)
        // ---------------------------------------------------------------------
        PidControlBox {
            x: 35
            y: 500
            z: 15
            visible: pidScreenRoot.showTags
            setpointTemp: scadaBridge.targetTemp
            gradientSp: 20.7
            processVal: scadaBridge.vesselTemp
        }
    }
}
