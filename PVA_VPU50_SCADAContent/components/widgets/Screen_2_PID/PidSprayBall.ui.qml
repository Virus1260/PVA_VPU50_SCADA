/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML.
*/
import QtQuick

Item {
    id: sprayRoot
    width: 36
    height: 48

    property string tag: "X 165 501"
    property bool isSpraying: false
    property real sprayAngle: 0.0 // 0 = straight down, -35 = angled right
    property bool showTags: true

    Item {
        id: rotatedHead
        x: (parent.width - width) / 2
        y: 0
        width: 24
        height: 32
        transformOrigin: Item.Top
        rotation: sprayRoot.sprayAngle

        // 1. Pixel-Perfect Vector Spray Ball (100% Qt Design Studio Visible)
        Image {
            id: sprayIcon
            anchors.fill: parent
            source: sprayRoot.isSpraying ? "../../../assets/icons/pid/spray_ball_active.svg" : "../../../assets/icons/pid/spray_ball_standby.svg"
            sourceSize.width: 48
            sourceSize.height: 64
            fillMode: Image.PreserveAspectFit
        }
    }

    // 2. Tag text below the head (e.g. X 165 501)
    Text {
        visible: sprayRoot.showTags
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        text: sprayRoot.tag
        color: "#8cb5dc"
        font.pixelSize: 7
        font.bold: true
    }
}
