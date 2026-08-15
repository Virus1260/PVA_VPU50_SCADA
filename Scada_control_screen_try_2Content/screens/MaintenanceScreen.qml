import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: maintRoot
    color: "#0a2644"

    property var ioChannels: [
        { ch: "DI-01", name: "Vessel Cover Closed Limit Switch", type: "DIGITAL_IN", val: "1 (TRUE)", force: false },
        { ch: "DI-02", name: "Agitator Drive Ready Feedback", type: "DIGITAL_IN", val: "1 (TRUE)", force: false },
        { ch: "DO-01", name: "Vessel Vacuum Solenoid 1K1001", type: "DIGITAL_OUT", val: "1 (ENERGIZED)", force: false },
        { ch: "DO-02", name: "Discharge Bottom Valve 1K2002", type: "DIGITAL_OUT", val: "0 (DE-ENERGIZED)", force: false },
        { ch: "AI-01", name: "Chamber Vacuum Transmitter PIC161001", type: "ANALOG_IN", val: "7.84 mA (-209.8 mbar)", force: false },
        { ch: "AI-02", name: "Product PT100 Sensor TIC162001", type: "ANALOG_IN", val: "11.2 mA (40.1 °C)", force: false },
        { ch: "AO-01", name: "Agitator VFD 0-10V Speed Reference", type: "ANALOG_OUT", val: "2.08 V (25.0 rpm)", force: false },
        { ch: "AO-02", name: "Homogenizer VFD 0-10V Reference", type: "ANALOG_OUT", val: "1.25 V (600 rpm)", force: false }
    ]

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 10

        // Screen Header Bar
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Rectangle {
                width: 32
                height: 32
                radius: 4
                color: "#ffaa00"
                Text { text: "T"; color: "#000000"; font.bold: true; font.pixelSize: 18; anchors.centerIn: parent }
            }

            ColumnLayout {
                spacing: 0
                Text { text: "HARDWARE I/O DIAGNOSTICS & FIELD CALIBRATION"; color: "#ffffff"; font.bold: true; font.pixelSize: 15 }
                Text { text: "Direct PLC Channel State Overrides & Sensor Diagnostics"; color: "#ffcc00"; font.pixelSize: 11 }
            }

            Item { Layout.fillWidth: true }

            Rectangle {
                Layout.preferredWidth: 130
                Layout.preferredHeight: 32
                color: "#0d365b"
                border.color: "#164673"
                border.width: 1
                radius: 4
                Text { anchors.centerIn: parent; text: "PLC: CONNECTED"; color: "#8ee62c"; font.bold: true; font.pixelSize: 10 }
            }
        }

        // Table Header
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 32
            color: "#0d365b"
            radius: 3

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 12

                Text { text: "CHANNEL"; color: "#91b8db"; font.bold: true; Layout.preferredWidth: 80 }
                Text { text: "SIGNAL NAME & DESCRIPTION"; color: "#91b8db"; font.bold: true; Layout.fillWidth: true }
                Text { text: "I/O TYPE"; color: "#91b8db"; font.bold: true; Layout.preferredWidth: 110 }
                Text { text: "RAW / SCALED VALUE"; color: "#91b8db"; font.bold: true; Layout.preferredWidth: 170 }
                Text { text: "FORCE OVERRIDE"; color: "#91b8db"; font.bold: true; Layout.preferredWidth: 110 }
            }
        }

        ListView {
            id: maintListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: maintRoot.ioChannels
            spacing: 4
            clip: true

            delegate: Rectangle {
                width: maintListView.width
                height: 42
                color: "#092440"
                border.color: "#164673"
                border.width: 1
                radius: 3

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 12

                    Text { text: modelData.ch; color: "#00d2ff"; font.bold: true; Layout.preferredWidth: 80 }
                    Text { text: modelData.name; color: "#ffffff"; Layout.fillWidth: true; elide: Text.ElideRight }
                    Text { text: modelData.type; color: "#91b8db"; font.pixelSize: 11; Layout.preferredWidth: 110 }
                    Text { text: modelData.val; color: "#8ee62c"; font.bold: true; Layout.preferredWidth: 170 }

                    Rectangle {
                        Layout.preferredWidth: 90
                        Layout.preferredHeight: 24
                        radius: 3
                        color: "#13497d"
                        border.color: "#205d9c"
                        border.width: 1
                        Text { anchors.centerIn: parent; text: "NORMAL"; color: "#91b8db"; font.bold: true; font.pixelSize: 10 }
                    }
                }
            }
        }
    }
}
