import QtQuick
import QtQuick.Layouts

Item {
    id: lifterRoot
    width: 140
    height: 380

    property bool isLidRaised: false

    // Hydraulic Lift Column
    Rectangle {
        id: column
        anchors.right: parent.right
        anchors.rightMargin: 40
        anchors.top: parent.top
        anchors.topMargin: 40
        width: 8
        height: 300
        radius: 4
        color: "#1e3a8a"
        border.color: "#3b82f6"
        border.width: 1
    }

    // Top Bracket Connection Arm
    Rectangle {
        anchors.top: column.top
        anchors.left: parent.left
        anchors.right: column.right
        height: 8
        radius: 3
        color: "#1e3a8a"
        border.color: "#3b82f6"
        border.width: 1
    }

    // Position Proximity Sensors: GOSH (High) & GOSL (Low)
    ColumnLayout {
        anchors.left: column.right
        anchors.leftMargin: 8
        anchors.top: column.top
        spacing: 40

        RowLayout {
            spacing: 4
            Rectangle { width: 10; height: 10; radius: 5; color: lifterRoot.isLidRaised ? "#22c55e" : "#334155" }
            Text { text: "GOSH 164 003"; color: "#8cb5dc"; font.pixelSize: 8 }
        }

        RowLayout {
            spacing: 4
            Rectangle { width: 10; height: 10; radius: 5; color: !lifterRoot.isLidRaised ? "#22c55e" : "#334155" }
            Text { text: "GOSL 164 002"; color: "#8cb5dc"; font.pixelSize: 8 }
        }
    }

    // Bottom Swivelling Motor & Cylinder
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.right: column.right
        anchors.rightMargin: -10
        width: 44
        height: 32
        radius: 4
        color: "#08213b"
        border.color: "#184d7e"
        border.width: 1

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 0
            Text { text: "M 164 001"; color: "#8cb5dc"; font.pixelSize: 8; Layout.alignment: Qt.AlignHCenter }
            Text { text: "Swivel"; color: "#64748b"; font.pixelSize: 7; Layout.alignment: Qt.AlignHCenter }
        }
    }
}
