import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: playbackContainer
    Layout.fillWidth: true
    Layout.fillHeight: true

    Screen_7_PlaybackView {
        id: ui
        anchors.fill: parent
    }

    Timer {
        interval: 200
        running: ui.isPlaying
        repeat: true
        onTriggered: {
            ui.playbackPos += 0.005;
            if (ui.playbackPos >= 1.0) {
                ui.playbackPos = 0.0;
                ui.isPlaying = false;
            }
        }
    }

    MouseArea {
        parent: ui.reportTabBtn
        anchors.fill: parent
        onClicked: ui.activeView = "report"
    }

    MouseArea {
        parent: ui.playbackTabBtn
        anchors.fill: parent
        onClicked: ui.activeView = "playback"
    }

    MouseArea {
        parent: ui.playPauseBtn
        anchors.fill: parent
        onClicked: ui.isPlaying = !ui.isPlaying
    }

    MouseArea {
        parent: ui.resetScrubberBtn
        anchors.fill: parent
        onClicked: {
            ui.playbackPos = 0.0;
            ui.isPlaying = false;
        }
    }
}
