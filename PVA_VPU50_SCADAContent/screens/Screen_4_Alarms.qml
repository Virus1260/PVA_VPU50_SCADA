import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components/modals/Screen_4_Alarms"

Item {
    id: alarmsContainer
    Layout.fillWidth: true
    Layout.fillHeight: true

    property int pendingAckIndex: -1
    property alias unackCount: ui.unackCount

    signal alarmAcknowledged(string tag, string title)
    signal alarmsSynchronized(int unackCount)

    Screen_4_AlarmsView {
        id: ui
        anchors.fill: parent
    }

    // Modal for 21 CFR Part 11 Electronic Signature & Reason Capture
    AlarmAcknowledgeModal {
        id: ackModal
        anchors.fill: parent
    }

    // Tab Switching
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

    // Silence Horn
    MouseArea {
        parent: ui.silenceHornBtn
        anchors.fill: parent
        onClicked: {
            console.log("Alarm horn silenced by operator");
        }
    }

    // Delegate Action Handling (Acknowledge)
    MouseArea {
        parent: ui.alarmList
        anchors.fill: parent
        onClicked: function(mouse) {
            var idx = ui.alarmList.indexAt(mouse.x, mouse.y + ui.alarmList.contentY);
            var model = ui.alarmList.model;
            if (model && idx >= 0 && idx < model.count) {
                var item = model.get(idx);
                if (!item.ack) {
                    alarmsContainer.pendingAckIndex = idx;
                    ackModal.alarmTagText = item.tag;
                    ackModal.alarmTitleText = item.title;
                    ackModal.visible = true;
                }
            }
        }
    }

    // Modal Confirmation
    MouseArea {
        parent: ackModal.confirmBtn
        anchors.fill: parent
        onClicked: {
            if (alarmsContainer.pendingAckIndex >= 0) {
                var model = ui.alarmList.model;
                if (model && alarmsContainer.pendingAckIndex < model.count) {
                    var ackedTag = model.get(alarmsContainer.pendingAckIndex).tag;
                    var ackedTitle = model.get(alarmsContainer.pendingAckIndex).title;

                    model.setProperty(alarmsContainer.pendingAckIndex, "ack", true);
                    model.setProperty(alarmsContainer.pendingAckIndex, "ackBy", "operator");

                    // Count remaining unack
                    var unack = 0;
                    for (var i = 0; i < model.count; i++) {
                        if (!model.get(i).ack) unack++;
                    }
                    ui.unackCount = unack;
                    alarmsContainer.alarmAcknowledged(ackedTag, ackedTitle);
                    alarmsContainer.alarmsSynchronized(unack);
                }
            }
            ackModal.visible = false;
        }
    }

    // Modal Cancel
    MouseArea {
        parent: ackModal.cancelBtn
        anchors.fill: parent
        onClicked: {
            ackModal.visible = false;
        }
    }

    function syncUnackCount() {
        var model = ui.alarmList.model;
        if (!model) return 0;
        var unack = 0;
        for (var i = 0; i < model.count; i++) {
            if (!model.get(i).ack) unack++;
        }
        ui.unackCount = unack;
        alarmsSynchronized(unack);
        return unack;
    }

    function getLatestUnacknowledgedAlarm() {
        var model = ui.alarmList.model;
        if (!model) return null;
        for (var i = 0; i < model.count; i++) {
            var item = model.get(i);
            if (!item.ack) {
                return {
                    alarmCode: item.alarmCode,
                    severity: item.severity,
                    tag: item.tag,
                    title: item.title,
                    value: item.value,
                    sp: item.sp,
                    time: item.time,
                    resp: item.resp
                };
            }
        }
        return null;
    }

    function acknowledgeLatestAlarm(ackedBy) {
        var model = ui.alarmList.model;
        if (!model) return false;
        for (var i = 0; i < model.count; i++) {
            if (!model.get(i).ack) {
                var ackedTag = model.get(i).tag;
                var ackedTitle = model.get(i).title;
                model.setProperty(i, "ack", true);
                model.setProperty(i, "ackBy", ackedBy ? ackedBy : "operator");
                syncUnackCount();
                alarmAcknowledged(ackedTag, ackedTitle);
                return true;
            }
        }
        return false;
    }

    Component.onCompleted: {
        syncUnackCount();
    }
}
