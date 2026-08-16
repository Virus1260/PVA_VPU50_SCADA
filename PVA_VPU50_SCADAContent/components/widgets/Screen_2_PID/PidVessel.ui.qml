/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML.
*/
import QtQuick
import QtQuick.Layouts

Item {
    id: vesselRoot
    width: 360
    height: 440

    property string vesselName: "Unimix 50"
    property real levelPercent: 65.0
    property real vesselTemp: 20.7
    property real jacketTemp: 21.2
    property real vacuumPressure: -179.0
    property real weightKg: 154.4
    property bool isHeating: false
    property bool isCooling: false
    property bool showTags: true

    // -------------------------------------------------------------------------
    // 1. CONCENTRIC THERMAL JACKET (Pixel-Perfect Vector SVG - 100% Qt Designer Visible)
    // -------------------------------------------------------------------------
    Item {
        id: jacketContainer
        x: 36
        y: 132
        width: 288
        height: 246
        z: 1

        Image {
            id: jacketVector
            anchors.fill: parent
            source: "../../../assets/pid_vessel_jacket.svg"
            sourceSize.width: 288
            sourceSize.height: 246
            fillMode: Image.PreserveAspectFit
        }

        // Live Heating / Cooling Color Tint Overlay
        Rectangle {
            anchors.fill: parent
            color: vesselRoot.isHeating ? "#e06c28" : (vesselRoot.isCooling ? "#0284c7" : "transparent")
            opacity: 0.75
            visible: vesselRoot.isHeating || vesselRoot.isCooling
        }
    }

    // -------------------------------------------------------------------------
    // 2. MAIN SOLID SKY-BLUE PROCESS VESSEL (DIN 28011 Torispherical Profile)
    // -------------------------------------------------------------------------
    Item {
        id: vesselContainer
        x: 50
        y: 26
        width: 260
        height: 326
        z: 2

        Image {
            id: vesselVector
            anchors.fill: parent
            source: "../../../assets/pid_vessel_body.svg"
            sourceSize.width: 260
            sourceSize.height: 326
            fillMode: Image.PreserveAspectFit
        }
    }

    // -------------------------------------------------------------------------
    // 3. TELEMETRY BADGES
    // -------------------------------------------------------------------------
    // Product Temperature (TIC 162001) - Top-Left Dome
    Rectangle {
        anchors.left: parent.left
        anchors.leftMargin: 55
        anchors.top: parent.top
        anchors.topMargin: 38
        width: 72
        height: 24
        radius: 3
        color: "#0b2e54"
        border.color: "#1d609e"
        border.width: 1
        visible: vesselRoot.showTags
        z: 10

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 0
            Text { text: "TIC 162001"; color: "#8cb5dc"; font.pixelSize: 7; font.bold: true; Layout.alignment: Qt.AlignHCenter }
            Text { text: vesselRoot.vesselTemp.toFixed(1) + "°C"; color: "#ffffff"; font.bold: true; font.pixelSize: 8; Layout.alignment: Qt.AlignHCenter }
        }
    }
}
