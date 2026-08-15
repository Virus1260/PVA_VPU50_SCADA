/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML.
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Scada_control_screen_try_2
import "screens"
import "components/widgets"
import "components/modals"

Rectangle {
    id: rootScreen
    width: 1280
    height: 720
    color: "#08213b"

    // Property Aliases for Top Header
    property alias header: scadaHeader
    property alias ackButton: scadaHeader.ackButton

    // Property Aliases for Control Screen View
    property alias controlView: controlScreenView

    // Property Aliases for Sidebar & Screens
    property alias sidebar: rightSidebar
    property alias screenStack: mainStack
    property alias pidScreen: pidView
    property alias trendsScreen: trendsView
    property alias alarmsScreen: alarmsView
    property alias recipesScreen: recipesView
    property alias auditScreen: auditView
    property alias playbackScreen: playbackView
    property alias maintenanceScreen: maintView

    // Property Aliases for Modals
    property alias keypadModal: numpadOverlay
    property alias agitatorModal: agitatorModeOverlay
    property alias homoModal: homoModeOverlay
    property alias vacuumModal: vacuumModeOverlay
    property alias plantModal: plantModeOverlay
    property alias confirmModal: confirmDialogOverlay

    // 1. TOP PROCESS HEADER BAR (Anchored directly to top)
    ScadaHeader {
        id: scadaHeader
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 56
        z: 10
        vesselName: "Unimix50"
        systemTag: "B1"
        alarmMessage: "SYSTEM READY - RECIPE [UNIMIX_BATCH_01] STANDBY"
    }

    // 2. RIGHT-SIDE SCADA NAVIGATION DOCK (Anchored directly to right)
    ScadaSidebar {
        id: rightSidebar
        anchors.top: scadaHeader.bottom
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: 76
        z: 10
    }

    // 3. CENTER DYNAMIC SCREEN CONTAINER (Anchored between header, sidebar & bounds)
    StackLayout {
        id: mainStack
        anchors.top: scadaHeader.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: rightSidebar.left
        anchors.margins: 4
        clip: true
        currentIndex: rightSidebar.activeIndex

        // SCREEN 0: 6-ROW PROCESS CONTROL DASHBOARD
        ControlScreen {
            id: controlScreenView
        }

        // SCREEN 1: P&ID VESSEL & PLANT SCHEMATIC
        PidScreen {
            id: pidView
        }

        // SCREEN 2: PROCESS TRENDS & HISTORICAL ANALYTICS
        TrendsScreen {
            id: trendsView
        }

        // SCREEN 3: ALARMS & ANNUNCIATOR
        AlarmsScreen {
            id: alarmsView
        }

        // SCREEN 4: RECIPES & BATCH PHASES
        RecipesScreen {
            id: recipesView
        }

        // SCREEN 5: AUDIT TRAIL & 21 CFR PART 11 EBR
        AuditScreen {
            id: auditView
        }

        // SCREEN 6: PROCESS LOG PLAYBACK
        PlaybackScreen {
            id: playbackView
        }

        // SCREEN 7: HARDWARE MAINTENANCE & I/O DIAGNOSTICS
        MaintenanceScreen {
            id: maintView
        }
    }

    // Bottom yellow indicator accent tab matching authentic EKATO EPOS
    Rectangle {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: 64
        height: 3
        color: "#f5d033"
        radius: 1
        z: 15
    }

    // =========================================================================
    // MODAL DIALOGS OVERLAYS (Z: 100)
    // =========================================================================
    NumericKeypadModal {
        id: numpadOverlay
        anchors.fill: parent
        visible: false
        z: 100
    }

    AgitatorModeModal {
        id: agitatorModeOverlay
        anchors.fill: parent
        visible: false
        z: 100
    }

    HomogenizerModeModal {
        id: homoModeOverlay
        anchors.fill: parent
        visible: false
        z: 100
    }

    VacuumModeModal {
        id: vacuumModeOverlay
        anchors.fill: parent
        visible: false
        z: 100
    }

    PlantModeModal {
        id: plantModeOverlay
        anchors.fill: parent
        visible: false
        z: 100
    }

    ConfirmationModal {
        id: confirmDialogOverlay
        anchors.fill: parent
        visible: false
        z: 100
    }
}
