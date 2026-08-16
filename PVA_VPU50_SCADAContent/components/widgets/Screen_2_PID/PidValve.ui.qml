/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML.
*/
import QtQuick

Item {
    id: valveRoot
    width: 28
    height: 28

    property string tag: "V101"
    property string subLabel: ""
    property bool isOpen: false
    property bool isVertical: false
    property string valveType: "diaphragm" // Options: "diaphragm" (solenoid) or "butterfly"
    property bool isButterfly: (valveType === "butterfly")
    property bool showTags: true

    property alias mouseArea: valveMouseArea

    signal clicked()

    // 1. Pixel-Perfect Vector Valve Symbol (Diaphragm & Butterfly - Open=Green, Closed=Red)
    Image {
        id: valveIcon
        anchors.centerIn: parent
        width: 24
        height: 22
        source: valveRoot.isButterfly ? 
                (valveRoot.isOpen ? "../../../assets/icons/pid/valve_butterfly_open.svg" : "../../../assets/icons/pid/valve_butterfly_closed.svg") :
                (valveRoot.isOpen ? "../../../assets/icons/pid/valve_diaphragm_open.svg" : "../../../assets/icons/pid/valve_diaphragm_closed.svg")
        sourceSize.width: 48
        sourceSize.height: 44
        fillMode: Image.PreserveAspectFit
        rotation: valveRoot.isVertical ? 90 : 0
    }

    // 2. Tag Label
    Text {
        visible: valveRoot.showTags
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.top
        anchors.bottomMargin: 1
        text: valveRoot.tag
        color: valveRoot.isOpen ? "#4ade80" : "#cbd5e1"
        font.pixelSize: 8
        font.bold: valveRoot.isOpen
    }

    // 3. Sub-Label
    Text {
        visible: valveRoot.showTags && valveRoot.subLabel.length > 0
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
        anchors.topMargin: 1
        text: valveRoot.subLabel
        color: "#94a3b8"
        font.pixelSize: 7
    }

    MouseArea {
        id: valveMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
    }
}
