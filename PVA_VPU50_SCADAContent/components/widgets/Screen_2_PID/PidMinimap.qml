import QtQuick
import QtQuick.Layouts

Item {
    id: minimapRoot
    width: 200
    height: 70

    RowLayout {
        anchors.fill: parent
        spacing: 8

        // Minimap Navigator Card
        Rectangle {
            Layout.preferredWidth: 100
            Layout.fillHeight: true
            color: "#08213b"
            border.color: "#184d7e"
            border.width: 1
            radius: 4
            clip: true

            // Mini Vessel Representation
            Rectangle {
                anchors.centerIn: parent
                width: 32
                height: 42
                radius: 4
                color: "#0c345a"
                border.color: "#00d2ff"
                border.width: 1
            }

            // Yellow Selection Frame Box
            Rectangle {
                anchors.centerIn: parent
                width: 50
                height: 52
                color: "transparent"
                border.color: "#f59e0b"
                border.width: 1
            }
        }

        // Mode Action Buttons: Legend & Manual Mode
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 4

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 3
                color: "#0d365e"
                border.color: "#1d5b94"
                border.width: 1
                Text { anchors.centerIn: parent; text: "Legend"; color: "#ffffff"; font.pixelSize: 10; font.bold: true }
                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 3
                color: "#0d365e"
                border.color: "#1d5b94"
                border.width: 1
                Text { anchors.centerIn: parent; text: "Manual Mode"; color: "#ffffff"; font.pixelSize: 10; font.bold: true }
                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor }
            }
        }
    }
}
