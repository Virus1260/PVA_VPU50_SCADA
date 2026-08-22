/*
This is a UI file (.ui.qml) for Screen 5: Recipes & ISA-88 Batch Execution.
Strictly declarative for Qt Design Studio.
Assembled from modular sub-widgets in components/widgets/Screen_5_Recipes/
Compliant with GAMP 5 and FDA 21 CFR Part 11.
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components/widgets/Screen_5_Recipes"

Rectangle {
    id: recipesViewRoot
    width: 1184
    height: 626
    color: "#08213b"

    property string activeTab: "execution" // "execution" or "formulation"
    property bool isExecuting: false
    property int currentStepIndex: 0
    property int stepTimeRemaining: 180
    property string activeRecipeName: "UNIMIX_BATCH_01"
    property string activeProductName: "Carbopol 980 Pharma Gel"

    property alias execTabBtn: executionTabButton
    property alias formTabBtn: formulationTabButton
    property alias toggleAutoBtn: startPauseButton

    property alias executorEngine: executionView
    property alias creatorStudio: formulationView

    property alias manualOverlay: manualInterventionOverlay
    property alias manualConfirmBtn: confirmActionBtn

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        // =====================================================================
        // 1. TOP HEADER & BATCH CONTROL TOOLBAR
        // =====================================================================
        Rectangle {
            id: topToolbar
            Layout.fillWidth: true
            Layout.preferredHeight: 52
            radius: 5
            color: "#0d2b4a"
            border.color: "#184d7e"
            border.width: 1.2

            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 12

                // Tab 1: Execution Engine
                Rectangle {
                    id: executionTabButton
                    Layout.preferredWidth: 150
                    Layout.preferredHeight: 36
                    radius: 4
                    color: recipesViewRoot.activeTab === "execution" ? "#0284c7" : "#0a223a"
                    border.color: recipesViewRoot.activeTab === "execution" ? "#38bdf8" : "#184d7e"

                    Row {
                        anchors.centerIn: parent
                        spacing: 6
                        Image {
                            source: "../assets/icons/nav/status_stack.svg"
                            width: 14
                            height: 14
                            sourceSize: Qt.size(14, 14)
                            fillMode: Image.PreserveAspectFit
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text { text: "Batch Execution"; color: "#ffffff"; font.bold: true; font.pixelSize: 11; anchors.verticalCenter: parent.verticalCenter }
                    }
                }

                // Tab 2: Formulation Studio / Creator
                Rectangle {
                    id: formulationTabButton
                    Layout.preferredWidth: 150
                    Layout.preferredHeight: 36
                    radius: 4
                    color: recipesViewRoot.activeTab === "formulation" ? "#0284c7" : "#0a223a"
                    border.color: recipesViewRoot.activeTab === "formulation" ? "#38bdf8" : "#184d7e"

                    Row {
                        anchors.centerIn: parent
                        spacing: 6
                        Image {
                            source: "../assets/icons/nav/recipes_checklist.svg"
                            width: 14
                            height: 14
                            sourceSize: Qt.size(14, 14)
                            fillMode: Image.PreserveAspectFit
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text { text: "Formulation Studio"; color: "#ffffff"; font.bold: true; font.pixelSize: 11; anchors.verticalCenter: parent.verticalCenter }
                    }
                }

                Item { Layout.fillWidth: true }

                // Start / Pause Batch Execution Button
                Rectangle {
                    id: startPauseButton
                    Layout.preferredWidth: 160
                    Layout.preferredHeight: 36
                    radius: 4
                    color: recipesViewRoot.isExecuting ? "#7f1d1d" : "#065f46"
                    border.color: recipesViewRoot.isExecuting ? "#ef4444" : "#10b981"
                    border.width: 1.2

                    Row {
                        anchors.centerIn: parent
                        spacing: 8
                        Rectangle {
                            width: 10
                            height: 10
                            radius: 5
                            color: recipesViewRoot.isExecuting ? "#ef4444" : "#22c55e"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            text: recipesViewRoot.isExecuting ? "PAUSE SEQUENCE" : "START AUTO BATCH"
                            color: "#ffffff"
                            font.bold: true
                            font.pixelSize: 11
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
            }
        }

        // =====================================================================
        // 2. MAIN WORKSPACE STACK: BATCH EXECUTOR VS FORMULATION STUDIO
        // =====================================================================
        StackLayout {
            id: workspaceStack
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: recipesViewRoot.activeTab === "execution" ? 0 : 1

            // TAB 1: ISA-88 BATCH RECIPE EXECUTION ENGINE
            RecipeExecutorView {
                id: executionView
                currentStepIndex: recipesViewRoot.currentStepIndex
                stepTimeRemaining: recipesViewRoot.stepTimeRemaining
                isExecuting: recipesViewRoot.isExecuting
                activeRecipeName: recipesViewRoot.activeRecipeName
                activeProductName: recipesViewRoot.activeProductName
            }

            // TAB 2: 21 CFR PART 11 FORMULATION STUDIO & CREATOR
            RecipeCreatorView {
                id: formulationView
                selectedRecipeName: recipesViewRoot.activeRecipeName
                selectedProduct: recipesViewRoot.activeProductName
            }
        }
    }

    // =========================================================================
    // 3. 21 CFR PART 11 MANDATORY MANUAL STEP SIGN-OFF OVERLAY DIALOG
    // =========================================================================
    Rectangle {
        id: manualInterventionOverlay
        anchors.fill: parent
        visible: false
        color: "#d0000000"
        z: 100

        Rectangle {
            anchors.centerIn: parent
            width: 520
            height: 310
            radius: 8
            color: "#081d33"
            border.color: "#f59e0b"
            border.width: 2.0

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 18
                spacing: 10

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    Image {
                        source: "../assets/icons/common/icon_warning.svg"
                        width: 20
                        height: 20
                        sourceSize: Qt.size(20, 20)
                        fillMode: Image.PreserveAspectFit
                    }
                    Text {
                        text: "21 CFR PART 11 PHASE HOLD POINT SIGN-OFF"
                        color: "#f59e0b"
                        font.bold: true
                        font.pixelSize: 13
                    }
                }

                Rectangle { Layout.fillWidth: true; height: 1; color: "#1e3a8a" }

                Text {
                    text: "Manual Phase Verification Required:"
                    color: "#ffffff"
                    font.bold: true
                    font.pixelSize: 13
                }

                Text {
                    text: "Please verify physical vessel charge ports, ensure suction valve interlocks are verified, and confirm raw material addition before proceeding to the next automated phase."
                    color: "#cbd5e1"
                    font.pixelSize: 11
                    wrapMode: Text.Wrap
                    Layout.fillWidth: true
                }

                Rectangle { Layout.fillWidth: true; Layout.fillHeight: true; color: "transparent" }

                Rectangle {
                    id: confirmActionBtn
                    Layout.fillWidth: true
                    Layout.preferredHeight: 42
                    radius: 4
                    color: "#059669"
                    border.color: "#34d399"
                    border.width: 1.2

                    Text {
                        anchors.centerIn: parent
                        text: "Authorize & Advance Phase (Sign Electronic Record)"
                        color: "#ffffff"
                        font.bold: true
                        font.pixelSize: 12
                    }
                }
            }
        }
    }
}
