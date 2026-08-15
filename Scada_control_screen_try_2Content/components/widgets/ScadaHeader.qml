import QtQuick
import QtQuick.Layouts

Rectangle {
    id: headerRoot
    height: 56
    color: "#08213b"

    property string vesselName: "VPU 50"
    property string systemTag: "B1"
    property string alarmMessage: "SYSTEM READY - RECIPE [VPU_BATCH_01] STANDBY"
    property string operatorName: "Administrator"
    property string operatorRole: "21 CFR / GAMP 5"
    property string timeString: "09:50:25"
    property string dateString: "11/09/2024"
    property bool isAlarmActive: false

    property alias ackButton: ackBtn

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 12
        spacing: 10

        // 1. Machine Identifier Badges & Pill
        RowLayout {
            spacing: 6
            Layout.alignment: Qt.AlignVCenter

            // B1 Badge
            Rectangle {
                Layout.preferredWidth: 32
                Layout.preferredHeight: 32
                radius: 16
                color: "#0c345a"
                border.color: "#1d5b94"
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: headerRoot.systemTag
                    color: "#ffffff"
                    font.bold: true
                    font.pixelSize: 11
                }
            }

            // Auto (A) Badge
            Rectangle {
                Layout.preferredWidth: 32
                Layout.preferredHeight: 32
                radius: 16
                color: "#0c345a"
                border.color: "#1d5b94"
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "(A)"
                    color: "#ffffff"
                    font.bold: true
                    font.pixelSize: 11
                }
            }

            // Status Green Dot
            Rectangle {
                Layout.preferredWidth: 10
                Layout.preferredHeight: 10
                radius: 5
                color: "#78dc20"
                border.color: "#ffffff"
                border.width: 1
            }

            // VPU 50 Machine Pill
            Rectangle {
                Layout.preferredWidth: 135
                Layout.preferredHeight: 36
                radius: 18
                color: "#0d365e"
                border.color: "#1d5b94"
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 6

                    Text {
                        text: headerRoot.vesselName
                        color: "#ffffff"
                        font.bold: true
                        font.pixelSize: 12
                        Layout.fillWidth: true
                    }

                    Item {
                        Layout.preferredWidth: 18
                        Layout.preferredHeight: 18
                        Image {
                            anchors.fill: parent
                            source: "../../assets/icons/header/lightbulb.svg"
                            fillMode: Image.PreserveAspectFit
                            mipmap: true
                            smooth: true
                        }
                    }
                }
            }
        }

        // 2. Alarm / Annunciator Box
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 38
            color: headerRoot.isAlarmActive ? "#4a1212" : "#092a4a"
            border.color: headerRoot.isAlarmActive ? "#ff4444" : "#1b5b94"
            border.width: 1
            radius: 4

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 4
                spacing: 8

                Item {
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 20
                    Image {
                        anchors.fill: parent
                        source: "../../assets/icons/header/alarm_bell.svg"
                        fillMode: Image.PreserveAspectFit
                        mipmap: true
                        smooth: true
                    }
                }

                Text {
                    text: headerRoot.alarmMessage
                    color: "#ffffff"
                    font.bold: true
                    font.pixelSize: 12
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }

                // Ack Button (Lime Green)
                Rectangle {
                    id: ackBtn
                    Layout.preferredWidth: 64
                    Layout.preferredHeight: 30
                    radius: 3
                    color: headerRoot.isAlarmActive ? "#ff4444" : "#78dc20"

                    signal clicked()

                    Text {
                        anchors.centerIn: parent
                        text: "Ack"
                        color: headerRoot.isAlarmActive ? "#ffffff" : "#000000"
                        font.bold: true
                        font.pixelSize: 12
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: ackBtn.clicked()
                    }
                }
            }
        }

        // 3. User Language & Credentials
        RowLayout {
            spacing: 8
            Layout.alignment: Qt.AlignVCenter

            Text {
                text: "EN"
                color: "#ffffff"
                font.bold: true
                font.pixelSize: 12
            }

            Item {
                Layout.preferredWidth: 20
                Layout.preferredHeight: 20
                Image {
                    anchors.fill: parent
                    source: "../../assets/icons/header/user.svg"
                    fillMode: Image.PreserveAspectFit
                    mipmap: true
                    smooth: true
                }
            }

            Text {
                text: headerRoot.operatorName
                color: "#ffffff"
                font.bold: true
                font.pixelSize: 11
            }
        }

        // 4. Live Clock & Date
        ColumnLayout {
            spacing: 0
            Layout.alignment: Qt.AlignVCenter

            Text {
                text: headerRoot.timeString
                color: "#ffffff"
                font.bold: true
                font.pixelSize: 11
                Layout.alignment: Qt.AlignHCenter
            }
            Text {
                text: headerRoot.dateString
                color: "#8cb5dc"
                font.pixelSize: 9
                Layout.alignment: Qt.AlignHCenter
            }
        }

        // 5. PVA Systems Brand Identity (OEM)
        Rectangle {
            Layout.preferredWidth: 84
            Layout.preferredHeight: 32
            color: "transparent"

            PvaLogo {
                anchors.centerIn: parent
                width: 80
                height: 28
            }
        }
    }
}
