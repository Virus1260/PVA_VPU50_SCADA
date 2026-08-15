import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: confirmRoot
    anchors.fill: parent
    color: "#95000000"

    property string title: "Confirm Manual Valve Positioning"
    property string instruction: "Please turn Manual Butterfly Valve V101 to OPEN position as required for current operation."
    property string tag: "V101"

    signal confirmed()
    signal cancelled()
    signal closed()

    MouseArea { anchors.fill: parent }

    Rectangle {
        id: modalBox
        anchors.centerIn: parent
        width: Math.max(420, Math.min(parent.width * 0.44, 520))
        height: Math.max(280, Math.min(parent.height * 0.5, 340))
        color: "#08213b"
        border.color: "#ffd54f"
        border.width: 2
        radius: 8

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 14

            RowLayout {
                spacing: 10
                Rectangle {
                    width: 32
                    height: 32
                    radius: 16
                    color: "#ffd54f"
                    Text {
                        anchors.centerIn: parent
                        text: "!"
                        color: "#08213b"
                        font.bold: true
                        font.pixelSize: 20
                    }
                }
                Text {
                    text: confirmRoot.title
                    color: "#ffffff"
                    font.bold: true
                    font.pixelSize: 15
                    Layout.fillWidth: true
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#051829"
                border.color: "#184d7e"
                border.width: 1
                radius: 4

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 6
                    Text {
                        text: confirmRoot.instruction
                        color: "#ffffff"
                        font.pixelSize: 13
                        wrapMode: Text.Wrap
                        Layout.fillWidth: true
                    }
                    Item { Layout.fillHeight: true }
                    Text {
                        text: "Tag: " + confirmRoot.tag
                        color: "#00d2ff"
                        font.bold: true
                        font.pixelSize: 12
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 38
                    radius: 4
                    color: "#0d365e"
                    border.color: "#1d5b94"
                    border.width: 1
                    Text { anchors.centerIn: parent; text: "Cancel"; color: "#8cb5dc"; font.bold: true; font.pixelSize: 12 }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: { confirmRoot.cancelled(); confirmRoot.closed(); }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 38
                    radius: 4
                    color: "#78dc20"
                    border.color: "#ffffff"
                    border.width: 1
                    Text { anchors.centerIn: parent; text: "✓ Confirm Positioning"; color: "#08213b"; font.bold: true; font.pixelSize: 13 }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: { confirmRoot.confirmed(); confirmRoot.closed(); }
                    }
                }
            }
        }
    }
}
