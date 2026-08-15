import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: playbackRoot
    color: "#08213b"

    property real playbackPosition: 0.35
    property bool isPlaying: false

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 12

        RowLayout {
            Layout.fillWidth: true
            Text {
                text: "BATCH PROCESS LOG REPLAY & TIMELINE INSPECTION"
                color: "#ffffff"
                font.bold: true
                font.pixelSize: 16
            }
            Item { Layout.fillWidth: true }
            ComboBox {
                model: ["Batch_2024_0911_01 (Complete)", "Batch_2024_0910_02 (Complete)"]
                Layout.preferredWidth: 280
                Layout.preferredHeight: 32
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#06182c"
            border.color: "#164673"
            border.width: 1
            radius: 4

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 16

                Text {
                    text: "Selected Batch Time: 00:45:20 / 02:15:00"
                    color: "#00e5ff"
                    font.bold: true
                    font.pixelSize: 14
                    Layout.alignment: Qt.AlignHCenter
                }

                Slider {
                    Layout.fillWidth: true
                    from: 0.0
                    to: 1.0
                    value: playbackRoot.playbackPosition
                    onMoved: playbackRoot.playbackPosition = value
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 20

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 80
                        color: "#092440"
                        border.color: "#164673"
                        radius: 4

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 4
                            Text { text: "Stirrer Speed"; color: "#91b8db"; font.pixelSize: 11; Layout.alignment: Qt.AlignHCenter }
                            Text { text: (playbackRoot.playbackPosition * 60.0).toFixed(1) + " rpm"; color: "#ffffff"; font.bold: true; font.pixelSize: 16; Layout.alignment: Qt.AlignHCenter }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 80
                        color: "#092440"
                        border.color: "#164673"
                        radius: 4

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 4
                            Text { text: "Vessel Temperature"; color: "#91b8db"; font.pixelSize: 11; Layout.alignment: Qt.AlignHCenter }
                            Text { text: (25.0 + playbackRoot.playbackPosition * 50.0).toFixed(1) + " °C"; color: "#ff9100"; font.bold: true; font.pixelSize: 16; Layout.alignment: Qt.AlignHCenter }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 80
                        color: "#092440"
                        border.color: "#164673"
                        radius: 4

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 4
                            Text { text: "Chamber Vacuum"; color: "#91b8db"; font.pixelSize: 11; Layout.alignment: Qt.AlignHCenter }
                            Text { text: (-100.0 - playbackRoot.playbackPosition * 750.0).toFixed(1) + " mbar"; color: "#00e5ff"; font.bold: true; font.pixelSize: 16; Layout.alignment: Qt.AlignHCenter }
                        }
                    }
                }

                Item { Layout.fillHeight: true }

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 12

                    Button { text: "⏮ Step Back"; Layout.preferredWidth: 100 }
                    Button {
                        text: playbackRoot.isPlaying ? "❚❚ Pause" : "▶ Play"
                        Layout.preferredWidth: 100
                        background: Rectangle { color: "#78dc24"; radius: 4 }
                        onClicked: playbackRoot.isPlaying = !playbackRoot.isPlaying
                    }
                    Button { text: "⏭ Step Next"; Layout.preferredWidth: 100 }
                }
            }
        }
    }
}
