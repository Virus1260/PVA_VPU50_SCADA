import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: auditRoot
    color: "#0a2644"

    property string batchNo: "B1"
    property string recipeName: "PFC_A180_Productionrecipe"
    property string productName: "Carbopol 980 Pharma Gel"
    property string machineId: "VPU 50"
    property string startedBy: "Florian Rismondo"
    property string batchStatus: "Released"
    property string startTime: "24.03.2021 14:06:39"
    property string stopTime: "24.03.2021 14:38:02"

    property var auditEvents: [
        { time: "24.03.2021 14:06:40", user: "RFL", name: "Florian Rismondo", source: "Command", id: "Command: 'Start Recipe' in mode 'Automatic'", op: "Control recipe '30388844110', Master 'PFC_A180'" },
        { time: "24.03.2021 14:06:46", user: "RFL", name: "Florian Rismondo", source: "User Input", id: "Manual user confirmation", op: "Modify value: 1 (Plant operationable confirmed)" },
        { time: "24.03.2021 14:07:03", user: "System", name: "PLC Auto", source: "Pressure Function", id: "Pressure Function Started in Vacuum Mode", op: "Start: -500.0mbar | Stop: -850.0mbar | Runtime: 5.0min" },
        { time: "24.03.2021 14:07:05", user: "System", name: "PLC Auto", source: "Agitator Function", id: "Agitator Started in Clockwise Mode", op: "Speed: 10.0rpm | Runtime: 12.0min | Power: 3.8kW" },
        { time: "24.03.2021 14:08:20", user: "System", name: "PLC Auto", source: "Filling Function", id: "Filling Started in Suction Bottom Mode", op: "Open: 70.0% / 10.0s | Closed: 0.0% / 10.0s | Qty: 500.0kg" },
        { time: "24.03.2021 14:08:30", user: "System", name: "PLC Auto", source: "Filling Function Info", id: "Quantity Filled: 500.0kg", op: "Suction phase completed successfully" },
        { time: "24.03.2021 14:08:32", user: "System", name: "PLC Auto", source: "Filling Function", id: "Stop Function", op: "V303 closed, suction port sealed" },
        { time: "24.03.2021 14:08:58", user: "RFL", name: "Florian Rismondo", source: "User Input", id: "Manual user confirmation", op: "User confirmed: Visual check after filling OK" },
        { time: "24.03.2021 14:38:02", user: "RFL", name: "Florian Rismondo", source: "Batch Release", id: "21 CFR Part 11 Electronic Signature", op: "Batch Released. Cryptographic Checksum: 0xA4F81C" }
    ]

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 10

        // 1. Formal Pharmaceutical Document Header (BatchReporter Slide 4)
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 110
            color: "#08213b"
            border.color: "#184d7e"
            border.width: 1.5
            radius: 6

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 6

                // Top Logo & Facility Bar
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    Rectangle {
                        width: 110
                        height: 28
                        color: "#0d365e"
                        border.color: "#00d2ff"
                        border.width: 1
                        radius: 4
                        Text {
                            anchors.centerIn: parent
                            text: "PVA / EKATO"
                            color: "#ffffff"
                            font.bold: true
                            font.pixelSize: 13
                        }
                    }

                    Text {
                        text: "BATCH REPORT — ELECTRONIC BATCH RECORD (EBR)"
                        color: "#ffffff"
                        font.bold: true
                        font.pixelSize: 15
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: "Facility: Beauty Pharma GmbH"
                        color: "#8cb5dc"
                        font.bold: true
                        font.pixelSize: 12
                    }
                }

                // Batch Metadata Row
                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: "#184d7e"
                }

                GridLayout {
                    columns: 4
                    Layout.fillWidth: true
                    columnSpacing: 16
                    rowSpacing: 2

                    Text { text: "Batch No: <b>" + auditRoot.batchNo + "</b>"; color: "#00d2ff"; font.pixelSize: 11 }
                    Text { text: "Recipe: <b>" + auditRoot.recipeName + "</b>"; color: "#cbd5e1"; font.pixelSize: 11 }
                    Text { text: "Product: <b>" + auditRoot.productName + "</b>"; color: "#cbd5e1"; font.pixelSize: 11 }
                    Text { text: "Status: <font color='#4ade80'><b>" + auditRoot.batchStatus + "</b></font>"; color: "#ffffff"; font.pixelSize: 11 }

                    Text { text: "Machine: <b>" + auditRoot.machineId + "</b>"; color: "#cbd5e1"; font.pixelSize: 11 }
                    Text { text: "Started by: <b>" + auditRoot.startedBy + "</b>"; color: "#cbd5e1"; font.pixelSize: 11 }
                    Text { text: "Start: <b>" + auditRoot.startTime + "</b>"; color: "#94a3b8"; font.pixelSize: 11 }
                    Text { text: "Stop: <b>" + auditRoot.stopTime + "</b>"; color: "#94a3b8"; font.pixelSize: 11 }
                }
            }
        }

        // 2. 21 CFR Part 11 Event Table Header
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 34
            color: "#0d365b"
            radius: 4

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 10

                Text { text: "DATE / TIME"; color: "#00d2ff"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 135 }
                Text { text: "USER"; color: "#00d2ff"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 55 }
                Text { text: "FULL NAME"; color: "#00d2ff"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 125 }
                Text { text: "SOURCE"; color: "#00d2ff"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 125 }
                Text { text: "IDENTIFICATION"; color: "#00d2ff"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 220 }
                Text { text: "OPERATION & AUDIT TRAIL LOG"; color: "#00d2ff"; font.bold: true; font.pixelSize: 11; Layout.fillWidth: true }
            }
        }

        // 3. Chronological Event List
        ListView {
            id: auditListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: auditRoot.auditEvents
            spacing: 4
            clip: true

            delegate: Rectangle {
                width: auditListView.width
                height: 38
                color: index % 2 === 0 ? "#092440" : "#071b30"
                border.color: "#164673"
                border.width: 1
                radius: 3

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 10

                    Text { text: modelData.time; color: "#94a3b8"; font.pixelSize: 11; font.family: "Courier"; Layout.preferredWidth: 135 }
                    Text { text: modelData.user; color: "#38bdf8"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 55 }
                    Text { text: modelData.name; color: "#e2e8f0"; font.pixelSize: 11; Layout.preferredWidth: 125; elide: Text.ElideRight }
                    Text { text: modelData.source; color: "#a5b4fc"; font.pixelSize: 11; Layout.preferredWidth: 125; elide: Text.ElideRight }
                    Text { text: modelData.id; color: "#f8fafc"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 220; elide: Text.ElideRight }
                    Text { text: modelData.op; color: "#86efac"; font.pixelSize: 11; Layout.fillWidth: true; elide: Text.ElideRight }
                }
            }
        }

        // 4. Footer Certification Bar
        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Text {
                text: "FDA 21 CFR Part 11 Electronic Records Validated | Checksum: 0xA4F81C | Tamper-Proof Storage Active"
                color: "#64748b"
                font.pixelSize: 11
                Layout.fillWidth: true
            }

            Rectangle {
                Layout.preferredWidth: 120
                Layout.preferredHeight: 30
                color: "#1e3a8a"
                border.color: "#3b82f6"
                border.width: 1
                radius: 4
                Text {
                    anchors.centerIn: parent
                    text: "🖨 PRINT REPORT"
                    color: "#ffffff"
                    font.bold: true
                    font.pixelSize: 11
                }
            }
        }
    }
}
