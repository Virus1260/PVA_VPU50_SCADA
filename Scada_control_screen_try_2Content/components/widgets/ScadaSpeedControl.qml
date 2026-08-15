import QtQuick
import QtQuick.Layouts

Rectangle {
    id: speedRoot
    implicitWidth: 444
    implicitHeight: 64
    width: 444
    height: 64

    // Process & Range Properties
    property real minVal: 25.0
    property real maxVal: 120.0
    property real currentVal: 0.0
    property real targetVal: 25.0
    property string unit: "rpm"
    property int decimals: 1
    property real controlHeight: 64

    property string parameterTitle: "Speed Setpoint"
    property string parameterTag: "1M1501"
    property bool isLocked: false

    property alias minusButton: decBtn
    property alias plusButton: incBtn
    property alias setpointBox: setpointClickArea

    signal setpointRequested(string title, string tag, double current, double min, double max, string unit)
    signal targetValChangedByUser(double newVal)

    Layout.preferredWidth: 444
    Layout.minimumWidth: 444
    Layout.maximumWidth: 444
    Layout.preferredHeight: 64
    Layout.minimumHeight: 64
    Layout.maximumHeight: 64

    color: "#082646"
    border.color: "#184d7e"
    border.width: 1
    radius: 4

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 6
        anchors.rightMargin: 6
        anchors.topMargin: 4
        anchors.bottomMargin: 4
        spacing: 6

        // =====================================================================
        // 1. SET MIN COMPARTMENT (Image 1 Authentic)
        // =====================================================================
        ColumnLayout {
            Layout.preferredWidth: 50
            Layout.minimumWidth: 50
            Layout.maximumWidth: 50
            Layout.fillHeight: true
            spacing: 1
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
                font.pixelSize: 15
                Layout.alignment: Qt.AlignHCenter
            }
            Item { Layout.fillHeight: true }
        }

        // =====================================================================
        // 2. PERFECT SQUARE MINUS BUTTON (Image 1 Authentic: 44px x 44px)
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
            radius: 3
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
        // 3. CENTER SLIDER RAIL & READOUTS (Image 1 Authentic)
        // =====================================================================
        Rectangle {
            id: sliderChannel
            Layout.fillWidth: true
            Layout.preferredHeight: 52
            color: "transparent"
            clip: false

            // Actual Speed Readout (Top Center/Right)
            RowLayout {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.rightMargin: 4
                anchors.topMargin: 0
                spacing: 3

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
                radius: 2

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

                // White Setpoint Needle Marker (Image 1 Authentic)
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

            // Target Setpoint Digital Button (Centered below rail in large bold text - Image 1)
            Rectangle {
                id: setpointClickArea
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                width: 140
                height: 18
                color: "transparent"

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 3

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
        // 4. PERFECT SQUARE PLUS BUTTON (Image 1 Authentic: 44px x 44px)
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
            radius: 3
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
        // 5. SET MAX COMPARTMENT (Image 1 Authentic)
        // =====================================================================
        ColumnLayout {
            Layout.preferredWidth: 50
            Layout.minimumWidth: 50
            Layout.maximumWidth: 50
            Layout.fillHeight: true
            spacing: 1
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
                font.pixelSize: 15
                Layout.alignment: Qt.AlignHCenter
            }
            Item { Layout.fillHeight: true }
        }
    }
}
