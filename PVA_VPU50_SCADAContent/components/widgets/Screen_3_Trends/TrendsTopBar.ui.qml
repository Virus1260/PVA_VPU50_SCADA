/*
This is a UI file (.ui.qml) for Trends Top Control Bar.
Strictly declarative for Qt Design Studio.
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: topBarRoot
    Layout.fillWidth: true
    Layout.preferredHeight: 46
    radius: 5
    color: "#0d2b4a"
    border.color: "#184d7e"
    border.width: 1.2

    property alias batchCombo: batchSelectorCombo
    property alias t1MinBtn: time1MinBtn
    property alias t5MinBtn: time5MinBtn
    property alias t15MinBtn: time15MinBtn
    property alias t1HourBtn: time1HourBtn
    property alias t8HourBtn: time8HourBtn
    property alias t24HourBtn: time24HourBtn
    property alias liveStreamBtn: liveStreamToggleBtn
    property alias resetZoomBtn: resetZoomButton
    property alias chartModeBtn: chartViewButton
    property alias tableModeBtn: tableViewButton

    property string operatorName: "Line Operator (Level 1)"
    property string activeTimePreset: "5min"
    property bool isLiveStreaming: true
    property bool isZoomed: false
    property string activeMode: "chart"

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
                Text { text: topBarRoot.operatorName; color: "#38bdf8"; font.bold: true; font.pixelSize: 10 }
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
                    color: topBarRoot.activeTimePreset === "1min" ? "#0284c7" : "transparent"
                    Text { anchors.centerIn: parent; text: "1m"; color: "#ffffff"; font.bold: true; font.pixelSize: 10 }
                }
                Rectangle {
                    id: time5MinBtn
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 3
                    color: topBarRoot.activeTimePreset === "5min" ? "#0284c7" : "transparent"
                    Text { anchors.centerIn: parent; text: "5m"; color: "#ffffff"; font.bold: true; font.pixelSize: 10 }
                }
                Rectangle {
                    id: time15MinBtn
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 3
                    color: topBarRoot.activeTimePreset === "15min" ? "#0284c7" : "transparent"
                    Text { anchors.centerIn: parent; text: "15m"; color: "#ffffff"; font.bold: true; font.pixelSize: 10 }
                }
                Rectangle {
                    id: time1HourBtn
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 3
                    color: topBarRoot.activeTimePreset === "1h" ? "#0284c7" : "transparent"
                    Text { anchors.centerIn: parent; text: "1h"; color: "#ffffff"; font.bold: true; font.pixelSize: 10 }
                }
                Rectangle {
                    id: time8HourBtn
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 3
                    color: topBarRoot.activeTimePreset === "8h" ? "#0284c7" : "transparent"
                    Text { anchors.centerIn: parent; text: "8h"; color: "#ffffff"; font.bold: true; font.pixelSize: 10 }
                }
                Rectangle {
                    id: time24HourBtn
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 3
                    color: topBarRoot.activeTimePreset === "24h" ? "#0284c7" : "transparent"
                    Text { anchors.centerIn: parent; text: "24h"; color: "#ffffff"; font.bold: true; font.pixelSize: 10 }
                }
            }
        }

        // Live Streaming Toggle / Status
        Rectangle {
            id: liveStreamToggleBtn
            Layout.preferredWidth: 125
            Layout.preferredHeight: 34
            radius: 4
            color: topBarRoot.isLiveStreaming ? "#052e16" : "#451a03"
            border.color: topBarRoot.isLiveStreaming ? "#22c55e" : "#f59e0b"

            RowLayout {
                anchors.centerIn: parent
                spacing: 6
                Rectangle { width: 8; height: 8; radius: 4; color: topBarRoot.isLiveStreaming ? "#22c55e" : "#f59e0b" }
                Text {
                    text: topBarRoot.isLiveStreaming ? "● LIVE SCROLL" : "⏸ PAUSED (PULL)"
                    color: topBarRoot.isLiveStreaming ? "#4ade80" : "#fde68a"
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
            visible: topBarRoot.isZoomed
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
                    color: topBarRoot.activeMode === "chart" ? "#0284c7" : "transparent"
                    Text { anchors.centerIn: parent; text: "📈 Graph"; color: "#ffffff"; font.bold: true; font.pixelSize: 11 }
                }

                Rectangle {
                    id: tableViewButton
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 3
                    color: topBarRoot.activeMode === "table" ? "#0284c7" : "transparent"
                    Text { anchors.centerIn: parent; text: "📋 Table"; color: "#ffffff"; font.bold: true; font.pixelSize: 11 }
                }
            }
        }
    }
}
