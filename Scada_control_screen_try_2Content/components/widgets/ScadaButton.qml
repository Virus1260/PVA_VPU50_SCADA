import QtQuick

Rectangle {
    id: btnRoot
    width: 60
    height: 36
    radius: 3

    property string text: "Button"
    property color accentColor: "#0f4477"
    property color textColor: "#ffffff"
    property bool isPressed: mouseArea.pressed

    signal clicked()

    color: isPressed ? Qt.darker(accentColor, 1.2) : (mouseArea.containsMouse ? Qt.lighter(accentColor, 1.15) : accentColor)
    border.color: Qt.lighter(accentColor, 1.3)
    border.width: 1

    Text {
        anchors.centerIn: parent
        text: btnRoot.text
        color: btnRoot.textColor
        font.bold: true
        font.pixelSize: 11
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: btnRoot.clicked()
    }
}
