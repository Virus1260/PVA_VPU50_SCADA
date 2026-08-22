import QtQuick
import QtQuick.Layouts

Rectangle {
    id: annunciatorRoot
    height: 52
    color: isAlarmActive ? "#4a1212" : "#042017"
    border.color: isAlarmActive ? "#ef4444" : "#15803d"
    border.width: 1.5
    radius: 8
    clip: true

    property bool isAlarmActive: false
    property string alarmMessage: "SYSTEM NORMAL - ALL PROCESS PARAMETERS NOMINAL"
    property alias ackButton: ackBtn

    signal ackClicked()

    SequentialAnimation on opacity {
        running: annunciatorRoot.isAlarmActive
        loops: Animation.Infinite
        NumberAnimation { to: 0.65; duration: 550; easing.type: Easing.InOutQuad }
        NumberAnimation { to: 1.0; duration: 550; easing.type: Easing.InOutQuad }
    }

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
                source: annunciatorRoot.isAlarmActive ? "../../../assets/icons/header/alarm_bell.svg" : "../../../assets/icons/header/alarm_bell_green.svg"
                fillMode: Image.PreserveAspectFit
                mipmap: true
                smooth: true
            }
        }

        Text {
            text: annunciatorRoot.alarmMessage
            color: annunciatorRoot.isAlarmActive ? "#ffffff" : "#ecfdf5"
            font.bold: true
            font.pixelSize: 13
            Layout.fillWidth: true
            elide: Text.ElideRight
            clip: true
        }

        // Ack Button (Displayed when alarm is active)
        Rectangle {
            id: ackBtn
            width: 76
            height: 38
            radius: 6
            color: "#ef4444"
            visible: annunciatorRoot.isAlarmActive

            signal clicked()

            Text {
                anchors.centerIn: parent
                text: "Ack"
                color: "#ffffff"
                font.bold: true
                font.pixelSize: 13
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    ackBtn.clicked();
                    annunciatorRoot.ackClicked();
                }
            }
        }

        // Soothing Green Normal Status Capsule (Displayed when system is healthy)
        Rectangle {
            width: 78
            height: 28
            radius: 14
            color: "#064e3b"
            border.color: "#22c55e"
            border.width: 1.2
            visible: !annunciatorRoot.isAlarmActive

            RowLayout {
                anchors.centerIn: parent
                spacing: 5
                Rectangle {
                    width: 7
                    height: 7
                    radius: 3.5
                    color: "#22c55e"
                }
                Text {
                    text: "NORMAL"
                    color: "#86efac"
                    font.bold: true
                    font.pixelSize: 10
                }
            }
        }
    }
}
