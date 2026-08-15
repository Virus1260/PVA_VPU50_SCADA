import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../widgets"

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
                Text { text: "SELECT AGITATOR ROTATION MODE"; color: "#ffffff"; font.bold: true; font.pixelSize: 15 }
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

                // CW
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#0f3862"
                    border.color: "#184d7e"
                    radius: 6

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 10
                        ScadaIcon { width: 52; height: 52; iconName: "agitator_cw"; Layout.alignment: Qt.AlignHCenter }
                        Text { text: "Clockwise (CW)\nDown-Pumping"; color: "#ffffff"; font.bold: true; font.pixelSize: 12; horizontalAlignment: Text.AlignHCenter }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: { modalRoot.modeSelected("agitator_cw"); modalRoot.closed(); }
                    }
                }

                // CCW
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#0f3862"
                    border.color: "#184d7e"
                    radius: 6

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 10
                        ScadaIcon { iconName: "agitator_ccw"; width: 52; height: 52; Layout.alignment: Qt.AlignHCenter }
                        Text { text: "Counter-CW (CCW)\nUp-Pumping"; color: "#ffffff"; font.bold: true; font.pixelSize: 12; horizontalAlignment: Text.AlignHCenter }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: { modalRoot.modeSelected("agitator_ccw"); modalRoot.closed(); }
                    }
                }

                // Reversing
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#0f3862"
                    border.color: "#184d7e"
                    radius: 6

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 10
                        ScadaIcon { iconName: "agitator_reversing"; width: 52; height: 52; Layout.alignment: Qt.AlignHCenter }
                        Text { text: "Reversing Cycle\n(Interval CW/CCW)"; color: "#ffffff"; font.bold: true; font.pixelSize: 12; horizontalAlignment: Text.AlignHCenter }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: { modalRoot.modeSelected("agitator_reversing"); modalRoot.closed(); }
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
