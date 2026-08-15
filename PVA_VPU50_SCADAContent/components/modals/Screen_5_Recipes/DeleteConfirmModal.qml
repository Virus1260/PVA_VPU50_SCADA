import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: deleteModalRoot
    anchors.fill: parent
    color: "#bb000000"
    visible: false
    z: 999

    property string message: "Are you sure you want to delete this recipe? This action cannot be undone."

    signal confirmed()
    signal cancelled()

    MouseArea {
        anchors.fill: parent
    }

    Rectangle {
        anchors.centerIn: parent
        width: 380
        height: 180
        color: "#0d2847"
        border.color: "#ef4444"
        border.width: 1.5
        radius: 8

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 14

            RowLayout {
                spacing: 8
                Text { text: "⚠️"; font.pixelSize: 20 }
                Text { text: "Confirm Recipe Deletion"; color: "#fca5a5"; font.bold: true; font.pixelSize: 14 }
            }

            Text {
                text: deleteModalRoot.message
                color: "#cbd5e1"
                font.pixelSize: 12
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }

            Item { Layout.fillHeight: true }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 34
                    radius: 4
                    color: "#091a2a"
                    border.color: "#1e40af"
                    border.width: 1
                    Text { anchors.centerIn: parent; text: "Cancel"; color: "#94a3b8"; font.pixelSize: 12 }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            deleteModalRoot.visible = false;
                            deleteModalRoot.cancelled();
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 34
                    radius: 4
                    color: "#7f1d1d"
                    border.color: "#ef4444"
                    border.width: 1
                    Text { anchors.centerIn: parent; text: "Delete"; color: "#fca5a5"; font.bold: true; font.pixelSize: 12 }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            deleteModalRoot.visible = false;
                            deleteModalRoot.confirmed();
                        }
                    }
                }
            }
        }
    }
}
