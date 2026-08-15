import QtQuick
import QtQuick.Layouts
import ".."

Item {
    id: powerCurrentRoot
    property string powerVal: "0.0"
    property string powerUnit: "kW"
    property string currentVal: "0.0"
    property string currentUnit: "A"

    property real cardHeight: 68

    Layout.fillWidth: true
    Layout.minimumWidth: 80
    Layout.preferredHeight: cardHeight
    Layout.minimumHeight: cardHeight
    Layout.maximumHeight: cardHeight

    ColumnLayout {
        anchors.fill: parent
        spacing: 3

        // 1. Titles OUTSIDE and ABOVE the card
        RowLayout {
            Layout.fillWidth: true
            Text {
                text: "Power"
                color: "#ffffff"
                font.pixelSize: 11
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignLeft
            }
            Text {
                text: "Current"
                color: "#ffffff"
                font.pixelSize: 11
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignLeft
            }
        }

        // 2. The Dual-Shade Card Rectangle
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#0c345a"
            border.color: "#1d5b94"
            border.width: 1
            radius: 4
            clip: true

            RowLayout {
                anchors.fill: parent
                spacing: 0

                // Left Compartment (Power in darker blue)
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#0a2e50"

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 2
                        Text {
                            text: powerCurrentRoot.powerVal
                            color: "#ffffff"
                            font.bold: true
                            font.pixelSize: 15
                        }
                        Text {
                            text: powerCurrentRoot.powerUnit
                            color: "#8cb5dc"
                            font.pixelSize: 10
                        }
                    }
                }

                // Vertical Divider Line
                Rectangle {
                    width: 1
                    Layout.fillHeight: true
                    color: "#1d5b94"
                }

                // Right Compartment (Current in lighter contrast blue)
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#154d80"

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 2
                        Text {
                            text: powerCurrentRoot.currentVal
                            color: "#ffffff"
                            font.bold: true
                            font.pixelSize: 15
                        }
                        Text {
                            text: powerCurrentRoot.currentUnit
                            color: "#8cb5dc"
                            font.pixelSize: 10
                        }
                    }
                }
            }
        }
    }
}
