import QtQuick
import QtQuick.Layouts

Item {
    id: minimapRoot
    width: 290
    height: 110

    property real contentWidth: 1440
    property real contentHeight: 840
    property real viewX: 0
    property real viewY: 0
    property real viewWidth: 1440
    property real viewHeight: 840
    property real zoomScale: 1.0
    property bool isLegendActive: true
    property Item targetSourceItem: null

    signal panRequested(real targetX, real targetY)
    signal legendToggled()
    signal manualModeClicked()

    RowLayout {
        anchors.fill: parent
        spacing: 8

        // 1. LIVE MIRROR MINIMAP PREVIEW BOX (Hardware Accelerated Live Feed)
        Rectangle {
            id: mapBox
            Layout.preferredWidth: 176
            Layout.fillHeight: true
            color: "#07203b"
            border.color: "#1d4ed8"
            border.width: 1.5
            radius: 5
            clip: true

            // Live Hardware-Accelerated Exact Mirror of Main P&ID World
            ShaderEffectSource {
                id: liveMirror
                anchors.fill: parent
                sourceItem: minimapRoot.targetSourceItem
                live: true
                hideSource: false
                smooth: true
                visible: minimapRoot.targetSourceItem !== null
            }

            // Fallback Vector Rendering if ShaderEffectSource is not available
            Canvas {
                id: thumbCanvas
                anchors.fill: parent
                visible: minimapRoot.targetSourceItem === null

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.clearRect(0, 0, width, height);

                    var sx = width / minimapRoot.contentWidth;
                    var sy = height / minimapRoot.contentHeight;

                    // Utility Lines
                    ctx.strokeStyle = "#1b538c";
                    ctx.lineWidth = 1.2;
                    ctx.beginPath();
                    ctx.moveTo(60 * sx, 250 * sy);
                    ctx.lineTo(60 * sx, 580 * sy);
                    ctx.moveTo(130 * sx, 250 * sy);
                    ctx.lineTo(130 * sx, 580 * sy);
                    ctx.stroke();

                    // Vessel
                    var cx = 720 * sx;
                    var vy = 160 * sy;
                    var vw = 400 * sx;
                    var vh = 420 * sy;
                    ctx.fillStyle = "#79b2e2";
                    ctx.strokeStyle = "#1b4c7c";
                    ctx.beginPath();
                    ctx.rect(cx - vw / 2, vy, vw, vh);
                    ctx.fill();
                    ctx.stroke();
                }
            }

            // Interactive Golden Viewport Frame (Accurately Tracks Zoom & Pan)
            Rectangle {
                id: selectionFrame
                readonly property real mapScaleX: mapBox.width / (minimapRoot.contentWidth * minimapRoot.zoomScale)
                readonly property real mapScaleY: mapBox.height / (minimapRoot.contentHeight * minimapRoot.zoomScale)

                x: Math.max(0, Math.min(mapBox.width - width, (-minimapRoot.viewX) * mapScaleX))
                y: Math.max(0, Math.min(mapBox.height - height, (-minimapRoot.viewY) * mapScaleY))
                width: Math.max(10, Math.min(mapBox.width, minimapRoot.viewWidth * mapScaleX))
                height: Math.max(10, Math.min(mapBox.height, minimapRoot.viewHeight * mapScaleY))
                color: "#30f59e0b"
                border.color: "#f59e0b"
                border.width: 1.8
                radius: 2
            }

            // Interactive Click & Drag to Pan
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.SizeAllCursor

                function updatePan(mouse) {
                    var normX = mouse.x / mapBox.width;
                    var normY = mouse.y / mapBox.height;
                    var targetX = -(normX * minimapRoot.contentWidth * minimapRoot.zoomScale - minimapRoot.viewWidth / 2);
                    var targetY = -(normY * minimapRoot.contentHeight * minimapRoot.zoomScale - minimapRoot.viewHeight / 2);
                    minimapRoot.panRequested(targetX, targetY);
                }

                onPressed: function(mouse) { updatePan(mouse); }
                onPositionChanged: function(mouse) {
                    if (mouse.buttons & Qt.LeftButton) updatePan(mouse);
                }
            }
        }

        // 2. MODE ACTION BUTTONS: Legend Toggle & Manual Mode
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 6

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 38
                radius: 4
                color: minimapRoot.isLegendActive ? "#15803d" : "#0d2847"
                border.color: minimapRoot.isLegendActive ? "#22c55e" : "#3b82f6"
                border.width: 1.4

                Text {
                    anchors.centerIn: parent
                    text: minimapRoot.isLegendActive ? "Legend [ON]" : "Legend [OFF]"
                    color: "#ffffff"
                    font.bold: true
                    font.pixelSize: 10
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: minimapRoot.legendToggled()
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 38
                radius: 4
                color: "#0d2847"
                border.color: "#3b82f6"
                border.width: 1.4

                Text {
                    anchors.centerIn: parent
                    text: "Manual Mode"
                    color: "#93c5fd"
                    font.bold: true
                    font.pixelSize: 10
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: minimapRoot.manualModeClicked()
                }
            }
        }
    }
}
