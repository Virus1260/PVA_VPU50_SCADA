/*
This is a UI file (.ui.qml) for Trends Sensor Channel Panel.
Strictly declarative for Qt Design Studio.
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: sensorPanelRoot
    Layout.preferredWidth: panelWidth
    Layout.fillHeight: true
    radius: 5
    color: "#071c33"
    border.color: "#184d7e"
    border.width: 1.2

    property int panelWidth: 290
    property alias selectAllBtnItem: selectAllActionButton
    property alias clearAllBtnItem: clearAllActionButton
    property alias sensorListViewItem: sensorChannelListView

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 6

        // Header with Full Sized "Select All" / "Clear All" Buttons
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 36
            radius: 4
            color: "#0d2b4a"

            RowLayout {
                anchors.fill: parent
                anchors.margins: 4
                spacing: 6

                Text { text: "📡"; font.pixelSize: 12 }
                Text { text: "SENSORS"; color: "#38bdf8"; font.bold: true; font.pixelSize: 11; Layout.fillWidth: true }

                Rectangle {
                    id: selectAllActionButton
                    Layout.preferredWidth: 80
                    Layout.preferredHeight: 28
                    radius: 3
                    color: "#1e3a8a"
                    border.color: "#38bdf8"
                    Text { anchors.centerIn: parent; text: "✓ Select All"; color: "#ffffff"; font.pixelSize: 10; font.bold: true }
                }
                Rectangle {
                    id: clearAllActionButton
                    Layout.preferredWidth: 75
                    Layout.preferredHeight: 28
                    radius: 3
                    color: "#334155"
                    border.color: "#64748b"
                    Text { anchors.centerIn: parent; text: "✗ Clear All"; color: "#ffffff"; font.pixelSize: 10; font.bold: true }
                }
            }
        }

        // Individually Scrollable Sensor Channels List
        ListView {
            id: sensorChannelListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 4
            ScrollBar.vertical: ScrollBar {
                active: true
                policy: ScrollBar.AlwaysOn
                width: 6
            }

            model: ListModel {
                id: sensorModelCatalogItems
                ListElement { section: "TEMPERATURE"; tag: "RTD 1TI1301"; desc: "Main Vessel Temp"; unit: "°C"; color: "#38bdf8"; active: true; val: "40.1 °C"; rangeMin: 0; rangeMax: 120; field: "temp_vessel" }
                ListElement { section: "TEMPERATURE"; tag: "RTD 2TI1001"; desc: "Jacket Thermal Temp"; unit: "°C"; color: "#f97316"; active: true; val: "52.6 °C"; rangeMin: 0; rangeMax: 140; field: "temp_jacket" }
                ListElement { section: "TEMPERATURE"; tag: "RTD HEATER 1"; desc: "Heater Element 01"; unit: "°C"; color: "#f43f5e"; active: false; val: "48.2 °C"; rangeMin: 0; rangeMax: 160; field: "temp_heater1" }
                ListElement { section: "TEMPERATURE"; tag: "RTD HEATER 2"; desc: "Heater Element 02"; unit: "°C"; color: "#ec4899"; active: false; val: "47.9 °C"; rangeMin: 0; rangeMax: 160; field: "temp_heater2" }
                ListElement { section: "TEMPERATURE"; tag: "RTD 3TI1003"; desc: "Lid Surface Temp"; unit: "°C"; color: "#fb7185"; active: false; val: "36.4 °C"; rangeMin: 0; rangeMax: 100; field: "temp_lid" }
                ListElement { section: "PRESSURE"; tag: "PR TRANSMITTER"; desc: "Chamber Vacuum"; unit: "mbar"; color: "#c084fc"; active: true; val: "-209.8 mbar"; rangeMin: -1000; rangeMax: 0; field: "vacuum_pressure" }
                ListElement { section: "PRESSURE"; tag: "PIT 1002"; desc: "Jacket Steam Press"; unit: "bar"; color: "#a855f7"; active: false; val: "1.8 bar"; rangeMin: 0; rangeMax: 6; field: "press_steam" }
                ListElement { section: "PRESSURE"; tag: "PIT 1003"; desc: "Purge Air Pressure"; unit: "bar"; color: "#818cf8"; active: false; val: "5.5 bar"; rangeMin: 0; rangeMax: 10; field: "press_air" }
                ListElement { section: "DRIVES"; tag: "1M1501 Speed"; desc: "Agitator Drive"; unit: "rpm"; color: "#22c55e"; active: true; val: "25.0 rpm"; rangeMin: 0; rangeMax: 60; field: "speed_agitator" }
                ListElement { section: "DRIVES"; tag: "2M1501 Speed"; desc: "Scraper Motor"; unit: "rpm"; color: "#10b981"; active: false; val: "0.0 rpm"; rangeMin: 0; rangeMax: 40; field: "speed_scraper" }
                ListElement { section: "DRIVES"; tag: "1M2003 Speed"; desc: "Homogenizer Rotor"; unit: "rpm"; color: "#eab308"; active: true; val: "600 rpm"; rangeMin: 0; rangeMax: 6000; field: "speed_homo" }
                ListElement { section: "DRIVES"; tag: "3M1001 Speed"; desc: "Discharge Pump"; unit: "rpm"; color: "#f59e0b"; active: false; val: "0.0 rpm"; rangeMin: 0; rangeMax: 1500; field: "speed_pump" }
                ListElement { section: "POWER"; tag: "KW TRANSMITTER"; desc: "Total Skid Power"; unit: "kW"; color: "#06b6d4"; active: false; val: "14.8 kW"; rangeMin: 0; rangeMax: 45; field: "power_kw" }
                ListElement { section: "POWER"; tag: "CURR 1M1501"; desc: "Agitator Current"; unit: "A"; color: "#14b8a6"; active: false; val: "3.4 A"; rangeMin: 0; rangeMax: 20; field: "curr_agitator" }
                ListElement { section: "POWER"; tag: "CURR 1M2003"; desc: "Homo Current"; unit: "A"; color: "#0ea5e9"; active: false; val: "8.9 A"; rangeMin: 0; rangeMax: 35; field: "curr_homo" }
            }

            delegate: Rectangle {
                width: sensorChannelListView ? sensorChannelListView.width - 8 : 0
                height: 48
                radius: 4
                color: model.active ? "#0d365b" : "#092440"
                border.color: model.active ? model.color : "#1e3a8a"
                border.width: model.active ? 1.6 : 1.0

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 6
                    spacing: 8

                    Rectangle {
                        width: 12
                        height: 12
                        radius: 6
                        color: model.active ? model.color : "#475569"
                        border.color: model.active ? "#ffffff" : "transparent"
                        border.width: 1
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 1
                        Text {
                            text: model.tag
                            color: model.active ? "#ffffff" : "#94a3b8"
                            font.bold: true
                            font.pixelSize: 11
                        }
                        Text {
                            text: model.desc
                            color: "#64748b"
                            font.pixelSize: 9
                        }
                    }

                    Text {
                        text: model.val
                        color: model.active ? model.color : "#64748b"
                        font.bold: true
                        font.pixelSize: 11
                    }
                }
            }
        }
    }
}
