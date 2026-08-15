import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: stepConfirmRoot
    implicitWidth: 1024
    implicitHeight: 600
    width: 1024
    height: 600
    color: "#cc000000"
    z: 999

    property string stepName: "Add Phase B"
    property string confirmMessage: "Have you added all Phase B oil ingredients (Items 6–10)?"
    property int timeoutSec: 60

    signal confirmed()
    signal aborted()

    Timer {
        id: countdownTimer
        interval: 1000
        repeat: true
        running: stepConfirmRoot.visible
        onTriggered: {
            if (stepConfirmRoot.timeoutSec > 0) {
                stepConfirmRoot.timeoutSec--;
            }
        }
    }

    MouseArea { anchors.fill: parent }

    Rectangle {
        anchors.centerIn: parent
        width: 460
        height: 230
        color: "#08213b"
        border.color: "#f59e0b"
        border.width: 2
        radius: 8

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 12

            RowLayout {
                spacing: 8
                Text { text: "⚠️"; font.pixelSize: 22 }
                Text {
                    text: "Operator Confirmation Required: " + stepConfirmRoot.stepName
                    color: "#fbbf24"
                    font.bold: true
                    font.pixelSize: 14
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 70
                color: "#06182c"
                border.color: "#1e40af"
                border.width: 1
                radius: 6

                Text {
                    anchors.fill: parent
                    anchors.margins: 10
                    text: stepConfirmRoot.confirmMessage
                    color: "#ffffff"
                    font.pixelSize: 13
                    wrapMode: Text.WordWrap
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Text {
                    text: "Auto-pause in: " + stepConfirmRoot.timeoutSec + "s"
                    color: "#94a3b8"
                    font.pixelSize: 11
                }

                Item { Layout.fillWidth: true }

                Rectangle {
                    Layout.preferredWidth: 90
                    Layout.preferredHeight: 34
                    radius: 4
                    color: "#450a0a"
                    border.color: "#ef4444"
                    border.width: 1
                    Text { anchors.centerIn: parent; text: "Abort Step"; color: "#fca5a5"; font.bold: true; font.pixelSize: 12 }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            stepConfirmRoot.visible = false;
                            stepConfirmRoot.aborted();
                        }
                    }
                }

                Rectangle {
                    Layout.preferredWidth: 130
                    Layout.preferredHeight: 34
                    radius: 4
                    color: "#16a34a"
                    border.color: "#4ade80"
                    border.width: 1.5
                    Text { anchors.centerIn: parent; text: "✓ Confirm & Proceed"; color: "#ffffff"; font.bold: true; font.pixelSize: 12 }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            stepConfirmRoot.visible = false;
                            stepConfirmRoot.confirmed();
                        }
                    }
                }
            }
        }
    }
}
