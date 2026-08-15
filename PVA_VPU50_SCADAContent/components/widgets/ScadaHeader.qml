import QtQuick
import QtQuick.Layouts

Rectangle {
    id: headerRoot
    implicitWidth: 1024
    width: 1024
    implicitHeight: 86
    height: 86
    color: "#08213b"
    clip: true

    property string activeBatchId: "B1"
    property string vesselName: "VPU 50"
    property string plantModeText: "(A)"
    property string alarmMessage: "SYSTEM READY - RECIPE [VPU_BATCH_01] STANDBY"
    property string operatorName: "Line Operator"
    property string operatorRole: "Operator (Level 1)"
    property string timeString: "17:25:00"
    property string dateString: "15/08/2026"
    property bool isAlarmActive: false

    property alias ackButton: ackBtn

    signal plantModeRequested()
    signal userLoginRequested()

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            var now = new Date();
            var hrs = String(now.getHours()).padStart(2, '0');
            var mins = String(now.getMinutes()).padStart(2, '0');
            var secs = String(now.getSeconds()).padStart(2, '0');
            headerRoot.timeString = hrs + ":" + mins + ":" + secs;
            var day = String(now.getDate()).padStart(2, '0');
            var month = String(now.getMonth() + 1).padStart(2, '0');
            var year = now.getFullYear();
            headerRoot.dateString = day + "/" + month + "/" + year;
        }
    }

    // =========================================================================
    // 1. LEFT CLUSTER: Machine Badges & Vessel Capsule (Anchored Left)
    // =========================================================================
    RowLayout {
        id: leftCluster
        anchors.left: parent.left
        anchors.leftMargin: 16
        anchors.verticalCenter: parent.verticalCenter
        spacing: 8

        // B1 System Identifier Badge (40px circle)
        Rectangle {
            width: 40
            height: 40
            radius: 20
            color: "#0c345a"
            border.color: "#1d5b94"
            border.width: 1.5

            Text {
                anchors.centerIn: parent
                text: headerRoot.activeBatchId
                color: "#ffffff"
                font.bold: true
                font.pixelSize: 14
            }
        }

        // Auto (A) / Manual (M) Mode Badge (40px circle - Clickable)
        Rectangle {
            width: 40
            height: 40
            radius: 20
            color: headerRoot.plantModeText === "(A)" ? "#0c345a" : "#4a3512"
            border.color: headerRoot.plantModeText === "(A)" ? "#1d5b94" : "#f5d033"
            border.width: 1.5

            Text {
                anchors.centerIn: parent
                text: headerRoot.plantModeText
                color: headerRoot.plantModeText === "(A)" ? "#ffffff" : "#f5d033"
                font.bold: true
                font.pixelSize: 14
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: headerRoot.plantModeRequested()
            }
        }

        // Status Green LED (12px)
        Rectangle {
            width: 12
            height: 12
            radius: 6
            color: "#78dc20"
            border.color: "#ffffff"
            border.width: 1.5
        }

        // VPU 50 Vessel Capsule Pill (50px height, rounded - Clickable)
        Rectangle {
            id: vesselPill
            width: 156
            height: 50
            radius: 25
            color: pillMouse.pressed ? "#07203a" : (pillMouse.containsMouse ? "#164d80" : "#0d365e")
            border.color: pillMouse.containsMouse ? "#3892e6" : "#1d5b94"
            border.width: 1.5

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 14
                spacing: 8

                Text {
                    text: headerRoot.activeBatchId + " - " + headerRoot.vesselName
                    color: "#ffffff"
                    font.bold: true
                    font.pixelSize: 14
                    Layout.fillWidth: true
                }

                Item {
                    width: 22
                    height: 22
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

    // =========================================================================
    // 2. RIGHT CLUSTER: User Profile, Digital Clock & PVA Logo (Anchored Right)
    // =========================================================================
    RowLayout {
        id: rightCluster
        anchors.right: parent.right
        anchors.rightMargin: 16
        anchors.verticalCenter: parent.verticalCenter
        spacing: 16

        // Language Pill
        Text {
            text: "EN"
            color: "#ffffff"
            font.bold: true
            font.pixelSize: 15
        }

        // User Identity & Role (Clickable to Login / Switch User)
        Rectangle {
            Layout.preferredHeight: 38
            Layout.preferredWidth: userRow.implicitWidth + 16
            radius: 6
            color: userMouse.pressed ? "#07203a" : (userMouse.containsMouse ? "#164d80" : "#0d365e")
            border.color: userMouse.containsMouse ? "#00d2ff" : "#1d5b94"
            border.width: 1

            RowLayout {
                id: userRow
                anchors.centerIn: parent
                spacing: 8
                Item {
                    width: 24
                    height: 24
                    Image {
                        anchors.fill: parent
                        source: "../../assets/icons/header/user.svg"
                        fillMode: Image.PreserveAspectFit
                        mipmap: true
                        smooth: true
                    }
                }

                ColumnLayout {
                    spacing: 1
                    Text {
                        text: headerRoot.operatorName
                        color: "#ffffff"
                        font.bold: true
                        font.pixelSize: 13
                    }
                    Text {
                        text: headerRoot.operatorRole
                        color: "#8cb5dc"
                        font.pixelSize: 9
                    }
                }
            }

            MouseArea {
                id: userMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: headerRoot.userLoginRequested()
            }
        }

        // 1px Vertical Divider
        Rectangle {
            width: 1
            height: 38
            color: "#1e5b94"
        }

        // Digital Clock & Date
        ColumnLayout {
            spacing: 2
            Text {
                text: headerRoot.timeString
                color: "#ffffff"
                font.bold: true
                font.pixelSize: 15
                Layout.alignment: Qt.AlignHCenter
            }
            Text {
                text: headerRoot.dateString
                color: "#8cb5dc"
                font.pixelSize: 11
                Layout.alignment: Qt.AlignHCenter
            }
        }

        // 1px Vertical Divider
        Rectangle {
            width: 1
            height: 38
            color: "#1e5b94"
        }

        // PVA Systems OEM Logo (Enlarged and crisp)
        Rectangle {
            width: 96
            height: 36
            color: "transparent"

            PvaLogo {
                anchors.centerIn: parent
                width: 96
                height: 34
            }
        }
    }

    // =========================================================================
    // 3. CENTER ALARM & ANNUNCIATOR BOX (Centered Between Left and Right)
    // =========================================================================
    Rectangle {
        id: alarmBox
        anchors.left: leftCluster.right
        anchors.leftMargin: 16
        anchors.right: rightCluster.left
        anchors.rightMargin: 16
        anchors.verticalCenter: parent.verticalCenter
        height: 52
        color: headerRoot.isAlarmActive ? "#4a1212" : "#092a4a"
        border.color: headerRoot.isAlarmActive ? "#ff4444" : "#1b5b94"
        border.width: 1.5
        radius: 8
        clip: true

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 14
            anchors.rightMargin: 8
            spacing: 10

            Item {
                width: 26
                height: 26
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
                clip: true
            }

            // Ack Button (Lime Green, 70px width, 38px height)
            Rectangle {
                id: ackBtn
                width: 70
                height: 38
                radius: 6
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
}
