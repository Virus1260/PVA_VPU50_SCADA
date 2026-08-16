/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML.
*/
import QtQuick
import QtQuick.Layouts

Item {
    id: pumpRoot
    width: 52
    height: 52

    property string tag: "P 168 001"
    property string pressTag: "PI 168 001"
    property real pressureBar: 1.2
    property bool isRunning: false
    property bool showTags: true

    property alias mouseArea: pumpMouseArea

    signal clicked()

    // 1. DIAL PRESSURE GAUGE (Top-Right Process Dial)
    Rectangle {
        id: dialHousing
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 0
        anchors.rightMargin: 0
        width: 16
        height: 16
        radius: 8
        color: "#ffffff"
        border.color: "#0369a1"
        border.width: 1.2
        z: 5

        // Dial Pointer Needle (45 deg)
        Rectangle {
            anchors.centerIn: parent
            width: 1.2
            height: 6
            color: "#dc2626"
            transformOrigin: Item.Bottom
            rotation: pumpRoot.isRunning ? 55 : -35
        }

        // Center Pivot Pin
        Rectangle {
            anchors.centerIn: parent
            width: 3
            height: 3
            radius: 1.5
            color: "#0f172a"
        }
    }

    // 2. REALISTIC INDUSTRIAL CENTRIFUGAL VOLUTE PUMP (100% Qt Design Studio Visible)
    Image {
        id: pumpVector
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: 44
        height: 40
        source: pumpRoot.isRunning ? 
                "../../../assets/icons/pid/pump_centrifugal_running.svg" : 
                "../../../assets/icons/pid/pump_centrifugal_idle.svg"
        sourceSize.width: 88
        sourceSize.height: 80
        fillMode: Image.PreserveAspectFit
    }

    // 3. TAG LABELS
    Text {
        visible: pumpRoot.showTags
        anchors.horizontalCenter: pumpVector.horizontalCenter
        anchors.top: pumpVector.bottom
        anchors.topMargin: 2
        text: pumpRoot.tag
        color: pumpRoot.isRunning ? "#4ade80" : "#8cb5dc"
        font.pixelSize: 8
        font.bold: true
    }

    MouseArea {
        id: pumpMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
    }
}
