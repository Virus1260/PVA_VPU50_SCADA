/*
This is a UI file (.ui.qml) for Trends Interactive Graph Widget.
Strictly declarative for Qt Design Studio.
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: graphWidgetRoot
    Layout.fillWidth: true
    Layout.fillHeight: true
    color: "#06182c"
    border.color: "#184d7e"
    border.width: 1.2
    radius: 5
    clip: true

    property alias trendCanvasItem: graphCanvas
    property alias dragBoxOverlay: dragSelectionRect
    property alias inspectCardItem: inspectionCard
    property alias inspectRepeaterItem: inspectRepeater
    property alias panStartBtn: timelineStartBtn
    property alias panLeftBtn: timelineLeftBtn
    property alias panRightBtn: timelineRightBtn
    property alias panLiveBtn: timelineLiveBtn
    property alias timeSliderItem: historyTimeSlider

    property string yAxisTitle: "Temperature (°C)"
    property string xAxisTitle: "Time (UTC)"
    property string inspectionTime: "08:34:11 UTC"
    property bool isLiveStreaming: true

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
                text: "Y-AXIS: " + graphWidgetRoot.yAxisTitle
                color: "#38bdf8"
                font.bold: true
                font.pixelSize: 11
            }
            Item { Layout.fillWidth: true }
            Text {
                text: "X-AXIS: " + graphWidgetRoot.xAxisTitle
                color: "#94a3b8"
                font.bold: true
                font.pixelSize: 10
            }
            Text {
                text: "| Free Drag Box to Zoom | Pan Bottom Bar when Paused"
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

            // Dynamic Visual Drag-to-Zoom Free-Size Selection Box
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
                    width: 90
                    radius: 3
                    color: "#0284c7"
                    Text {
                        anchors.centerIn: parent
                        text: "Zoom Window"
                        color: "#ffffff"
                        font.bold: true
                        font.pixelSize: 9
                    }
                }
            }

            // Dynamic Floating Inspection Tooltip with Live Channel Values
            Rectangle {
                id: inspectionCard
                visible: false
                width: 250
                height: 160
                radius: 5
                color: "#081d33"
                border.color: "#38bdf8"
                border.width: 1.4
                opacity: 0.96
                z: 10

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 4

                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: graphWidgetRoot.inspectionTime; color: "#ffffff"; font.bold: true; font.pixelSize: 11 }
                        Item { Layout.fillWidth: true }
                        Text { text: "ACTIVE VALUES"; color: "#38bdf8"; font.bold: true; font.pixelSize: 9 }
                    }

                    Rectangle { Layout.fillWidth: true; height: 1; color: "#1e3a8a" }

                    // Dynamic List of Active Sensor Values at Hovered Timestamp
                    ListView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        spacing: 2
                        interactive: false

                        model: ListModel { id: inspectRepeater }

                        delegate: RowLayout {
                            width: parent ? parent.width : 0
                            spacing: 6

                            Rectangle {
                                width: 8
                                height: 8
                                radius: 4
                                color: model.color ? model.color : "#38bdf8"
                            }

                            Text {
                                text: model.tag
                                color: "#e2e8f0"
                                font.bold: true
                                font.pixelSize: 10
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                            }

                            Text {
                                text: model.val
                                color: model.color ? model.color : "#ffffff"
                                font.bold: true
                                font.pixelSize: 10
                            }
                        }
                    }
                }
            }
        }

        // Bottom Timeline History Panning Bar
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 32
            radius: 4
            color: "#0d2b4a"

            RowLayout {
                anchors.fill: parent
                anchors.margins: 4
                spacing: 6

                Rectangle {
                    id: timelineStartBtn
                    Layout.preferredWidth: 65
                    Layout.preferredHeight: 24
                    radius: 3
                    color: "#1e3a8a"
                    Text { anchors.centerIn: parent; text: "Start"; color: "#ffffff"; font.bold: true; font.pixelSize: 10 }
                }
                Rectangle {
                    id: timelineLeftBtn
                    Layout.preferredWidth: 55
                    Layout.preferredHeight: 24
                    radius: 3
                    color: "#0f3a63"
                    Text { anchors.centerIn: parent; text: "< 10s"; color: "#ffffff"; font.pixelSize: 10 }
                }

                Slider {
                    id: historyTimeSlider
                    Layout.fillWidth: true
                    from: 0
                    to: 100
                    value: 100
                }

                Rectangle {
                    id: timelineRightBtn
                    Layout.preferredWidth: 55
                    Layout.preferredHeight: 24
                    radius: 3
                    color: "#0f3a63"
                    Text { anchors.centerIn: parent; text: "10s >"; color: "#ffffff"; font.pixelSize: 10 }
                }
                Rectangle {
                    id: timelineLiveBtn
                    Layout.preferredWidth: 65
                    Layout.preferredHeight: 24
                    radius: 3
                    color: graphWidgetRoot.isLiveStreaming ? "#15803d" : "#0284c7"
                    Text { anchors.centerIn: parent; text: "Live"; color: "#ffffff"; font.bold: true; font.pixelSize: 10 }
                }
            }
        }
    }
}
