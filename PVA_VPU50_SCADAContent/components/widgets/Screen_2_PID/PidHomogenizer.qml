import QtQuick
import QtQuick.Layouts

Item {
    id: homogRoot
    width: 140
    height: 90

    property string motorTag: "M 163 001"
    property string speedTag: "SCR 163001"
    property real speedRpm: 0.0
    property bool isRunning: false

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 4

        // 1. ROTOR / STATOR CHAMBER
        Rectangle {
            Layout.preferredWidth: 64
            Layout.preferredHeight: 30
            Layout.alignment: Qt.AlignHCenter
            radius: 4
            color: homogRoot.isRunning ? "#14532d" : "#0d2847"
            border.color: homogRoot.isRunning ? "#22c55e" : "#4a90d9"
            border.width: 1.5

            Text {
                anchors.centerIn: parent
                text: "HOMOG"
                color: homogRoot.isRunning ? "#4ade80" : "#8cb5dc"
                font.bold: true
                font.pixelSize: 10
            }
        }

        // 2. BOTTOM DRIVE MOTOR (M 163 001)
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 8

            Rectangle {
                width: 28
                height: 28
                radius: 14
                color: homogRoot.isRunning ? "#166534" : "#0d2847"
                border.color: homogRoot.isRunning ? "#22c55e" : "#4a90d9"
                border.width: 1.5

                Text {
                    anchors.centerIn: parent
                    text: "M"
                    color: "#ffffff"
                    font.bold: true
                    font.pixelSize: 11
                }
            }

            ColumnLayout {
                spacing: 0
                Text { text: homogRoot.motorTag; color: "#94a3b8"; font.pixelSize: 8 }
                Text { text: homogRoot.speedTag; color: "#8cb5dc"; font.pixelSize: 8 }
                Text {
                    text: homogRoot.speedRpm.toFixed(0) + " rpm"
                    color: homogRoot.isRunning ? "#22c55e" : "#94a3b8"
                    font.bold: true
                    font.pixelSize: 10
                }
            }
        }
    }
}
