import QtQuick
import QtQuick.Layouts

Rectangle {
    id: runtimeRoot
    property string timeText: "00:00:00"
    property real preferredWidth: 66
    property real widgetHeight: 68

    Layout.preferredWidth: preferredWidth
    Layout.minimumWidth: preferredWidth
    Layout.maximumWidth: preferredWidth
    Layout.preferredHeight: widgetHeight
    Layout.minimumHeight: widgetHeight
    Layout.maximumHeight: widgetHeight

    color: "#0d345a"
    border.color: "#1e5b94"
    border.width: 1
    radius: 4

    ColumnLayout {
        anchors.fill: parent
        anchors.leftMargin: 2
        anchors.rightMargin: 2
        anchors.topMargin: 4
        anchors.bottomMargin: 4
        spacing: 2

        // Top Header
        Text {
            text: "Runtime"
            color: "#8cb5dc"
            font.pixelSize: 9
            font.bold: true
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
        }

        // Center Clock Icon
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Image {
                anchors.centerIn: parent
                width: 24
                height: 24
                source: "../../assets/icons/controls/clock.svg"
                fillMode: Image.PreserveAspectFit
                mipmap: true
                smooth: true
            }
        }

        // Digital Time Readout
        Text {
            text: runtimeRoot.timeText
            color: "#ffffff"
            font.bold: true
            font.pixelSize: 10
            Layout.alignment: Qt.AlignHCenter
        }

        // Bottom Dropdown Arrow
        Text {
            text: "▼"
            color: "#8cb5dc"
            font.pixelSize: 7
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
