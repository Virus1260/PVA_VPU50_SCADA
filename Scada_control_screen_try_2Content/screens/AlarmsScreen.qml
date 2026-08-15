import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: alarmsRoot
    color: "#0a2644"

    property var alarmModel: [
        { id: "ALM-001", priority: "HIGH", tag: "PIC161001", desc: "Vacuum Seal Low Differential Pressure Warning", val: "-209.8 mbar", sp: "-450.0 mbar", time: "09:42:15", ack: false },
        { id: "ALM-002", priority: "MEDIUM", tag: "TIC162001", desc: "Jacket Heating High Temperature Deviation", val: "48.9 °C", sp: "1.0 °C", time: "09:40:02", ack: true },
        { id: "ALM-003", priority: "LOW", tag: "SCR182001", desc: "Agitator Motor Drive Ready Feedback Status", val: "25.0 rpm", sp: "25.0 rpm", time: "09:35:18", ack: true },
        { id: "ALM-004", priority: "INFO", tag: "1M2003", desc: "Homogenizer Mechanical Seal Cooling Flow Normal", val: "4.2 L/min", sp: "3.5 L/min", time: "09:30:00", ack: true },
        { id: "ALM-005", priority: "HIGH", tag: "1K1001", desc: "Vessel Cover Interlock Closed & Locked", val: "LOCKED", sp: "LOCKED", time: "09:15:22", ack: true }
    ]

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 10

        // Screen Title Bar
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Rectangle {
                width: 32
                height: 32
                radius: 4
                color: "#ff4444"
                Text { text: "!"; color: "#ffffff"; font.bold: true; font.pixelSize: 18; anchors.centerIn: parent }
            }

            Text {
                text: "ALARM ANNUNCIATOR & PROCESS EVENT LOG"
                color: "#ffffff"
                font.bold: true
                font.pixelSize: 16
            }

            Item { Layout.fillWidth: true }

            Rectangle {
                Layout.preferredWidth: 120
                Layout.preferredHeight: 32
                color: "#0d365b"
                border.color: "#164673"
                border.width: 1
                radius: 4
                Text { anchors.centerIn: parent; text: "ACTIVE: 1 UNACK"; color: "#ff5555"; font.bold: true; font.pixelSize: 11 }
            }
        }

        // Table Header
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 32
            color: "#0d365b"
            radius: 3

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 12

                Text { text: "ID"; color: "#91b8db"; font.bold: true; Layout.preferredWidth: 70 }
                Text { text: "PRIORITY"; color: "#91b8db"; font.bold: true; Layout.preferredWidth: 80 }
                Text { text: "TAG"; color: "#91b8db"; font.bold: true; Layout.preferredWidth: 100 }
                Text { text: "DESCRIPTION"; color: "#91b8db"; font.bold: true; Layout.fillWidth: true }
                Text { text: "VALUE"; color: "#91b8db"; font.bold: true; Layout.preferredWidth: 90 }
                Text { text: "SETPOINT"; color: "#91b8db"; font.bold: true; Layout.preferredWidth: 90 }
                Text { text: "TIMESTAMP"; color: "#91b8db"; font.bold: true; Layout.preferredWidth: 80 }
                Text { text: "STATUS"; color: "#91b8db"; font.bold: true; Layout.preferredWidth: 60 }
            }
        }

        ListView {
            id: alarmListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: alarmsRoot.alarmModel
            spacing: 4
            clip: true

            delegate: Rectangle {
                width: alarmListView.width
                height: 44
                color: modelData.priority === "HIGH" ? (modelData.ack ? "#2b1c1c" : "#4a1212") : "#0a2644"
                border.color: modelData.priority === "HIGH" ? "#ff4444" : "#164673"
                border.width: 1
                radius: 3

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 12

                    Text { text: modelData.id; color: "#ffffff"; font.bold: true; Layout.preferredWidth: 70 }

                    Rectangle {
                        Layout.preferredWidth: 65
                        Layout.preferredHeight: 22
                        radius: 3
                        color: modelData.priority === "HIGH" ? "#ff3333" : (modelData.priority === "MEDIUM" ? "#ffaa00" : "#00d2ff")
                        Text { anchors.centerIn: parent; text: modelData.priority; color: "#000000"; font.bold: true; font.pixelSize: 10 }
                    }

                    Text { text: modelData.tag; color: "#91b8db"; font.bold: true; Layout.preferredWidth: 100 }
                    Text { text: modelData.desc; color: "#ffffff"; Layout.fillWidth: true; elide: Text.ElideRight }
                    Text { text: modelData.val; color: "#00d2ff"; font.bold: true; Layout.preferredWidth: 90 }
                    Text { text: modelData.sp; color: "#91b8db"; Layout.preferredWidth: 90 }
                    Text { text: modelData.time; color: "#ffffff"; Layout.preferredWidth: 80 }

                    Rectangle {
                        Layout.preferredWidth: 50
                        Layout.preferredHeight: 22
                        radius: 3
                        color: modelData.ack ? "#1b5a94" : "#ff4444"
                        Text { anchors.centerIn: parent; text: modelData.ack ? "ACK" : "UNACK"; color: "#ffffff"; font.bold: true; font.pixelSize: 9 }
                    }
                }
            }
        }
    }
}
