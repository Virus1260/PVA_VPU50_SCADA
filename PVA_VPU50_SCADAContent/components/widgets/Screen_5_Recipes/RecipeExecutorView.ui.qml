/*
This is a UI file (.ui.qml) for the ISA-88 Automated Batch Recipe Execution Engine.
Strictly declarative for Qt Design Studio.
Compliant with GAMP 5 and FDA 21 CFR Part 11.
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: executorRoot
    Layout.fillWidth: true
    Layout.fillHeight: true
    color: "#06182c"
    border.color: "#184d7e"
    border.width: 1.2
    radius: 6
    clip: true

    property int currentStepIndex: 0
    property int stepTimeRemaining: 180
    property bool isExecuting: false
    property string activeRecipeName: "UNIMIX_BATCH_01"
    property string activeProductName: "Carbopol 980 Pharma Gel"
    property string activeBatchId: "B1"

    property real currentTemp: 34.4
    property real targetTemp: 70.0
    property real currentVac: -450.0
    property real targetVac: -450.0
    property real currentAgitatorRpm: 35.0
    property real targetAgitatorRpm: 35.0
    property real currentHomoRpm: 0.0
    property real targetHomoRpm: 2800.0

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        // =====================================================================
        // 1. ACTIVE PHASE HERO BANNER & REAL-TIME COUNTDOWN
        // =====================================================================
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 88
            radius: 6
            color: "#0d2b4a"
            border.color: executorRoot.isExecuting ? "#00d2ff" : "#1e40af"
            border.width: 1.5

            RowLayout {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 16

                // Step Number Circle Badge
                Rectangle {
                    width: 56
                    height: 56
                    radius: 28
                    color: executorRoot.isExecuting ? "#0284c7" : "#1e293b"
                    border.color: executorRoot.isExecuting ? "#38bdf8" : "#64748b"
                    border.width: 2

                    Text {
                        anchors.centerIn: parent
                        text: (executorRoot.currentStepIndex + 1) + ""
                        color: "#ffffff"
                        font.bold: true
                        font.pixelSize: 22
                    }
                }

                // Phase Identity & ISA-88 Context
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 3

                    RowLayout {
                        spacing: 8
                        Rectangle {
                            width: 100
                            height: 20
                            radius: 10
                            color: executorRoot.isExecuting ? "#064e3b" : "#334155"
                            Text {
                                anchors.centerIn: parent
                                text: executorRoot.isExecuting ? "PHASE RUNNING" : "PHASE STANDBY"
                                color: executorRoot.isExecuting ? "#6ee7b7" : "#cbd5e1"
                                font.bold: true
                                font.pixelSize: 10
                            }
                        }

                        Text {
                            text: "ISA-88 BATCH SEQUENCE – PHASE " + (executorRoot.currentStepIndex + 1) + " OF 5"
                            color: "#38bdf8"
                            font.bold: true
                            font.pixelSize: 11
                        }
                    }

                    Text {
                        text: executorRoot.currentStepIndex === 0 ? "1. Raw Material Charging & Pre-Inspection" :
                              (executorRoot.currentStepIndex === 1 ? "2. Thermal Ramp & Homogeneous Agitation" :
                              (executorRoot.currentStepIndex === 2 ? "3. Deep Vacuum Deaeration & Degassing" :
                              (executorRoot.currentStepIndex === 3 ? "4. High-Shear Bottom Homogenization" : "5. Controlled Cooling & Discharge Transfer")))
                        color: "#ffffff"
                        font.bold: true
                        font.pixelSize: 15
                    }

                    Text {
                        text: "Recipe: " + executorRoot.activeRecipeName + " | Product: " + executorRoot.activeProductName + " | Batch: " + executorRoot.activeBatchId
                        color: "#94a3b8"
                        font.pixelSize: 11
                    }
                }

                // Digital Timer & Phase Progress
                Rectangle {
                    Layout.preferredWidth: 160
                    Layout.preferredHeight: 60
                    radius: 4
                    color: "#051527"
                    border.color: "#184d7e"

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 2
                        Text {
                            text: "TIME REMAINING"
                            color: "#94a3b8"
                            font.bold: true
                            font.pixelSize: 9
                            Layout.alignment: Qt.AlignHCenter
                        }
                        Text {
                            text: (Math.floor(executorRoot.stepTimeRemaining / 60)) + ":" + 
                                  (executorRoot.stepTimeRemaining % 60 < 10 ? "0" : "") + 
                                  (executorRoot.stepTimeRemaining % 60)
                            color: executorRoot.isExecuting ? "#22c55e" : "#f59e0b"
                            font.bold: true
                            font.pixelSize: 22
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }
            }
        }

        // =====================================================================
        // 2. LIVE PROCESS PARAMETERS MATRIX (SETPOINT VS ACTUAL)
        // =====================================================================
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 110
            spacing: 10

            // CARD A: AGITATOR DRIVE
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 5
                color: "#0a243f"
                border.color: "#184d7e"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 4

                    Text { text: "MAIN AGITATOR (1M1501)"; color: "#38bdf8"; font.bold: true; font.pixelSize: 10 }
                    RowLayout {
                        Layout.fillWidth: true
                        ColumnLayout {
                            Text { text: "Actual"; color: "#94a3b8"; font.pixelSize: 10 }
                            Text { text: executorRoot.currentAgitatorRpm.toFixed(1) + " rpm"; color: "#22c55e"; font.bold: true; font.pixelSize: 16 }
                        }
                        Item { Layout.fillWidth: true }
                        ColumnLayout {
                            Text { text: "Target SP"; color: "#94a3b8"; font.pixelSize: 10; horizontalAlignment: Text.AlignRight }
                            Text { text: executorRoot.targetAgitatorRpm.toFixed(1) + " rpm"; color: "#ffffff"; font.bold: true; font.pixelSize: 16; horizontalAlignment: Text.AlignRight }
                        }
                    }
                    Rectangle { Layout.fillWidth: true; height: 3; radius: 1.5; color: "#164e85"; Rectangle { width: parent.width * 0.7; height: parent.height; radius: 1.5; color: "#22c55e" } }
                }
            }

            // CARD B: HOMOGENIZER
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 5
                color: "#0a243f"
                border.color: "#184d7e"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 4

                    Text { text: "HOMOGENIZER (1M2003)"; color: "#f59e0b"; font.bold: true; font.pixelSize: 10 }
                    RowLayout {
                        Layout.fillWidth: true
                        ColumnLayout {
                            Text { text: "Actual"; color: "#94a3b8"; font.pixelSize: 10 }
                            Text { text: executorRoot.currentHomoRpm.toFixed(0) + " rpm"; color: "#22c55e"; font.bold: true; font.pixelSize: 16 }
                        }
                        Item { Layout.fillWidth: true }
                        ColumnLayout {
                            Text { text: "Target SP"; color: "#94a3b8"; font.pixelSize: 10; horizontalAlignment: Text.AlignRight }
                            Text { text: executorRoot.targetHomoRpm.toFixed(0) + " rpm"; color: "#ffffff"; font.bold: true; font.pixelSize: 16; horizontalAlignment: Text.AlignRight }
                        }
                    }
                    Rectangle { Layout.fillWidth: true; height: 3; radius: 1.5; color: "#164e85"; Rectangle { width: parent.width * (executorRoot.currentHomoRpm / 3500); height: parent.height; radius: 1.5; color: "#f59e0b" } }
                }
            }

            // CARD C: VESSEL TEMPERATURE
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 5
                color: "#0a243f"
                border.color: "#184d7e"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 4

                    Text { text: "VESSEL TEMP (1TI1301)"; color: "#f97316"; font.bold: true; font.pixelSize: 10 }
                    RowLayout {
                        Layout.fillWidth: true
                        ColumnLayout {
                            Text { text: "Actual"; color: "#94a3b8"; font.pixelSize: 10 }
                            Text { text: executorRoot.currentTemp.toFixed(1) + " °C"; color: "#f97316"; font.bold: true; font.pixelSize: 16 }
                        }
                        Item { Layout.fillWidth: true }
                        ColumnLayout {
                            Text { text: "Target SP"; color: "#94a3b8"; font.pixelSize: 10; horizontalAlignment: Text.AlignRight }
                            Text { text: executorRoot.targetTemp.toFixed(1) + " °C"; color: "#ffffff"; font.bold: true; font.pixelSize: 16; horizontalAlignment: Text.AlignRight }
                        }
                    }
                    Rectangle { Layout.fillWidth: true; height: 3; radius: 1.5; color: "#164e85"; Rectangle { width: parent.width * (executorRoot.currentTemp / 100); height: parent.height; radius: 1.5; color: "#f97316" } }
                }
            }

            // CARD D: CHAMBER VACUUM
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 5
                color: "#0a243f"
                border.color: "#184d7e"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 4

                    Text { text: "CHAMBER VACUUM (1P1001)"; color: "#c084fc"; font.bold: true; font.pixelSize: 10 }
                    RowLayout {
                        Layout.fillWidth: true
                        ColumnLayout {
                            Text { text: "Actual"; color: "#94a3b8"; font.pixelSize: 10 }
                            Text { text: executorRoot.currentVac.toFixed(1) + " mbar"; color: "#c084fc"; font.bold: true; font.pixelSize: 16 }
                        }
                        Item { Layout.fillWidth: true }
                        ColumnLayout {
                            Text { text: "Target SP"; color: "#94a3b8"; font.pixelSize: 10; horizontalAlignment: Text.AlignRight }
                            Text { text: executorRoot.targetVac.toFixed(1) + " mbar"; color: "#ffffff"; font.bold: true; font.pixelSize: 16; horizontalAlignment: Text.AlignRight }
                        }
                    }
                    Rectangle { Layout.fillWidth: true; height: 3; radius: 1.5; color: "#164e85"; Rectangle { width: parent.width * (Math.abs(executorRoot.currentVac) / 1000); height: parent.height; radius: 1.5; color: "#c084fc" } }
                }
            }
        }

        // =====================================================================
        // 3. FIVE-STAGE ISA-88 BATCH PROCESS STEPPER TABLE
        // =====================================================================
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 5
            color: "#071c33"
            border.color: "#184d7e"
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 6

                Text {
                    text: "ISA-88 BATCH CONTROL SEQUENCE MATRIX"
                    color: "#94a3b8"
                    font.bold: true
                    font.pixelSize: 11
                }

                // Five Step Visual Rows
                Repeater {
                    model: [
                        { step: 1, name: "Raw Material Charging", desc: "Manual liquid base & active powder funnel intake.", temp: "25.0 °C", vac: "-200 mbar", agit: "15 rpm", homo: "0 rpm", dur: "05:00", reqSign: true },
                        { step: 2, name: "Pre-Heat & Continuous Agitation", desc: "Thermal jacket heating with counter-rotating wall scrapers.", temp: "70.0 °C", vac: "-300 mbar", agit: "35 rpm", homo: "0 rpm", dur: "10:00", reqSign: false },
                        { step: 3, name: "Vacuum Deaeration Degassing", desc: "High vacuum deaeration loop to eliminate micro-bubbles.", temp: "70.0 °C", vac: "-450 mbar", agit: "25 rpm", homo: "0 rpm", dur: "07:30", reqSign: false },
                        { step: 4, name: "High-Shear Emulsification", desc: "Rotor-stator micro-dispersion high-shear homogenization.", temp: "68.0 °C", vac: "-450 mbar", agit: "35 rpm", homo: "2800 rpm", dur: "10:00", reqSign: false },
                        { step: 5, name: "Controlled Cooling & Product Transfer", desc: "Chilled water jacket cooling and bottom valve discharge.", temp: "35.0 °C", vac: "0 mbar", agit: "15 rpm", homo: "0 rpm", dur: "07:30", reqSign: true }
                    ]

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 46
                        radius: 4
                        color: index === executorRoot.currentStepIndex ? "#0e3a66" :
                               (index < executorRoot.currentStepIndex ? "#06231a" : "#081d33")
                        border.color: index === executorRoot.currentStepIndex ? "#00d2ff" :
                                      (index < executorRoot.currentStepIndex ? "#22c55e" : "#184d7e")
                        border.width: index === executorRoot.currentStepIndex ? 1.5 : 1

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12
                            spacing: 12

                            // Status Indicator
                            Rectangle {
                                width: 26
                                height: 26
                                radius: 13
                                color: index < executorRoot.currentStepIndex ? "#16a34a" :
                                       (index === executorRoot.currentStepIndex ? (executorRoot.isExecuting ? "#0284c7" : "#f59e0b") : "#1e293b")
                                Text {
                                    anchors.centerIn: parent
                                    text: index < executorRoot.currentStepIndex ? "✓" : (index + 1) + ""
                                    color: "#ffffff"
                                    font.bold: true
                                    font.pixelSize: 12
                                }
                            }

                            // Step Name & Description
                            ColumnLayout {
                                Layout.preferredWidth: 260
                                spacing: 1
                                Text {
                                    text: modelData.name
                                    color: index <= executorRoot.currentStepIndex ? "#ffffff" : "#64748b"
                                    font.bold: true
                                    font.pixelSize: 12
                                }
                                Text {
                                    text: modelData.desc
                                    color: index <= executorRoot.currentStepIndex ? "#94a3b8" : "#475569"
                                    font.pixelSize: 10
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                            }

                            // Setpoint Targets
                            Text { text: "Temp: " + modelData.temp; color: "#cbd5e1"; font.pixelSize: 11; Layout.preferredWidth: 100 }
                            Text { text: "Vac: " + modelData.vac; color: "#cbd5e1"; font.pixelSize: 11; Layout.preferredWidth: 110 }
                            Text { text: "Agit: " + modelData.agit; color: "#cbd5e1"; font.pixelSize: 11; Layout.preferredWidth: 90 }
                            Text { text: "Homo: " + modelData.homo; color: "#cbd5e1"; font.pixelSize: 11; Layout.preferredWidth: 110 }
                            Text { text: "Dur: " + modelData.dur; color: "#f5d033"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 80 }

                            Item { Layout.fillWidth: true }

                            // Phase Status Capsule
                            Rectangle {
                                Layout.preferredWidth: 100
                                Layout.preferredHeight: 24
                                radius: 4
                                color: index < executorRoot.currentStepIndex ? "#064e3b" :
                                       (index === executorRoot.currentStepIndex ? (executorRoot.isExecuting ? "#0369a1" : "#78350f") : "#1e293b")
                                border.color: index < executorRoot.currentStepIndex ? "#22c55e" :
                                              (index === executorRoot.currentStepIndex ? (executorRoot.isExecuting ? "#38bdf8" : "#f59e0b") : "#475569")
                                Text {
                                    anchors.centerIn: parent
                                    text: index < executorRoot.currentStepIndex ? "COMPLETED" :
                                           (index === executorRoot.currentStepIndex ? (executorRoot.isExecuting ? "RUNNING" : "HOLD / SIGN") : "PENDING")
                                    color: index < executorRoot.currentStepIndex ? "#86efac" :
                                           (index === executorRoot.currentStepIndex ? (executorRoot.isExecuting ? "#bae6fd" : "#fde68a") : "#94a3b8")
                                    font.bold: true
                                    font.pixelSize: 9
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
