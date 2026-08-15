import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: auditRoot
    color: "#0a2644"

    property var auditEvents: [
        { id: "EBR-8921", time: "09:48:12", user: "Administrator", action: "PARAMETER_SET", target: "1M1501 Stirrer", prev: "20.0 rpm", curr: "25.0 rpm", sig: "VALID" },
        { id: "EBR-8920", time: "09:47:05", user: "Administrator", action: "RECIPE_LOAD", target: "UNIMIX_BATCH_01", prev: "NONE", curr: "CARBOPOL_980", sig: "VALID" },
        { id: "EBR-8919", time: "09:45:30", user: "Operator_1", action: "INTERLOCK_CONFIRM", target: "V101 Bottom Valve", prev: "CLOSED", curr: "OPEN", sig: "VALID" },
        { id: "EBR-8918", time: "09:40:00", user: "System", action: "ALARM_TRIGGER", target: "TIC162001", prev: "NORMAL", curr: "HIGH_DEV", sig: "SYSTEM" },
        { id: "EBR-8917", time: "09:35:00", user: "Administrator", action: "MODE_CHANGE", target: "1M2003 Homogenizer", prev: "OFF", curr: "PERMANENT", sig: "VALID" }
    ]

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 10

        // Screen Header
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Rectangle {
                width: 32
                height: 32
                radius: 4
                color: "#246eb9"
                Text { text: "§"; color: "#ffffff"; font.bold: true; font.pixelSize: 18; anchors.centerIn: parent }
            }

            ColumnLayout {
                spacing: 0
                Text { text: "21 CFR PART 11 / GAMP 5 ELECTRONIC BATCH RECORD"; color: "#ffffff"; font.bold: true; font.pixelSize: 15 }
                Text { text: "Immutable Cryptographic Audit Trail with Digital Signatures"; color: "#8ee62c"; font.pixelSize: 11 }
            }

            Item { Layout.fillWidth: true }

            Rectangle {
                Layout.preferredWidth: 140
                Layout.preferredHeight: 32
                color: "#0d365b"
                border.color: "#164673"
                border.width: 1
                radius: 4
                Text { anchors.centerIn: parent; text: "CHECKSUM: 0xA4F81C"; color: "#91b8db"; font.bold: true; font.pixelSize: 10 }
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

                Text { text: "EVENT ID"; color: "#91b8db"; font.bold: true; Layout.preferredWidth: 80 }
                Text { text: "TIME"; color: "#91b8db"; font.bold: true; Layout.preferredWidth: 80 }
                Text { text: "OPERATOR"; color: "#91b8db"; font.bold: true; Layout.preferredWidth: 100 }
                Text { text: "ACTION"; color: "#91b8db"; font.bold: true; Layout.preferredWidth: 130 }
                Text { text: "TARGET / TAG"; color: "#91b8db"; font.bold: true; Layout.preferredWidth: 140 }
                Text { text: "PREV VAL"; color: "#91b8db"; font.bold: true; Layout.preferredWidth: 80 }
                Text { text: "NEW VAL"; color: "#91b8db"; font.bold: true; Layout.preferredWidth: 80 }
                Text { text: "SIGNATURE"; color: "#91b8db"; font.bold: true; Layout.preferredWidth: 70 }
            }
        }

        ListView {
            id: auditListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: auditRoot.auditEvents
            spacing: 4
            clip: true

            delegate: Rectangle {
                width: auditListView.width
                height: 42
                color: "#092440"
                border.color: "#164673"
                border.width: 1
                radius: 3

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 12

                    Text { text: modelData.id; color: "#ffffff"; font.bold: true; Layout.preferredWidth: 80 }
                    Text { text: modelData.time; color: "#ffffff"; Layout.preferredWidth: 80 }
                    Text { text: modelData.user; color: "#91b8db"; Layout.preferredWidth: 100 }
                    Text { text: modelData.action; color: "#00d2ff"; font.bold: true; Layout.preferredWidth: 130 }
                    Text { text: modelData.target; color: "#ffffff"; Layout.preferredWidth: 140 }
                    Text { text: modelData.prev; color: "#91b8db"; Layout.preferredWidth: 80 }
                    Text { text: modelData.curr; color: "#8ee62c"; font.bold: true; Layout.preferredWidth: 80 }

                    Rectangle {
                        Layout.preferredWidth: 60
                        Layout.preferredHeight: 22
                        radius: 3
                        color: modelData.sig === "VALID" ? "#1e5b2b" : "#4a3b12"
                        Text { anchors.centerIn: parent; text: modelData.sig; color: modelData.sig === "VALID" ? "#8ee62c" : "#ffcc00"; font.bold: true; font.pixelSize: 10 }
                    }
                }
            }
        }
    }
}
