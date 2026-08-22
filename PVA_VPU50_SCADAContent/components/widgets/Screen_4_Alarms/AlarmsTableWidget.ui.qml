/*
This is a UI file (.ui.qml) for Alarms Annunciator Table Grid.
Strictly declarative for Qt Design Studio with pixel-perfect column alignment.
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: alarmsTableRoot
    Layout.fillWidth: true
    Layout.fillHeight: true
    color: "#06182c"
    border.color: "#184d7e"
    border.width: 1.2
    radius: 5
    clip: true

    property alias alarmList: alarmsListView

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 6

        // =====================================================================
        // ALARM TABLE HEADER ROW
        // =====================================================================
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 38
            color: "#0d2b4a"
            radius: 4

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 12

                Text {
                    text: "SEVERITY"
                    color: "#94a3b8"
                    font.bold: true
                    font.pixelSize: 11
                    Layout.preferredWidth: 90
                    horizontalAlignment: Text.AlignHCenter
                }

                Text {
                    text: "TAG"
                    color: "#94a3b8"
                    font.bold: true
                    font.pixelSize: 11
                    Layout.preferredWidth: 110
                }

                Text {
                    text: "ALARM DESCRIPTION & OPERATOR ACTION"
                    color: "#94a3b8"
                    font.bold: true
                    font.pixelSize: 11
                    Layout.fillWidth: true
                }

                Text {
                    text: "VALUE"
                    color: "#94a3b8"
                    font.bold: true
                    font.pixelSize: 11
                    Layout.preferredWidth: 100
                    horizontalAlignment: Text.AlignRight
                }

                Text {
                    text: "SETPOINT"
                    color: "#94a3b8"
                    font.bold: true
                    font.pixelSize: 11
                    Layout.preferredWidth: 100
                    horizontalAlignment: Text.AlignRight
                }

                Text {
                    text: "TIME (UTC)"
                    color: "#94a3b8"
                    font.bold: true
                    font.pixelSize: 11
                    Layout.preferredWidth: 95
                    horizontalAlignment: Text.AlignRight
                }

                Text {
                    text: "ACTION"
                    color: "#94a3b8"
                    font.bold: true
                    font.pixelSize: 11
                    Layout.preferredWidth: 140
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        // =====================================================================
        // ALARM DATA ROWS LISTVIEW
        // =====================================================================
        ListView {
            id: alarmsListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 4

            model: ListModel {
                ListElement { alarmCode: "ALM-001"; severity: "CRITICAL"; tag: "PIC161001"; title: "Vacuum Seal Differential Pressure Loss"; value: "-209.8 mbar"; sp: "-450.0 mbar"; time: "09:42:15"; ack: false; ackBy: ""; resp: "Check lid gasket seal integrity and vacuum valve V101." }
                ListElement { alarmCode: "ALM-002"; severity: "HIGH"; tag: "TIC162001"; title: "Jacket Thermal Overheat Warning"; value: "88.9 °C"; sp: "80.0 °C"; time: "09:40:02"; ack: true; ackBy: "operator"; resp: "Engage thermal jacket cooling circuit." }
                ListElement { alarmCode: "ALM-003"; severity: "MEDIUM"; tag: "SCR182001"; title: "Agitator Drive Ready Status Feedback"; value: "25.0 rpm"; sp: "25.0 rpm"; time: "09:35:18"; ack: true; ackBy: "supervisor"; resp: "Verify motor current and VFD parameters." }
                ListElement { alarmCode: "ALM-004"; severity: "INFO"; tag: "1M2003"; title: "Homogenizer Seal Cooling Fluid Flow Normal"; value: "4.2 L/min"; sp: "3.5 L/min"; time: "09:30:00"; ack: true; ackBy: "operator"; resp: "Routine telemetry verification." }
            }

            delegate: Rectangle {
                width: alarmsListView ? alarmsListView.width : 0
                height: 56
                radius: 4
                color: model.severity === "CRITICAL" ? (model.ack ? "#2b1313" : "#450a0a") : (index % 2 === 0 ? "#071c33" : "#092440")
                border.color: model.severity === "CRITICAL" ? "#ef4444" : (model.severity === "HIGH" ? "#f97316" : "#1e40af")
                border.width: 1.4

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 12

                    // 1. Severity Badge (Exactly 90px width centered)
                    Item {
                        Layout.preferredWidth: 90
                        Layout.fillHeight: true

                        Rectangle {
                            anchors.centerIn: parent
                            width: 84
                            height: 28
                            radius: 3
                            color: model.severity === "CRITICAL" ? "#ef4444" : (model.severity === "HIGH" ? "#f97316" : (model.severity === "MEDIUM" ? "#0284c7" : "#0ea5e9"))

                            Text {
                                anchors.centerIn: parent
                                text: model.severity
                                color: "#ffffff"
                                font.bold: true
                                font.pixelSize: 11
                            }
                        }
                    }

                    // 2. Sensor Tag (Exactly 110px width left-aligned)
                    Text {
                        text: model.tag
                        color: "#38bdf8"
                        font.bold: true
                        font.pixelSize: 12
                        Layout.preferredWidth: 110
                        elide: Text.ElideRight
                    }

                    // 3. Alarm Description & Operator Action (Expands to fill remaining width)
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2

                        Text {
                            text: model.title
                            color: "#ffffff"
                            font.bold: true
                            font.pixelSize: 12
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }

                        Text {
                            text: "Action: " + model.resp
                            color: "#cbd5e1"
                            font.pixelSize: 11
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                    }

                    // 4. Value (Exactly 100px width right-aligned)
                    Text {
                        text: model.value
                        color: "#f87171"
                        font.bold: true
                        font.pixelSize: 12
                        Layout.preferredWidth: 100
                        horizontalAlignment: Text.AlignRight
                    }

                    // 5. Setpoint (Exactly 100px width right-aligned)
                    Text {
                        text: model.sp
                        color: "#94a3b8"
                        font.pixelSize: 11
                        Layout.preferredWidth: 100
                        horizontalAlignment: Text.AlignRight
                    }

                    // 6. Time (Exactly 95px width right-aligned)
                    Text {
                        text: model.time
                        color: "#cbd5e1"
                        font.pixelSize: 11
                        Layout.preferredWidth: 95
                        horizontalAlignment: Text.AlignRight
                    }

                    // 7. Action Button (Exactly 140px width centered)
                    Item {
                        Layout.preferredWidth: 140
                        Layout.fillHeight: true

                        Rectangle {
                            anchors.centerIn: parent
                            width: 136
                            height: 32
                            radius: 4
                            color: model.ack ? "#064e3b" : "#dc2626"
                            border.color: model.ack ? "#10b981" : "#ef4444"

                            Text {
                                anchors.centerIn: parent
                                text: model.ack ? "✓ ACK (" + model.ackBy + ")" : "🔔 ACKNOWLEDGE"
                                color: "#ffffff"
                                font.bold: true
                                font.pixelSize: 11
                            }
                        }
                    }
                }
            }
        }
    }
}
