import QtQuick
import QtQuick.Layouts

Rectangle {
    id: powerCurrentRoot
    property string powerVal: "0.0"
    property string powerUnit: "kW"
    property string currentVal: "0.0"
    property string currentUnit: "A"

    property real preferredCardWidth: 180
    property real cardHeight: 74

    Layout.fillWidth: true
    Layout.preferredWidth: preferredCardWidth
    Layout.minimumWidth: 155
    Layout.maximumWidth: 260
    Layout.preferredHeight: cardHeight
    Layout.minimumHeight: cardHeight
    Layout.maximumHeight: cardHeight

    color: "#082646"
    border.color: "#184d7e"
    border.width: 1
    radius: 4

    ColumnLayout {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 8
        anchors.bottomMargin: 8
        spacing: 4

        // Top Headers (Power on left, Current on right)
        RowLayout {
            Layout.fillWidth: true
            Text {
                text: "Power"
                color: "#8cb5dc"
                font.pixelSize: 11
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
            }
            Text {
                text: "Current"
                color: "#8cb5dc"
                font.pixelSize: 11
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
            }
        }

        Item { Layout.fillHeight: true }

        // Values Row (0.0 kW on left, 0.0 A on right) with ample breathing room
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            // Power Value Box
            RowLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                spacing: 3
                Text {
                    text: powerCurrentRoot.powerVal
                    color: "#ffffff"
                    font.bold: true
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignRight
                    Layout.fillWidth: true
                }
                Text {
                    text: powerCurrentRoot.powerUnit
                    color: "#8cb5dc"
                    font.pixelSize: 11
                }
            }

            // Subtle vertical separator
            Rectangle {
                width: 1
                Layout.preferredHeight: 22
                color: "#164673"
            }

            // Current Value Box
            RowLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                spacing: 3
                Text {
                    text: powerCurrentRoot.currentVal
                    color: "#ffffff"
                    font.bold: true
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignRight
                    Layout.fillWidth: true
                }
                Text {
                    text: powerCurrentRoot.currentUnit
                    color: "#8cb5dc"
                    font.pixelSize: 11
                }
            }
        }

        Item { Layout.fillHeight: true }
    }
}
