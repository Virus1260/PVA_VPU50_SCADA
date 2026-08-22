/*
This is a UI file (.ui.qml) for Screen 3: Process Trends & Historical Analytics.
Strictly declarative for Qt Design Studio.
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: trendsViewRoot
    width: 1184
    height: 626
    color: "#08213b"

    // Property Aliases for Logic Integration
    property alias batchCombo: batchSelectorCombo
    property alias selectAllBtnItem: selectAllActionButton
    property alias clearAllBtnItem: clearAllActionButton
    property alias chartModeBtn: chartViewButton
    property alias tableModeBtn: tableViewButton
    property alias resetZoomBtn: resetZoomButton
    property alias liveStreamBtn: liveStreamToggleBtn
    property alias mainStack: trendStack
    property alias sensorListViewItem: sensorChannelListView
    property alias trendCanvasItem: graphCanvas
    property alias inspectCardItem: inspectionCard
    property alias telemetryList: tableListView
    property alias dragBoxOverlay: dragSelectionRect
    property alias yAxisTitleLabel: yAxisUnitText
    property alias xAxisTitleLabel: xAxisUnitText
    property alias panelSplitterHandle: panelResizeHandle

    // Time Presets Buttons
    property alias t1MinBtn: time1MinBtn
    property alias t5MinBtn: time5MinBtn
    property alias t15MinBtn: time15MinBtn
    property alias t1HourBtn: time1HourBtn
    property alias t8HourBtn: time8HourBtn
    property alias t24HourBtn: time24HourBtn

    // Declarative State Properties
    property string activeMode: "chart" // "chart" or "table"
    property string operatorName: "Line Operator (Level 1)"
    property bool isZoomed: false
    property bool isLiveStreaming: true
    property string activeTimePreset: "5min"
    property int sensorPanelWidth: 290
    property string yAxisTitle: "Temperature (°C)"
    property string xAxisTitle: "Time (UTC)"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8

        // =====================================================================
        // 1. TOP PROCESS BAR (Batch No, Time Window Presets, Live Status)
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
                anchors.margins: 6
                spacing: 8

                // Batch Selector
                Text { text: "Batch:"; color: "#94a3b8"; font.bold: true; font.pixelSize: 12 }
                ComboBox {
                    id: batchSelectorCombo
                    Layout.preferredWidth: 210
                    Layout.preferredHeight: 34
                    model: ["● Real-Time Live Process", "B-20260815-A1: Body Lotion (50kg)", "B-20260814-S2: Shampoo (50kg)", "B-20260812-C1: Carbopol Gel (50kg)"]
                    currentIndex: 0
                }

                // Operator Badge
                Rectangle {
                    Layout.preferredHeight: 34
                    Layout.preferredWidth: 170
                    radius: 4
                    color: "#071c33"
                    border.color: "#0284c7"
                    border.width: 1.0

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 4
                        Text { text: "👤"; font.pixelSize: 11 }
                        Text { text: trendsViewRoot.operatorName; color: "#38bdf8"; font.bold: true; font.pixelSize: 10 }
                    }
                }

                // Time Window Preset Buttons (1m, 5m, 15m, 1h, 8h, 24h)
                Rectangle {
                    Layout.preferredWidth: 260
                    Layout.preferredHeight: 34
                    radius: 4
                    color: "#071c33"
                    border.color: "#184d7e"

                    RowLayout {
                        anchors.fill: parent
                        spacing: 2
                        anchors.margins: 2

                        Rectangle {
                            id: time1MinBtn
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 3
                            color: trendsViewRoot.activeTimePreset === "1min" ? "#0284c7" : "transparent"
                            Text { anchors.centerIn: parent; text: "1m"; color: "#ffffff"; font.bold: true; font.pixelSize: 10 }
                        }
                        Rectangle {
                            id: time5MinBtn
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 3
                            color: trendsViewRoot.activeTimePreset === "5min" ? "#0284c7" : "transparent"
                            Text { anchors.centerIn: parent; text: "5m"; color: "#ffffff"; font.bold: true; font.pixelSize: 10 }
                        }
                        Rectangle {
                            id: time15MinBtn
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 3
                            color: trendsViewRoot.activeTimePreset === "15min" ? "#0284c7" : "transparent"
                            Text { anchors.centerIn: parent; text: "15m"; color: "#ffffff"; font.bold: true; font.pixelSize: 10 }
                        }
                        Rectangle {
                            id: time1HourBtn
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 3
                            color: trendsViewRoot.activeTimePreset === "1h" ? "#0284c7" : "transparent"
                            Text { anchors.centerIn: parent; text: "1h"; color: "#ffffff"; font.bold: true; font.pixelSize: 10 }
                        }
                        Rectangle {
                            id: time8HourBtn
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 3
                            color: trendsViewRoot.activeTimePreset === "8h" ? "#0284c7" : "transparent"
                            Text { anchors.centerIn: parent; text: "8h"; color: "#ffffff"; font.bold: true; font.pixelSize: 10 }
                        }
                        Rectangle {
                            id: time24HourBtn
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 3
                            color: trendsViewRoot.activeTimePreset === "24h" ? "#0284c7" : "transparent"
                            Text { anchors.centerIn: parent; text: "24h"; color: "#ffffff"; font.bold: true; font.pixelSize: 10 }
                        }
                    }
                }

                // Live Streaming Toggle / Status
                Rectangle {
                    id: liveStreamToggleBtn
                    Layout.preferredWidth: 120
                    Layout.preferredHeight: 34
                    radius: 4
                    color: trendsViewRoot.isLiveStreaming ? "#052e16" : "#1e293b"
                    border.color: trendsViewRoot.isLiveStreaming ? "#22c55e" : "#64748b"

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 6
                        Rectangle { width: 8; height: 8; radius: 4; color: trendsViewRoot.isLiveStreaming ? "#22c55e" : "#e2e8f0" }
                        Text {
                            text: trendsViewRoot.isLiveStreaming ? "LIVE SCROLL" : "⏸ PAUSED"
                            color: trendsViewRoot.isLiveStreaming ? "#4ade80" : "#cbd5e1"
                            font.bold: true
                            font.pixelSize: 10
                        }
                    }
                }

                Item { Layout.fillWidth: true }

                // Reset Zoom
                Rectangle {
                    id: resetZoomButton
                    Layout.preferredWidth: 95
                    Layout.preferredHeight: 34
                    radius: 4
                    visible: trendsViewRoot.isZoomed
                    color: "#1e3a8a"
                    border.color: "#60a5fa"
                    Text { anchors.centerIn: parent; text: "⟲ Reset Zoom"; color: "#ffffff"; font.bold: true; font.pixelSize: 10 }
                }

                // Mode Switcher: Graph / Table
                Rectangle {
                    Layout.preferredWidth: 150
                    Layout.preferredHeight: 34
                    radius: 4
                    color: "#071c33"
                    border.color: "#0284c7"
                    border.width: 1.0

                    RowLayout {
                        anchors.fill: parent
                        spacing: 0

                        Rectangle {
                            id: chartViewButton
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 3
                            color: trendsViewRoot.activeMode === "chart" ? "#0284c7" : "transparent"
                            Text { anchors.centerIn: parent; text: "📈 Graph"; color: "#ffffff"; font.bold: true; font.pixelSize: 11 }
                        }

                        Rectangle {
                            id: tableViewButton
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 3
                            color: trendsViewRoot.activeMode === "table" ? "#0284c7" : "transparent"
                            Text { anchors.centerIn: parent; text: "📋 Table"; color: "#ffffff"; font.bold: true; font.pixelSize: 11 }
                        }
                    }
                }
            }
        }

        // =====================================================================
        // 2. MAIN BODY: RESIZABLE SENSOR LIST + PROCESS GRAPH/TABLE
        // =====================================================================
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            // 2A. LEFT SIDEBAR: EXPANDED RESIZABLE SENSOR CHANNELS LIST
            Rectangle {
                Layout.preferredWidth: trendsViewRoot.sensorPanelWidth
                Layout.fillHeight: true
                radius: 5
                color: "#071c33"
                border.color: "#184d7e"
                border.width: 1.2

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

            // 2B. INTERACTIVE PANEL RESIZE HANDLE / SPLITTER
            Rectangle {
                id: panelResizeHandle
                Layout.preferredWidth: 6
                Layout.fillHeight: true
                color: "#08213b"

                Rectangle {
                    anchors.centerIn: parent
                    width: 2
                    height: 40
                    radius: 1
                    color: "#0284c7"
                }
            }

            // 2C. RIGHT AREA: INTERACTIVE GRAPH OR TABULAR LOG
            StackLayout {
                id: trendStack
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: trendsViewRoot.activeMode === "chart" ? 0 : 1

                // GRAPH VIEW
                Rectangle {
                    color: "#06182c"
                    border.color: "#184d7e"
                    border.width: 1.2
                    radius: 5
                    clip: true

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 4

                        // Graph Title Bar with Dynamic Units
                        RowLayout {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 24
                            spacing: 8

                            Text {
                                id: yAxisUnitText
                                text: "📈 Y-AXIS: " + trendsViewRoot.yAxisTitle
                                color: "#38bdf8"
                                font.bold: true
                                font.pixelSize: 11
                            }
                            Item { Layout.fillWidth: true }
                            Text {
                                id: xAxisUnitText
                                text: "🕒 X-AXIS: " + trendsViewRoot.xAxisTitle
                                color: "#94a3b8"
                                font.bold: true
                                font.pixelSize: 10
                            }
                            Text {
                                text: "| Drag box to zoom"
                                color: "#64748b"
                                font.pixelSize: 10
                            }
                        }

                        // Canvas Graph Area with Visual Dragging Box Overlay
                        Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            Canvas {
                                id: graphCanvas
                                anchors.fill: parent
                            }

                            // Dynamic Visual Drag-to-Zoom Selection Box
                            Rectangle {
                                id: dragSelectionRect
                                visible: false
                                color: "#380284c7"
                                border.color: "#38bdf8"
                                border.width: 1.5
                                z: 5

                                Rectangle {
                                    anchors.top: parent.top
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.topMargin: 4
                                    height: 18
                                    width: 80
                                    radius: 3
                                    color: "#0284c7"
                                    Text {
                                        anchors.centerIn: parent
                                        text: "🔍 Zoom Box"
                                        color: "#ffffff"
                                        font.bold: true
                                        font.pixelSize: 9
                                    }
                                }
                            }

                            // Floating Inspection Tooltip
                            Rectangle {
                                id: inspectionCard
                                visible: false
                                width: 230
                                height: 140
                                radius: 5
                                color: "#081d33"
                                border.color: "#38bdf8"
                                border.width: 1.4
                                opacity: 0.96
                                z: 10

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 8
                                    spacing: 3

                                    Text {
                                        text: "🕒 Telemetry Inspection"
                                        color: "#ffffff"
                                        font.bold: true
                                        font.pixelSize: 11
                                    }
                                    Rectangle { Layout.fillWidth: true; height: 1; color: "#1e3a8a" }
                                    Text { text: "Live Values at Timestamp"; color: "#94a3b8"; font.pixelSize: 10 }
                                }
                            }
                        }
                    }
                }

                // TABLE VIEW (Right-Aligned Industrial Engineering Layout)
                Rectangle {
                    color: "#06182c"
                    border.color: "#184d7e"
                    border.width: 1.2
                    radius: 5

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 4

                        // Table Header with Strict Right-Aligned Column Widths
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 34
                            color: "#0d2b4a"
                            radius: 3

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 12
                                spacing: 10

                                Text { text: "TIMESTAMP"; color: "#94a3b8"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 100 }
                                Text { text: "VESSEL TEMP"; color: "#38bdf8"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 120; horizontalAlignment: Text.AlignRight }
                                Text { text: "JACKET TEMP"; color: "#f97316"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 120; horizontalAlignment: Text.AlignRight }
                                Text { text: "VACUUM"; color: "#c084fc"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 130; horizontalAlignment: Text.AlignRight }
                                Text { text: "AGITATOR"; color: "#4ade80"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 120; horizontalAlignment: Text.AlignRight }
                                Text { text: "HOMOGENIZER"; color: "#facc15"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 130; horizontalAlignment: Text.AlignRight }
                                Item { Layout.fillWidth: true }
                            }
                        }

                        // Table Rows
                        ListView {
                            id: tableListView
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            spacing: 2
                            ScrollBar.vertical: ScrollBar {
                                active: true
                                policy: ScrollBar.AsNeeded
                            }

                            delegate: Rectangle {
                                width: tableListView ? tableListView.width : 0
                                height: 30
                                color: index % 2 === 0 ? "#071c33" : "#092440"

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: 12
                                    anchors.rightMargin: 12
                                    spacing: 10

                                    Text { text: modelData.time; color: "#ffffff"; font.pixelSize: 11; Layout.preferredWidth: 100 }
                                    Text { text: modelData.temp.toFixed(1) + " °C"; color: "#38bdf8"; font.pixelSize: 11; Layout.preferredWidth: 120; horizontalAlignment: Text.AlignRight }
                                    Text { text: modelData.jacket.toFixed(1) + " °C"; color: "#f97316"; font.pixelSize: 11; Layout.preferredWidth: 120; horizontalAlignment: Text.AlignRight }
                                    Text { text: modelData.vacuum.toFixed(1) + " mbar"; color: "#c084fc"; font.pixelSize: 11; Layout.preferredWidth: 130; horizontalAlignment: Text.AlignRight }
                                    Text { text: modelData.agitator.toFixed(1) + " rpm"; color: "#4ade80"; font.pixelSize: 11; Layout.preferredWidth: 120; horizontalAlignment: Text.AlignRight }
                                    Text { text: modelData.homo.toFixed(0) + " rpm"; color: "#facc15"; font.pixelSize: 11; Layout.preferredWidth: 130; horizontalAlignment: Text.AlignRight }
                                    Item { Layout.fillWidth: true }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
