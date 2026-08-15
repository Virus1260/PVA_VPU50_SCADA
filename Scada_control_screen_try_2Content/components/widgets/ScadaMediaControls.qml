import QtQuick
import QtQuick.Layouts

RowLayout {
    id: mediaRoot
    spacing: 6

    property bool isPlaying: false
    property bool isPaused: false
    property bool isStopped: true

    property alias stopButton: stopBtn
    property alias pauseButton: pauseBtn
    property alias playButton: playBtn

    signal playClicked()
    signal pauseClicked()
    signal stopClicked()

    // 1. Industrial STOP Button
    Rectangle {
        id: stopBtn
        Layout.preferredWidth: 44
        Layout.preferredHeight: 44
        radius: 4
        color: mediaRoot.isStopped ? "#8b1c1c" : "#0c3359"
        border.color: mediaRoot.isStopped ? "#ff4d4d" : "#1a5286"
        border.width: 1

        Image {
            anchors.centerIn: parent
            width: 22
            height: 22
            source: "../../assets/icons/controls/stop.svg"
            fillMode: Image.PreserveAspectFit
            mipmap: true
            smooth: true
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                mediaRoot.isStopped = true;
                mediaRoot.isPlaying = false;
                mediaRoot.isPaused = false;
                mediaRoot.stopClicked();
            }
        }
    }

    // 2. Industrial PAUSE Button
    Rectangle {
        id: pauseBtn
        Layout.preferredWidth: 44
        Layout.preferredHeight: 44
        radius: 4
        color: mediaRoot.isPaused ? "#8b681c" : "#0c3359"
        border.color: mediaRoot.isPaused ? "#ffcc00" : "#1a5286"
        border.width: 1

        Image {
            anchors.centerIn: parent
            width: 22
            height: 22
            source: mediaRoot.isPaused ? "../../assets/icons/controls/pause_dark.svg" : "../../assets/icons/controls/pause.svg"
            fillMode: Image.PreserveAspectFit
            mipmap: true
            smooth: true
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                mediaRoot.isPaused = true;
                mediaRoot.isPlaying = false;
                mediaRoot.isStopped = false;
                mediaRoot.pauseClicked();
            }
        }
    }

    // 3. Industrial PLAY Button
    Rectangle {
        id: playBtn
        Layout.preferredWidth: 44
        Layout.preferredHeight: 44
        radius: 4
        color: mediaRoot.isPlaying ? "#78dc20" : "#0c3359"
        border.color: mediaRoot.isPlaying ? "#ffffff" : "#1a5286"
        border.width: 1

        Image {
            anchors.centerIn: parent
            width: 22
            height: 22
            source: mediaRoot.isPlaying ? "../../assets/icons/controls/start_dark.svg" : "../../assets/icons/controls/start.svg"
            fillMode: Image.PreserveAspectFit
            mipmap: true
            smooth: true
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                mediaRoot.isPlaying = true;
                mediaRoot.isPaused = false;
                mediaRoot.isStopped = false;
                mediaRoot.playClicked();
            }
        }
    }
}
