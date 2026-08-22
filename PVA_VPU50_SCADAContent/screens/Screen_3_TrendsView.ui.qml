/*
This is a UI file (.ui.qml) for Screen 3: Process Trends & Historical Analytics.
Strictly declarative for Qt Design Studio.
Assembled from modular sub-widgets in components/widgets/Screen_3_Trends/
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components/widgets/Screen_3_Trends"

Rectangle {
    id: trendsViewRoot
    width: 1184
    height: 626
    color: "#08213b"

    // Property Aliases for Logic Controller Integration
    property alias topBar: topControlBar
    property alias t1MinBtn: topControlBar.t1MinBtn
    property alias t5MinBtn: topControlBar.t5MinBtn
    property alias t15MinBtn: topControlBar.t15MinBtn
    property alias t1HourBtn: topControlBar.t1HourBtn
    property alias t8HourBtn: topControlBar.t8HourBtn
    property alias t24HourBtn: topControlBar.t24HourBtn
    property alias liveStreamBtn: topControlBar.liveStreamBtn
    property alias resetZoomBtn: topControlBar.resetZoomBtn
    property alias chartModeBtn: topControlBar.chartModeBtn
    property alias tableModeBtn: topControlBar.tableModeBtn

    property alias sensorPanel: sensorSidebar
    property alias selectAllBtnItem: sensorSidebar.selectAllBtnItem
    property alias clearAllBtnItem: sensorSidebar.clearAllBtnItem
    property alias sensorListViewItem: sensorSidebar.sensorListViewItem

    property alias graphWidget: trendsGraph
    property alias trendCanvasItem: trendsGraph.trendCanvasItem
    property alias dragBoxOverlay: trendsGraph.dragBoxOverlay
    property alias inspectCardItem: trendsGraph.inspectCardItem
    property alias inspectRepeaterItem: trendsGraph.inspectRepeaterItem
    property alias panStartBtn: trendsGraph.panStartBtn
    property alias panLiveBtn: trendsGraph.panLiveBtn
    property alias timeSliderItem: trendsGraph.timeSliderItem
    property alias startTimeLabel: trendsGraph.startTimeLabel
    property alias endTimeLabel: trendsGraph.endTimeLabel

    property alias tableWidget: trendsTable
    property alias tableHeaderModelItem: trendsTable.tableHeaderModelItem
    property alias telemetryList: trendsTable.telemetryList

    property alias panelSplitterHandle: panelResizeHandle

    // Declarative State Properties
    property string activeMode: "chart" // "chart" or "table"
    property bool isZoomed: false
    property bool isLiveStreaming: true
    property string activeTimePreset: "15min"
    property int sensorPanelWidth: 290
    property string yAxisTitle: "Temperature (°C)"
    property string xAxisTitle: "Time (UTC)"
    property string inspectionTime: "08:34:11 UTC"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8

        // =====================================================================
        // 1. TOP PROCESS BAR (Modular TrendsTopBar Widget)
        // =====================================================================
        TrendsTopBar {
            id: topControlBar
            activeTimePreset: trendsViewRoot.activeTimePreset
            isLiveStreaming: trendsViewRoot.isLiveStreaming
            isZoomed: trendsViewRoot.isZoomed
            activeMode: trendsViewRoot.activeMode
        }

        // =====================================================================
        // 2. MAIN BODY: SENSOR LIST + PROCESS GRAPH/TABLE
        // =====================================================================
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            // 2A. LEFT SIDEBAR: MODULAR SENSOR CHANNELS LIST
            TrendsSensorPanel {
                id: sensorSidebar
                panelWidth: trendsViewRoot.sensorPanelWidth
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

            // 2C. RIGHT WORKSPACE: MODULAR GRAPH OR TABLE STACK
            StackLayout {
                id: trendStack
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: trendsViewRoot.activeMode === "chart" ? 0 : 1

                // GRAPH VIEW WIDGET
                TrendsGraphWidget {
                    id: trendsGraph
                    yAxisTitle: trendsViewRoot.yAxisTitle
                    xAxisTitle: trendsViewRoot.xAxisTitle
                    inspectionTime: trendsViewRoot.inspectionTime
                    isLiveStreaming: trendsViewRoot.isLiveStreaming
                }

                // TABLE VIEW WIDGET
                TrendsTableWidget {
                    id: trendsTable
                    activeTimePreset: trendsViewRoot.activeTimePreset
                }
            }
        }
    }
}
