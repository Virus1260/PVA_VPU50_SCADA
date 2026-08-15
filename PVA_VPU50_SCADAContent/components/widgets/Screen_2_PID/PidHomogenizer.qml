import QtQuick
import QtQuick.Layouts

Item {
    id: homogRoot
    width: 140
    height: 75

    property string motorTag: "M 163 001"
    property string speedTag: "SCR 163001"
    property real speedRpm: 4800.0
    property bool isRunning: true

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 3

        // 1. ROTOR / STATOR CHAMBER
        Rectangle {
            Layout.preferredWidth: 38
            Layout.preferredHeight: 18
            Layout.alignment: Qt.AlignHCenter
            radius: 2
            color: homogRoot.isRunning ? "#15803d" : "#0d2847"
            border.color: homogRoot.isRunning ? "#4ade80" : "#3b82f6"
            border.width: 1.2

            Text {
                anchors.centerIn: parent
                text: "Z 163 001"
                color: "#ffffff"
                font.bold: true
                font.pixelSize: 7
            }
        }

        // 2. BOTTOM DRIVE MOTOR & SPEED TAG
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 6

            Rectangle {
                width: 22
                height: 22
                radius: 11
                color: homogRoot.isRunning ? "#16a34a" : "#0d2847"
                border.color: homogRoot.isRunning ? "#4ade80" : "#3b82f6"
                border.width: 1.2

                Text {
                    anchors.centerIn: parent
                    text: "M"
                    color: "#ffffff"
                    font.bold: true
                    font.pixelSize: 10
                }
            }

            ColumnLayout {
                spacing: 0
                Text { text: homogRoot.speedTag; color: "#8cb5dc"; font.pixelSize: 7 }
                Text {
                    text: homogRoot.speedRpm.toFixed(0) + "rpm"
                    color: homogRoot.isRunning ? "#4ade80" : "#94a3b8"
                    font.bold: true
                    font.pixelSize: 8
                }
                Text { text: homogRoot.motorTag; color: "#64748b"; font.pixelSize: 7 }
            }
        }
    }
}
