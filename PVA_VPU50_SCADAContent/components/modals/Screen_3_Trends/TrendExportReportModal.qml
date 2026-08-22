import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: exportReportModalRoot
    anchors.fill: parent
    visible: false
    color: "#d0000000"
    z: 100

    property alias batchNameText: batchNameLabel.text
    property alias timeRangeText: timeRangeLabel.text
    property alias confirmBtn: generatePdfBtn
    property alias cancelBtn: cancelActionBtn

    signal exportConfirmed(string reportTitle, string format)
    signal exportCancelled()

    Rectangle {
        anchors.centerIn: parent
        width: 520
        height: 360
        radius: 8
        color: "#081d33"
        border.color: "#0284c7"
        border.width: 2.0

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 12

            // Title
            RowLayout {
                Layout.fillWidth: true
                spacing: 8
                Image {
                    source: "../../../assets/icons/nav/docs_report.svg"
                    width: 20
                    height: 20
                    sourceSize: Qt.size(20, 20)
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 20
                    fillMode: Image.PreserveAspectFit
                }
                Text { text: "21 CFR PART 11 BATCH TREND REPORT EXPORT"; color: "#ffffff"; font.bold: true; font.pixelSize: 13 }
                Item { Layout.fillWidth: true }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: "#1e3a8a" }

            // Details Card
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 120
                radius: 5
                color: "#051527"
                border.color: "#0d2b4a"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 6

                    RowLayout {
                        Text { text: "Batch Identification:"; color: "#94a3b8"; font.pixelSize: 11; Layout.preferredWidth: 140 }
                        Text { id: batchNameLabel; text: "B-20260815-A1 (Body Lotion 50kg)"; color: "#38bdf8"; font.bold: true; font.pixelSize: 11 }
                    }
                    RowLayout {
                        Text { text: "Selected Time Scale:"; color: "#94a3b8"; font.pixelSize: 11; Layout.preferredWidth: 140 }
                        Text { id: timeRangeLabel; text: "5 Min Window (Full Resolution Telemetry)"; color: "#4ade80"; font.bold: true; font.pixelSize: 11 }
                    }
                    RowLayout {
                        Text { text: "Audit Trail Integrity:"; color: "#94a3b8"; font.pixelSize: 11; Layout.preferredWidth: 140 }
                        Text { text: "HMAC SHA-256 Cryptographically Sealed"; color: "#facc15"; font.bold: true; font.pixelSize: 11 }
                    }
                    RowLayout {
                        Text { text: "Compliance Standard:"; color: "#94a3b8"; font.pixelSize: 11; Layout.preferredWidth: 140 }
                        Text { text: "FDA 21 CFR Part 11 & GAMP 5 Cat 4"; color: "#e2e8f0"; font.bold: true; font.pixelSize: 11 }
                    }
                }
            }

            Text {
                text: "Exporting this historical report will generate a digitally signed PDF and record a non-repudiable entry in the system audit trail."
                color: "#cbd5e1"
                font.pixelSize: 11
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }

            Item { Layout.fillHeight: true }

            // Action Buttons
            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Rectangle {
                    id: cancelActionBtn
                    Layout.fillWidth: true
                    Layout.preferredHeight: 38
                    radius: 4
                    color: "#1e293b"
                    border.color: "#64748b"
                    Text { anchors.centerIn: parent; text: "Cancel"; color: "#cbd5e1"; font.bold: true; font.pixelSize: 12 }
                }

                Rectangle {
                    id: generatePdfBtn
                    Layout.fillWidth: true
                    Layout.preferredHeight: 38
                    radius: 4
                    color: "#059669"
                    border.color: "#34d399"
                    Text { anchors.centerIn: parent; text: "Export Signed PDF Report"; color: "#ffffff"; font.bold: true; font.pixelSize: 12 }
                }
            }
        }
    }
}
