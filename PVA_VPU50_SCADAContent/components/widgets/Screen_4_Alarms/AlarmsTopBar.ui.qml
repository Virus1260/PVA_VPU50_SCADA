/*
This is a UI file (.ui.qml) for Alarms Top Header & Control Bar.
Strictly declarative for Qt Design Studio. Uses SVG vector icons for web/WASM compatibility.
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
    property bool isHornSilenced: false

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
            color: topBarRoot.unackCount > 0 ? "#dc2626" : "#16a34a"
            Image {
                source: topBarRoot.unackCount > 0 ? "../../../assets/icons/header/alarm_bell.svg" : "../../../assets/icons/nav/alarms_bell_green.svg"
                width: 18
                height: 18
                sourceSize: Qt.size(18, 18)
                fillMode: Image.PreserveAspectFit
                anchors.centerIn: parent
            }
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
            color: topBarRoot.isHornSilenced ? "#0f172a" : "#1e3a8a"
            border.color: topBarRoot.isHornSilenced ? "#64748b" : "#38bdf8"

            Row {
                anchors.centerIn: parent
                spacing: 6
                Text {
                    text: topBarRoot.isHornSilenced ? "Horn Silenced" : "Silence Horn"
                    color: topBarRoot.isHornSilenced ? "#94a3b8" : "#ffffff"
                    font.bold: true
                    font.pixelSize: 11
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        // Unacknowledged Alarms Count Badge
        Rectangle {
            Layout.preferredWidth: 150
            Layout.preferredHeight: 32
            radius: 4
            color: topBarRoot.unackCount > 0 ? "#450a0a" : "#052e16"
            border.color: topBarRoot.unackCount > 0 ? "#ef4444" : "#22c55e"

            Row {
                anchors.centerIn: parent
                spacing: 6
                Rectangle {
                    width: 8
                    height: 8
                    radius: 4
                    color: topBarRoot.unackCount > 0 ? "#ef4444" : "#22c55e"
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    text: topBarRoot.unackCount > 0 ? ("ACTIVE: " + topBarRoot.unackCount + " UNACK") : "ALL ALARMS ACKED"
                    color: topBarRoot.unackCount > 0 ? "#f87171" : "#4ade80"
                    font.bold: true
                    font.pixelSize: 11
                    anchors.verticalCenter: parent.verticalCenter
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
                    color: topBarRoot.activeTab === "active" ? (topBarRoot.unackCount > 0 ? "#dc2626" : "#16a34a") : "transparent"

                    Row {
                        anchors.centerIn: parent
                        spacing: 4
                        Image {
                            source: topBarRoot.unackCount > 0 ? "../../../assets/icons/nav/alarms_bell.svg" : "../../../assets/icons/nav/alarms_bell_green.svg"
                            width: 13
                            height: 13
                            sourceSize: Qt.size(13, 13)
                            fillMode: Image.PreserveAspectFit
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            text: "Active Alarms"
                            color: "#ffffff"
                            font.bold: true
                            font.pixelSize: 11
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }

                Rectangle {
                    id: historySwitchBtn
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 3
                    color: topBarRoot.activeTab === "history" ? "#0284c7" : "transparent"

                    Row {
                        anchors.centerIn: parent
                        spacing: 4
                        Image {
                            source: "../../../assets/icons/nav/logs_order.svg"
                            width: 13
                            height: 13
                            sourceSize: Qt.size(13, 13)
                            fillMode: Image.PreserveAspectFit
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            text: "Event Log"
                            color: "#ffffff"
                            font.bold: true
                            font.pixelSize: 11
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
            }
        }
    }
}
