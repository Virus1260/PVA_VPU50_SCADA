import QtQuick
import QtQuick.Layouts

Rectangle {
    id: selectorRoot
    property string label: "Mode"
    property string modeText: ""
    property string iconName: ""
    property real preferredWidth: 76
    property real selectorHeight: 68
    property bool isPressed: mouseArea.pressed

    signal clicked()

    Layout.preferredWidth: preferredWidth
    Layout.preferredHeight: selectorHeight
    Layout.minimumHeight: selectorHeight
    Layout.maximumHeight: selectorHeight

    color: isPressed ? "#124373" : (mouseArea.containsMouse ? "#0f3c67" : "#0d345a")
    border.color: mouseArea.containsMouse ? "#3892e6" : "#1e5b94"
    border.width: 1
    radius: 4

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 4
        spacing: 2

        Text {
            text: selectorRoot.label
            color: "#8cb5dc"
            font.pixelSize: 10
            Layout.alignment: Qt.AlignHCenter
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ScadaIcon {
                anchors.centerIn: parent
                iconName: selectorRoot.iconName
                width: 34
                height: 34
                visible: selectorRoot.iconName !== ""
            }

            Text {
                anchors.centerIn: parent
                text: selectorRoot.modeText
                color: "#ffffff"
                font.bold: true
                font.pixelSize: 11
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                visible: selectorRoot.iconName === ""
            }
        }

        Text {
            text: "▼"
            color: "#8cb5dc"
            font.pixelSize: 8
            Layout.alignment: Qt.AlignHCenter
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: selectorRoot.clicked()
    }
}
