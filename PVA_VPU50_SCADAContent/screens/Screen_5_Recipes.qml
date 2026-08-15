import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../components/widgets/Screen_5_Recipes"
import "../components/modals/Screen_5_Recipes"
import "../config"

Rectangle {
    id: recipesScreenRoot
    color: "#081d33"

    // --- State Management ---
    property string activeTab: "matrix" // "matrix" or "formulation"
    property int activeRecipeIndex: 0
    property bool isExecuting: false
    property var expandedSteps: ({})

    // --- Master Recipe Database (Central In-Memory State) ---
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

    readonly property var currentRecipe: recipeDatabase[activeRecipeIndex] || recipeDatabase[0]

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 10

        // 1. TOP PROCESS TOOLBAR
        RecipeToolbar {
            Layout.fillWidth: true
            activeTab: recipesScreenRoot.activeTab
            recipes: recipesScreenRoot.recipeDatabase
            selectedIndex: recipesScreenRoot.activeRecipeIndex
            isExecuting: recipesScreenRoot.isExecuting

            onTabChanged: function(newTab) {
                recipesScreenRoot.activeTab = newTab;
            }
            onRecipeSelected: function(index) {
                recipesScreenRoot.activeRecipeIndex = index;
            }
            onNewRecipeRequested: {
                newRecipeModal.visible = true;
            }
            onDeleteRecipeRequested: {
                deleteConfirmModal.message = "Delete recipe '" + recipesScreenRoot.currentRecipe.name + "'? This action cannot be undone.";
                deleteConfirmModal.visible = true;
            }
            onAddStepRequested: {
                var cur = recipesScreenRoot.currentRecipe;
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
                recipesScreenRoot.recipeDatabaseChanged();
            }
            onExecuteToggleRequested: {
                recipesScreenRoot.isExecuting = !recipesScreenRoot.isExecuting;
                ScadaStateMiddleware.isRecipeRunning = recipesScreenRoot.isExecuting;

                if (recipesScreenRoot.isExecuting) {
                    var activeStep = recipesScreenRoot.currentRecipe.steps.find(function(s) { return s.status === "ACTIVE"; }) || recipesScreenRoot.currentRecipe.steps[0];
                    if (activeStep) {
                        ScadaStateMiddleware.currentRecipeStepName = activeStep.name;
                        if (activeStep.isManual) {
                            stepConfirmDialog.stepName = activeStep.name;
                            stepConfirmDialog.confirmMessage = activeStep.confirmMsg || "Manual operator check required for this step.";
                            stepConfirmDialog.visible = true;
                        } else if (activeStep.ops) {
                            for (var i = 0; i < activeStep.ops.length; i++) {
                                var op = activeStep.ops[i];
                                var numVal = parseFloat(op.val);
                                if (op.dev === "Agitator") {
                                    ScadaStateMiddleware.setAgitator(true, isNaN(numVal) ? 40.0 : numVal);
                                } else if (op.dev === "Homogenizer") {
                                    ScadaStateMiddleware.setHomogenizer(true, isNaN(numVal) ? 3600.0 : numVal);
                                } else if (op.dev === "Heater") {
                                    ScadaStateMiddleware.setHeating(true, isNaN(numVal) ? 80.0 : numVal);
                                } else if (op.dev === "Vacuum") {
                                    ScadaStateMiddleware.setVacuum(true, isNaN(numVal) ? -450.0 : numVal);
                                }
                            }
                        }
                    }
                } else {
                    ScadaStateMiddleware.setAgitator(false, 0);
                    ScadaStateMiddleware.setHomogenizer(false, 0);
                    ScadaStateMiddleware.setHeating(false, 20.7);
                    ScadaStateMiddleware.setVacuum(false, 0);
                }
            }
        }

        // 2. RECIPE MATRIX VIEW
        RecipeMatrixView {
            visible: recipesScreenRoot.activeTab === "matrix"
            Layout.fillWidth: true
            Layout.fillHeight: true
            steps: recipesScreenRoot.currentRecipe.steps || []
            expandedMap: recipesScreenRoot.expandedSteps

            onStepToggled: function(stepId) {
                var map = Object.assign({}, recipesScreenRoot.expandedSteps);
                map[stepId] = !map[stepId];
                recipesScreenRoot.expandedSteps = map;
            }
            onStepMovedUp: function(index) {
                if (index > 0) {
                    var steps = recipesScreenRoot.currentRecipe.steps;
                    var temp = steps[index];
                    steps[index] = steps[index - 1];
                    steps[index - 1] = temp;
                    recipesScreenRoot.recipeDatabaseChanged();
                }
            }
            onStepMovedDown: function(index) {
                var steps = recipesScreenRoot.currentRecipe.steps;
                if (index < steps.length - 1) {
                    var temp = steps[index];
                    steps[index] = steps[index + 1];
                    steps[index + 1] = temp;
                    recipesScreenRoot.recipeDatabaseChanged();
                }
            }
            onStepDeleted: function(index) {
                recipesScreenRoot.currentRecipe.steps.splice(index, 1);
                recipesScreenRoot.recipeDatabaseChanged();
            }
            onAddOperationRequested: function(stepIndex) {
                var targetStep = recipesScreenRoot.currentRecipe.steps[stepIndex];
                if (targetStep) {
                    if (!targetStep.ops) targetStep.ops = [];
                    targetStep.ops.push({
                        dev: "Agitator",
                        act: "ON",
                        delay: 0,
                        dur: 180,
                        val: "45 RPM",
                        cond: "Timer 3 min"
                    });
                    targetStep.opsCount = targetStep.ops.length;
                    recipesScreenRoot.recipeDatabaseChanged();
                }
            }
            onRemoveOperationRequested: function(stepIndex, opIndex) {
                var targetStep = recipesScreenRoot.currentRecipe.steps[stepIndex];
                if (targetStep && targetStep.ops) {
                    targetStep.ops.splice(opIndex, 1);
                    targetStep.opsCount = targetStep.ops.length;
                    recipesScreenRoot.recipeDatabaseChanged();
                }
            }
        }

        // 3. FORMULATION VIEW
        FormulationView {
            visible: recipesScreenRoot.activeTab === "formulation"
            Layout.fillWidth: true
            Layout.fillHeight: true
            recipe: recipesScreenRoot.currentRecipe
            isExecuting: recipesScreenRoot.isExecuting
        }
    }

    // --- Modals Layer ---
    NewRecipeModal {
        id: newRecipeModal
        onRecipeCreated: function(name, prod, size) {
            recipesScreenRoot.recipeDatabase.push({
                name: name,
                totalSteps: 1,
                createdAt: new Date().toISOString(),
                ingredients: [{ sr: 1, name: "Base Liquid", phase: "A", qty: "100 kg" }],
                steps: [{
                    id: 1,
                    name: "Initial Charge",
                    desc: "Charge initial ingredients",
                    opsCount: 1,
                    isManual: false,
                    status: "WAITING",
                    confirmMsg: "",
                    ops: [{ dev: "Fill Valve", act: "ON", delay: 0, dur: 120, val: "50%", cond: "Timer 2 min" }]
                }]
            });
            recipesScreenRoot.activeRecipeIndex = recipesScreenRoot.recipeDatabase.length - 1;
            recipesScreenRoot.recipeDatabaseChanged();
        }
    }

    DeleteConfirmModal {
        id: deleteConfirmModal
        onConfirmed: {
            if (recipesScreenRoot.recipeDatabase.length > 1) {
                recipesScreenRoot.recipeDatabase.splice(recipesScreenRoot.activeRecipeIndex, 1);
                recipesScreenRoot.activeRecipeIndex = Math.max(0, recipesScreenRoot.activeRecipeIndex - 1);
                recipesScreenRoot.recipeDatabaseChanged();
            }
        }
    }

    StepConfirmDialog {
        id: stepConfirmDialog
        onConfirmed: {
            var activeStep = recipesScreenRoot.currentRecipe.steps.find(function(s) { return s.status === "ACTIVE"; });
            if (activeStep) {
                activeStep.status = "DONE";
                var nextStep = recipesScreenRoot.currentRecipe.steps.find(function(s) { return s.status === "WAITING"; });
                if (nextStep) nextStep.status = "ACTIVE";
                recipesScreenRoot.recipeDatabaseChanged();
            }
        }
    }
}
