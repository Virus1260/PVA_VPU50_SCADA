import QtQuick
import QtQuick.Layouts

Item {
    id: cardRoot
    property string title: ""
    property string primaryValue: "--"
    property string secondaryValue: ""
    property string unit: ""
    property bool showProgressBar: false
    property real progressValue: 0.0
    property color progressColor: "#00d2ff"

    property real cardHeight: 68

    Layout.fillWidth: true
    Layout.minimumWidth: 80
    Layout.maximumWidth: 240
    Layout.preferredHeight: cardHeight
    Layout.minimumHeight: cardHeight
    Layout.maximumHeight: cardHeight

    ColumnLayout {
        anchors.fill: parent
        spacing: 3

        // 1. Title OUTSIDE and ABOVE the card, Top-Left aligned
        Text {
            text: cardRoot.title
            color: "#ffffff"
            font.pixelSize: 11
            font.bold: false
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignLeft
            elide: Text.ElideRight
            visible: cardRoot.title !== ""
        }

        // 2. The Main Card Rectangle
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#0c345a"
            border.color: "#1d5b94"
            border.width: 1
            radius: 4
            clip: true

            // CASE A: Dual-Value Card (Two compartments with distinct background shades)
            RowLayout {
                anchors.fill: parent
                spacing: 0
                visible: cardRoot.secondaryValue !== ""

                // Left Compartment (Primary / Actual Process Value)
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#0a2e50"

                    Text {
                        anchors.centerIn: parent
                        text: cardRoot.primaryValue
                        color: "#ffffff"
                        font.bold: true
                        font.pixelSize: 15
                    }
                }

                // Vertical Divider Line
                Rectangle {
                    width: 1
                    Layout.fillHeight: true
                    color: "#1d5b94"
                }

                // Right Compartment (Secondary / Target Value with lighter contrasting shade)
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#154d80"

                    Text {
                        anchors.centerIn: parent
                        text: cardRoot.secondaryValue
                        color: "#ffffff"
                        font.bold: true
                        font.pixelSize: 14
                    }
                }
            }

            // CASE B: Single-Value Card (Centered value + unit)
            RowLayout {
                anchors.centerIn: parent
                spacing: 4
                visible: cardRoot.secondaryValue === ""

                Text {
                    text: cardRoot.primaryValue
                    color: "#ffffff"
                    font.bold: true
                    font.pixelSize: 15
                }

                Text {
                    text: cardRoot.unit
                    color: "#8cb5dc"
                    font.pixelSize: 11
                }
            }

            // Bottom Progress Bar (if enabled, e.g. Vacuum Pressure, Temperature Gradient)
            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 3
                color: "#061a30"
                visible: cardRoot.showProgressBar

                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: Math.max(0, Math.min(parent.width, parent.width * Math.max(0.0, Math.min(1.0, cardRoot.progressValue))))
                    color: cardRoot.progressColor
                }
            }
        }
    }
}
