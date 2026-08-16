import QtQuick
import QtQuick.Layouts

Item {
    id: minimapRoot
    width: 220
    height: 180

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

    // =========================================================================
    // AWARDS-LEVEL INDUSTRIAL SCADA HUD GLASS CONTAINER
    // =========================================================================
    Rectangle {
        id: hudContainer
        anchors.fill: parent
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
            anchors.margins: 7
            spacing: 5

            // -----------------------------------------------------------------
            // 1. TOP HEADER: RADAR TITLE + ZOOM BADGE + FIT BUTTON
            // -----------------------------------------------------------------
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 20
                spacing: 5

                // Radar Pulsing Indicator Dot
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
                    Layout.preferredWidth: 38
                    Layout.preferredHeight: 18
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

                // Fit View Reset Button
                Rectangle {
                    Layout.preferredWidth: 42
                    Layout.preferredHeight: 18
                    radius: 3
                    color: "#0f2b48"
                    border.color: "#0284c7"
                    border.width: 0.8

                    Text {
                        anchors.centerIn: parent
                        text: "⛶ FIT"
                        color: "#bae6fd"
                        font.pixelSize: 8
                        font.bold: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: minimapRoot.fitRequested()
                    }
                }
            }

            // -----------------------------------------------------------------
            // 2. LIVE EXACT-REPLICA P&ID MINIATURE VIEWPORT (100% Vector Fidelity)
            // -----------------------------------------------------------------
            Rectangle {
                id: mapBox
                Layout.fillWidth: true
                Layout.preferredHeight: 114
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

                // Interactive Click & Drag Pan Navigation
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
                }
            }

            // -----------------------------------------------------------------
            // 3. BOTTOM CONTROL BAR: COMPACT TAGS PILL + ZOOM STEPPERS (+ / -)
            // -----------------------------------------------------------------
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 22
                spacing: 5

                // Compact Tags Toggle Pill (Width ~85px, not stretched)
                Rectangle {
                    Layout.preferredWidth: 84
                    Layout.preferredHeight: 20
                    radius: 10
                    color: minimapRoot.isLegendActive ? "#052e16" : "#0f172a"
                    border.color: minimapRoot.isLegendActive ? "#22c55e" : "#334155"
                    border.width: 1.0

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 4

                        Rectangle {
                            width: 6
                            height: 6
                            radius: 3
                            color: minimapRoot.isLegendActive ? "#22c55e" : "#475569"
                        }

                        Text {
                            text: minimapRoot.isLegendActive ? "Tags: ON" : "Tags: OFF"
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

                // Flexible Spacer
                Item {
                    Layout.fillWidth: true
                }

                // Zoom Out Button (−)
                Rectangle {
                    Layout.preferredWidth: 22
                    Layout.preferredHeight: 20
                    radius: 3
                    color: "#0f2b48"
                    border.color: "#1e40af"
                    border.width: 0.8

                    Text {
                        anchors.centerIn: parent
                        text: "−"
                        color: "#bae6fd"
                        font.pixelSize: 12
                        font.bold: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: minimapRoot.zoomOutRequested()
                    }
                }

                // Zoom In Button (+)
                Rectangle {
                    Layout.preferredWidth: 22
                    Layout.preferredHeight: 20
                    radius: 3
                    color: "#0f2b48"
                    border.color: "#1e40af"
                    border.width: 0.8

                    Text {
                        anchors.centerIn: parent
                        text: "+"
                        color: "#bae6fd"
                        font.pixelSize: 11
                        font.bold: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: minimapRoot.zoomInRequested()
                    }
                }
            }
        }
    }
}
