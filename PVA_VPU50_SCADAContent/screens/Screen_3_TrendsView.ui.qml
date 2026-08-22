/*
This is a UI file (.ui.qml) for Screen 3: Process Trends & Analytics.
Strictly declarative for Qt Design Studio.
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: trendsViewRoot
    Layout.fillWidth: true
    Layout.fillHeight: true
    color: "#08213b"

    // Property Aliases for Logic Integration
    property alias batchCombo: batchSelectorCombo
    property alias graphBtn: showGraphButton
    property alias reportBtn: generateReportButton
    property alias chartModeBtn: chartViewButton
    property alias tableModeBtn: tableViewButton
    property alias resetZoomBtn: resetZoomButton
    property alias selectAllSensorsBtn: selectAllBtn
    property alias deselectAllSensorsBtn: deselectAllBtn
    property alias mainStack: trendStack
    property alias sensorListViewItem: sensorChannelListView
    property alias trendCanvasItem: graphCanvas
    property alias inspectCardItem: inspectionCard
    property alias telemetryList: tableListView
    property alias dragBoxOverlay: dragSelectionRect
    property alias yAxisTitleLabel: yAxisUnitText
    property alias xAxisTitleLabel: xAxisUnitText

    // Declarative State Properties
    property string activeMode: "chart" // "chart" or "table"
    property string operatorName: "Line Operator (Level 1)"
    property bool isZoomed: false
    property string yAxisTitle: "Temperature (°C)"
    property string xAxisTitle: "Time (HH:mm:ss UTC)"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8

        // =====================================================================
        // 1. TOP PROCESS BAR (Batch No, Operator, Actions, Mode Switch)
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
                spacing: 10

                // Batch Selector Label & Dropdown
                Text {
                    text: "Batch No:"
                    color: "#94a3b8"
                    font.bold: true
                    font.pixelSize: 12
                }

                ComboBox {
                    id: batchSelectorCombo
                    Layout.preferredWidth: 230
                    Layout.preferredHeight: 34
                    model: ["● Real-Time Live Process", "B-20260815-A1: Body Lotion (50kg)", "B-20260814-S2: Shampoo (50kg)", "B-20260812-C1: Carbopol Gel (50kg)"]
                    currentIndex: 0
                }

                // Operator Name Badge
                Rectangle {
                    Layout.preferredHeight: 34
                    Layout.preferredWidth: 190
                    radius: 4
                    color: "#071c33"
                    border.color: "#0284c7"
                    border.width: 1.0

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 6
                        Text { text: "👤"; font.pixelSize: 12 }
                        Text {
                            text: trendsViewRoot.operatorName
                            color: "#38bdf8"
                            font.bold: true
                            font.pixelSize: 11
                        }
                    }
                }

                // Show Graph Action Button
                Rectangle {
                    id: showGraphButton
                    Layout.preferredWidth: 110
                    Layout.preferredHeight: 34
                    radius: 4
                    color: "#0284c7"

                    Text {
                        anchors.centerIn: parent
                        text: "📊 Show Graph"
                        color: "#ffffff"
                        font.bold: true
                        font.pixelSize: 12
                    }
                }

                // Generate Report Action Button
                Rectangle {
                    id: generateReportButton
                    Layout.preferredWidth: 130
                    Layout.preferredHeight: 34
                    radius: 4
                    color: "#16a34a"

                    Text {
                        anchors.centerIn: parent
                        text: "📑 Generate Report"
                        color: "#ffffff"
                        font.bold: true
                        font.pixelSize: 12
                    }
                }

                Item { Layout.fillWidth: true }

                // Reset Zoom Button
                Rectangle {
                    id: resetZoomButton
                    Layout.preferredWidth: 100
                    Layout.preferredHeight: 34
                    radius: 4
                    visible: trendsViewRoot.isZoomed
                    color: "#1e3a8a"
                    border.color: "#60a5fa"
                    border.width: 1.2

                    Text {
                        anchors.centerIn: parent
                        text: "⟲ Reset Zoom"
                        color: "#ffffff"
                        font.bold: true
                        font.pixelSize: 11
                    }
                }

                // View Switcher: Graph / Table
                Rectangle {
                    Layout.preferredWidth: 160
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
        // 2. MAIN BODY: LEFT SCROLLABLE SENSOR LIST + RIGHT PROCESS GRAPH/TABLE
        // =====================================================================
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 8

            // 2A. LEFT SIDEBAR: EXPANDED SCROLLABLE SENSOR CHANNELS LIST
            Rectangle {
                Layout.preferredWidth: 240
                Layout.fillHeight: true
                radius: 5
                color: "#071c33"
                border.color: "#184d7e"
                border.width: 1.2

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 6

                    // Header with Multi-Select Utilities
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 32
                        radius: 3
                        color: "#0d2b4a"

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 4
                            spacing: 4

                            Text { text: "📡"; font.pixelSize: 11 }
                            Text { text: "SENSOR CHANNELS"; color: "#38bdf8"; font.bold: true; font.pixelSize: 10; Layout.fillWidth: true }

                            Rectangle {
                                id: selectAllBtn
                                Layout.preferredWidth: 32
                                Layout.preferredHeight: 22
                                radius: 2
                                color: "#1e3a8a"
                                Text { anchors.centerIn: parent; text: "ALL"; color: "#ffffff"; font.pixelSize: 8; font.bold: true }
                            }
                            Rectangle {
                                id: deselectAllBtn
                                Layout.preferredWidth: 32
                                Layout.preferredHeight: 22
                                radius: 2
                                color: "#334155"
                                Text { anchors.centerIn: parent; text: "CLR"; color: "#ffffff"; font.pixelSize: 8; font.bold: true }
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
                            id: sensorModelItems
                            // 1. Temperature Section
                            ListElement { section: "TEMPERATURE"; tag: "RTD 1TI1301"; desc: "Main Vessel Temp"; unit: "°C"; color: "#38bdf8"; active: true; val: "40.1 °C"; rangeMin: 0; rangeMax: 100 }
                            ListElement { section: "TEMPERATURE"; tag: "RTD 2TI1001"; desc: "Jacket Thermal Temp"; unit: "°C"; color: "#f97316"; active: true; val: "52.6 °C"; rangeMin: 0; rangeMax: 100 }
                            ListElement { section: "TEMPERATURE"; tag: "RTD HEATER 1"; desc: "Heater Element 01"; unit: "°C"; color: "#f43f5e"; active: false; val: "48.2 °C"; rangeMin: 0; rangeMax: 120 }
                            ListElement { section: "TEMPERATURE"; tag: "RTD HEATER 2"; desc: "Heater Element 02"; unit: "°C"; color: "#ec4899"; active: false; val: "47.9 °C"; rangeMin: 0; rangeMax: 120 }
                            ListElement { section: "TEMPERATURE"; tag: "RTD 3TI1003"; desc: "Lid Surface Temp"; unit: "°C"; color: "#fb7185"; active: false; val: "36.4 °C"; rangeMin: 0; rangeMax: 80 }
                            // 2. Pressure & Vacuum Section
                            ListElement { section: "PRESSURE"; tag: "PR TRANSMITTER"; desc: "Chamber Vacuum"; unit: "mbar"; color: "#c084fc"; active: true; val: "-209.8 mbar"; rangeMin: -1000; rangeMax: 0 }
                            ListElement { section: "PRESSURE"; tag: "PIT 1002"; desc: "Jacket Steam Press"; unit: "bar"; color: "#a855f7"; active: false; val: "1.8 bar"; rangeMin: 0; rangeMax: 6 }
                            ListElement { section: "PRESSURE"; tag: "PIT 1003"; desc: "Purge Air Pressure"; unit: "bar"; color: "#818cf8"; active: false; val: "5.5 bar"; rangeMin: 0; rangeMax: 10 }
                            // 3. Drives & Speed Section
                            ListElement { section: "DRIVES"; tag: "1M1501 Speed"; desc: "Agitator Drive"; unit: "rpm"; color: "#22c55e"; active: true; val: "25.0 rpm"; rangeMin: 0; rangeMax: 60 }
                            ListElement { section: "DRIVES"; tag: "2M1501 Speed"; desc: "Scraper Motor"; unit: "rpm"; color: "#10b981"; active: false; val: "0.0 rpm"; rangeMin: 0; rangeMax: 40 }
                            ListElement { section: "DRIVES"; tag: "1M2003 Speed"; desc: "Homogenizer Rotor"; unit: "rpm"; color: "#eab308"; active: true; val: "600 rpm"; rangeMin: 0; rangeMax: 6000 }
                            ListElement { section: "DRIVES"; tag: "3M1001 Speed"; desc: "Discharge Pump"; unit: "rpm"; color: "#f59e0b"; active: false; val: "0.0 rpm"; rangeMin: 0; rangeMax: 1500 }
                            // 4. Power & Energy Section
                            ListElement { section: "POWER"; tag: "KW TRANSMITTER"; desc: "Total Skid Power"; unit: "kW"; color: "#06b6d4"; active: false; val: "14.8 kW"; rangeMin: 0; rangeMax: 45 }
                            ListElement { section: "POWER"; tag: "CURR 1M1501"; desc: "Agitator Motor Current"; unit: "A"; color: "#14b8a6"; active: false; val: "3.4 A"; rangeMin: 0; rangeMax: 15 }
                            ListElement { section: "POWER"; tag: "CURR 1M2003"; desc: "Homo Motor Current"; unit: "A"; color: "#0ea5e9"; active: false; val: "8.9 A"; rangeMin: 0; rangeMax: 30 }
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
                                spacing: 6

                                Rectangle {
                                    width: 10
                                    height: 10
                                    radius: 5
                                    color: model.active ? model.color : "#475569"
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
                                    font.pixelSize: 10
                                }
                            }
                        }
                    }
                }
            }

            // 2B. RIGHT AREA: AWARD-WINNING INTERACTIVE GRAPH OR TABULAR LOG
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
                                text: "| Click & drag box to zoom"
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
                                        id: inspectTimeLabel
                                        text: "🕒 Timestamp: 09:42:15 UTC"
                                        color: "#ffffff"
                                        font.bold: true
                                        font.pixelSize: 11
                                    }
                                    Rectangle { Layout.fillWidth: true; height: 1; color: "#1e3a8a" }
                                    Text { text: "Vessel Temp: 40.1 °C"; color: "#38bdf8"; font.pixelSize: 10; font.bold: true }
                                    Text { text: "Jacket Temp: 52.6 °C"; color: "#f97316"; font.pixelSize: 10; font.bold: true }
                                    Text { text: "Vacuum: -209.8 mbar"; color: "#c084fc"; font.pixelSize: 10; font.bold: true }
                                    Text { text: "Agitator Speed: 25.0 rpm"; color: "#22c55e"; font.pixelSize: 10; font.bold: true }
                                    Text { text: "Homogenizer: 600 rpm"; color: "#eab308"; font.pixelSize: 10; font.bold: true }
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
