import QtQuick
import QtQuick.Layouts

Rectangle {
    id: cardRoot
    property string title: "Card Title"
    property string primaryValue: "0.0"
    property string secondaryValue: ""
    property string unit: ""
    property bool showProgressBar: false
    property real progressValue: 0.0
    property color progressColor: "#00d2ff"

    property real preferredCardWidth: 92
    property real cardHeight: 76

    Layout.preferredWidth: preferredCardWidth
    Layout.preferredHeight: cardHeight
    Layout.minimumHeight: cardHeight
    Layout.maximumHeight: cardHeight

    color: "#092848"
    border.color: "#184d7e"
    border.width: 1
    radius: 4

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 6
        spacing: 2

        // Title at Top Center
        Text {
            text: cardRoot.title
            color: "#8cb5dc"
            font.pixelSize: 10
            font.bold: false
            elide: Text.ElideRight
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
        }

        Item { Layout.fillHeight: true }

        // Centered Primary & Secondary Values & Unit
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 3

            Text {
                text: cardRoot.primaryValue
                color: "#ffffff"
                font.pixelSize: 16
                font.bold: true
            }

            Text {
                text: cardRoot.secondaryValue !== "" ? cardRoot.secondaryValue : ""
                color: "#8cb5dc"
                font.pixelSize: 12
                font.bold: true
                visible: cardRoot.secondaryValue !== ""
            }

            Text {
                text: cardRoot.unit
                color: "#8cb5dc"
                font.pixelSize: 11
                visible: cardRoot.unit !== ""
            }
        }

        Item { Layout.fillHeight: true }

        // Optional Cyan Progress Bar
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 4
            color: "#0d365e"
            radius: 2
            visible: cardRoot.showProgressBar

            Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width * Math.max(0.0, Math.min(1.0, cardRoot.progressValue))
                color: cardRoot.progressColor
                radius: 2
            }
        }
    }
}
