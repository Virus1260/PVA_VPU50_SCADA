import QtQuick
import QtQuick.Layouts
import "../"

RowLayout {
    id: userClusterRoot
    spacing: 16

    property string operatorName: "Line Operator"
    property string operatorRole: "Operator (Level 1)"
    property string timeString: "17:25:00"
    property string dateString: "15/08/2026"

    signal userLoginRequested()

    // Language Pill
    Text {
        text: "EN"
        color: "#ffffff"
        font.bold: true
        font.pixelSize: 15
    }

    // User Identity & Role Card (Clickable to Login / Switch User)
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
                    source: "../../../assets/icons/header/user.svg"
                    fillMode: Image.PreserveAspectFit
                    mipmap: true
                    smooth: true
                }
            }

            ColumnLayout {
                spacing: 1
                Text {
                    text: userClusterRoot.operatorName
                    color: "#ffffff"
                    font.bold: true
                    font.pixelSize: 13
                }
                Text {
                    text: userClusterRoot.operatorRole
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
            onClicked: userClusterRoot.userLoginRequested()
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
            text: userClusterRoot.timeString
            color: "#ffffff"
            font.bold: true
            font.pixelSize: 15
            Layout.alignment: Qt.AlignHCenter
        }
        Text {
            text: userClusterRoot.dateString
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

    // PVA Systems OEM Logo
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
