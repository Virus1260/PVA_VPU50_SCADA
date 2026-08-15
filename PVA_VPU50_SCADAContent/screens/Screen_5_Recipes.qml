import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: recipesRoot
    color: "#081d33"

    // Active View Mode: "matrix" or "formulation"
    property string activeTab: "matrix"
    property int activeRecipeIndex: 0
    property int currentExecutingStep: 3 // 0-indexed, Step 4 active
    property bool isExecuting: false
    property var expandedSteps: ({})

    // --- Master Recipe Database (Single Source of Truth) ---
    property var recipeDatabase: [
        {
            name: "Body Lotion Formulation",
            totalSteps: 14,
            createdAt: "2026-01-15T08:00:00Z",
            ingredients: [
                { sr: 1, name: "Water (DI 9.2 KG)", phase: "A", qty: "9.2 kg" },
                { sr: 2, name: "Di Sodium EDTA", phase: "A", qty: "0.05 kg" },
                { sr: 3, name: "Glycerine", phase: "A", qty: "2.0 kg" },
                { sr: 4, name: "Shell Pol 940", phase: "A", qty: "0.15 kg" },
                { sr: 5, name: "Phenoxy Ethanol", phase: "A", qty: "0.5 kg" },
                { sr: 6, name: "Light Liquid Paraffin", phase: "B", qty: "3.0 kg" },
                { sr: 7, name: "Ceto Stearyl Alcohol", phase: "B", qty: "2.5 kg" },
                { sr: 8, name: "Microcrystalline Wax", phase: "B", qty: "1.0 kg" },
                { sr: 9, name: "Glyceryl Stearate", phase: "B", qty: "1.5 kg" },
                { sr: 10, name: "Stearic Acid", phase: "B", qty: "1.0 kg" },
                { sr: 11, name: "SLES 70%", phase: "C", qty: "0.8 kg" },
                { sr: 12, name: "Triethanolamine (TEA)", phase: "D", qty: "0.3 kg" },
                { sr: 13, name: "DMDM Hydantoin", phase: "E", qty: "0.2 kg" }
            ],
            steps: [
                { id: 1, name: "Fill Phase A", desc: "Fill vessel with water & Phase A", opsCount: 1, isManual: false, status: "DONE", confirmMsg: "", ops: [
                    { dev: "Fill Valve", act: "ON", delay: 0, dur: 0, val: "50.0%", cond: "Level > 50%" }
                ]},
                { id: 2, name: "Premix Phase A", desc: "Stir Phase A at low speed 3 min", opsCount: 1, isManual: false, status: "DONE", confirmMsg: "", ops: [
                    { dev: "Agitator", act: "ON", delay: 0, dur: 180, val: "40 RPM", cond: "Timer 3 min" }
                ]},
                { id: 3, name: "Heat & Stir", desc: "Heat to 80°C while high stirring", opsCount: 2, isManual: false, status: "DONE", confirmMsg: "", ops: [
                    { dev: "Agitator", act: "ON", delay: 0, dur: 0, val: "60 RPM", cond: "Temp > 80°C" },
                    { dev: "Heater", act: "ON", delay: 0, dur: 0, val: "80.0°C", cond: "Temp > 80°C" }
                ]},
                { id: 4, name: "Add Phase B", desc: "Add Phase B (oil phase) manually", opsCount: 0, isManual: true, status: "ACTIVE", confirmMsg: "Have you added all Phase B oil ingredients (Items 6–10)?", ops: []},
                { id: 5, name: "Homogenize", desc: "High-shear emulsification loop", opsCount: 3, isManual: false, status: "WAITING", confirmMsg: "", ops: [
                    { dev: "Agitator", act: "ON", delay: 0, dur: 600, val: "60 RPM", cond: "Timer 10 min" },
                    { dev: "Homogenizer", act: "ON", delay: 120, dur: 480, val: "3600 RPM", cond: "Timer 8 min" },
                    { dev: "Heater", act: "ON", delay: 180, dur: 120, val: "83.0°C", cond: "Timer 2 min" }
                ]},
                { id: 6, name: "Vacuum Mix", desc: "Deaeration under vacuum", opsCount: 2, isManual: false, status: "WAITING", confirmMsg: "", ops: [
                    { dev: "Agitator", act: "ON", delay: 0, dur: 300, val: "50 RPM", cond: "Timer 5 min" },
                    { dev: "Vacuum", act: "ON", delay: 60, dur: 240, val: "-450 mbar", cond: "Timer 4 min" }
                ]},
                { id: 7, name: "Cool to 55°C", desc: "Cool while stirring to 55°C", opsCount: 2, isManual: false, status: "WAITING", confirmMsg: "", ops: [
                    { dev: "Agitator", act: "ON", delay: 0, dur: 0, val: "40 RPM", cond: "Temp < 55°C" },
                    { dev: "Cooler", act: "ON", delay: 0, dur: 0, val: "55.0°C", cond: "Temp < 55°C" }
                ]},
                { id: 8, name: "Add Phase C", desc: "At 55°C add SLES 70%", opsCount: 0, isManual: true, status: "WAITING", confirmMsg: "Have you added Phase C (SLES 70%)?", ops: []},
                { id: 9, name: "Cool to 50°C", desc: "Continue cooling to 50°C", opsCount: 2, isManual: false, status: "WAITING", confirmMsg: "", ops: [
                    { dev: "Agitator", act: "ON", delay: 0, dur: 0, val: "40 RPM", cond: "Temp < 50°C" },
                    { dev: "Cooler", act: "ON", delay: 0, dur: 0, val: "50.0°C", cond: "Temp < 50°C" }
                ]},
                { id: 10, name: "Add Phase D", desc: "At 50°C add TEA neutralization", opsCount: 0, isManual: true, status: "WAITING", confirmMsg: "Have you added Phase D (Triethanolamine)?", ops: []},
                { id: 11, name: "Cool to 40°C", desc: "Cool to 40–45°C finishing", opsCount: 2, isManual: false, status: "WAITING", confirmMsg: "", ops: [
                    { dev: "Agitator", act: "ON", delay: 0, dur: 0, val: "30 RPM", cond: "Temp < 40°C" },
                    { dev: "Cooler", act: "ON", delay: 0, dur: 0, val: "40.0°C", cond: "Temp < 40°C" }
                ]},
                { id: 12, name: "Add Phase E", desc: "At 40°C add Preservative", opsCount: 0, isManual: true, status: "WAITING", confirmMsg: "Have you added Phase E (DMDM Hydantoin)?", ops: []},
                { id: 13, name: "Final Deaeration", desc: "Vacuum pull-down -850 mbar", opsCount: 2, isManual: false, status: "WAITING", confirmMsg: "", ops: [
                    { dev: "Agitator", act: "ON", delay: 0, dur: 300, val: "20 RPM", cond: "Timer 5 min" },
                    { dev: "Vacuum", act: "ON", delay: 0, dur: 300, val: "-850 mbar", cond: "Timer 5 min" }
                ]},
                { id: 14, name: "Discharge Product", desc: "Open V101 & V102 to discharge", opsCount: 1, isManual: false, status: "WAITING", confirmMsg: "", ops: [
                    { dev: "Drain Valve", act: "ON", delay: 0, dur: 0, val: "OPEN", cond: "Vessel Empty" }
                ]}
            ]
        },
        {
            name: "Industrial Shampoo Formulation",
            totalSteps: 22,
            createdAt: "2026-02-20T10:00:00Z",
            ingredients: [
                { sr: 1, name: "Deionized Water", phase: "A", qty: "45.0 kg" },
                { sr: 2, name: "EDTA Disodium", phase: "A", qty: "0.1 kg" },
                { sr: 3, name: "Citric Acid", phase: "A", qty: "0.3 kg" },
                { sr: 4, name: "SLES 28%", phase: "B", qty: "18.0 kg" },
                { sr: 5, name: "CAPB", phase: "B", qty: "4.0 kg" },
                { sr: 6, name: "Cocamide DEA", phase: "B", qty: "2.0 kg" }
            ],
            steps: [
                { id: 1, name: "Fill DI Water", desc: "Fill vessel to 55% water", opsCount: 1, isManual: false, status: "DONE", confirmMsg: "", ops: [{ dev: "Fill Valve", act: "ON", delay: 0, dur: 0, val: "55%", cond: "Level > 55%" }] },
                { id: 2, name: "Pre-Heat Water", desc: "Heat to 45°C gentle stir", opsCount: 2, isManual: false, status: "DONE", confirmMsg: "", ops: [{ dev: "Agitator", act: "ON", delay: 0, dur: 0, val: "25 RPM", cond: "Temp > 45°C" }, { dev: "Heater", act: "ON", delay: 0, dur: 0, val: "45°C", cond: "Temp > 45°C" }] },
                { id: 3, name: "Dissolve Additives", desc: "Add EDTA & Citric acid", opsCount: 1, isManual: true, status: "ACTIVE", confirmMsg: "Add EDTA Disodium & Citric Acid now.", ops: [{ dev: "Agitator", act: "ON", delay: 0, dur: 120, val: "50 RPM", cond: "Timer 2 min" }] }
            ]
        },
        {
            name: "Carbopol 980 Pharma Gel",
            totalSteps: 5,
            createdAt: "2026-03-01T09:00:00Z",
            ingredients: [
                { sr: 1, name: "DI Water", phase: "A", qty: "350 L" },
                { sr: 2, name: "Carbopol 980 Polymer", phase: "A", qty: "3.5 kg" },
                { sr: 3, name: "Triethanolamine", phase: "B", qty: "3.5 kg" }
            ],
            steps: [
                { id: 1, name: "DI Water Charge", desc: "Charge 350 L DI Water", opsCount: 1, isManual: false, status: "DONE", confirmMsg: "", ops: [{ dev: "Fill Valve", act: "ON", delay: 0, dur: 300, val: "350 L", cond: "Timer 5 min" }] },
                { id: 2, name: "Powder Vacuum Suction", desc: "Suction Carbopol 980 under vacuum", opsCount: 3, isManual: false, status: "ACTIVE", confirmMsg: "", ops: [{ dev: "Agitator", act: "ON", delay: 0, dur: 750, val: "40 RPM", cond: "Timer 12.5 min" }, { dev: "Homogenizer", act: "ON", delay: 0, dur: 750, val: "1800 RPM", cond: "Timer 12.5 min" }, { dev: "Vacuum", act: "ON", delay: 0, dur: 750, val: "-450 mbar", cond: "Timer 12.5 min" }] }
            ]
        }
    ]

    readonly property var activeRecipe: recipeDatabase[activeRecipeIndex]

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 10

        // =====================================================================
        // 1. TOP DUAL-TAB NAVIGATION & COMMAND TOOLBAR (Matching Reference UI)
        // =====================================================================
        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            // Dual Tab Switcher: [ Formulation ] | [ Recipe Matrix ]
            Rectangle {
                Layout.preferredHeight: 38
                Layout.preferredWidth: 260
                color: "#06182c"
                border.color: "#184d7e"
                border.width: 1
                radius: 6

                RowLayout {
                    anchors.fill: parent
                    spacing: 0

                    // Tab: Formulation
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: 5
                        color: recipesRoot.activeTab === "formulation" ? "#164e85" : "transparent"
                        border.color: recipesRoot.activeTab === "formulation" ? "#00d2ff" : "transparent"
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "Formulation"
                            color: recipesRoot.activeTab === "formulation" ? "#ffffff" : "#94a3b8"
                            font.bold: recipesRoot.activeTab === "formulation"
                            font.pixelSize: 13
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: recipesRoot.activeTab = "formulation"
                        }
                    }

                    // Tab: Recipe Matrix
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: 5
                        color: recipesRoot.activeTab === "matrix" ? "#164e85" : "transparent"
                        border.color: recipesRoot.activeTab === "matrix" ? "#00d2ff" : "transparent"
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "Recipe Matrix"
                            color: recipesRoot.activeTab === "matrix" ? "#ffffff" : "#94a3b8"
                            font.bold: recipesRoot.activeTab === "matrix"
                            font.pixelSize: 13
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: recipesRoot.activeTab = "matrix"
                        }
                    }
                }
            }

            // Recipe Selector Dropdown
            RowLayout {
                spacing: 8
                Text {
                    text: "Recipe:"
                    color: "#cbd5e1"
                    font.bold: true
                    font.pixelSize: 13
                }

                Rectangle {
                    Layout.preferredWidth: 260
                    Layout.preferredHeight: 36
                    color: "#091a2a"
                    border.color: "#1a4070"
                    border.width: 1
                    radius: 5

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 8

                        Text {
                            text: recipesRoot.activeRecipe.name + " (" + recipesRoot.activeRecipe.steps.length + " steps)"
                            color: "#ffffff"
                            font.bold: true
                            font.pixelSize: 12
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }
                        Text {
                            text: "▼"
                            color: "#6b8fbb"
                            font.pixelSize: 10
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            recipesRoot.activeRecipeIndex = (recipesRoot.activeRecipeIndex + 1) % recipesRoot.recipeDatabase.length;
                        }
                    }
                }
            }

            Item { Layout.fillWidth: true }

            // Action Buttons: + New, Delete, + Step, ▶ Execute
            RowLayout {
                spacing: 8

                // + New Recipe Button
                Rectangle {
                    Layout.preferredWidth: 64
                    Layout.preferredHeight: 34
                    color: "#1e40af"
                    border.color: "#3b82f6"
                    border.width: 1
                    radius: 4
                    Text { anchors.centerIn: parent; text: "+ New"; color: "#ffffff"; font.bold: true; font.pixelSize: 12 }
                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: newRecipeDialog.visible = true }
                }

                // Delete Recipe Button
                Rectangle {
                    Layout.preferredWidth: 64
                    Layout.preferredHeight: 34
                    color: "#7f1d1d"
                    border.color: "#ef4444"
                    border.width: 1
                    radius: 4
                    Text { anchors.centerIn: parent; text: "Delete"; color: "#fca5a5"; font.bold: true; font.pixelSize: 12 }
                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor }
                }

                // + Step Button
                Rectangle {
                    Layout.preferredWidth: 68
                    Layout.preferredHeight: 34
                    color: "#14532d"
                    border.color: "#22c55e"
                    border.width: 1
                    radius: 4
                    Text { anchors.centerIn: parent; text: "+ Step"; color: "#86efac"; font.bold: true; font.pixelSize: 12 }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            var cur = recipesRoot.activeRecipe;
                            var newId = cur.steps.length + 1;
                            cur.steps.push({
                                id: newId,
                                name: "Step " + newId,
                                desc: "New process step",
                                opsCount: 1,
                                isManual: false,
                                status: "WAITING",
                                confirmMsg: "",
                                ops: [{ dev: "Agitator", act: "ON", delay: 0, dur: 120, val: "40 RPM", cond: "Timer 2 min" }]
                            });
                            recipesRoot.recipeDatabaseChanged();
                        }
                    }
                }

                // ▶ Execute Button
                Rectangle {
                    Layout.preferredWidth: 100
                    Layout.preferredHeight: 34
                    color: recipesRoot.isExecuting ? "#15803d" : "#16a34a"
                    border.color: "#4ade80"
                    border.width: 1.5
                    radius: 4
                    Text {
                        anchors.centerIn: parent
                        text: recipesRoot.isExecuting ? "❚❚ Pause" : "▶ Execute"
                        color: "#ffffff"
                        font.bold: true
                        font.pixelSize: 13
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: recipesRoot.isExecuting = !recipesRoot.isExecuting
                    }
                }
            }
        }

        // =====================================================================
        // 2. VIEW CONTENT: (A) RECIPE MATRIX VIEW
        // =====================================================================
        ColumnLayout {
            visible: recipesRoot.activeTab === "matrix"
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 4

            // Matrix Table Header (#, Name, Description, Ops, ⚠️, Status, Actions)
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

                    Text { text: "#"; color: "#6b8fbb"; font.bold: true; font.pixelSize: 11; horizontalAlignment: Text.AlignHCenter; Layout.preferredWidth: 40 }
                    Text { text: "Name"; color: "#6b8fbb"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 180 }
                    Text { text: "Description"; color: "#6b8fbb"; font.bold: true; font.pixelSize: 11; Layout.fillWidth: true }
                    Text { text: "Ops"; color: "#6b8fbb"; font.bold: true; font.pixelSize: 11; horizontalAlignment: Text.AlignHCenter; Layout.preferredWidth: 50 }
                    Text { text: "⚠️"; color: "#6b8fbb"; font.bold: true; font.pixelSize: 11; horizontalAlignment: Text.AlignHCenter; Layout.preferredWidth: 40 }
                    Text { text: "Status"; color: "#6b8fbb"; font.bold: true; font.pixelSize: 11; horizontalAlignment: Text.AlignHCenter; Layout.preferredWidth: 60 }
                    Text { text: "Actions"; color: "#6b8fbb"; font.bold: true; font.pixelSize: 11; horizontalAlignment: Text.AlignHCenter; Layout.preferredWidth: 120 }
                }
            }

            // Scrollable Step Rows
            ListView {
                id: matrixStepList
                Layout.fillWidth: true
                Layout.fillHeight: true
                model: recipesRoot.activeRecipe.steps
                spacing: 3
                clip: true

                delegate: Rectangle {
                    id: stepDelegate
                    width: matrixStepList.width
                    height: isStepExpanded ? (modelData.ops.length > 0 ? 80 + modelData.ops.length * 32 : 80) : 42
                    color: modelData.status === "ACTIVE" ? "#0f3a64" : (index % 2 === 0 ? "#092440" : "#071b30")
                    border.color: modelData.status === "ACTIVE" ? "#00d2ff" : "#122d52"
                    border.width: modelData.status === "ACTIVE" ? 1.5 : 1
                    radius: 4
                    clip: true

                    property bool isStepExpanded: !!recipesRoot.expandedSteps[modelData.id]

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 6
                        spacing: 6

                        // Main Step Row Bar
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            // Step Number Badge
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

                            // Ops Count Pill
                            Rectangle {
                                Layout.preferredWidth: 36
                                Layout.preferredHeight: 24
                                radius: 12
                                color: "#0d2847"
                                border.color: "#1e40af"
                                border.width: 1
                                Text {
                                    anchors.centerIn: parent
                                    text: modelData.ops.length
                                    color: "#38bdf8"
                                    font.bold: true
                                    font.pixelSize: 11
                                }
                            }

                            // Warning / Manual Interlock Icon
                            Text {
                                text: modelData.isManual ? "⚠️" : "○"
                                color: modelData.isManual ? "#f59e0b" : "#475569"
                                font.pixelSize: 13
                                horizontalAlignment: Text.AlignHCenter
                                Layout.preferredWidth: 40
                            }

                            // Status Indicator
                            Rectangle {
                                Layout.preferredWidth: 14
                                Layout.preferredHeight: 14
                                radius: 7
                                color: modelData.status === "DONE" ? "#22c55e" : (modelData.status === "ACTIVE" ? "#38bdf8" : "#334155")
                                border.color: "#ffffff"
                                border.width: 1
                            }

                            // Actions: Expand ▼, Move ↑, Move ↓, Delete ✕
                            RowLayout {
                                Layout.preferredWidth: 120
                                spacing: 4

                                // Expand / Collapse Button
                                Rectangle {
                                    width: 26
                                    height: 26
                                    radius: 3
                                    color: "#0d2847"
                                    border.color: "#1e40af"
                                    border.width: 1
                                    Text { anchors.centerIn: parent; text: stepDelegate.isStepExpanded ? "▲" : "▼"; color: "#38bdf8"; font.pixelSize: 10 }
                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            var map = Object.assign({}, recipesRoot.expandedSteps);
                                            map[modelData.id] = !map[modelData.id];
                                            recipesRoot.expandedSteps = map;
                                        }
                                    }
                                }

                                // Move Up Button
                                Rectangle {
                                    width: 26
                                    height: 26
                                    radius: 3
                                    color: "#0d2847"
                                    border.color: "#1e40af"
                                    border.width: 1
                                    Text { anchors.centerIn: parent; text: "↑"; color: "#94a3b8"; font.bold: true; font.pixelSize: 12 }
                                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor }
                                }

                                // Move Down Button
                                Rectangle {
                                    width: 26
                                    height: 26
                                    radius: 3
                                    color: "#0d2847"
                                    border.color: "#1e40af"
                                    border.width: 1
                                    Text { anchors.centerIn: parent; text: "↓"; color: "#94a3b8"; font.bold: true; font.pixelSize: 12 }
                                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor }
                                }

                                // Delete Step Button
                                Rectangle {
                                    width: 26
                                    height: 26
                                    radius: 3
                                    color: "#450a0a"
                                    border.color: "#ef4444"
                                    border.width: 1
                                    Text { anchors.centerIn: parent; text: "✕"; color: "#f87171"; font.bold: true; font.pixelSize: 11 }
                                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor }
                                }
                            }
                        }

                        // Sub-Operations Detailed Table (When Step is Expanded)
                        ColumnLayout {
                            visible: stepDelegate.isStepExpanded
                            Layout.fillWidth: true
                            spacing: 4

                            Repeater {
                                model: modelData.ops
                                delegate: Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 28
                                    color: "#06182c"
                                    border.color: "#1e40af"
                                    border.width: 1
                                    radius: 3

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.leftMargin: 16
                                        anchors.rightMargin: 10
                                        spacing: 12

                                        Text { text: "⚙ " + modelData.dev; color: "#38bdf8"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 110 }
                                        Text { text: "Action: " + modelData.act; color: "#ffffff"; font.pixelSize: 11; Layout.preferredWidth: 80 }
                                        Text { text: "Delay: " + modelData.delay + "s"; color: "#94a3b8"; font.pixelSize: 11; Layout.preferredWidth: 70 }
                                        Text { text: "Dur: " + modelData.dur + "s"; color: "#94a3b8"; font.pixelSize: 11; Layout.preferredWidth: 70 }
                                        Text { text: "Setpoint: " + modelData.val; color: "#4ade80"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 100 }
                                        Text { text: "Condition: " + modelData.cond; color: "#fbbf24"; font.pixelSize: 11; Layout.fillWidth: true }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // =====================================================================
        // 3. VIEW CONTENT: (B) FORMULATION EXECUTION VIEW (Matching Reference UI)
        // =====================================================================
        ColumnLayout {
            visible: recipesRoot.activeTab === "formulation"
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10

            // Top Status & Process Readouts Card
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                color: "#0d2d4d"
                border.color: "#1a4070"
                border.width: 1.5
                radius: 6

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    spacing: 16

                    ColumnLayout {
                        spacing: 2
                        Text { text: "ACTIVE PRODUCT FORMULATION"; color: "#38bdf8"; font.bold: true; font.pixelSize: 11 }
                        Text { text: recipesRoot.activeRecipe.name; color: "#ffffff"; font.bold: true; font.pixelSize: 15 }
                    }

                    Rectangle {
                        Layout.preferredWidth: 86
                        Layout.preferredHeight: 26
                        radius: 4
                        color: recipesRoot.isExecuting ? "#14532d" : "#1e3a8a"
                        border.color: recipesRoot.isExecuting ? "#22c55e" : "#3b82f6"
                        border.width: 1
                        Text {
                            anchors.centerIn: parent
                            text: recipesRoot.isExecuting ? "RUNNING" : "STANDBY"
                            color: "#ffffff"
                            font.bold: true
                            font.pixelSize: 11
                        }
                    }

                    Item { Layout.fillWidth: true }

                    // Process Readouts: Vessel Temp, Level %, Batch Timer
                    RowLayout {
                        spacing: 20

                        ColumnLayout {
                            spacing: 1
                            Text { text: "Vessel Temp"; color: "#94a3b8"; font.pixelSize: 10; Layout.alignment: Qt.AlignHCenter }
                            Text { text: "79.8 °C"; color: "#22c55e"; font.bold: true; font.pixelSize: 16; Layout.alignment: Qt.AlignHCenter }
                        }

                        ColumnLayout {
                            spacing: 1
                            Text { text: "Level %"; color: "#94a3b8"; font.pixelSize: 10; Layout.alignment: Qt.AlignHCenter }
                            Text { text: "64.2 %"; color: "#38bdf8"; font.bold: true; font.pixelSize: 16; Layout.alignment: Qt.AlignHCenter }
                        }

                        ColumnLayout {
                            spacing: 1
                            Text { text: "Batch Time"; color: "#94a3b8"; font.pixelSize: 10; Layout.alignment: Qt.AlignHCenter }
                            Text { text: "00:14:32"; color: "#fbbf24"; font.bold: true; font.pixelSize: 16; Layout.alignment: Qt.AlignHCenter }
                        }
                    }
                }
            }

            // Two-Column Grid: Left (Step Progression) | Right (Ingredients Table)
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 12

                // Left: Step Execution Stream (7 Columns width equivalent)
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: 600
                    color: "#06182c"
                    border.color: "#184d7e"
                    border.width: 1
                    radius: 6
                    clip: true

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 8

                        Text {
                            text: "RECIPE SEQUENCE PROGRESSION"
                            color: "#38bdf8"
                            font.bold: true
                            font.pixelSize: 12
                        }

                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            model: recipesRoot.activeRecipe.steps
                            spacing: 4
                            clip: true

                            delegate: Rectangle {
                                width: parent.width
                                height: 42
                                radius: 5
                                color: modelData.status === "ACTIVE" ? "#0f3a64" : (modelData.status === "DONE" ? "#06231a" : "#092440")
                                border.color: modelData.status === "ACTIVE" ? "#00d2ff" : (modelData.status === "DONE" ? "#22c55e" : "#164673")
                                border.width: modelData.status === "ACTIVE" ? 2 : 1

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: 10
                                    anchors.rightMargin: 10
                                    spacing: 10

                                    Text { text: "Step " + modelData.id; color: "#38bdf8"; font.bold: true; font.pixelSize: 12; Layout.preferredWidth: 50 }
                                    Text { text: modelData.name; color: "#ffffff"; font.bold: true; font.pixelSize: 12; Layout.preferredWidth: 160; elide: Text.ElideRight }
                                    Text { text: modelData.desc; color: "#94a3b8"; font.pixelSize: 11; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text {
                                        text: modelData.status
                                        color: modelData.status === "DONE" ? "#4ade80" : (modelData.status === "ACTIVE" ? "#38bdf8" : "#64748b")
                                        font.bold: true
                                        font.pixelSize: 11
                                        Layout.preferredWidth: 60
                                        horizontalAlignment: Text.AlignRight
                                    }
                                }
                            }
                        }
                    }
                }

                // Right: Ingredients Bill of Materials (5 Columns width equivalent)
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: 420
                    color: "#06182c"
                    border.color: "#184d7e"
                    border.width: 1
                    radius: 6
                    clip: true

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 8

                        Text {
                            text: "FORMULATION INGREDIENTS (BOM)"
                            color: "#38bdf8"
                            font.bold: true
                            font.pixelSize: 12
                        }

                        // Table Header
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 26
                            color: "#0d2847"
                            radius: 3

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 8
                                anchors.rightMargin: 8
                                spacing: 8

                                Text { text: "#"; color: "#6b8fbb"; font.bold: true; font.pixelSize: 10; Layout.preferredWidth: 24 }
                                Text { text: "Ingredient"; color: "#6b8fbb"; font.bold: true; font.pixelSize: 10; Layout.fillWidth: true }
                                Text { text: "Phase"; color: "#6b8fbb"; font.bold: true; font.pixelSize: 10; Layout.preferredWidth: 44; horizontalAlignment: Text.AlignHCenter }
                                Text { text: "Qty"; color: "#6b8fbb"; font.bold: true; font.pixelSize: 10; Layout.preferredWidth: 64; horizontalAlignment: Text.AlignRight }
                            }
                        }

                        // Ingredients List
                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            model: recipesRoot.activeRecipe.ingredients || []
                            spacing: 3
                            clip: true

                            delegate: Rectangle {
                                width: parent.width
                                height: 30
                                color: index % 2 === 0 ? "#092440" : "#071b30"
                                border.color: "#164673"
                                border.width: 1
                                radius: 3

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: 8
                                    anchors.rightMargin: 8
                                    spacing: 8

                                    Text { text: modelData.sr; color: "#94a3b8"; font.pixelSize: 11; Layout.preferredWidth: 24 }
                                    Text { text: modelData.name; color: "#ffffff"; font.bold: true; font.pixelSize: 11; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Rectangle {
                                        Layout.preferredWidth: 32
                                        Layout.preferredHeight: 18
                                        radius: 3
                                        color: modelData.phase === "A" ? "#1e3a8a" : (modelData.phase === "B" ? "#7c2d12" : "#14532d")
                                        Text { anchors.centerIn: parent; text: "Ph " + modelData.phase; color: "#ffffff"; font.bold: true; font.pixelSize: 9 }
                                    }
                                    Text { text: modelData.qty; color: "#4ade80"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 64; horizontalAlignment: Text.AlignRight }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
