import QtQuick
import QtQuick.Layouts

Item {
    id: lifterRoot
    width: 190
    height: 420

    property bool isLidRaised: false
    property bool showTags: true

    // 1. TOP HORIZONTAL LIFT BRACKET
    Rectangle {
        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.left: parent.left
        anchors.right: guideRod.horizontalCenter
        height: 5
        color: "#64748b"
        radius: 2
    }

    // 2. VERTICAL GUIDE ROD
    Rectangle {
        id: guideRod
        anchors.right: parent.right
        anchors.rightMargin: 70
        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.bottom: hydraulicBase.top
        width: 3.5
        color: "#cbd5e1"
    }

    // 3. TOP PROXIMITY SENSORS
    ColumnLayout {
        anchors.left: guideRod.right
        anchors.leftMargin: 8
        anchors.top: parent.top
        anchors.topMargin: 2
        spacing: 3
        visible: lifterRoot.showTags

        RowLayout {
            spacing: 4
            Rectangle { width: 7; height: 7; radius: 3.5; color: lifterRoot.isLidRaised ? "#22c55e" : "#475569" }
            Text { text: "GOSH 164 003"; color: "#8cb5dc"; font.pixelSize: 7 }
        }
        RowLayout {
            spacing: 4
            Rectangle { width: 7; height: 7; radius: 3.5; color: !lifterRoot.isLidRaised ? "#22c55e" : "#475569" }
            Text { text: "GOSL 164 002"; color: "#8cb5dc"; font.pixelSize: 7 }
        }
        RowLayout {
            spacing: 4
            Rectangle { width: 7; height: 7; radius: 3.5; color: "#eab308" }
            Text { text: "GZ 164 001"; color: "#8cb5dc"; font.pixelSize: 7 }
        }
    }

    // 4. BOTTOM HYDRAULIC BASE BRACKET
    Rectangle {
        id: hydraulicBase
        anchors.right: guideRod.right
        anchors.rightMargin: -10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 60
        width: 28
        height: 16
        radius: 2
        color: "#c28b53"
        border.color: "#d97706"
        border.width: 1
    }

    // 5. SWIVELLING DEVICE MINI VESSEL
    Rectangle {
        id: swivelVessel
        anchors.top: hydraulicBase.bottom
        anchors.topMargin: 12
        anchors.left: hydraulicBase.left
        anchors.leftMargin: 16
        width: 34
        height: 20
        radius: 2
        color: "#c28b53"
        border.color: "#d97706"
        border.width: 1

        Text {
            anchors.centerIn: parent
            text: "Z 164 001"
            color: "#ffffff"
            font.bold: true
            font.pixelSize: 6
        }
    }

    // Swivel Text & Sensors
    ColumnLayout {
        anchors.top: swivelVessel.bottom
        anchors.topMargin: 2
        anchors.horizontalCenter: swivelVessel.horizontalCenter
        spacing: 1
        visible: lifterRoot.showTags

        Text { text: "Swivelling\ndevice"; color: "#94a3b8"; font.pixelSize: 7; horizontalAlignment: Text.AlignHCenter }

        RowLayout {
            spacing: 3
            Rectangle { width: 5; height: 5; radius: 2.5; color: "#22c55e" }
            Text { text: "GOSL 164 004"; color: "#8cb5dc"; font.pixelSize: 6 }
        }
    }

    // Swivel Drive Motor M 164 001
    RowLayout {
        anchors.left: swivelVessel.right
        anchors.leftMargin: 6
        anchors.verticalCenter: swivelVessel.verticalCenter
        spacing: 4

        Rectangle {
            width: 16
            height: 16
            radius: 8
            color: "#0d2847"
            border.color: "#3b82f6"
            border.width: 1
            Text { anchors.centerIn: parent; text: "M"; color: "#ffffff"; font.pixelSize: 8; font.bold: true }
        }
        Text { visible: lifterRoot.showTags; text: "M 164 001"; color: "#8cb5dc"; font.pixelSize: 7 }
    }
}
