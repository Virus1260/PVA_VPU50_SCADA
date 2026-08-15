import QtQuick
import QtQuick.Layouts

Rectangle {
    id: runtimeRoot
    property string timeText: "00:00:00"
    property real preferredWidth: 80
    property real widgetHeight: 74

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
        anchors.margins: 6
        spacing: 2

        Text {
            text: "Runtime"
            color: "#8cb5dc"
            font.pixelSize: 11
            Layout.alignment: Qt.AlignHCenter
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Image {
                anchors.centerIn: parent
                width: 26
                height: 26
                source: "../../assets/icons/controls/clock.svg"
                fillMode: Image.PreserveAspectFit
                mipmap: true
                smooth: true
            }
        }

        Text {
            text: runtimeRoot.timeText
            color: "#ffffff"
            font.bold: true
            font.pixelSize: 12
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: "▼"
            color: "#8cb5dc"
            font.pixelSize: 8
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
