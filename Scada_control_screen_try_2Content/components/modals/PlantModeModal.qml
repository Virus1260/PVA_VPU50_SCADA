import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

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
        width: Math.max(420, Math.min(parent.width * 0.44, 520))
        height: Math.max(360, Math.min(parent.height * 0.65, 460))
        color: "#08213b"
        border.color: "#184d7e"
        border.width: 2
        radius: 8

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 12

            // Header Bar
            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: "Plantmode"
                    color: "#ffffff"
                    font.bold: true
                    font.pixelSize: 18
                }
                Item { Layout.fillWidth: true }
                Rectangle {
                    width: 28
                    height: 28
                    radius: 4
                    color: "#0d365e"
                    border.color: "#1d5b94"
                    border.width: 1
                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        color: "#ffffff"
                        font.bold: true
                        font.pixelSize: 14
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: modalRoot.closed()
                    }
                }
            }

            // Subtitle Tag
            Text {
                text: "B1 - Unimix50"
                color: "#8cb5dc"
                font.bold: true
                font.pixelSize: 13
                Layout.alignment: Qt.AlignHCenter
            }

            // 2x2 Grid of Plantmode Options (Matching EKATO EPOS Image 5)
            GridLayout {
                columns: 2
                rows: 2
                Layout.fillWidth: true
                Layout.fillHeight: true
                columnSpacing: 14
                rowSpacing: 14

                // 1. Automatic Tile (Active Green Border)
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#0f3a64"
                    border.color: "#78dc20"
                    border.width: 2
                    radius: 6

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 8
                        Text {
                            text: "Automatic"
                            color: "#ffffff"
                            font.bold: true
                            font.pixelSize: 13
                            Layout.alignment: Qt.AlignHCenter
                        }
                        Rectangle {
                            width: 48
                            height: 48
                            radius: 24
                            color: "#78dc20"
                            Text {
                                anchors.centerIn: parent
                                text: "(A)"
                                color: "#000000"
                                font.bold: true
                                font.pixelSize: 18
                            }
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: { modalRoot.modeSelected("AUTOMATIC"); modalRoot.closed(); }
                    }
                }

                // 2. Recipe Tile
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#0f3a64"
                    border.color: "#1d5b94"
                    border.width: 1
                    radius: 6

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 8
                        Text {
                            text: "Recipe"
                            color: "#ffffff"
                            font.bold: true
                            font.pixelSize: 13
                            Layout.alignment: Qt.AlignHCenter
                        }
                        Image {
                            width: 40
                            height: 40
                            source: "../../assets/icons/nav/recipes_checklist.svg"
                            fillMode: Image.PreserveAspectFit
                            mipmap: true
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: { modalRoot.modeSelected("RECIPE"); modalRoot.closed(); }
                    }
                }

                // 3. CIP Tile (Clean In Place)
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#0f3a64"
                    border.color: "#1d5b94"
                    border.width: 1
                    radius: 6

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 8
                        Text {
                            text: "CIP"
                            color: "#ffffff"
                            font.bold: true
                            font.pixelSize: 13
                            Layout.alignment: Qt.AlignHCenter
                        }
                        Image {
                            width: 40
                            height: 40
                            source: "../../assets/icons/modes/plant/external_circulation.svg"
                            fillMode: Image.PreserveAspectFit
                            mipmap: true
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: { modalRoot.modeSelected("CIP"); modalRoot.closed(); }
                    }
                }

                // 4. Production Tile (Active Green Border)
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#0f3a64"
                    border.color: "#78dc20"
                    border.width: 2
                    radius: 6

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 8
                        Text {
                            text: "Production"
                            color: "#ffffff"
                            font.bold: true
                            font.pixelSize: 13
                            Layout.alignment: Qt.AlignHCenter
                        }
                        Image {
                            width: 40
                            height: 40
                            source: "../../assets/icons/nav/tools_maintenance.svg"
                            fillMode: Image.PreserveAspectFit
                            mipmap: true
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: { modalRoot.modeSelected("PRODUCTION"); modalRoot.closed(); }
                    }
                }
            }
        }
    }
}
