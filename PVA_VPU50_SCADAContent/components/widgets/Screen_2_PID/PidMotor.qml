import QtQuick
import QtQuick.Layouts

Item {
    id: motorRoot
    width: 90
    height: 70

    property string motorTag: "M 162 001"
    property string speedTag: "SCR 162001"
    property real speedRpm: 0.0
    property bool isRunning: false
    property bool showTags: true
    property bool showSpeedAbove: true
    property bool enableVibration: false

    signal clicked()

    // High-Frequency Micro Vibration Effect when running (as in VPU10 SCADA)
    property real vibX: 0
    property real vibY: 0

    SequentialAnimation {
        running: motorRoot.isRunning && motorRoot.enableVibration
        loops: Animation.Infinite
        NumberAnimation { target: motorRoot; property: "vibX"; to: 1.0; duration: 35 }
        NumberAnimation { target: motorRoot; property: "vibY"; to: -1.0; duration: 35 }
        NumberAnimation { target: motorRoot; property: "vibX"; to: -1.0; duration: 35 }
        NumberAnimation { target: motorRoot; property: "vibY"; to: 1.0; duration: 35 }
        NumberAnimation { target: motorRoot; property: "vibX"; to: 0.0; duration: 35 }
        NumberAnimation { target: motorRoot; property: "vibY"; to: 0.0; duration: 35 }
    }

    transform: Translate {
        x: motorRoot.vibX
        y: motorRoot.vibY
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 1

        // Speed & Motor Tag (When displayed above motor circle)
        ColumnLayout {
            visible: motorRoot.showTags && motorRoot.showSpeedAbove
            spacing: 0
            Layout.alignment: Qt.AlignHCenter

            Text {
                visible: motorRoot.speedTag.length > 0
                text: motorRoot.speedTag
                color: "#8cb5dc"
                font.bold: true
                font.pixelSize: 8
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: motorRoot.speedRpm.toFixed(1) + "rpm"
                color: motorRoot.isRunning ? "#4ade80" : "#ffffff"
                font.bold: true
                font.pixelSize: 8
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: motorRoot.motorTag
                color: "#8cb5dc"
                font.bold: true
                font.pixelSize: 8
                Layout.alignment: Qt.AlignHCenter
            }
        }

        // Circular Motor Symbol 'M' with Pulsing Running Glow
        Rectangle {
            id: motorCircle
            Layout.alignment: Qt.AlignHCenter
            width: 24
            height: 24
            radius: 12
            color: motorRoot.isRunning ? "#4ade80" : "#0d2847"
            border.color: motorRoot.isRunning ? "#22c55e" : "#3b82f6"
            border.width: 1.6

            // Pulsing Glow Ring when Running
            Rectangle {
                anchors.centerIn: parent
                width: parent.width + 6
                height: parent.height + 6
                radius: width / 2
                color: "transparent"
                border.color: "#4ade80"
                border.width: 1.5
                opacity: 0.5
                visible: motorRoot.isRunning

                SequentialAnimation on opacity {
                    running: motorRoot.isRunning
                    loops: Animation.Infinite
                    NumberAnimation { from: 0.2; to: 0.8; duration: 600; easing.type: Easing.InOutQuad }
                    NumberAnimation { from: 0.8; to: 0.2; duration: 600; easing.type: Easing.InOutQuad }
                }
            }

            Text {
                anchors.centerIn: parent
                text: "M"
                color: motorRoot.isRunning ? "#052e16" : "#ffffff"
                font.bold: true
                font.pixelSize: 12
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: motorRoot.clicked()
            }
        }

        // Motor Tag (When displayed below motor circle)
        ColumnLayout {
            visible: motorRoot.showTags && !motorRoot.showSpeedAbove
            spacing: 0
            Layout.alignment: Qt.AlignHCenter

            Text {
                text: motorRoot.motorTag
                color: "#8cb5dc"
                font.bold: true
                font.pixelSize: 8
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                visible: motorRoot.speedTag.length > 0
                text: motorRoot.speedTag + " " + motorRoot.speedRpm.toFixed(0) + "rpm"
                color: motorRoot.isRunning ? "#4ade80" : "#ffffff"
                font.bold: true
                font.pixelSize: 8
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
