import QtQuick
import QtQuick.Layouts

Rectangle {
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
    Layout.maximumWidth: 220
    Layout.preferredHeight: cardHeight
    Layout.minimumHeight: cardHeight
    Layout.maximumHeight: cardHeight

    color: "#082646"
    border.color: "#184d7e"
    border.width: 1
    radius: 4

    ColumnLayout {
        anchors.fill: parent
        anchors.leftMargin: 6
        anchors.rightMargin: 6
        anchors.topMargin: 5
        anchors.bottomMargin: 5
        spacing: 2

        // Card Title (Top centered)
        Text {
            text: cardRoot.title
            color: "#8cb5dc"
            font.pixelSize: 10
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
        }

        Item { Layout.fillHeight: true }

        // Readout Values Row (Primary large value + optional secondary/unit)
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 3

            Text {
                text: cardRoot.primaryValue
                color: "#ffffff"
                font.bold: true
                font.pixelSize: 15
            }

            Text {
                text: cardRoot.secondaryValue
                color: "#8cb5dc"
                font.pixelSize: 11
                visible: cardRoot.secondaryValue !== ""
            }

            Text {
                text: cardRoot.unit
                color: "#8cb5dc"
                font.pixelSize: 10
                visible: cardRoot.unit !== ""
            }
        }

        Item { Layout.fillHeight: true }

        // Optional Cyan/Blue Progress Bar
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 3
            color: "#061a30"
            radius: 1
            visible: cardRoot.showProgressBar

            Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: Math.max(0, Math.min(parent.width, parent.width * Math.max(0.0, Math.min(1.0, cardRoot.progressValue))))
                color: cardRoot.progressColor
                radius: 1
            }
        }
    }
}
