import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: recipesRoot
    color: "#0a2644"

    property var phaseList: [
        { phase: 1, name: "DI Water Pre-charge (350 L)", status: "COMPLETED", duration: "05:00", agitator: "30.0 rpm", homo: "0 rpm", temp: "25.0 °C", vac: "-200 mbar" },
        { phase: 2, name: "Vacuum Powder Suction (Carbopol 980)", status: "ACTIVE", duration: "12:30", agitator: "40.0 rpm", homo: "1800 rpm", temp: "25.0 °C", vac: "-450 mbar" },
        { phase: 3, name: "High-Shear Dispersion & Hydration", status: "PENDING", duration: "20:00", agitator: "60.0 rpm", homo: "3000 rpm", temp: "40.0 °C", vac: "-300 mbar" },
        { phase: 4, name: "Triethanolamine (TEA) Neutralization", status: "PENDING", duration: "10:00", agitator: "25.0 rpm", homo: "800 rpm", temp: "30.0 °C", vac: "-200 mbar" },
        { phase: 5, name: "Final Gel Deaeration & Discharge", status: "PENDING", duration: "15:00", agitator: "20.0 rpm", homo: "0 rpm", temp: "25.0 °C", vac: "-850 mbar" }
    ]

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 10

        // Recipe Header Bar
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Rectangle {
                width: 32
                height: 32
                radius: 4
                color: "#8ee62c"
                Text { text: "R"; color: "#000000"; font.bold: true; font.pixelSize: 18; anchors.centerIn: parent }
            }

            ColumnLayout {
                spacing: 0
                Text { text: "BATCH RECIPE: CARBOPOL 980 PHARMA GEL"; color: "#ffffff"; font.bold: true; font.pixelSize: 15 }
                Text { text: "Batch No: #20260815-VPU50 | Target Volume: 500 L | Status: PHASE 2 RUNNING"; color: "#91b8db"; font.pixelSize: 11 }
            }

            Item { Layout.fillWidth: true }

            Rectangle {
                Layout.preferredWidth: 100
                Layout.preferredHeight: 32
                color: "#1e5b2b"
                border.color: "#8ee62c"
                border.width: 1
                radius: 4
                Text { anchors.centerIn: parent; text: "RUNNING"; color: "#8ee62c"; font.bold: true; font.pixelSize: 11 }
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

                Text { text: "PHASE"; color: "#91b8db"; font.bold: true; Layout.preferredWidth: 60 }
                Text { text: "OPERATION DESCRIPTION"; color: "#91b8db"; font.bold: true; Layout.fillWidth: true }
                Text { text: "DURATION"; color: "#91b8db"; font.bold: true; Layout.preferredWidth: 80 }
                Text { text: "AGITATOR"; color: "#91b8db"; font.bold: true; Layout.preferredWidth: 80 }
                Text { text: "HOMO"; color: "#91b8db"; font.bold: true; Layout.preferredWidth: 80 }
                Text { text: "TEMP"; color: "#91b8db"; font.bold: true; Layout.preferredWidth: 80 }
                Text { text: "VACUUM"; color: "#91b8db"; font.bold: true; Layout.preferredWidth: 80 }
                Text { text: "STATUS"; color: "#91b8db"; font.bold: true; Layout.preferredWidth: 90 }
            }
        }

        ListView {
            id: recipeListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: recipesRoot.phaseList
            spacing: 4
            clip: true

            delegate: Rectangle {
                width: recipeListView.width
                height: 44
                color: modelData.status === "ACTIVE" ? "#0f3e69" : "#092440"
                border.color: modelData.status === "ACTIVE" ? "#00d2ff" : "#164673"
                border.width: modelData.status === "ACTIVE" ? 2 : 1
                radius: 3

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 12

                    Text { text: "P" + modelData.phase; color: "#ffffff"; font.bold: true; Layout.preferredWidth: 60 }
                    Text { text: modelData.name; color: "#ffffff"; font.bold: modelData.status === "ACTIVE"; Layout.fillWidth: true; elide: Text.ElideRight }
                    Text { text: modelData.duration; color: "#91b8db"; Layout.preferredWidth: 80 }
                    Text { text: modelData.agitator; color: "#00d2ff"; font.bold: true; Layout.preferredWidth: 80 }
                    Text { text: modelData.homo; color: "#00d2ff"; font.bold: true; Layout.preferredWidth: 80 }
                    Text { text: modelData.temp; color: "#ffaa00"; font.bold: true; Layout.preferredWidth: 80 }
                    Text { text: modelData.vac; color: "#8ee62c"; font.bold: true; Layout.preferredWidth: 80 }

                    Rectangle {
                        Layout.preferredWidth: 85
                        Layout.preferredHeight: 22
                        radius: 3
                        color: modelData.status === "COMPLETED" ? "#1b5a94" : (modelData.status === "ACTIVE" ? "#8ee62c" : "#215c9b")
                        Text {
                            anchors.centerIn: parent
                            text: modelData.status
                            color: modelData.status === "ACTIVE" ? "#000000" : "#ffffff"
                            font.bold: true
                            font.pixelSize: 10
                        }
                    }
                }
            }
        }
    }
}
