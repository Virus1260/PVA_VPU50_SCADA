import QtQuick
import QtQuick.Layouts

Rectangle {
    id: headerRoot
    height: 86
    color: "#08213b"
    clip: true

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
        anchors.leftMargin: 10
        anchors.rightMargin: 12
        anchors.topMargin: 8
        anchors.bottomMargin: 8
        spacing: 8

        // =====================================================================
        // 1. LEFT CLUSTER: Machine Identifier Badges & Pill (Fixed 256px)
        // =====================================================================
        RowLayout {
            Layout.preferredWidth: 256
            Layout.minimumWidth: 256
            Layout.maximumWidth: 256
            Layout.fillHeight: true
            spacing: 6

            // B1 Badge (36px circle)
            Rectangle {
                Layout.preferredWidth: 36
                Layout.preferredHeight: 36
                radius: 18
                color: "#0c345a"
                border.color: "#1d5b94"
                border.width: 1.5

                Text {
                    anchors.centerIn: parent
                    text: headerRoot.systemTag
                    color: "#ffffff"
                    font.bold: true
                    font.pixelSize: 12
                }
            }

            // Auto (A) / Manual (M) Badge (36px circle - Clickable)
            Rectangle {
                Layout.preferredWidth: 36
                Layout.preferredHeight: 36
                radius: 18
                color: headerRoot.plantModeText === "(A)" ? "#0c345a" : "#4a3512"
                border.color: headerRoot.plantModeText === "(A)" ? "#1d5b94" : "#f5d033"
                border.width: 1.5

                Text {
                    anchors.centerIn: parent
                    text: headerRoot.plantModeText
                    color: headerRoot.plantModeText === "(A)" ? "#ffffff" : "#f5d033"
                    font.bold: true
                    font.pixelSize: 12
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: headerRoot.plantModeRequested()
                }
            }

            // Status Green Dot (10px)
            Rectangle {
                Layout.preferredWidth: 10
                Layout.preferredHeight: 10
                radius: 5
                color: "#78dc20"
                border.color: "#ffffff"
                border.width: 1
            }

            // VPU 50 Machine Pill (46px height, rounded capsule - Clickable)
            Rectangle {
                id: vesselPill
                Layout.preferredWidth: 148
                Layout.minimumWidth: 148
                Layout.maximumWidth: 148
                Layout.preferredHeight: 46
                radius: 23
                color: pillMouse.pressed ? "#07203a" : (pillMouse.containsMouse ? "#164d80" : "#0d365e")
                border.color: pillMouse.containsMouse ? "#3892e6" : "#1d5b94"
                border.width: 1.5

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 14
                    anchors.rightMargin: 12
                    spacing: 6

                    Text {
                        text: headerRoot.vesselName
                        color: "#ffffff"
                        font.bold: true
                        font.pixelSize: 13
                        Layout.fillWidth: true
                    }

                    Item {
                        Layout.preferredWidth: 20
                        Layout.preferredHeight: 20
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

        // =====================================================================
        // 2. CENTER CLUSTER: Alarm / Annunciator Box (Dynamic Fill Width)
        // =====================================================================
        Rectangle {
            Layout.fillWidth: true
            Layout.minimumWidth: 180
            Layout.maximumWidth: 620
            Layout.preferredHeight: 48
            Layout.alignment: Qt.AlignVCenter
            color: headerRoot.isAlarmActive ? "#4a1212" : "#092a4a"
            border.color: headerRoot.isAlarmActive ? "#ff4444" : "#1b5b94"
            border.width: 1.5
            radius: 6
            clip: true

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 6
                spacing: 8

                Item {
                    Layout.preferredWidth: 22
                    Layout.preferredHeight: 22
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
                    clip: true
                }

                // Ack Button (Lime Green, 62px width, 36px height)
                Rectangle {
                    id: ackBtn
                    Layout.preferredWidth: 62
                    Layout.minimumWidth: 62
                    Layout.maximumWidth: 62
                    Layout.preferredHeight: 36
                    radius: 4
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

        // =====================================================================
        // 3. RIGHT CLUSTER: User Credentials, Clock & PVA Systems Brand
        // =====================================================================
        // User Credentials (Language & Name)
        RowLayout {
            Layout.preferredWidth: 125
            Layout.minimumWidth: 90
            Layout.maximumWidth: 135
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 6
            clip: true

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
                Layout.fillWidth: true
                elide: Text.ElideRight
            }
        }

        // Live Clock & Date
        ColumnLayout {
            Layout.preferredWidth: 68
            Layout.minimumWidth: 55
            Layout.maximumWidth: 75
            Layout.alignment: Qt.AlignVCenter
            spacing: 1

            Text {
                text: headerRoot.timeString
                color: "#ffffff"
                font.bold: true
                font.pixelSize: 12
                Layout.alignment: Qt.AlignHCenter
            }
            Text {
                text: headerRoot.dateString
                color: "#8cb5dc"
                font.pixelSize: 9
                Layout.alignment: Qt.AlignHCenter
            }
        }

        // PVA Systems Brand Identity (OEM)
        Rectangle {
            Layout.preferredWidth: 80
            Layout.minimumWidth: 70
            Layout.maximumWidth: 85
            Layout.preferredHeight: 38
            Layout.alignment: Qt.AlignVCenter
            color: "transparent"

            PvaLogo {
                anchors.centerIn: parent
                width: 76
                height: 28
            }
        }
    }
}
