/*
This is a UI file (.ui.qml) for Screen 4: Alarms & Annunciator.
Strictly declarative for Qt Design Studio.
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: alarmsViewRoot
    width: 1184
    height: 626
    color: "#08213b"

    property string activeTab: "active" // "active" or "history"
    property alias activeTabBtn: activeSwitchBtn
    property alias historyTabBtn: historySwitchBtn
    property alias alarmList: alarmsListView
    property alias ackModal: ackDialogOverlay

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        // =====================================================================
        // 1. TOP HEADER & SUMMARY
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
                anchors.margins: 8
                spacing: 12

                Rectangle {
                    width: 34
                    height: 34
                    radius: 4
                    color: "#dc2626"
                    Text { text: "🔔"; font.pixelSize: 18; anchors.centerIn: parent }
                }

                Text {
                    text: "ISA-18.2 ALARM ANNUNCIATOR & PROCESS EVENT LOG"
                    color: "#ffffff"
                    font.bold: true
                    font.pixelSize: 15
                }

                Item { Layout.fillWidth: true }

                // Unack Badge
                Rectangle {
                    Layout.preferredWidth: 150
                    Layout.preferredHeight: 34
                    radius: 4
                    color: "#450a0a"
                    border.color: "#ef4444"

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 6
                        Rectangle { width: 8; height: 8; radius: 4; color: "#ef4444" }
                        Text { text: "ACTIVE: 1 UNACK"; color: "#f87171"; font.bold: true; font.pixelSize: 12 }
                    }
                }

                // Tab Switcher
                Rectangle {
                    Layout.preferredWidth: 220
                    Layout.preferredHeight: 34
                    radius: 4
                    color: "#071c33"
                    border.color: "#0284c7"
                    border.width: 1.0

                    RowLayout {
                        anchors.fill: parent
                        spacing: 0

                        Rectangle {
                            id: activeSwitchBtn
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 3
                            color: alarmsViewRoot.activeTab === "active" ? "#dc2626" : "transparent"
                            Text { anchors.centerIn: parent; text: "⚠️ Active Alarms"; color: "#ffffff"; font.bold: true; font.pixelSize: 11 }
                        }

                        Rectangle {
                            id: historySwitchBtn
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 3
                            color: alarmsViewRoot.activeTab === "history" ? "#0284c7" : "transparent"
                            Text { anchors.centerIn: parent; text: "📜 Event Log"; color: "#ffffff"; font.bold: true; font.pixelSize: 11 }
                        }
                    }
                }
            }
        }

        // =====================================================================
        // 2. ALARM TABLE HEADER
        // =====================================================================
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 34
            color: "#0d2b4a"
            radius: 4

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 10

                Text { text: "SEVERITY"; color: "#94a3b8"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 86; horizontalAlignment: Text.AlignHCenter }
                Text { text: "TAG"; color: "#94a3b8"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 100 }
                Text { text: "ALARM DESCRIPTION & OPERATOR ACTION"; color: "#94a3b8"; font.bold: true; font.pixelSize: 11; Layout.fillWidth: true }
                Text { text: "VALUE"; color: "#94a3b8"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 95; horizontalAlignment: Text.AlignRight }
                Text { text: "SETPOINT"; color: "#94a3b8"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 95; horizontalAlignment: Text.AlignRight }
                Text { text: "TIME (UTC)"; color: "#94a3b8"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 95; horizontalAlignment: Text.AlignRight }
                Text { text: "ACTION"; color: "#94a3b8"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 130; horizontalAlignment: Text.AlignHCenter }
            }
        }

        // =====================================================================
        // 3. ALARM LIST VIEW
        // =====================================================================
        ListView {
            id: alarmsListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 6

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
                color: model.severity === "CRITICAL" ? (model.ack ? "#2b1313" : "#450a0a") : "#092440"
                border.color: model.severity === "CRITICAL" ? "#ef4444" : "#1e40af"
                border.width: 1.4

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 10

                    // Severity Badge
                    Rectangle {
                        Layout.preferredWidth: 86
                        Layout.preferredHeight: 28
                        radius: 3
                        color: model.severity === "CRITICAL" ? "#ef4444" : (model.severity === "HIGH" ? "#f97316" : "#0284c7")
                        Text {
                            anchors.centerIn: parent
                            text: model.severity
                            color: "#ffffff"
                            font.bold: true
                            font.pixelSize: 11
                        }
                    }

                    Text { text: model.tag; color: "#38bdf8"; font.bold: true; font.pixelSize: 12; Layout.preferredWidth: 100 }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        Text { text: model.title; color: "#ffffff"; font.bold: true; font.pixelSize: 12 }
                        Text { text: "Action: " + model.resp; color: "#cbd5e1"; font.pixelSize: 11 }
                    }

                    Text { text: model.value; color: "#f87171"; font.bold: true; font.pixelSize: 12; Layout.preferredWidth: 95; horizontalAlignment: Text.AlignRight }
                    Text { text: model.sp; color: "#94a3b8"; font.pixelSize: 11; Layout.preferredWidth: 95; horizontalAlignment: Text.AlignRight }
                    Text { text: model.time; color: "#cbd5e1"; font.pixelSize: 11; Layout.preferredWidth: 95; horizontalAlignment: Text.AlignRight }

                    // Acknowledge Action Button / Badge
                    Rectangle {
                        Layout.preferredWidth: 130
                        Layout.preferredHeight: 32
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

    // =========================================================================
    // 4. 21 CFR PART 11 REASON CAPTURE DIALOG OVERLAY
    // =========================================================================
    Rectangle {
        id: ackDialogOverlay
        anchors.fill: parent
        visible: false
        color: "#d0000000"
        z: 100

        Rectangle {
            anchors.centerIn: parent
            width: 480
            height: 260
            radius: 8
            color: "#081d33"
            border.color: "#ef4444"
            border.width: 2.0

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 10

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    Text { text: "⚠️"; font.pixelSize: 20 }
                    Text { text: "21 CFR PART 11 ALARM ACKNOWLEDGEMENT"; color: "#ef4444"; font.bold: true; font.pixelSize: 13; Layout.fillWidth: true }
                }

                Rectangle { Layout.fillWidth: true; height: 1; color: "#1e3a8a" }

                Text {
                    text: "Enter mandatory operator reason / corrective action taken:"
                    color: "#94a3b8"
                    font.pixelSize: 11
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#06182c"
                    border.color: "#0284c7"
                    radius: 4

                    TextInput {
                        anchors.fill: parent
                        anchors.margins: 8
                        color: "#ffffff"
                        font.pixelSize: 12
                        text: "Inspected vacuum seals and verified normal skid state."
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Button {
                        text: "Cancel"
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 36
                        radius: 4
                        color: "#059669"
                        Text { anchors.centerIn: parent; text: "✓ Confirm & Log to Audit"; color: "#ffffff"; font.bold: true; font.pixelSize: 11 }
                    }
                }
            }
        }
    }
}
