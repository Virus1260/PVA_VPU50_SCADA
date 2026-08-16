import QtQuick
import QtQuick.Layouts

Item {
    id: minimapRoot
    width: 284
    height: 154

    property real contentWidth: 1440
    property real contentHeight: 840
    property real viewX: 0
    property real viewY: 0
    property real viewWidth: 1440
    property real viewHeight: 840
    property real zoomScale: 1.0
    property real fitZoom: 1.0
    property bool isLegendActive: true

    signal panRequested(real targetX, real targetY)
    signal legendToggled()
    signal fitRequested()
    signal zoomInRequested()
    signal zoomOutRequested()

    RowLayout {
        anchors.fill: parent
        spacing: 6

        // =====================================================================
        // 1. LEFT: RADAR MINIMAP (With Legend Pill at Bottom & Double-Tap Fit)
        // =====================================================================
        Rectangle {
            id: mapHudContainer
            Layout.preferredWidth: 224
            Layout.fillHeight: true
            radius: 8
            color: "#071c33"
            border.color: "#0284c7"
            border.width: 1.4

            // Top Specular Highlight
            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: 1
                color: "#38bdf8"
                opacity: 0.7
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 6
                spacing: 5

                // Top Header: Title + Live Zoom Percentage Badge
                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 18
                    spacing: 4

                    Rectangle {
                        width: 6
                        height: 6
                        radius: 3
                        color: "#38bdf8"
                    }

                    Text {
                        text: "P&ID RADAR"
                        color: "#94a3b8"
                        font.pixelSize: 8
                        font.bold: true
                        Layout.fillWidth: true
                    }

                    // Current Zoom Percentage Badge
                    Rectangle {
                        Layout.preferredWidth: 44
                        Layout.preferredHeight: 16
                        radius: 3
                        color: "#0b2a4a"
                        border.color: "#1e40af"
                        border.width: 0.8

                        Text {
                            anchors.centerIn: parent
                            text: Math.round((minimapRoot.zoomScale / Math.max(0.1, minimapRoot.fitZoom)) * 100) + "%"
                            color: "#38bdf8"
                            font.pixelSize: 8
                            font.bold: true
                        }
                    }
                }

                // Live Vector Miniature Preview Box
                Rectangle {
                    id: mapBox
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#06182c"
                    border.color: "#1e3a8a"
                    border.width: 1.2
                    radius: 4
                    clip: true

                    readonly property real mapScale: width / minimapRoot.contentWidth

                    // Exact 1:1 Live Scaled Miniature Replica of Main P&ID Equipment Layer
                    Item {
                        id: miniWorld
                        width: minimapRoot.contentWidth
                        height: minimapRoot.contentHeight
                        scale: mapBox.mapScale
                        transformOrigin: Item.TopLeft

                        P_ID_Layer_3_Equipments {
                            anchors.fill: parent
                            showTags: false
                        }
                    }

                    // Interactive Golden Viewport Selection Frame (Strictly Clamped)
                    Rectangle {
                        id: selectionFrame
                        readonly property real visWorldW: minimapRoot.viewWidth / Math.max(0.1, minimapRoot.zoomScale)
                        readonly property real visWorldH: minimapRoot.viewHeight / Math.max(0.1, minimapRoot.zoomScale)

                        readonly property real rawW: visWorldW * mapBox.mapScale
                        readonly property real rawH: visWorldH * mapBox.mapScale

                        width: Math.max(14, Math.min(mapBox.width, rawW))
                        height: Math.max(10, Math.min(mapBox.height, rawH))

                        readonly property real rawX: ((-minimapRoot.viewX) / Math.max(0.1, minimapRoot.zoomScale)) * mapBox.mapScale
                        readonly property real rawY: ((-minimapRoot.viewY) / Math.max(0.1, minimapRoot.zoomScale)) * mapBox.mapScale

                        x: Math.max(0, Math.min(mapBox.width - width, rawX))
                        y: Math.max(0, Math.min(mapBox.height - height, rawY))

                        color: "#25f59e0b"
                        border.color: "#f59e0b"
                        border.width: 1.6
                        radius: 2

                        // Center Crosshair
                        Rectangle {
                            anchors.centerIn: parent
                            width: 4
                            height: 4
                            radius: 2
                            color: "#f59e0b"
                        }
                    }

                    // Interactive Pan & Double-Tap / Double-Click to Fit
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.SizeAllCursor

                        function updatePan(mouse) {
                            var normX = Math.max(0, Math.min(1.0, mouse.x / mapBox.width));
                            var normY = Math.max(0, Math.min(1.0, mouse.y / mapBox.height));
                            var targetX = -(normX * minimapRoot.contentWidth * minimapRoot.zoomScale - minimapRoot.viewWidth / 2);
                            var targetY = -(normY * minimapRoot.contentHeight * minimapRoot.zoomScale - minimapRoot.viewHeight / 2);
                            minimapRoot.panRequested(targetX, targetY);
                        }

                        onPressed: function(mouse) { updatePan(mouse); }
                        onPositionChanged: function(mouse) {
                            if (mouse.buttons & Qt.LeftButton) updatePan(mouse);
                        }
                        // Dynamic Double-Tap to Fit Screen
                        onDoubleClicked: {
                            minimapRoot.fitRequested();
                        }
                    }
                }

                // Bottom: Legend / Tags Toggle Button
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 22
                    radius: 4
                    color: minimapRoot.isLegendActive ? "#052e16" : "#0f172a"
                    border.color: minimapRoot.isLegendActive ? "#22c55e" : "#334155"
                    border.width: 1.0

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 5

                        Rectangle {
                            width: 6
                            height: 6
                            radius: 3
                            color: minimapRoot.isLegendActive ? "#22c55e" : "#475569"
                        }

                        Text {
                            text: minimapRoot.isLegendActive ? "TAGS: ON" : "TAGS: OFF"
                            color: minimapRoot.isLegendActive ? "#4ade80" : "#94a3b8"
                            font.bold: true
                            font.pixelSize: 8
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: minimapRoot.legendToggled()
                    }
                }
            }
        }

        // =====================================================================
        // 2. RIGHT: LARGE SQUARE ZOOM STEPPERS (+ & −) COVERING FULL HEIGHT
        // =====================================================================
        ColumnLayout {
            Layout.preferredWidth: 54
            Layout.fillHeight: true
            spacing: 6

            // Large Square Zoom In Button (+)
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 7
                color: "#0b2545"
                border.color: "#1d4ed8"
                border.width: 1.4

                Text {
                    anchors.centerIn: parent
                    text: "+"
                    color: "#93c5fd"
                    font.pixelSize: 22
                    font.bold: true
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: minimapRoot.zoomInRequested()
                }
            }

            // Large Square Zoom Out Button (−)
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 7
                color: "#0b2545"
                border.color: "#1d4ed8"
                border.width: 1.4

                Text {
                    anchors.centerIn: parent
                    text: "−"
                    color: "#93c5fd"
                    font.pixelSize: 24
                    font.bold: true
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: minimapRoot.zoomOutRequested()
                }
            }
        }
    }
}
