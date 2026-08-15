import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ColumnLayout {
    id: formulationViewRoot
    spacing: 10

    property var recipe: ({})
    property bool isExecuting: false
    property double vesselTemp: 79.8
    property double tankLevel: 64.2
    property string batchTime: "00:14:32"

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
                Text {
                    text: formulationViewRoot.recipe.name || "Formulation"
                    color: "#ffffff"
                    font.bold: true
                    font.pixelSize: 15
                }
            }

            Rectangle {
                Layout.preferredWidth: 86
                Layout.preferredHeight: 26
                radius: 4
                color: formulationViewRoot.isExecuting ? "#14532d" : "#1e3a8a"
                border.color: formulationViewRoot.isExecuting ? "#22c55e" : "#3b82f6"
                border.width: 1
                Text {
                    anchors.centerIn: parent
                    text: formulationViewRoot.isExecuting ? "RUNNING" : "STANDBY"
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
                    Text { text: formulationViewRoot.vesselTemp.toFixed(1) + " °C"; color: "#22c55e"; font.bold: true; font.pixelSize: 16; Layout.alignment: Qt.AlignHCenter }
                }

                ColumnLayout {
                    spacing: 1
                    Text { text: "Level %"; color: "#94a3b8"; font.pixelSize: 10; Layout.alignment: Qt.AlignHCenter }
                    Text { text: formulationViewRoot.tankLevel.toFixed(1) + " %"; color: "#38bdf8"; font.bold: true; font.pixelSize: 16; Layout.alignment: Qt.AlignHCenter }
                }

                ColumnLayout {
                    spacing: 1
                    Text { text: "Batch Time"; color: "#94a3b8"; font.pixelSize: 10; Layout.alignment: Qt.AlignHCenter }
                    Text { text: formulationViewRoot.batchTime; color: "#fbbf24"; font.bold: true; font.pixelSize: 16; Layout.alignment: Qt.AlignHCenter }
                }
            }
        }
    }

    // Two-Column Grid: Left (Step Progression) | Right (Ingredients Table)
    RowLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true
        spacing: 12

        // Left Column: Step Progression
        RecipeStepProgress {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 600
            steps: formulationViewRoot.recipe.steps || []
        }

        // Right Column: Ingredients BOM
        RecipeIngredientsTable {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 420
            ingredients: formulationViewRoot.recipe.ingredients || []
        }
    }
}
