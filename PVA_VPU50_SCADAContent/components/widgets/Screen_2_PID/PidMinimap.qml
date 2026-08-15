import QtQuick
import QtQuick.Layouts

Item {
    id: minimapRoot
    width: 220
    height: 80

    property real contentWidth: 1100
    property real contentHeight: 650
    property real viewX: 0
    property real viewY: 0
    property real viewWidth: 1100
    property real viewHeight: 650
    property real zoomScale: 1.0
    property bool isLegendActive: true

    signal panRequested(real targetX, real targetY)
    signal legendToggled()
    signal manualModeClicked()

    RowLayout {
        anchors.fill: parent
        spacing: 8

        // 1. MINIMAP PREVIEW CANVAS & DRAGGABLE SELECTION BOX
        Rectangle {
            id: mapBox
            Layout.preferredWidth: 115
            Layout.fillHeight: true
            color: "#07203b"
            border.color: "#1b4e82"
            border.width: 1
            radius: 4
            clip: true

            // Schematic Thumbnail
            Canvas {
                id: thumbCanvas
                anchors.fill: parent
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.clearRect(0, 0, width, height);

                    var sx = width / minimapRoot.contentWidth;
                    var sy = height / minimapRoot.contentHeight;

                    // Mini Left Manifold
                    ctx.strokeStyle = "#1b538c";
                    ctx.lineWidth = 1;
                    ctx.beginPath();
                    ctx.moveTo(70 * sx, 180 * sy);
                    ctx.lineTo(70 * sx, 580 * sy);
                    ctx.moveTo(140 * sx, 180 * sy);
                    ctx.lineTo(140 * sx, 580 * sy);
                    ctx.stroke();

                    // Mini Vessel
                    var vx = 560 * sx;
                    var vy = 280 * sy;
                    ctx.fillStyle = "#76b0e0";
                    ctx.strokeStyle = "#1b4c7c";
                    ctx.beginPath();
                    ctx.rect(vx - 16, vy - 24, 32, 48);
                    ctx.fill();
                    ctx.stroke();

                    // Mini Recirculation Line
                    ctx.strokeStyle = "#22c55e";
                    ctx.beginPath();
                    ctx.moveTo(vx, vy + 24);
                    ctx.lineTo(vx + 24, vy + 24);
                    ctx.lineTo(vx + 24, vy - 24);
                    ctx.lineTo(vx + 6, vy - 24);
                    ctx.stroke();
                }
            }

            // Interactive Yellow Viewport Frame
            Rectangle {
                id: selectionFrame
                x: Math.max(0, Math.min(mapBox.width - width, ((-minimapRoot.viewX) / (minimapRoot.contentWidth * minimapRoot.zoomScale)) * mapBox.width))
                y: Math.max(0, Math.min(mapBox.height - height, ((-minimapRoot.viewY) / (minimapRoot.contentHeight * minimapRoot.zoomScale)) * mapBox.height))
                width: Math.max(14, Math.min(mapBox.width, (minimapRoot.viewWidth / (minimapRoot.contentWidth * minimapRoot.zoomScale)) * mapBox.width))
                height: Math.max(14, Math.min(mapBox.height, (minimapRoot.viewHeight / (minimapRoot.contentHeight * minimapRoot.zoomScale)) * mapBox.height))
                color: "#20f59e0b"
                border.color: "#f59e0b"
                border.width: 1.5
                radius: 2
            }

            // Click / Drag to Pan on Minimap
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.SizeAllCursor
                onPositionChanged: function(mouse) {
                    var normX = mouse.x / mapBox.width;
                    var normY = mouse.y / mapBox.height;
                    var targetX = -(normX * minimapRoot.contentWidth * minimapRoot.zoomScale - minimapRoot.viewWidth / 2);
                    var targetY = -(normY * minimapRoot.contentHeight * minimapRoot.zoomScale - minimapRoot.viewHeight / 2);
                    minimapRoot.panRequested(targetX, targetY);
                }
                onClicked: function(mouse) {
                    var normX = mouse.x / mapBox.width;
                    var normY = mouse.y / mapBox.height;
                    var targetX = -(normX * minimapRoot.contentWidth * minimapRoot.zoomScale - minimapRoot.viewWidth / 2);
                    var targetY = -(normY * minimapRoot.contentHeight * minimapRoot.zoomScale - minimapRoot.viewHeight / 2);
                    minimapRoot.panRequested(targetX, targetY);
                }
            }
        }

        // 2. MODE ACTION BUTTONS: Legend & Manual Mode
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 4

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 3
                color: minimapRoot.isLegendActive ? "#15803d" : "#0c345c"
                border.color: minimapRoot.isLegendActive ? "#4ade80" : "#1d5e9c"
                border.width: 1
                Text {
                    anchors.centerIn: parent
                    text: "Legend"
                    color: "#ffffff"
                    font.pixelSize: 10
                    font.bold: true
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        minimapRoot.isLegendActive = !minimapRoot.isLegendActive;
                        minimapRoot.legendToggled();
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 3
                color: "#0c345c"
                border.color: "#1d5e9c"
                border.width: 1
                Text {
                    anchors.centerIn: parent
                    text: "Manual Mode"
                    color: "#ffffff"
                    font.pixelSize: 10
                    font.bold: true
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
