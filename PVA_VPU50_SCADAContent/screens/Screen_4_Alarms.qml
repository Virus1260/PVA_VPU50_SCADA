import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: alarmsContainer
    Layout.fillWidth: true
    Layout.fillHeight: true

    Screen_4_AlarmsView {
        id: ui
        anchors.fill: parent
    }

    MouseArea {
        parent: ui.activeTabBtn
        anchors.fill: parent
        onClicked: ui.activeTab = "active"
    }

    MouseArea {
        parent: ui.historyTabBtn
        anchors.fill: parent
        onClicked: ui.activeTab = "history"
    }
}
