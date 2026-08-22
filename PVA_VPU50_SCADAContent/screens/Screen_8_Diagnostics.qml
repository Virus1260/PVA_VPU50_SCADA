import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: maintContainer
    Layout.fillWidth: true
    Layout.fillHeight: true

    Screen_8_DiagnosticsView {
        id: ui
        anchors.fill: parent
    }
}
