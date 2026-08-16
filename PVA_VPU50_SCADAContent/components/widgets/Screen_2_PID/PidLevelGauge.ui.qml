/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML.
*/
import QtQuick
import QtQuick.Layouts

Item {
    id: gaugeRoot
    width: 78
    height: 195

    property real levelPercent: 65.0
    property string tag: "X 165 503"
    property bool showTags: true

    // 1. TOP TAG BADGE (X 165 503)
    Text {
        id: tagLabel
        anchors.top: parent.top
        anchors.horizontalCenter: gaugePill.horizontalCenter
        text: gaugeRoot.tag
        color: "#8cb5dc"
        font.pixelSize: 8
        font.bold: true
        visible: gaugeRoot.showTags
    }

    // 2. SCALE LABELS (1000.0 to 0.0) ALONG LEFT SIDE
    Item {
        anchors.right: gaugePill.left
        anchors.rightMargin: 5
        anchors.top: gaugePill.top
        anchors.bottom: gaugePill.bottom

        Text { anchors.top: parent.top; anchors.topMargin: 2; anchors.right: parent.right; text: "1000.0"; color: "#1e3a5f"; font.pixelSize: 7; font.bold: true; font.family: "Arial" }
        Text { anchors.verticalCenter: parent.top; anchors.verticalCenterOffset: parent.height * 0.25; anchors.right: parent.right; text: "750.0"; color: "#1e3a5f"; font.pixelSize: 7; font.bold: true; font.family: "Arial" }
        Text { anchors.verticalCenter: parent.top; anchors.verticalCenterOffset: parent.height * 0.50; anchors.right: parent.right; text: "500.0"; color: "#1e3a5f"; font.pixelSize: 7; font.bold: true; font.family: "Arial" }
        Text { anchors.verticalCenter: parent.top; anchors.verticalCenterOffset: parent.height * 0.75; anchors.right: parent.right; text: "250.0"; color: "#1e3a5f"; font.pixelSize: 7; font.bold: true; font.family: "Arial" }
        Text { anchors.bottom: parent.bottom; anchors.bottomMargin: 2; anchors.right: parent.right; text: "0.0"; color: "#1e3a5f"; font.pixelSize: 7; font.bold: true; font.family: "Arial" }
    }

    // 3. MAIN CAPSULE PILL GAUGE (Elevated Z-Axis Over Agitator)
    Rectangle {
        id: gaugePill
        anchors.right: parent.right
        anchors.top: tagLabel.bottom
        anchors.topMargin: 2
        anchors.bottom: parent.bottom
        width: 24
        radius: 12
        color: "#082342"
        border.color: "#1d5b94"
        border.width: 1.5
        clip: true

        // Center dashed vertical guideline
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin: 6
            anchors.bottomMargin: 6
            width: 1
            color: "#1d4ed8"
            opacity: 0.7
        }

        // Major horizontal tick marks (25%, 50%, 75%)
        Rectangle { anchors.horizontalCenter: parent.horizontalCenter; y: parent.height * 0.25; width: 8; height: 1; color: "#38bdf8" }
        Rectangle { anchors.horizontalCenter: parent.horizontalCenter; y: parent.height * 0.50; width: 8; height: 1; color: "#38bdf8" }
        Rectangle { anchors.horizontalCenter: parent.horizontalCenter; y: parent.height * 0.75; width: 8; height: 1; color: "#38bdf8" }

        // Active Glowing Green Liquid Column
        Rectangle {
            id: liquidFill
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 1.5
            height: Math.max(0, (parent.height - 3) * (Math.max(0, Math.min(100, gaugeRoot.levelPercent)) / 100.0))
            radius: 11
            visible: height > 2

            gradient: Gradient {
                GradientStop { position: 0.0; color: "#4ade80" }
                GradientStop { position: 0.3; color: "#22c55e" }
                GradientStop { position: 1.0; color: "#15803d" }
            }

            Behavior on height {
                NumberAnimation { duration: 400; easing.type: Easing.OutQuad }
            }
        }
    }
}
