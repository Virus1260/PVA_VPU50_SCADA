import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../widgets"

Rectangle {
    id: modalRoot
    anchors.fill: parent
    color: "#95000000"

    signal modeSelected(string mode)
    signal closed()

    MouseArea { anchors.fill: parent }

    Rectangle {
        id: modalBox
        anchors.centerIn: parent
        width: Math.max(420, Math.min(parent.width * 0.48, 560))
        height: Math.max(300, Math.min(parent.height * 0.55, 380))
        color: "#08213b"
        border.color: "#184d7e"
        border.width: 2
        radius: 8

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 14

            RowLayout {
                Layout.fillWidth: true
                Text { text: "SELECT HOMOGENIZER RUN MODE"; color: "#ffffff"; font.bold: true; font.pixelSize: 15 }
                Item { Layout.fillWidth: true }
                Rectangle {
                    width: 28
                    height: 28
                    radius: 4
                    color: "#0d365e"
                    border.color: "#1d5b94"
                    border.width: 1
                    Text { anchors.centerIn: parent; text: "✕"; color: "#ffffff"; font.bold: true; font.pixelSize: 14 }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: modalRoot.closed()
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 14

                // Permanent
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#0f3862"
                    border.color: "#184d7e"
                    radius: 6

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 10
                        ScadaIcon { iconName: "homo_permanent"; width: 52; height: 52; Layout.alignment: Qt.AlignHCenter }
                        Text { text: "Permanent\nContinuous Run"; color: "#ffffff"; font.bold: true; font.pixelSize: 12; horizontalAlignment: Text.AlignHCenter }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: { modalRoot.modeSelected("homo_permanent"); modalRoot.closed(); }
                    }
                }

                // Interval
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#0f3862"
                    border.color: "#184d7e"
                    radius: 6

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 10
                        ScadaIcon { iconName: "homo_interval"; width: 52; height: 52; Layout.alignment: Qt.AlignHCenter }
                        Text { text: "Interval Pulse\n(Timer ON/OFF)"; color: "#ffffff"; font.bold: true; font.pixelSize: 12; horizontalAlignment: Text.AlignHCenter }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: { modalRoot.modeSelected("homo_interval"); modalRoot.closed(); }
                    }
                }

                // Internal Loop
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#0f3862"
                    border.color: "#184d7e"
                    radius: 6

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 10
                        ScadaIcon { iconName: "homogenizer"; width: 52; height: 52; Layout.alignment: Qt.AlignHCenter }
                        Text { text: "Internal Vessel\nRecirculation"; color: "#ffffff"; font.bold: true; font.pixelSize: 12; horizontalAlignment: Text.AlignHCenter }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: { modalRoot.modeSelected("homogenizer"); modalRoot.closed(); }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 36
                radius: 4
                color: "#0d365e"
                border.color: "#1d5b94"
                border.width: 1
                Text { anchors.centerIn: parent; text: "Cancel"; color: "#8cb5dc"; font.bold: true; font.pixelSize: 12 }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: modalRoot.closed()
                }
            }
        }
    }
}
