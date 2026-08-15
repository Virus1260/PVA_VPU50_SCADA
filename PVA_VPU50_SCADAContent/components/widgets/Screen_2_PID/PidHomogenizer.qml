import QtQuick
import QtQuick.Layouts

Item {
    id: homogRoot
    width: 200
    height: 90

    property string motorTag: "M 163 001"
    property string speedTag: "SCR 163001"
    property real speedRpm: 4800.0
    property bool isRunning: true
    property bool showTags: true

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 3

        // 1. STATOR CHAMBER (Neon green with glowing dots when running)
        Rectangle {
            Layout.preferredWidth: 42
            Layout.preferredHeight: 18
            Layout.alignment: Qt.AlignHCenter
            radius: 2
            color: homogRoot.isRunning ? "#4ade80" : "#0d2847"
            border.color: homogRoot.isRunning ? "#22c55e" : "#3b82f6"
            border.width: 1.2

            Row {
                anchors.centerIn: parent
                spacing: 8
                Rectangle { width: 4; height: 4; radius: 2; color: homogRoot.isRunning ? "#ffffff" : "#4a90d9" }
                Rectangle { width: 4; height: 4; radius: 2; color: homogRoot.isRunning ? "#ffffff" : "#4a90d9" }
            }
        }

        // 2. BOTTOM DRIVE MOTOR & SPEED TAG
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 6

            Rectangle {
                width: 20
                height: 20
                radius: 10
                color: homogRoot.isRunning ? "#4ade80" : "#0d2847"
                border.color: homogRoot.isRunning ? "#22c55e" : "#3b82f6"
                border.width: 1.5

                Text {
                    anchors.centerIn: parent
                    text: "M"
                    color: homogRoot.isRunning ? "#052e16" : "#ffffff"
                    font.bold: true
                    font.pixelSize: 10
                }
            }

            ColumnLayout {
                spacing: 0
                visible: homogRoot.showTags
                Text { text: homogRoot.speedTag; color: "#8cb5dc"; font.pixelSize: 7 }
                Text {
                    text: homogRoot.speedRpm.toFixed(0) + "rpm"
                    color: homogRoot.isRunning ? "#4ade80" : "#94a3b8"
                    font.bold: true
                    font.pixelSize: 8
                }
            }
        }
    }
}
