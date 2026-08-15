import QtQuick
import QtQuick.Layouts

Rectangle {
    id: speedRoot
    property real minVal: 25.0
    property real maxVal: 120.0
    property real currentVal: 0.0
    property real targetVal: 25.0
    property string unit: "rpm"
    property int decimals: 1
    property real controlHeight: 76
    property string parameterTitle: "Speed Setpoint"
    property string parameterTag: "1M1501"
    property bool isLocked: false

    property alias minusButton: decBtn
    property alias plusButton: incBtn
    property alias setpointBox: setpointClickArea

    signal setpointRequested(string title, string tag, double current, double min, double max, string unit)
    signal targetValChangedByUser(double newVal)

    Layout.preferredWidth: 430
    Layout.maximumWidth: 480
    Layout.fillWidth: false
    Layout.preferredHeight: controlHeight
    Layout.minimumHeight: controlHeight
    Layout.maximumHeight: controlHeight

    color: "#092848"
    border.color: "#184d7e"
    border.width: 1
    radius: 4

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        anchors.topMargin: 4
        anchors.bottomMargin: 4
        spacing: 6

        // 1. SET MIN Digital Readout Box
        Rectangle {
            Layout.preferredWidth: 56
            Layout.preferredHeight: 64
            color: "#0c3359"
            border.color: "#1a5286"
            border.width: 1
            radius: 3

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 2
                Text {
                    text: "SET MIN"
                    color: "#8cb5dc"
                    font.pixelSize: 8
                    Layout.alignment: Qt.AlignHCenter
                }
                Text {
                    text: speedRoot.minVal.toFixed(speedRoot.decimals === 0 ? 0 : 1)
                    color: "#ffffff"
                    font.bold: true
                    font.pixelSize: 13
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        // 2. Tactile Minus Button
        ScadaButton {
            id: decBtn
            text: "−"
            enabled: speedRoot.enabled && !speedRoot.isLocked
            opacity: enabled ? 1.0 : 0.5
            Layout.preferredWidth: 32
            Layout.preferredHeight: 64
            accentColor: "#103c68"
        }

        // 3. Center Slider Visualizer & Track
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2
            Layout.alignment: Qt.AlignVCenter

            // Top Status Labels
            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: speedRoot.minVal.toFixed(speedRoot.decimals === 0 ? 0 : 1) + " " + speedRoot.unit
                    color: "#8cb5dc"
                    font.pixelSize: 9
                }
                Item { Layout.fillWidth: true }
                Text {
                    text: speedRoot.currentVal.toFixed(speedRoot.decimals === 0 ? 0 : 1) + " " + speedRoot.unit
                    color: "#ffffff"
                    font.bold: true
                    font.pixelSize: 11
                }
                Item { Layout.fillWidth: true }
                Text {
                    text: speedRoot.maxVal.toFixed(speedRoot.decimals === 0 ? 0 : 1) + " " + speedRoot.unit
                    color: "#8cb5dc"
                    font.pixelSize: 9
                }
            }

            // Interactive Slider Rail Track (Clickable & Draggable)
            Rectangle {
                id: sliderTrack
                Layout.fillWidth: true
                Layout.preferredHeight: 14
                color: "#051829"
                border.color: "#184d7e"
                border.width: 1
                radius: 3
                clip: false

                // Actual Speed Fill
                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.margins: 1
                    width: Math.max(0, Math.min(parent.width - 2, (parent.width - 2) * ((speedRoot.currentVal - speedRoot.minVal) / Math.max(1.0, (speedRoot.maxVal - speedRoot.minVal)))))
                    color: "#78dc24"
                    radius: 2
                }

                // Target Setpoint Needle Marker (White with cyan border)
                Rectangle {
                    id: setpointNeedle
                    x: Math.max(0, Math.min(sliderTrack.width - 6, (sliderTrack.width - 6) * ((speedRoot.targetVal - speedRoot.minVal) / Math.max(1.0, (speedRoot.maxVal - speedRoot.minVal)))))
                    y: -5
                    width: 6
                    height: 24
                    color: "#ffffff"
                    border.color: "#00d2ff"
                    border.width: 1
                    radius: 2
                    z: 5
                }

                // MouseArea for Slider Dragging & Clicking
                MouseArea {
                    id: sliderMouseArea
                    anchors.fill: parent
                    anchors.topMargin: -8
                    anchors.bottomMargin: -8
                    enabled: speedRoot.enabled && !speedRoot.isLocked
                    cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

                    function updateValueFromPos(mouseX) {
                        var ratio = Math.max(0.0, Math.min(1.0, mouseX / sliderTrack.width));
                        var rawVal = speedRoot.minVal + ratio * (speedRoot.maxVal - speedRoot.minVal);
                        var step = speedRoot.decimals === 0 ? 10.0 : 1.0;
                        var steppedVal = Math.round(rawVal / step) * step;
                        steppedVal = Math.max(speedRoot.minVal, Math.min(speedRoot.maxVal, steppedVal));
                        speedRoot.targetVal = steppedVal;
                        speedRoot.targetValChangedByUser(steppedVal);
                    }

                    onPressed: function(mouse) { updateValueFromPos(mouse.x); }
                    onPositionChanged: function(mouse) { if (pressed) updateValueFromPos(mouse.x); }
                }
            }

            // Bottom Setpoint Digital Button (Clicking opens Keypad Modal!)
            RowLayout {
                Layout.fillWidth: true
                spacing: 4

                Text {
                    text: "Act: " + speedRoot.currentVal.toFixed(speedRoot.decimals === 0 ? 0 : 1) + " " + speedRoot.unit
                    color: "#ffffff"
                    font.bold: true
                    font.pixelSize: 10
                }

                Item { Layout.fillWidth: true }

                // Clickable Setpoint Box
                Rectangle {
                    Layout.preferredWidth: 105
                    Layout.preferredHeight: 20
                    color: setpointClickArea.containsMouse && !speedRoot.isLocked ? "#154d80" : "#0c3359"
                    border.color: speedRoot.isLocked ? "#4a749b" : (setpointClickArea.containsMouse ? "#00d2ff" : "#1a5286")
                    border.width: 1
                    radius: 3

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 3
                        Text {
                            text: speedRoot.isLocked ? "🔒" : "Set:"
                            color: "#8cb5dc"
                            font.pixelSize: 9
                        }
                        Text {
                            text: speedRoot.targetVal.toFixed(speedRoot.decimals === 0 ? 0 : 1) + " " + speedRoot.unit
                            color: speedRoot.isLocked ? "#8cb5dc" : "#00d2ff"
                            font.bold: true
                            font.pixelSize: 10
                        }
                        Text {
                            text: speedRoot.isLocked ? "" : "✎"
                            color: "#8cb5dc"
                            font.pixelSize: 8
                            visible: !speedRoot.isLocked
                        }
                    }

                    MouseArea {
                        id: setpointClickArea
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: speedRoot.enabled && !speedRoot.isLocked
                        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: {
                            speedRoot.setpointRequested(
                                speedRoot.parameterTitle,
                                speedRoot.parameterTag,
                                speedRoot.targetVal,
                                speedRoot.minVal,
                                speedRoot.maxVal,
                                speedRoot.unit
                            );
                        }
                    }
                }
            }
        }

        // 4. Tactile Plus Button
        ScadaButton {
            id: incBtn
            text: "+"
            enabled: speedRoot.enabled && !speedRoot.isLocked
            opacity: enabled ? 1.0 : 0.5
            Layout.preferredWidth: 32
            Layout.preferredHeight: 64
            accentColor: "#103c68"
        }

        // 5. SET MAX Digital Readout Box
        Rectangle {
            Layout.preferredWidth: 56
            Layout.preferredHeight: 64
            color: "#0c3359"
            border.color: "#1a5286"
            border.width: 1
            radius: 3

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 2
                Text {
                    text: "SET MAX"
                    color: "#8cb5dc"
                    font.pixelSize: 8
                    Layout.alignment: Qt.AlignHCenter
                }
                Text {
                    text: speedRoot.maxVal.toFixed(speedRoot.decimals === 0 ? 0 : 1)
                    color: "#ffffff"
                    font.bold: true
                    font.pixelSize: 13
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
}
