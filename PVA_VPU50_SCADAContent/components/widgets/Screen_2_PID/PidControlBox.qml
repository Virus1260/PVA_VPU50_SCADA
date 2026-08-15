import QtQuick
import QtQuick.Layouts

Rectangle {
    id: controlBoxRoot
    width: 140
    height: 95
    color: "#091a2a"
    border.color: "#184d7e"
    border.width: 1
    radius: 6

    property real setpointTemp: 95.0
    property real gradientSp: 20.7
    property real processVal: 20.7
    property real lmnP: 0.0
    property real lmnI: 0.0

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 2

        RowLayout {
            spacing: 4
            Text { text: "⚙"; color: "#38bdf8"; font.pixelSize: 10 }
            Text { text: "PID Control"; color: "#8cb5dc"; font.bold: true; font.pixelSize: 10 }
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: "#184d7e" }

        Grid {
            columns: 2
            spacing: 4
            Text { text: "SP:"; color: "#64748b"; font.pixelSize: 9 }
            Text { text: controlBoxRoot.setpointTemp.toFixed(1) + " °C"; color: "#22c55e"; font.bold: true; font.pixelSize: 9 }

            Text { text: "Gr.SP:"; color: "#64748b"; font.pixelSize: 9 }
            Text { text: controlBoxRoot.gradientSp.toFixed(1) + " °C"; color: "#cbd5e1"; font.pixelSize: 9 }

            Text { text: "PV:"; color: "#64748b"; font.pixelSize: 9 }
            Text { text: controlBoxRoot.processVal.toFixed(1) + " °C"; color: "#38bdf8"; font.bold: true; font.pixelSize: 9 }

            Text { text: "LMN P:"; color: "#64748b"; font.pixelSize: 9 }
            Text { text: controlBoxRoot.lmnP.toFixed(1) + " %"; color: "#cbd5e1"; font.pixelSize: 9 }
        }
    }
}
