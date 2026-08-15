import QtQuick
import QtQuick.Layouts

Rectangle {
    id: headerRoot
    height: 86
    color: "#08213b"

    property string vesselName: "VPU 50"
    property string systemTag: "B1"
    property string plantModeText: "(A)"
    property string alarmMessage: "SYSTEM READY - RECIPE [VPU_BATCH_01] STANDBY"
    property string operatorName: "Administrator"
    property string operatorRole: "21 CFR / GAMP 5"
    property string timeString: "09:50:25"
    property string dateString: "11/09/2024"
    property bool isAlarmActive: false

    property alias ackButton: ackBtn

    signal plantModeRequested()

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 16
        anchors.topMargin: 8
        anchors.bottomMargin: 8
        spacing: 12

        // 1. Machine Identifier Badges & Pill (Clickable -> Opens Plantmode Modal)
        RowLayout {
            spacing: 8
            Layout.alignment: Qt.AlignVCenter

            // B1 Badge (38px circle)
            Rectangle {
                Layout.preferredWidth: 38
                Layout.preferredHeight: 38
                radius: 19
                color: "#0c345a"
                border.color: "#1d5b94"
                border.width: 1.5

                Text {
                    anchors.centerIn: parent
                    text: headerRoot.systemTag
                    color: "#ffffff"
                    font.bold: true
                    font.pixelSize: 13
                }
            }

            // Auto (A) / Manual (M) Badge (38px circle - Clickable)
            Rectangle {
                Layout.preferredWidth: 38
                Layout.preferredHeight: 38
                radius: 19
                color: headerRoot.plantModeText === "(A)" ? "#0c345a" : "#4a3512"
                border.color: headerRoot.plantModeText === "(A)" ? "#1d5b94" : "#f5d033"
                border.width: 1.5

                Text {
                    anchors.centerIn: parent
                    text: headerRoot.plantModeText
                    color: headerRoot.plantModeText === "(A)" ? "#ffffff" : "#f5d033"
                    font.bold: true
                    font.pixelSize: 13
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: headerRoot.plantModeRequested()
                }
            }

            // Status Green Dot
            Rectangle {
                Layout.preferredWidth: 12
                Layout.preferredHeight: 12
                radius: 6
                color: "#78dc20"
                border.color: "#ffffff"
                border.width: 1
            }

            // VPU 50 Machine Pill (48px height, rounded capsule - Clickable)
            Rectangle {
                id: vesselPill
                Layout.preferredWidth: 150
                Layout.preferredHeight: 48
                radius: 24
                color: pillMouse.pressed ? "#07203a" : (pillMouse.containsMouse ? "#164d80" : "#0d365e")
                border.color: pillMouse.containsMouse ? "#3892e6" : "#1d5b94"
                border.width: 1.5

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 14
                    spacing: 8

                    Text {
                        text: headerRoot.vesselName
                        color: "#ffffff"
                        font.bold: true
                        font.pixelSize: 14
                        Layout.fillWidth: true
                    }

                    Item {
                        Layout.preferredWidth: 22
                        Layout.preferredHeight: 22
                        Image {
                            anchors.fill: parent
                            source: "../../assets/icons/header/lightbulb.svg"
                            fillMode: Image.PreserveAspectFit
                            mipmap: true
                            smooth: true
                        }
                    }
                }

                MouseArea {
                    id: pillMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: headerRoot.plantModeRequested()
                }
            }
        }

        // 2. Alarm / Annunciator Box (50px height, spacious)
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            color: headerRoot.isAlarmActive ? "#4a1212" : "#092a4a"
            border.color: headerRoot.isAlarmActive ? "#ff4444" : "#1b5b94"
            border.width: 1.5
            radius: 6

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 14
                anchors.rightMargin: 6
                spacing: 10

                Item {
                    Layout.preferredWidth: 24
                    Layout.preferredHeight: 24
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
                    font.pixelSize: 13
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }

                // Ack Button (Lime Green, 40px height)
                Rectangle {
                    id: ackBtn
                    Layout.preferredWidth: 76
                    Layout.preferredHeight: 40
                    radius: 4
                    color: headerRoot.isAlarmActive ? "#ff4444" : "#78dc20"

                    signal clicked()

                    Text {
                        anchors.centerIn: parent
                        text: "Ack"
                        color: headerRoot.isAlarmActive ? "#ffffff" : "#000000"
                        font.bold: true
                        font.pixelSize: 13
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
            spacing: 10
            Layout.alignment: Qt.AlignVCenter

            Text {
                text: "EN"
                color: "#ffffff"
                font.bold: true
                font.pixelSize: 13
            }

            Item {
                Layout.preferredWidth: 24
                Layout.preferredHeight: 24
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
                font.pixelSize: 12
            }
        }

        // 4. Live Clock & Date
        ColumnLayout {
            spacing: 2
            Layout.alignment: Qt.AlignVCenter

            Text {
                text: headerRoot.timeString
                color: "#ffffff"
                font.bold: true
                font.pixelSize: 13
                Layout.alignment: Qt.AlignHCenter
            }
            Text {
                text: headerRoot.dateString
                color: "#8cb5dc"
                font.pixelSize: 10
                Layout.alignment: Qt.AlignHCenter
            }
        }

        // 5. PVA Systems Brand Identity (OEM)
        Rectangle {
            Layout.preferredWidth: 100
            Layout.preferredHeight: 42
            color: "transparent"

            PvaLogo {
                anchors.centerIn: parent
                width: 95
                height: 36
            }
        }
    }
}
