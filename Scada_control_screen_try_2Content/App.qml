import QtQuick
import Scada_control_screen_try_2

Window {
    id: appWindow
    width: 1280
    height: 720
    visible: true
    title: "PVA Systems - VPU 50 Industrial SCADA Control System"
    color: "#08213b"

    Main_frame_screen {
        id: mainScreen
        anchors.fill: parent
    }
}
