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
        width: Math.max(460, Math.min(parent.width * 0.52, 600))
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
                Text { text: "SELECT VACUUM / SUCTION MODE"; color: "#ffffff"; font.bold: true; font.pixelSize: 15 }
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
                spacing: 12

                // 1. Suction Liquids
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#0f3862"
                    border.color: "#184d7e"
                    radius: 6

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 10
                        ScadaIcon { iconName: "suction_liquids"; width: 48; height: 48; Layout.alignment: Qt.AlignHCenter }
                        Text { text: "Suction\nLiquids"; color: "#ffffff"; font.bold: true; font.pixelSize: 11; horizontalAlignment: Text.AlignHCenter }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: { modalRoot.modeSelected("SUCTION_LIQUIDS"); modalRoot.closed(); }
                    }
                }

                // 2. Suction Solids
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#0f3862"
                    border.color: "#184d7e"
                    radius: 6

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 10
                        ScadaIcon { iconName: "suction_solids"; width: 48; height: 48; Layout.alignment: Qt.AlignHCenter }
                        Text { text: "Suction\nSolids (Powder)"; color: "#ffffff"; font.bold: true; font.pixelSize: 11; horizontalAlignment: Text.AlignHCenter }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: { modalRoot.modeSelected("SUCTION_SOLIDS"); modalRoot.closed(); }
                    }
                }

                // 3. Suction Bottom
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#0f3862"
                    border.color: "#184d7e"
                    radius: 6

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 10
                        ScadaIcon { iconName: "suction_bottom"; width: 48; height: 48; Layout.alignment: Qt.AlignHCenter }
                        Text { text: "Suction\nBottom Valve"; color: "#ffffff"; font.bold: true; font.pixelSize: 11; horizontalAlignment: Text.AlignHCenter }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: { modalRoot.modeSelected("SUCTION_BOTTOM"); modalRoot.closed(); }
                    }
                }

                // 4. Chamber Venting
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#0f3862"
                    border.color: "#184d7e"
                    radius: 6

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 10
                        ScadaIcon { iconName: "vacuum_gauge"; width: 48; height: 48; Layout.alignment: Qt.AlignHCenter }
                        Text { text: "Atmospheric\nVenting"; color: "#ffffff"; font.bold: true; font.pixelSize: 11; horizontalAlignment: Text.AlignHCenter }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: { modalRoot.modeSelected("VENTING"); modalRoot.closed(); }
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
