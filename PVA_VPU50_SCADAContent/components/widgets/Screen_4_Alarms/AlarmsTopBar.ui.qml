/*
This is a UI file (.ui.qml) for Alarms Top Header & Control Bar.
Strictly declarative for Qt Design Studio.
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: topBarRoot
    Layout.fillWidth: true
    Layout.preferredHeight: 46
    radius: 5
    color: "#0d2b4a"
    border.color: "#184d7e"
    border.width: 1.2

    property string activeTab: "active" // "active" or "history"
    property int unackCount: 1
    property alias activeTabBtn: activeSwitchBtn
    property alias historyTabBtn: historySwitchBtn
    property alias silenceHornBtn: silenceHornButton

    RowLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 12

        Rectangle {
            width: 34
            height: 34
            radius: 4
            color: "#dc2626"
            Text { text: "🔔"; font.pixelSize: 18; anchors.centerIn: parent }
        }

        Text {
            text: "ISA-18.2 ALARM ANNUNCIATOR & PROCESS EVENT LOG"
            color: "#ffffff"
            font.bold: true
            font.pixelSize: 14
        }

        Item { Layout.fillWidth: true }

        // Silence Horn Button
        Rectangle {
            id: silenceHornButton
            Layout.preferredWidth: 120
            Layout.preferredHeight: 32
            radius: 4
            color: "#1e3a8a"
            border.color: "#38bdf8"

            RowLayout {
                anchors.centerIn: parent
                spacing: 4
                Text { text: "🔕"; font.pixelSize: 11 }
                Text { text: "Silence Horn"; color: "#ffffff"; font.bold: true; font.pixelSize: 11 }
            }
        }

        // Unacknowledged Alarms Count Badge
        Rectangle {
            Layout.preferredWidth: 150
            Layout.preferredHeight: 32
            radius: 4
            color: topBarRoot.unackCount > 0 ? "#450a0a" : "#052e16"
            border.color: topBarRoot.unackCount > 0 ? "#ef4444" : "#22c55e"

            RowLayout {
                anchors.centerIn: parent
                spacing: 6
                Rectangle {
                    width: 8
                    height: 8
                    radius: 4
                    color: topBarRoot.unackCount > 0 ? "#ef4444" : "#22c55e"
                }
                Text {
                    text: topBarRoot.unackCount > 0 ? ("ACTIVE: " + topBarRoot.unackCount + " UNACK") : "ALL ALARMS ACKED"
                    color: topBarRoot.unackCount > 0 ? "#f87171" : "#4ade80"
                    font.bold: true
                    font.pixelSize: 11
                }
            }
        }

        // Tab Switcher (Active Alarms vs Event Log)
        Rectangle {
            Layout.preferredWidth: 220
            Layout.preferredHeight: 32
            radius: 4
            color: "#071c33"
            border.color: "#0284c7"
            border.width: 1.0

            RowLayout {
                anchors.fill: parent
                spacing: 0

                Rectangle {
                    id: activeSwitchBtn
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 3
                    color: topBarRoot.activeTab === "active" ? "#dc2626" : "transparent"
                    Text {
                        anchors.centerIn: parent
                        text: "⚠️ Active Alarms"
                        color: "#ffffff"
                        font.bold: true
                        font.pixelSize: 11
                    }
                }

                Rectangle {
                    id: historySwitchBtn
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 3
                    color: topBarRoot.activeTab === "history" ? "#0284c7" : "transparent"
                    Text {
                        anchors.centerIn: parent
                        text: "📜 Event Log"
                        color: "#ffffff"
                        font.bold: true
                        font.pixelSize: 11
                    }
                }
            }
        }
    }
}
