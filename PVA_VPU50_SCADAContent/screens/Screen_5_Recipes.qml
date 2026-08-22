import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: recipesContainer
    Layout.fillWidth: true
    Layout.fillHeight: true

    Screen_5_RecipesView {
        id: ui
        anchors.fill: parent
    }

    Timer {
        interval: 1000
        running: ui.isExecuting && !ui.manualOverlay.visible
        repeat: true
        onTriggered: {
            if (ui.stepTimeRemaining > 0) {
                ui.stepTimeRemaining -= 1;
            } else {
                if (ui.currentStepIndex < 5) {
                    ui.currentStepIndex += 1;
                    if (ui.currentStepIndex === 2 || ui.currentStepIndex === 5) {
                        ui.manualOverlay.visible = true;
                    } else {
                        ui.stepTimeRemaining = 180;
                    }
                } else {
                    ui.isExecuting = false;
                }
            }
        }
    }

    MouseArea {
        parent: ui.execTabBtn
        anchors.fill: parent
        onClicked: ui.activeTab = "execution"
    }

    MouseArea {
        parent: ui.formTabBtn
        anchors.fill: parent
        onClicked: ui.activeTab = "formulation"
    }

    MouseArea {
        parent: ui.toggleAutoBtn
        anchors.fill: parent
        onClicked: {
            ui.isExecuting = !ui.isExecuting;
            if (ui.isExecuting && ui.stepTimeRemaining <= 0) {
                ui.stepTimeRemaining = 180;
            }
        }
    }

    MouseArea {
        parent: ui.manualConfirmBtn
        anchors.fill: parent
        onClicked: {
            ui.manualOverlay.visible = false;
            if (ui.currentStepIndex < 5) {
                ui.currentStepIndex += 1;
                ui.stepTimeRemaining = 180;
            }
        }
    }
}
