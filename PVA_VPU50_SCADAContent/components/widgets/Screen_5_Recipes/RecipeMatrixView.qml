import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ColumnLayout {
    id: matrixViewRoot
    spacing: 4

    property var steps: []
    property var expandedMap: ({})

    signal stepToggled(int stepId)
    signal stepMovedUp(int index)
    signal stepMovedDown(int index)
    signal stepDeleted(int index)
    signal addOperationRequested(int stepIndex)
    signal removeOperationRequested(int stepIndex, int opIndex)

    // Table Column Headers: #, Name, Description, Ops, ⚠️, Status, Actions
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 34
        color: "#071525"
        border.color: "#122d52"
        border.width: 1
        radius: 4

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            spacing: 8

            Text { text: "#"; color: "#6b8fbb"; font.bold: true; font.pixelSize: 11; horizontalAlignment: Text.AlignHCenter; Layout.preferredWidth: 36 }
            Text { text: "Name"; color: "#6b8fbb"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 180 }
            Text { text: "Description"; color: "#6b8fbb"; font.bold: true; font.pixelSize: 11; Layout.fillWidth: true }
            Text { text: "Ops"; color: "#6b8fbb"; font.bold: true; font.pixelSize: 11; horizontalAlignment: Text.AlignHCenter; Layout.preferredWidth: 46 }
            Text { text: "⚠️"; color: "#6b8fbb"; font.bold: true; font.pixelSize: 11; horizontalAlignment: Text.AlignHCenter; Layout.preferredWidth: 36 }
            Text { text: "Status"; color: "#6b8fbb"; font.bold: true; font.pixelSize: 11; horizontalAlignment: Text.AlignHCenter; Layout.preferredWidth: 60 }
            Text { text: "Actions"; color: "#6b8fbb"; font.bold: true; font.pixelSize: 11; horizontalAlignment: Text.AlignHCenter; Layout.preferredWidth: 110 }
        }
    }

    // Scrollable Step Rows
    ListView {
        id: stepList
        Layout.fillWidth: true
        Layout.fillHeight: true
        model: matrixViewRoot.steps
        spacing: 4
        clip: true

        delegate: Rectangle {
            id: stepBox
            width: stepList.width
            property bool isExpanded: !!matrixViewRoot.expandedMap[modelData.id]
            height: isExpanded ? (80 + (modelData.ops ? modelData.ops.length * 36 : 0)) : 42
            color: modelData.status === "ACTIVE" ? "#0f3a64" : (index % 2 === 0 ? "#092440" : "#071b30")
            border.color: modelData.status === "ACTIVE" ? "#00d2ff" : "#122d52"
            border.width: modelData.status === "ACTIVE" ? 1.5 : 1
            radius: 4
            clip: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 6
                spacing: 6

                // Step Row Bar
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    // Step ID Pill
                    Rectangle {
                        Layout.preferredWidth: 32
                        Layout.preferredHeight: 28
                        radius: 14
                        color: modelData.status === "ACTIVE" ? "#1e40af" : "#0f2d4d"
                        border.color: modelData.status === "ACTIVE" ? "#00d2ff" : "#1d5b94"
                        border.width: 1
                        Text {
                            anchors.centerIn: parent
                            text: modelData.id
                            color: "#ffffff"
                            font.bold: true
                            font.pixelSize: 12
                        }
                    }

                    // Step Name
                    Text {
                        text: modelData.name
                        color: "#ffffff"
                        font.bold: true
                        font.pixelSize: 13
                        Layout.preferredWidth: 170
                        elide: Text.ElideRight
                    }

                    // Step Description
                    Text {
                        text: modelData.desc
                        color: "#94a3b8"
                        font.pixelSize: 12
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }

                    // Ops Count
                    Rectangle {
                        Layout.preferredWidth: 36
                        Layout.preferredHeight: 22
                        radius: 11
                        color: "#0d2847"
                        border.color: "#1e40af"
                        border.width: 1
                        Text {
                            anchors.centerIn: parent
                            text: modelData.ops ? modelData.ops.length : 0
                            color: "#38bdf8"
                            font.bold: true
                            font.pixelSize: 11
                        }
                    }

                    // Warning / Manual Flag
                    Text {
                        text: modelData.isManual ? "⚠️" : "○"
                        color: modelData.isManual ? "#f59e0b" : "#475569"
                        font.pixelSize: 13
                        horizontalAlignment: Text.AlignHCenter
                        Layout.preferredWidth: 36
                    }

                    // Status Indicator Dot
                    Rectangle {
                        Layout.preferredWidth: 12
                        Layout.preferredHeight: 12
                        radius: 6
                        color: modelData.status === "DONE" ? "#22c55e" : (modelData.status === "ACTIVE" ? "#38bdf8" : "#334155")
                        border.color: "#ffffff"
                        border.width: 1
                    }

                    // Action Icons (Expand, Move Up, Move Down, Delete)
                    RowLayout {
                        Layout.preferredWidth: 110
                        spacing: 4

                        // Expand Button
                        Rectangle {
                            width: 24
                            height: 24
                            radius: 3
                            color: "#0d2847"
                            border.color: "#1e40af"
                            border.width: 1
                            Text { anchors.centerIn: parent; text: stepBox.isExpanded ? "▲" : "▼"; color: "#38bdf8"; font.pixelSize: 10 }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: matrixViewRoot.stepToggled(modelData.id)
                            }
                        }

                        // Up Button
                        Rectangle {
                            width: 24
                            height: 24
                            radius: 3
                            color: "#0d2847"
                            border.color: "#1e40af"
                            border.width: 1
                            Text { anchors.centerIn: parent; text: "↑"; color: "#94a3b8"; font.bold: true; font.pixelSize: 11 }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: matrixViewRoot.stepMovedUp(index)
                            }
                        }

                        // Down Button
                        Rectangle {
                            width: 24
                            height: 24
                            radius: 3
                            color: "#0d2847"
                            border.color: "#1e40af"
                            border.width: 1
                            Text { anchors.centerIn: parent; text: "↓"; color: "#94a3b8"; font.bold: true; font.pixelSize: 11 }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: matrixViewRoot.stepMovedDown(index)
                            }
                        }

                        // Delete Button
                        Rectangle {
                            width: 24
                            height: 24
                            radius: 3
                            color: "#450a0a"
                            border.color: "#ef4444"
                            border.width: 1
                            Text { anchors.centerIn: parent; text: "✕"; color: "#f87171"; font.bold: true; font.pixelSize: 10 }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: matrixViewRoot.stepDeleted(index)
                            }
                        }
                    }
                }

                // Sub-Operations Detailed Section (When Expanded)
                ColumnLayout {
                    visible: stepBox.isExpanded
                    Layout.fillWidth: true
                    spacing: 4

                    // Operations List
                    Repeater {
                        model: modelData.ops || []
                        RecipeOperationRow {
                            operationData: modelData
                            opIndex: index
                            onRemoveRequested: function(opIdx) {
                                matrixViewRoot.removeOperationRequested(index, opIdx);
                            }
                        }
                    }

                    // + Add Operation Button
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 26
                        color: "#0a2238"
                        border.color: "#1e40af"
                        border.width: 1
                        radius: 3
                        Text {
                            anchors.centerIn: parent
                            text: "+ Add Parallel Equipment Operation"
                            color: "#38bdf8"
                            font.bold: true
                            font.pixelSize: 11
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: matrixViewRoot.addOperationRequested(index)
                        }
                    }
                }
            }
        }
    }
}
