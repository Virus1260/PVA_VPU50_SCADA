import QtQuick
import QtQuick.Layouts

Item {
    id: lifterRoot
    width: 170
    height: 440

    property bool isLidRaised: false
    property bool isMotorRunning: false
    property bool showTags: true

    signal motorClicked()

    // 1. TOP HORIZONTAL LIFTING ARM (Extending from Lid Right Shoulder)
    Rectangle {
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.right: screwColumn.horizontalCenter
        height: 6
        color: "#64748b"
        radius: 2
    }

    // 2. VERTICAL ELECTRIC PRECISION SCREW COLUMN (Declarative for Qt Design Studio)
    Rectangle {
        id: screwColumn
        anchors.left: parent.left
        anchors.leftMargin: 80
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.bottom: electricGearBox.top
        width: 6
        color: "#cbd5e1"
        clip: true

        // Declarative Screw Thread Hatchings (Zero JS Warnings in Qt Design Studio)
        Column {
            anchors.fill: parent
            spacing: 6

            Repeater {
                model: 45
                Rectangle {
                    width: 6
                    height: 2
                    color: "#94a3b8"
                    rotation: 15
                }
            }
        }
    }

    // 3. TOP POSITION & INTERLOCK SENSORS (Spaced cleanly without overlapping)
    ColumnLayout {
        anchors.left: screwColumn.right
        anchors.leftMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 4
        spacing: 4
        visible: lifterRoot.showTags

        RowLayout {
            spacing: 5
            Rectangle { width: 8; height: 8; radius: 4; color: lifterRoot.isLidRaised ? "#22c55e" : "#64748b" }
            Text { text: "GOSH 164 003"; color: "#8cb5dc"; font.pixelSize: 8 }
        }
        RowLayout {
            spacing: 5
            Rectangle { width: 8; height: 8; radius: 4; color: !lifterRoot.isLidRaised ? "#22c55e" : "#64748b" }
            Text { text: "GOSL 164 002"; color: "#8cb5dc"; font.pixelSize: 8 }
        }
        RowLayout {
            spacing: 5
            Rectangle { width: 8; height: 8; radius: 4; color: "#eab308" }
            Text { text: "GZ 164 001"; color: "#8cb5dc"; font.pixelSize: 8 }
        }
    }

    // 4. BOTTOM ELECTRIC SCREW-JACK GEARBOX BASE
    Rectangle {
        id: electricGearBox
        anchors.left: screwColumn.left
        anchors.leftMargin: -12
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 60
        width: 30
        height: 24
        radius: 3
        color: "#1e3a5f"
        border.color: "#3b82f6"
        border.width: 1.2

        Text {
            anchors.centerIn: parent
            text: "GEAR"
            color: "#93c5fd"
            font.bold: true
            font.pixelSize: 6
        }
    }

    // 5. ELECTRIC DRIVE MOTOR M 164 001 (Reusable PidMotor)
    PidMotor {
        anchors.left: electricGearBox.right
        anchors.leftMargin: 4
        anchors.verticalCenter: electricGearBox.verticalCenter
        motorTag: "M 164 001"
        speedTag: "Lid Motor"
        speedRpm: 0
        isRunning: lifterRoot.isMotorRunning
        showTags: lifterRoot.showTags
        showSpeedAbove: false
        onClicked: lifterRoot.motorClicked()
    }
}
