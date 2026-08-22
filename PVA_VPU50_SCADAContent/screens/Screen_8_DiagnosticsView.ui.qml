/*
This is a UI file (.ui.qml) for Screen 8: Hardware I/O Diagnostics.
Strictly declarative for Qt Design Studio.
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: maintViewRoot
    width: 1184
    height: 626
    color: "#08213b"

    property alias ioList: channelsListView

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        // =====================================================================
        // 1. TOP HEADER & PLC LINK STATUS
        // =====================================================================
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 46
            radius: 5
            color: "#0d2b4a"
            border.color: "#184d7e"
            border.width: 1.2

            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 12

                Rectangle {
                    width: 34
                    height: 34
                    radius: 4
                    color: "#eab308"
                    Text { text: "🛠️"; font.pixelSize: 18; anchors.centerIn: parent }
                }

                ColumnLayout {
                    spacing: 2
                    Text { text: "DELTA AS332T-A PLC HARDWARE I/O & CALIBRATION"; color: "#ffffff"; font.bold: true; font.pixelSize: 15 }
                    Text { text: "Direct Field Channel Diagnostics, Modbus / OPC UA Health & Signal Forcing"; color: "#facc15"; font.bold: true; font.pixelSize: 11 }
                }

                Item { Layout.fillWidth: true }

                // PLC Link Status
                Rectangle {
                    Layout.preferredWidth: 170
                    Layout.preferredHeight: 34
                    radius: 4
                    color: "#052e16"
                    border.color: "#22c55e"
                    border.width: 1.2

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 8
                        Rectangle { width: 8; height: 8; radius: 4; color: "#22c55e" }
                        Text { text: "● PLC: ONLINE (12ms)"; color: "#4ade80"; font.bold: true; font.pixelSize: 11 }
                    }
                }
            }
        }

        // =====================================================================
        // 2. I/O CHANNELS TABLE HEADER
        // =====================================================================
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 34
            color: "#0d2b4a"
            radius: 4

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 10

                Text { text: "CHANNEL"; color: "#38bdf8"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 80 }
                Text { text: "SIGNAL NAME & DESCRIPTION"; color: "#94a3b8"; font.bold: true; font.pixelSize: 11; Layout.fillWidth: true }
                Text { text: "TYPE"; color: "#94a3b8"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 110 }
                Text { text: "RAW FIELD SIGNAL"; color: "#94a3b8"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 130; horizontalAlignment: Text.AlignRight }
                Text { text: "SCALED ENGINEERING VALUE"; color: "#94a3b8"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 160; horizontalAlignment: Text.AlignRight }
                Text { text: "FORCE OVERRIDE"; color: "#94a3b8"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 120; horizontalAlignment: Text.AlignHCenter }
            }
        }

        // =====================================================================
        // 3. I/O CHANNELS LIST VIEW
        // =====================================================================
        ListView {
            id: channelsListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 4

            model: ListModel {
                ListElement { ch: "DI-01"; name: "Vessel Cover Closed Limit Switch (1K1001)"; type: "DIGITAL_IN"; raw: "1 (TRUE)"; val: "LOCKED (TRUE)"; force: false }
                ListElement { ch: "DI-02"; name: "Agitator Drive Ready Feedback (1M1501)"; type: "DIGITAL_IN"; raw: "1 (TRUE)"; val: "READY (TRUE)"; force: false }
                ListElement { ch: "DO-01"; name: "Vessel Vacuum Solenoid 1K1001"; type: "DIGITAL_OUT"; raw: "1 (ON)"; val: "ENERGIZED (TRUE)"; force: false }
                ListElement { ch: "DO-02"; name: "Discharge Bottom Valve 1K2002"; type: "DIGITAL_OUT"; raw: "0 (OFF)"; val: "DE-ENERGIZED (FALSE)"; force: false }
                ListElement { ch: "AI-01"; name: "Chamber Vacuum Transmitter PIC161001"; type: "ANALOG_IN"; raw: "7.84 mA"; val: "-209.8 mbar"; force: false }
                ListElement { ch: "AI-02"; name: "Product PT100 Sensor TIC162001"; type: "ANALOG_IN"; raw: "11.2 mA"; val: "40.1 °C"; force: false }
                ListElement { ch: "AO-01"; name: "Agitator VFD 0-10V Speed Reference"; type: "ANALOG_OUT"; raw: "2.08 V"; val: "25.0 rpm"; force: false }
                ListElement { ch: "AO-02"; name: "Homogenizer VFD 0-10V Reference"; type: "ANALOG_OUT"; raw: "1.25 V"; val: "600 rpm"; force: false }
            }

            delegate: Rectangle {
                width: channelsListView ? channelsListView.width : 0
                height: 48
                radius: 4
                color: index % 2 === 0 ? "#071c33" : "#092440"
                border.color: model.force ? "#ef4444" : "#1e3a8a"
                border.width: model.force ? 1.6 : 1.0

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 10

                    Text { text: model.ch; color: "#38bdf8"; font.bold: true; font.pixelSize: 12; Layout.preferredWidth: 80 }
                    Text { text: model.name; color: "#ffffff"; font.pixelSize: 12; Layout.fillWidth: true }
                    Text { text: model.type; color: "#94a3b8"; font.pixelSize: 10; Layout.preferredWidth: 110 }
                    Text { text: model.raw; color: "#facc15"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 130; horizontalAlignment: Text.AlignRight }
                    Text { text: model.val; color: "#4ade80"; font.bold: true; font.pixelSize: 12; Layout.preferredWidth: 160; horizontalAlignment: Text.AlignRight }

                    // Force Toggle Button
                    Rectangle {
                        Layout.preferredWidth: 110
                        Layout.preferredHeight: 30
                        radius: 4
                        color: model.force ? "#dc2626" : "#0f2b48"
                        border.color: model.force ? "#ef4444" : "#0284c7"

                        Text {
                            anchors.centerIn: parent
                            text: model.force ? "⚡ FORCED" : "NORM AUTO"
                            color: model.force ? "#ffffff" : "#94a3b8"
                            font.bold: true
                            font.pixelSize: 10
                        }
                    }
                }
            }
        }
    }
}
