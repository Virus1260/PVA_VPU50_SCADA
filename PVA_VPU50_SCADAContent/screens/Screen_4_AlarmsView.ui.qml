/*
This is a UI file (.ui.qml) for Screen 4: Alarms & Annunciator.
Strictly declarative for Qt Design Studio.
Assembled from modular sub-widgets in components/widgets/Screen_4_Alarms/
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components/widgets/Screen_4_Alarms"

Rectangle {
    id: alarmsViewRoot
    width: 1184
    height: 626
    color: "#08213b"

    property string activeTab: "active" // "active" or "history"
    property int unackCount: 1

    property alias topBar: alarmsHeaderBar
    property alias activeTabBtn: alarmsHeaderBar.activeTabBtn
    property alias historyTabBtn: alarmsHeaderBar.historyTabBtn
    property alias silenceHornBtn: alarmsHeaderBar.silenceHornBtn

    property alias activeAlarmsTable: activeTableWidget
    property alias alarmList: activeTableWidget.alarmList

    property alias historyTable: historyTableWidget
    property alias historyList: historyTableWidget.historyList

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        // =====================================================================
        // 1. TOP HEADER & CONTROLS (Modular AlarmsTopBar Widget)
        // =====================================================================
        AlarmsTopBar {
            id: alarmsHeaderBar
            activeTab: alarmsViewRoot.activeTab
            unackCount: alarmsViewRoot.unackCount
        }

        // =====================================================================
        // 2. MAIN CONTENT STACK (Active Alarms Table vs Event Log Table)
        // =====================================================================
        StackLayout {
            id: contentStack
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: alarmsViewRoot.activeTab === "active" ? 0 : 1

            // TAB 1: ACTIVE ALARMS TABLE GRID
            AlarmsTableWidget {
                id: activeTableWidget
            }

            // TAB 2: HISTORICAL EVENT LOG GRID
            AlarmsHistoryTableWidget {
                id: historyTableWidget
            }
        }
    }
}
