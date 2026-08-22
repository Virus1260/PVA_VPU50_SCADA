/*
This is a UI file (.ui.qml) for the Recipe Formulation Studio & 21 CFR Part 11 Recipe Creator.
Strictly declarative for Qt Design Studio.
Compliant with GAMP 5 and FDA 21 CFR Part 11.
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: creatorRoot
    Layout.fillWidth: true
    Layout.fillHeight: true
    color: "#06182c"
    border.color: "#184d7e"
    border.width: 1.2
    radius: 6
    clip: true

    property string selectedRecipeName: "UNIMIX_BATCH_01"
    property string selectedProduct: "Carbopol 980 Pharma Gel"
    property string recipeVersion: "v2.6.4-GAMP5"
    property string validationStatus: "APPROVED & VALIDATED"
    property string approvedBy: "Florian Rismondo (QA Officer)"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        // =====================================================================
        // 1. RECIPE METADATA & 21 CFR PART 11 VALIDATION HEADER
        // =====================================================================
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            radius: 6
            color: "#0d2b4a"
            border.color: "#0284c7"
            border.width: 1.4

            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 16

                Rectangle {
                    width: 48
                    height: 48
                    radius: 6
                    color: "#0c345a"
                    border.color: "#38bdf8"
                    Image {
                        source: "../../../assets/icons/nav/recipes.svg"
                        width: 26
                        height: 26
                        anchors.centerIn: parent
                        fillMode: Image.PreserveAspectFit
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2
                    Text { text: "MASTER FORMULATION TEMPLATE"; color: "#38bdf8"; font.bold: true; font.pixelSize: 10 }
                    Text { text: creatorRoot.selectedRecipeName + " (" + creatorRoot.selectedProduct + ")"; color: "#ffffff"; font.bold: true; font.pixelSize: 15 }
                    Text { text: "Compliance: FDA 21 CFR Part 11 & ISPE GAMP 5 Category 4 | Revision: " + creatorRoot.recipeVersion; color: "#94a3b8"; font.pixelSize: 11 }
                }

                // Electronic Approval Stamp
                Rectangle {
                    Layout.preferredWidth: 220
                    Layout.preferredHeight: 52
                    radius: 4
                    color: "#052e16"
                    border.color: "#22c55e"
                    border.width: 1.2

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 2
                        RowLayout {
                            spacing: 6
                            Rectangle { width: 8; height: 8; radius: 4; color: "#22c55e" }
                            Text { text: creatorRoot.validationStatus; color: "#86efac"; font.bold: true; font.pixelSize: 10 }
                        }
                        Text { text: "Signed: " + creatorRoot.approvedBy; color: "#cbd5e1"; font.pixelSize: 9 }
                    }
                }
            }
        }

        // =====================================================================
        // 2. TWO-COLUMN SPLIT: PHASE PARAMETERS (LEFT) & BOM INGREDIENTS (RIGHT)
        // =====================================================================
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10

            // LEFT COLUMN: 5-PHASE SETPOINTS CONFIGURATION MATRIX
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

                    Text { text: "PHASE SEQUENCE & PROCESS SETPOINTS (ISA-88)"; color: "#94a3b8"; font.bold: true; font.pixelSize: 11 }

                    Repeater {
                        model: [
                            { step: 1, name: "Raw Material Charging", tempSp: "25.0 °C", vacSp: "-200 mbar", agitSp: "15 rpm", homoSp: "0 rpm", dur: "5 min", autoNext: "Manual Sign-off" },
                            { step: 2, name: "Pre-Heat & Agitation", tempSp: "70.0 °C", vacSp: "-300 mbar", agitSp: "35 rpm", homoSp: "0 rpm", dur: "10 min", autoNext: "Auto-Advance" },
                            { step: 3, name: "Vacuum Deaeration", tempSp: "70.0 °C", vacSp: "-450 mbar", agitSp: "25 rpm", homoSp: "0 rpm", dur: "8 min", autoNext: "Auto-Advance" },
                            { step: 4, name: "High-Shear Emulsification", tempSp: "68.0 °C", vacSp: "-450 mbar", agitSp: "35 rpm", homoSp: "2800 rpm", dur: "10 min", autoNext: "Auto-Advance" },
                            { step: 5, name: "Cooling & Discharge Transfer", tempSp: "35.0 °C", vacSp: "0 mbar", agitSp: "15 rpm", homoSp: "0 rpm", dur: "8 min", autoNext: "Manual Sign-off" }
                        ]

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 52
                            radius: 4
                            color: "#0a243f"
                            border.color: "#184d7e"

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 10
                                anchors.rightMargin: 10
                                spacing: 10

                                Rectangle {
                                    width: 24
                                    height: 24
                                    radius: 12
                                    color: "#0f3a64"
                                    border.color: "#38bdf8"
                                    Text { anchors.centerIn: parent; text: modelData.step + ""; color: "#ffffff"; font.bold: true; font.pixelSize: 11 }
                                }

                                ColumnLayout {
                                    Layout.preferredWidth: 150
                                    spacing: 1
                                    Text { text: modelData.name; color: "#ffffff"; font.bold: true; font.pixelSize: 11 }
                                    Text { text: modelData.autoNext; color: modelData.autoNext === "Auto-Advance" ? "#38bdf8" : "#f59e0b"; font.pixelSize: 9 }
                                }

                                Text { text: "Temp: " + modelData.tempSp; color: "#94a3b8"; font.pixelSize: 10; Layout.preferredWidth: 80 }
                                Text { text: "Vac: " + modelData.vacSp; color: "#94a3b8"; font.pixelSize: 10; Layout.preferredWidth: 85 }
                                Text { text: "Agit: " + modelData.agitSp; color: "#94a3b8"; font.pixelSize: 10; Layout.preferredWidth: 75 }
                                Text { text: "Homo: " + modelData.homoSp; color: "#94a3b8"; font.pixelSize: 10; Layout.preferredWidth: 85 }
                                Text { text: "Dur: " + modelData.dur; color: "#f5d033"; font.bold: true; font.pixelSize: 10; Layout.preferredWidth: 60 }
                            }
                        }
                    }
                }
            }

            // RIGHT COLUMN: BILL OF MATERIALS (BOM) RAW MATERIALS
            Rectangle {
                Layout.preferredWidth: 420
                Layout.fillHeight: true
                radius: 5
                color: "#071c33"
                border.color: "#184d7e"
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 6

                    Text { text: "RAW MATERIAL BILL OF MATERIALS (BOM)"; color: "#94a3b8"; font.bold: true; font.pixelSize: 11 }

                    Repeater {
                        model: [
                            { code: "RM-101", name: "Purified USP Water (Bulk Phase)", qty: "320.0 kg", tol: "±0.2 kg", phase: "Phase 1" },
                            { code: "RM-102", name: "Carbopol 980 Polymer", qty: "4.50 kg", tol: "±0.05 kg", phase: "Phase 1" },
                            { code: "RM-103", name: "Propylene Glycol (Humectant)", qty: "25.0 kg", tol: "±0.1 kg", phase: "Phase 2" },
                            { code: "RM-104", name: "Triethanolamine (Neutralizer 99%)", qty: "5.20 kg", tol: "±0.05 kg", phase: "Phase 4" },
                            { code: "RM-105", name: "Methylparaben (Preservative)", qty: "0.80 kg", tol: "±0.01 kg", phase: "Phase 4" }
                        ]

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 48
                            radius: 4
                            color: "#0a243f"
                            border.color: "#184d7e"

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 10
                                anchors.rightMargin: 10
                                spacing: 8

                                Rectangle {
                                    width: 50
                                    height: 20
                                    radius: 3
                                    color: "#1e3a8a"
                                    Text { anchors.centerIn: parent; text: modelData.code; color: "#93c5fd"; font.bold: true; font.pixelSize: 9 }
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 1
                                    Text { text: modelData.name; color: "#ffffff"; font.bold: true; font.pixelSize: 10; elide: Text.ElideRight }
                                    Text { text: "Charged in " + modelData.phase + " | Tol: " + modelData.tol; color: "#64748b"; font.pixelSize: 9 }
                                }

                                Text { text: modelData.qty; color: "#22c55e"; font.bold: true; font.pixelSize: 11; horizontalAlignment: Text.AlignRight }
                            }
                        }
                    }
                }
            }
        }
    }
}
