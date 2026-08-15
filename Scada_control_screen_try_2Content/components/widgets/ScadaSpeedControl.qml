import QtQuick
import QtQuick.Layouts

Rectangle {
    id: speedRoot
    implicitHeight: 70
    height: 70

    // Process & Range Properties
    property real minVal: 25.0
    property real maxVal: 120.0
    property real currentVal: 0.0
    property real targetVal: 25.0
    property string unit: "rpm"
    property int decimals: 1
    property real controlHeight: 70

    property string parameterTitle: "Speed Setpoint"
    property string parameterTag: "1M1501"
    property bool isLocked: false

    property alias minusButton: decBtn
    property alias plusButton: incBtn
    property alias setpointBox: setpointClickArea

    signal setpointRequested(string title, string tag, double current, double min, double max, string unit)
    signal targetValChangedByUser(double newVal)

    Layout.fillWidth: true
    Layout.minimumWidth: 260
    Layout.preferredHeight: 70
    Layout.minimumHeight: 70
    Layout.maximumHeight: 70

    color: "#082646"
    border.color: "#184d7e"
    border.width: 1
    radius: 4

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 6
        anchors.rightMargin: 6
        anchors.topMargin: 6
        anchors.bottomMargin: 6
        spacing: 6

        // =====================================================================
        // 1. SET MIN COMPARTMENT
        // =====================================================================
        ColumnLayout {
            Layout.preferredWidth: 46
            Layout.minimumWidth: 40
            Layout.maximumWidth: 50
            Layout.fillHeight: true
            spacing: 2
            Layout.alignment: Qt.AlignVCenter

            Text {
                text: "SET MIN"
                color: "#8cb5dc"
                font.pixelSize: 9
                Layout.alignment: Qt.AlignHCenter
            }
            Item { Layout.fillHeight: true }
            Text {
                text: speedRoot.minVal.toFixed(speedRoot.decimals === 0 ? 0 : 1)
                color: "#ffffff"
                font.bold: true
                font.pixelSize: 14
                Layout.alignment: Qt.AlignHCenter
            }
            Item { Layout.fillHeight: true }
        }

        // =====================================================================
        // 2. PERFECT SQUARE MINUS BUTTON (44px x 44px)
        // =====================================================================
        Rectangle {
            id: decBtn
            Layout.preferredWidth: 44
            Layout.minimumWidth: 44
            Layout.maximumWidth: 44
            Layout.preferredHeight: 44
            Layout.minimumHeight: 44
            Layout.maximumHeight: 44
            Layout.alignment: Qt.AlignVCenter
            radius: 4
            color: decMouse.pressed ? "#07203a" : (decMouse.containsMouse ? "#154d80" : "#0d365e")
            border.color: decMouse.containsMouse ? "#3892e6" : "#1a5286"
            border.width: 1
            enabled: speedRoot.enabled && !speedRoot.isLocked
            opacity: enabled ? 1.0 : 0.45

            signal clicked()

            Text {
                anchors.centerIn: parent
                text: "−"
                color: "#ffffff"
                font.bold: true
                font.pixelSize: 22
            }

            MouseArea {
                id: decMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: parent.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                onClicked: decBtn.clicked()
            }
        }

        // =====================================================================
        // 3. CENTER SLIDER RAIL & READOUTS
        // =====================================================================
        Rectangle {
            id: sliderChannel
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
            clip: false

            // Actual Speed Readout (Top Center/Right)
            RowLayout {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.rightMargin: 2
                anchors.topMargin: 0
                spacing: 2

                Text {
                    text: speedRoot.currentVal.toFixed(speedRoot.decimals === 0 ? 0 : 1)
                    color: "#ffffff"
                    font.bold: true
                    font.pixelSize: 13
                }
                Text {
                    text: speedRoot.unit
                    color: "#8cb5dc"
                    font.pixelSize: 10
                }
            }

            // Inner Track Rail Channel
            Rectangle {
                id: trackRail
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin: 18
                height: 10
                color: "#09243e"
                border.color: "#154673"
                border.width: 1
                radius: 3

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

                // White Setpoint Needle Marker
                Rectangle {
                    id: setpointNeedle
                    x: Math.max(0, Math.min(trackRail.width - 5, (trackRail.width - 5) * ((speedRoot.targetVal - speedRoot.minVal) / Math.max(1.0, (speedRoot.maxVal - speedRoot.minVal)))))
                    anchors.verticalCenter: parent.verticalCenter
                    width: 5
                    height: 24
                    color: "#ffffff"
                    border.color: "#00d2ff"
                    border.width: 1
                    radius: 2
                    z: 10
                }

                // MouseArea for Slider Dragging & Clicking
                MouseArea {
                    id: trackMouse
                    anchors.fill: parent
                    anchors.topMargin: -10
                    anchors.bottomMargin: -10
                    enabled: speedRoot.enabled && !speedRoot.isLocked
                    cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

                    function updateValueFromPos(mouseX) {
                        var ratio = Math.max(0.0, Math.min(1.0, mouseX / trackRail.width));
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

            // Target Setpoint Digital Button (Centered below rail in large bold text)
            Rectangle {
                id: setpointClickArea
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                width: 130
                height: 18
                color: "transparent"

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 2

                    Text {
                        text: speedRoot.isLocked ? "🔒" : ""
                        color: "#8cb5dc"
                        font.pixelSize: 10
                        visible: speedRoot.isLocked
                    }
                    Text {
                        text: speedRoot.targetVal.toFixed(speedRoot.decimals === 0 ? 0 : 1)
                        color: "#ffffff"
                        font.bold: true
                        font.pixelSize: 15
                    }
                    Text {
                        text: speedRoot.unit
                        color: "#8cb5dc"
                        font.pixelSize: 11
                    }
                }

                MouseArea {
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

        // =====================================================================
        // 4. PERFECT SQUARE PLUS BUTTON (44px x 44px)
        // =====================================================================
        Rectangle {
            id: incBtn
            Layout.preferredWidth: 44
            Layout.minimumWidth: 44
            Layout.maximumWidth: 44
            Layout.preferredHeight: 44
            Layout.minimumHeight: 44
            Layout.maximumHeight: 44
            Layout.alignment: Qt.AlignVCenter
            radius: 4
            color: incMouse.pressed ? "#07203a" : (incMouse.containsMouse ? "#154d80" : "#0d365e")
            border.color: incMouse.containsMouse ? "#3892e6" : "#1a5286"
            border.width: 1
            enabled: speedRoot.enabled && !speedRoot.isLocked
            opacity: enabled ? 1.0 : 0.45

            signal clicked()

            Text {
                anchors.centerIn: parent
                text: "+"
                color: "#ffffff"
                font.bold: true
                font.pixelSize: 22
            }

            MouseArea {
                id: incMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: parent.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                onClicked: incBtn.clicked()
            }
        }

        // =====================================================================
        // 5. SET MAX COMPARTMENT
        // =====================================================================
        ColumnLayout {
            Layout.preferredWidth: 46
            Layout.minimumWidth: 40
            Layout.maximumWidth: 50
            Layout.fillHeight: true
            spacing: 2
            Layout.alignment: Qt.AlignVCenter

            Text {
                text: "SET MAX"
                color: "#8cb5dc"
                font.pixelSize: 9
                Layout.alignment: Qt.AlignHCenter
            }
            Item { Layout.fillHeight: true }
            Text {
                text: speedRoot.maxVal.toFixed(speedRoot.decimals === 0 ? 0 : 1)
                color: "#ffffff"
                font.bold: true
                font.pixelSize: 14
                Layout.alignment: Qt.AlignHCenter
            }
            Item { Layout.fillHeight: true }
        }
    }
}
