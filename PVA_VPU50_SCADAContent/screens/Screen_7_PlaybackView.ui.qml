/*
This is a UI file (.ui.qml) for Screen 7: Batch Reports & Process Playback.
Strictly declarative for Qt Design Studio.
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: playbackViewRoot
    width: 1184
    height: 626
    color: "#08213b"

    property string activeView: "report" // "report" or "playback"
    property real playbackPos: 0.45
    property bool isPlaying: false

    property alias reportTabBtn: reportSwitchBtn
    property alias playbackTabBtn: playbackSwitchBtn
    property alias playPauseBtn: playPauseActionBtn
    property alias resetScrubberBtn: resetActionBtn
    property alias timelineSlider: scrubberSlider

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        // =====================================================================
        // 1. TOP HEADER & VIEW SWITCH
        // =====================================================================
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 46
            radius: 5
            color: "#0d2b4a"
            border.color: "#184d7e"
            border.width: 1.2

            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 12

                Rectangle {
                    width: 34
                    height: 34
                    radius: 4
                    color: "#8b5cf6"
                    Image {
                        source: "../assets/icons/nav/docs_report.svg"
                        width: 18
                        height: 18
                        sourceSize: Qt.size(18, 18)
                        fillMode: Image.PreserveAspectFit
                        anchors.centerIn: parent
                    }
                }

                ColumnLayout {
                    spacing: 2
                    Text { text: "PHARMACEUTICAL ELECTRONIC BATCH RECORD (EBR) & PLAYBACK"; color: "#ffffff"; font.bold: true; font.pixelSize: 15 }
                    Text { text: "Batch: B-20260815-A1 | DermaCare Hydrating Lotion | Status: RELEASED"; color: "#c084fc"; font.bold: true; font.pixelSize: 11 }
                }

                Item { Layout.fillWidth: true }

                // View Mode Switcher (EBR Report vs Timeline Playback)
                Rectangle {
                    Layout.preferredWidth: 240
                    Layout.preferredHeight: 34
                    radius: 4
                    color: "#071c33"
                    border.color: "#0284c7"
                    border.width: 1.0

                    RowLayout {
                        anchors.fill: parent
                        spacing: 0

                        Rectangle {
                            id: reportSwitchBtn
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 3
                            color: playbackViewRoot.activeView === "report" ? "#0284c7" : "transparent"
                            Text { anchors.centerIn: parent; text: "EBR Report"; color: "#ffffff"; font.bold: true; font.pixelSize: 12 }
                        }

                        Rectangle {
                            id: playbackSwitchBtn
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 3
                            color: playbackViewRoot.activeView === "playback" ? "#0284c7" : "transparent"
                            Text { anchors.centerIn: parent; text: "Process Playback"; color: "#ffffff"; font.bold: true; font.pixelSize: 12 }
                        }
                    }
                }

                // Export PDF Button
                Rectangle {
                    Layout.preferredWidth: 120
                    Layout.preferredHeight: 34
                    radius: 4
                    color: "#052e16"
                    border.color: "#22c55e"

                    Text {
                        anchors.centerIn: parent
                        text: "Export PDF"
                        color: "#4ade80"
                        font.bold: true
                        font.pixelSize: 12
                    }
                }
            }
        }

        // =====================================================================
        // 2. MAIN WORKSPACE: EBR DOCUMENT OR PLAYBACK TIMELINE
        // =====================================================================
        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: playbackViewRoot.activeView === "report" ? 0 : 1

            // VIEW 0: EBR REPORT SUMMARY
            Rectangle {
                color: "#06182c"
                border.color: "#184d7e"
                border.width: 1.2
                radius: 5

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 12

                    // Document Header
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 80
                        color: "#0d2b4a"
                        radius: 5
                        border.color: "#0284c7"

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 16

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 3
                                Text { text: "PVA SYSTEMS / EKATO — PROCESS SKID VPU-50"; color: "#38bdf8"; font.bold: true; font.pixelSize: 13 }
                                Text { text: "Batch Record: B-20260815-A1 | Lot No: LOT-2026-0815-99"; color: "#ffffff"; font.bold: true; font.pixelSize: 12 }
                                Text { text: "Recipe: Body Lotion Formulation (v2.1) | Total Yield: 50.0 kg"; color: "#94a3b8"; font.pixelSize: 11 }
                            }

                            ColumnLayout {
                                spacing: 3
                                Text { text: "Status: RELEASED (QA Signed)"; color: "#4ade80"; font.bold: true; font.pixelSize: 12; Layout.alignment: Qt.AlignRight }
                                Text { text: "Operator: Line Operator (Level 1)"; color: "#cbd5e1"; font.pixelSize: 11; Layout.alignment: Qt.AlignRight }
                                Text { text: "Duration: 01h 30m 00s (09:15:00 - 10:45:00 UTC)"; color: "#94a3b8"; font.pixelSize: 11; Layout.alignment: Qt.AlignRight }
                            }
                        }
                    }

                    // Critical Process Parameters (CPPs) Cards
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 75
                        spacing: 10

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 4
                            color: "#092440"
                            border.color: "#38bdf8"
                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 4
                                Text { text: "Max Product Temp"; color: "#94a3b8"; font.pixelSize: 10 }
                                Text { text: "75.4 °C"; color: "#38bdf8"; font.bold: true; font.pixelSize: 18 }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 4
                            color: "#092440"
                            border.color: "#c084fc"
                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 4
                                Text { text: "Peak Vacuum Level"; color: "#94a3b8"; font.pixelSize: 10 }
                                Text { text: "-452.0 mbar"; color: "#c084fc"; font.bold: true; font.pixelSize: 18 }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 4
                            color: "#092440"
                            border.color: "#facc15"
                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 4
                                Text { text: "Peak Homogenizer"; color: "#94a3b8"; font.pixelSize: 10 }
                                Text { text: "3620 rpm"; color: "#facc15"; font.bold: true; font.pixelSize: 18 }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 4
                            color: "#092440"
                            border.color: "#f43f5e"
                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 4
                                Text { text: "Total Energy Consumed"; color: "#94a3b8"; font.pixelSize: 10 }
                                Text { text: "14.8 kWh"; color: "#f43f5e"; font.bold: true; font.pixelSize: 18 }
                            }
                        }
                    }

                    // 21 CFR Part 11 Electronic Signature Section
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "#081d33"
                        border.color: "#1e40af"
                        radius: 5

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 8

                            Text { text: "21 CFR PART 11 ELECTRONIC RELEASE SIGNATURES & HASH INTEGRITY"; color: "#ffffff"; font.bold: true; font.pixelSize: 12 }
                            Rectangle { Layout.fillWidth: true; height: 1; color: "#1e40af" }

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 14
                                Text { text: "1. Batch Executed by: Line Operator (Level 1)"; color: "#38bdf8"; font.bold: true; font.pixelSize: 11; Layout.fillWidth: true }
                                Text { text: "Signed: 15.08.2026 10:45:00 UTC"; color: "#94a3b8"; font.pixelSize: 11 }
                            }
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 14
                                Text { text: "2. Technical Review by: Production Supervisor"; color: "#38bdf8"; font.bold: true; font.pixelSize: 11; Layout.fillWidth: true }
                                Text { text: "Signed: 15.08.2026 11:00:12 UTC"; color: "#94a3b8"; font.pixelSize: 11 }
                            }
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 14
                                Text { text: "3. QA Release Approval by: Quality Lead (Level 3)"; color: "#4ade80"; font.bold: true; font.pixelSize: 11; Layout.fillWidth: true }
                                Text { text: "Digital Checksum: 0xA4F81C9B (VALID)"; color: "#4ade80"; font.bold: true; font.pixelSize: 11 }
                            }
                        }
                    }
                }
            }

            // VIEW 1: TIMELINE PLAYBACK SCRUBBER
            Rectangle {
                color: "#06182c"
                border.color: "#184d7e"
                border.width: 1.2
                radius: 5

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 12

                    Text {
                        text: "Timeline Scrubber: " + String(Math.floor(playbackViewRoot.playbackPos * 90)).padStart(2, '0') + ":00 / 01:30:00 UTC"
                        color: "#38bdf8"
                        font.bold: true
                        font.pixelSize: 16
                        Layout.alignment: Qt.AlignHCenter
                    }

                    // Progress Slider
                    Slider {
                        id: scrubberSlider
                        Layout.fillWidth: true
                        from: 0.0
                        to: 1.0
                        value: playbackViewRoot.playbackPos
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 14

                        Button {
                            id: playPauseActionBtn
                            text: playbackViewRoot.isPlaying ? "Pause Timeline" : "Play Historical Stream"
                        }
                        Button {
                            id: resetActionBtn
                            text: "Reset to Start"
                        }
                    }

                    // Replay Sensor Cards
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: 10

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 4
                            color: "#092440"
                            border.color: "#38bdf8"
                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 4
                                Text { text: "Agitator Speed"; color: "#94a3b8"; font.pixelSize: 11 }
                                Text { text: (playbackViewRoot.playbackPos > 0.1 ? 40.0 : 0.0).toFixed(1) + " rpm"; color: "#38bdf8"; font.bold: true; font.pixelSize: 18 }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 4
                            color: "#092440"
                            border.color: "#eab308"
                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 4
                                Text { text: "Homogenizer Speed"; color: "#94a3b8"; font.pixelSize: 11 }
                                Text { text: (playbackViewRoot.playbackPos > 0.4 ? 3600.0 : 0.0).toFixed(0) + " rpm"; color: "#facc15"; font.bold: true; font.pixelSize: 18 }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 4
                            color: "#092440"
                            border.color: "#f97316"
                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 4
                                Text { text: "Vessel Temperature"; color: "#94a3b8"; font.pixelSize: 11 }
                                Text { text: (24.5 + playbackViewRoot.playbackPos * 50.0).toFixed(1) + " °C"; color: "#f97316"; font.bold: true; font.pixelSize: 18 }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 4
                            color: "#092440"
                            border.color: "#c084fc"
                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 4
                                Text { text: "Vacuum Pressure"; color: "#94a3b8"; font.pixelSize: 11 }
                                Text { text: (-5.0 - playbackViewRoot.playbackPos * 445.0).toFixed(1) + " mbar"; color: "#c084fc"; font.bold: true; font.pixelSize: 18 }
                            }
                        }
                    }
                }
            }
        }
    }
}
