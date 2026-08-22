/*
This is a UI file (.ui.qml) for Screen 5: Recipes & Automatic Execution.
Strictly declarative for Qt Design Studio.
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: recipesViewRoot
    width: 1184
    height: 626
    color: "#08213b"

    property string activeTab: "execution" // "execution" or "formulation"
    property bool isExecuting: false
    property int currentStepIndex: 0
    property int stepTimeRemaining: 180

    property alias execTabBtn: executionTabButton
    property alias formTabBtn: formulationTabButton
    property alias toggleAutoBtn: startPauseButton
    property alias manualOverlay: confirmDialogOverlay
    property alias manualConfirmBtn: confirmActionBtn

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        // =====================================================================
        // 1. TOP HEADER & EXECUTION CONTROL TOOLBAR
        // =====================================================================
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            radius: 5
            color: "#0d2b4a"
            border.color: "#184d7e"
            border.width: 1.2

            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 12

                Rectangle {
                    width: 36
                    height: 36
                    radius: 4
                    color: "#16a34a"
                    Text { text: "⚗️"; font.pixelSize: 20; anchors.centerIn: parent }
                }

                ColumnLayout {
                    spacing: 2
                    Text { text: "Body Lotion Formulation (50 KG Batch)"; color: "#ffffff"; font.bold: true; font.pixelSize: 15 }
                    Text { text: "Code: REC-VPU50-LOTION-01 | Version: v2.1 (Approved & Released)"; color: "#4ade80"; font.bold: true; font.pixelSize: 11 }
                }

                Item { Layout.fillWidth: true }

                // Start / Pause Auto Execution Button
                Rectangle {
                    id: startPauseButton
                    Layout.preferredWidth: 140
                    Layout.preferredHeight: 36
                    radius: 4
                    color: recipesViewRoot.isExecuting ? "#dc2626" : "#16a34a"

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 6
                        Text { text: recipesViewRoot.isExecuting ? "⏸" : "▶"; font.pixelSize: 14; color: "#ffffff" }
                        Text {
                            text: recipesViewRoot.isExecuting ? "PAUSE AUTO" : "START RECIPE"
                            color: "#ffffff"
                            font.bold: true
                            font.pixelSize: 12
                        }
                    }
                }

                // Tab Switcher (Execution vs Formulation)
                Rectangle {
                    Layout.preferredWidth: 320
                    Layout.preferredHeight: 36
                    radius: 4
                    color: "#071c33"
                    border.color: "#0284c7"
                    border.width: 1.0

                    RowLayout {
                        anchors.fill: parent
                        spacing: 0

                        Rectangle {
                            id: executionTabButton
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 3
                            color: recipesViewRoot.activeTab === "execution" ? "#0284c7" : "transparent"
                            Text { anchors.centerIn: parent; text: "⚡ Step Sequence"; color: "#ffffff"; font.bold: true; font.pixelSize: 11 }
                        }

                        Rectangle {
                            id: formulationTabButton
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 3
                            color: recipesViewRoot.activeTab === "formulation" ? "#0284c7" : "transparent"
                            Text { anchors.centerIn: parent; text: "🧪 Formulation Matrix"; color: "#ffffff"; font.bold: true; font.pixelSize: 11 }
                        }
                    }
                }
            }
        }

        // =====================================================================
        // 2. MAIN WORKSPACE: STEP EXECUTION OR FORMULATION PHASES
        // =====================================================================
        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: recipesViewRoot.activeTab === "execution" ? 0 : 1

            // VIEW 0: STEP SEQUENCE EXECUTION
            Rectangle {
                color: "#06182c"
                border.color: "#184d7e"
                border.width: 1.2
                radius: 5

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 8

                    // Active Step Hero Banner
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 80
                        radius: 5
                        color: "#0d2b4a"
                        border.color: "#0284c7"
                        border.width: 1.4

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 16

                            Rectangle {
                                width: 52
                                height: 52
                                radius: 26
                                color: "#0284c7"
                                Text {
                                    anchors.centerIn: parent
                                    text: String(recipesViewRoot.currentStepIndex + 1)
                                    color: "#ffffff"
                                    font.bold: true
                                    font.pixelSize: 22
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 3
                                Text {
                                    text: "STEP " + (recipesViewRoot.currentStepIndex + 1) + " IN PROGRESS"
                                    color: "#38bdf8"
                                    font.bold: true
                                    font.pixelSize: 12
                                }
                                Text {
                                    text: "High-Shear Emulsification & Deaeration Loop"
                                    color: "#ffffff"
                                    font.bold: true
                                    font.pixelSize: 14
                                }
                                Text {
                                    text: "Operations: Agitator: 50 RPM | Homogenizer: 3600 RPM | Vacuum: -450 mbar"
                                    color: "#94a3b8"
                                    font.pixelSize: 11
                                }
                            }

                            ColumnLayout {
                                spacing: 2
                                Text { text: "Time Remaining"; color: "#94a3b8"; font.pixelSize: 10; Layout.alignment: Qt.AlignRight }
                                Text {
                                    text: String(Math.floor(recipesViewRoot.stepTimeRemaining / 60)).padStart(2, '0') + ":" + String(recipesViewRoot.stepTimeRemaining % 60).padStart(2, '0')
                                    color: "#4ade80"
                                    font.bold: true
                                    font.pixelSize: 24
                                    Layout.alignment: Qt.AlignRight
                                }
                            }
                        }
                    }

                    // Step Sequence Column Header
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 32
                        color: "#0d2b4a"
                        radius: 3

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12
                            spacing: 12

                            Text { text: "STEP"; color: "#94a3b8"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 40; horizontalAlignment: Text.AlignHCenter }
                            Text { text: "RECIPE PHASE NAME"; color: "#94a3b8"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 260 }
                            Text { text: "TARGET OPERATIONS & PARAMETERS"; color: "#94a3b8"; font.bold: true; font.pixelSize: 11; Layout.fillWidth: true }
                            Text { text: "MODE / DURATION"; color: "#94a3b8"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 140; horizontalAlignment: Text.AlignRight }
                        }
                    }

                    // Steps Sequence List
                    ListView {
                        id: recipeStepsListView
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        spacing: 6

                        model: ListModel {
                            ListElement { name: "Step 1: Fill & Heat Phase A"; desc: "Charge DI water & heat to 75°C under low agitation"; ops: "Agitator: 30 RPM | Heater: 75.0°C | Valve V101: OPEN"; isManual: false; duration: "180s AUTO" }
                            ListElement { name: "Step 2: Phase A Premix Loop"; desc: "Dissolve EDTA & Glycerine at 75°C"; ops: "Agitator: 45 RPM | Heater: 75.0°C | Timer: 2 min"; isManual: false; duration: "120s AUTO" }
                            ListElement { name: "Step 3: Add Phase B (Oils & Waxes)"; desc: "Charge pre-melted oil phase manually through charging port"; ops: "Manual Ingredient Addition Checkpoint"; isManual: true; duration: "🖐 MANUAL" }
                            ListElement { name: "Step 4: High-Shear Emulsification"; desc: "Homogenize & deaerate emulsion under vacuum"; ops: "Agitator: 50 RPM | Homogenizer: 3600 RPM | Vacuum: -450 mbar"; isManual: false; duration: "300s AUTO" }
                            ListElement { name: "Step 5: Cool Down to 40°C"; desc: "Engage jacket cooling circulation circuit"; ops: "Agitator: 35 RPM | Cooler: 40.0°C | Vacuum: -450 mbar"; isManual: false; duration: "240s AUTO" }
                            ListElement { name: "Step 6: Add Phase C & D (Finish)"; desc: "Add actives and discharge finished batch"; ops: "Manual Ingredient Addition & Quality Release"; isManual: true; duration: "🖐 MANUAL" }
                        }

                        delegate: Rectangle {
                            width: recipeStepsListView ? recipeStepsListView.width : 0
                            height: 52
                            radius: 4
                            color: index === recipesViewRoot.currentStepIndex ? "#0f3a63" : (index < recipesViewRoot.currentStepIndex ? "#052e16" : "#081d33")
                            border.color: index === recipesViewRoot.currentStepIndex ? "#38bdf8" : (index < recipesViewRoot.currentStepIndex ? "#22c55e" : "#1e3a8a")
                            border.width: index === recipesViewRoot.currentStepIndex ? 1.8 : 1.0

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 12
                                spacing: 12

                                Rectangle {
                                    Layout.preferredWidth: 28
                                    Layout.preferredHeight: 28
                                    Layout.alignment: Qt.AlignVCenter
                                    radius: 14
                                    color: index < recipesViewRoot.currentStepIndex ? "#22c55e" : (index === recipesViewRoot.currentStepIndex ? "#38bdf8" : "#334155")
                                    Text {
                                        anchors.centerIn: parent
                                        text: index < recipesViewRoot.currentStepIndex ? "✓" : String(index + 1)
                                        color: "#ffffff"
                                        font.bold: true
                                        font.pixelSize: 12
                                    }
                                }

                                ColumnLayout {
                                    Layout.preferredWidth: 260
                                    spacing: 2
                                    Text { text: model.name; color: "#ffffff"; font.bold: true; font.pixelSize: 12 }
                                    Text { text: model.desc; color: "#94a3b8"; font.pixelSize: 11 }
                                }

                                Text {
                                    text: model.ops
                                    color: "#38bdf8"
                                    font.pixelSize: 11
                                    Layout.fillWidth: true
                                }

                                Rectangle {
                                    Layout.preferredWidth: 120
                                    Layout.preferredHeight: 28
                                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                    radius: 4
                                    color: model.isManual ? "#78350f" : "#0c4a6e"
                                    border.color: model.isManual ? "#f59e0b" : "#0284c7"

                                    Text {
                                        anchors.centerIn: parent
                                        text: model.duration
                                        color: model.isManual ? "#fde68a" : "#bae6fd"
                                        font.bold: true
                                        font.pixelSize: 11
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // VIEW 1: INGREDIENTS FORMULATION MATRIX
            Rectangle {
                color: "#06182c"
                border.color: "#184d7e"
                border.width: 1.2
                radius: 5

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 10

                    Text { text: "BATCH FORMULATION & PHASE ADDITION SCHEDULE"; color: "#ffffff"; font.bold: true; font.pixelSize: 14 }

                    ListView {
                        id: formulationListView
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        spacing: 8

                        model: ListModel {
                            ListElement { phase: "Phase A (Water Phase)"; items: "Deionized Water (32.5 kg), Disodium EDTA (0.1 kg), Glycerine (2.5 kg)"; temp: "75.0 °C" }
                            ListElement { phase: "Phase B (Oil Phase)"; items: "Light Liquid Paraffin (8.0 kg), Cetostearyl Alcohol (3.5 kg), Glyceryl Stearate (2.0 kg)"; temp: "78.0 °C" }
                            ListElement { phase: "Phase C (Active Phase)"; items: "SLES 70% (1.5 kg), Vitamin E Acetate (0.2 kg)"; temp: "45.0 °C" }
                            ListElement { phase: "Phase D (Neutralizer)"; items: "Triethanolamine TEA 99% (0.4 kg), Preservative (0.2 kg)"; temp: "38.0 °C" }
                        }

                        delegate: Rectangle {
                            width: formulationListView ? formulationListView.width : 0
                            height: 60
                            radius: 4
                            color: "#092440"
                            border.color: "#1d4ed8"
                            border.width: 1.2

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 10
                                spacing: 12

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 2
                                    Text { text: model.phase; color: "#38bdf8"; font.bold: true; font.pixelSize: 12 }
                                    Text { text: model.items; color: "#ffffff"; font.pixelSize: 11 }
                                }

                                Rectangle {
                                    Layout.preferredWidth: 90
                                    Layout.preferredHeight: 30
                                    radius: 3
                                    color: "#071c33"
                                    border.color: "#f97316"
                                    Text { anchors.centerIn: parent; text: "Temp: " + model.temp; color: "#f97316"; font.bold: true; font.pixelSize: 11 }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // =========================================================================
    // 3. 21 CFR PART 11 MANUAL CONFIRMATION MODAL OVERLAY
    // =========================================================================
    Rectangle {
        id: confirmDialogOverlay
        anchors.fill: parent
        visible: false
        color: "#d0000000"
        z: 100

        Rectangle {
            anchors.centerIn: parent
            width: 480
            height: 240
            radius: 8
            color: "#081d33"
            border.color: "#f59e0b"
            border.width: 2.0

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 10

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    Text { text: "🖐"; font.pixelSize: 22 }
                    Text { text: "MANUAL INGREDIENT ADDITION CHECKPOINT"; color: "#f59e0b"; font.bold: true; font.pixelSize: 14; Layout.fillWidth: true }
                }

                Rectangle { Layout.fillWidth: true; height: 1; color: "#1e3a8a" }

                Text {
                    text: "Action Required: Charge Phase B (Oils & Waxes) into reactor."
                    color: "#ffffff"
                    font.bold: true
                    font.pixelSize: 12
                }

                Text {
                    text: "Verify ingredient weights, charge through top port, close charging lid, then confirm."
                    color: "#cbd5e1"
                    font.pixelSize: 11
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }

                Item { Layout.fillHeight: true }

                Rectangle {
                    id: confirmActionBtn
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    radius: 4
                    color: "#16a34a"

                    Text {
                        anchors.centerIn: parent
                        text: "✓ Confirm Phase Addition & Resume Recipe"
                        color: "#ffffff"
                        font.bold: true
                        font.pixelSize: 12
                    }
                }
            }
        }
    }
}
