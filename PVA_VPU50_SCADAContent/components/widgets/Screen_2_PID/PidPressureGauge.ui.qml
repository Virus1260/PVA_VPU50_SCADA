/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML.
*/
import QtQuick

Item {
    id: pressRoot
    width: isVertical ? 38 : 50
    height: isVertical ? 50 : 38

    property string tag: "PI 168 001"
    property real pressureBar: 2.4
    property real maxPressureBar: 6.0
    property bool isVertical: true
    property bool showTags: true

    // =========================================================================
    // 1. PROCESS MOUNTING STEM & HEX NUT (Vertical or Horizontal)
    // =========================================================================
    // Vertical Stem (Bottom Mount)
    Rectangle {
        visible: pressRoot.isVertical
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        width: 3.5
        height: 18
        color: "#64748b"
        border.color: "#334155"
        border.width: 0.5
    }

    Rectangle {
        visible: pressRoot.isVertical
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 2
        width: 9
        height: 5.5
        radius: 1
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: "#64748b" }
            GradientStop { position: 0.45; color: "#e2e8f0" }
            GradientStop { position: 1.0; color: "#475569" }
        }
        border.color: "#1e293b"
        border.width: 0.8
    }

    // Horizontal Stem (Side Mount tapping into vertical riser)
    Rectangle {
        visible: !pressRoot.isVertical
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        width: 18
        height: 3.5
        color: "#64748b"
        border.color: "#334155"
        border.width: 0.5
    }

    Rectangle {
        visible: !pressRoot.isVertical
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 2
        width: 5.5
        height: 9
        radius: 1
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0; color: "#64748b" }
            GradientStop { position: 0.45; color: "#e2e8f0" }
            GradientStop { position: 1.0; color: "#475569" }
        }
        border.color: "#1e293b"
        border.width: 0.8
    }

    // =========================================================================
    // 2. CIRCULAR PROCESS PRESSURE/TEMP DIAL GAUGE (Pixel-Perfect Industrial Design)
    // =========================================================================
    Rectangle {
        id: dialHousing
        anchors.horizontalCenter: pressRoot.isVertical ? parent.horizontalCenter : undefined
        anchors.top: pressRoot.isVertical ? parent.top : undefined
        anchors.topMargin: pressRoot.isVertical ? 4 : 0
        anchors.right: !pressRoot.isVertical ? parent.right : undefined
        anchors.verticalCenter: !pressRoot.isVertical ? parent.verticalCenter : undefined
        anchors.rightMargin: !pressRoot.isVertical ? 2 : 0

        width: 28
        height: 28
        radius: 14
        color: "#08213b"
        border.color: "#0284c7"
        border.width: 1.4

        // Outer Stainless Steel Bezel Ring
        Rectangle {
            anchors.fill: parent
            anchors.margins: 1.2
            radius: 13
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#e2e8f0" }
                GradientStop { position: 0.5; color: "#94a3b8" }
                GradientStop { position: 1.0; color: "#475569" }
            }
            border.color: "#334155"
            border.width: 0.6
        }

        // Inner White Dial Face Plate
        Rectangle {
            id: dialFacePlate
            anchors.fill: parent
            anchors.margins: 2.2
            radius: 12
            color: "#f8fafc"
            border.color: "#cbd5e1"
            border.width: 0.6

            // Radial Scale Graduation Tick Marks (Exact 240 deg span from -120 to +120 deg)
            Item {
                anchors.centerIn: parent
                width: 0
                height: 0
                rotation: -120
                Rectangle { x: -0.5; y: -10.5; width: 1.0; height: 2.8; color: "#334155" }
            }
            Item {
                anchors.centerIn: parent
                width: 0
                height: 0
                rotation: -90
                Rectangle { x: -0.4; y: -10.5; width: 0.8; height: 1.8; color: "#64748b" }
            }
            Item {
                anchors.centerIn: parent
                width: 0
                height: 0
                rotation: -60
                Rectangle { x: -0.5; y: -10.5; width: 1.0; height: 2.8; color: "#334155" }
            }
            Item {
                anchors.centerIn: parent
                width: 0
                height: 0
                rotation: -30
                Rectangle { x: -0.4; y: -10.5; width: 0.8; height: 1.8; color: "#64748b" }
            }
            Item {
                anchors.centerIn: parent
                width: 0
                height: 0
                rotation: 0
                Rectangle { x: -0.5; y: -10.5; width: 1.0; height: 2.8; color: "#334155" }
            }
            Item {
                anchors.centerIn: parent
                width: 0
                height: 0
                rotation: 30
                Rectangle { x: -0.4; y: -10.5; width: 0.8; height: 1.8; color: "#64748b" }
            }
            Item {
                anchors.centerIn: parent
                width: 0
                height: 0
                rotation: 60
                Rectangle { x: -0.5; y: -10.5; width: 1.0; height: 2.8; color: "#334155" }
            }
            Item {
                anchors.centerIn: parent
                width: 0
                height: 0
                rotation: 90
                Rectangle { x: -0.4; y: -10.5; width: 0.8; height: 1.8; color: "#64748b" }
            }
            Item {
                anchors.centerIn: parent
                width: 0
                height: 0
                rotation: 120
                Rectangle { x: -0.6; y: -10.5; width: 1.2; height: 2.8; color: "#dc2626" } // Redline Limit Tick
            }

            // Precision Tapered Indicator Needle
            Item {
                id: needlePivot
                anchors.centerIn: parent
                width: 0
                height: 0
                rotation: -120 + Math.min(240, Math.max(0, (pressRoot.pressureBar / pressRoot.maxPressureBar) * 240))

                // Counterweight Tail (Dark Grey Metallic)
                Rectangle {
                    x: -0.7
                    y: 0.5
                    width: 1.4
                    height: 3.2
                    radius: 0.5
                    color: "#1e293b"
                }

                // Needle Pointer (Vibrant Red, Tapered Tip)
                Rectangle {
                    x: -0.5
                    y: -9.5
                    width: 1.0
                    height: 10
                    color: "#dc2626"
                    radius: 0.4
                }
            }

            // Center Pivot Cap (Concentric Chrome Highlight)
            Rectangle {
                anchors.centerIn: parent
                width: 4.6
                height: 4.6
                radius: 2.3
                color: "#0f172a"
                border.color: "#94a3b8"
                border.width: 0.6

                Rectangle {
                    anchors.centerIn: parent
                    width: 2.0
                    height: 2.0
                    radius: 1.0
                    color: "#e2e8f0"
                }
            }
        }
    }

    // =========================================================================
    // 3. TAG & VALUE READOUT (Crisp Industrial Typography)
    // =========================================================================
    Text {
        visible: pressRoot.showTags
        anchors.horizontalCenter: dialHousing.horizontalCenter
        anchors.bottom: dialHousing.top
        anchors.bottomMargin: 1
        text: pressRoot.tag
        color: "#8cb5dc"
        font.pixelSize: 8
        font.bold: true
    }
}
