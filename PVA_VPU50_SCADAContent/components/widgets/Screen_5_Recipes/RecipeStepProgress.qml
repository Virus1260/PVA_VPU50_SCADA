import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: stepProgressRoot
    color: "#06182c"
    border.color: "#184d7e"
    border.width: 1
    radius: 6
    clip: true

    property var steps: []
    property int currentStepIndex: 3

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8

        Text {
            text: "RECIPE SEQUENCE PROGRESSION"
            color: "#38bdf8"
            font.bold: true
            font.pixelSize: 12
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: stepProgressRoot.steps
            spacing: 4
            clip: true

            delegate: Rectangle {
                width: parent.width
                height: 42
                radius: 5
                color: modelData.status === "ACTIVE" ? "#0f3a64" : (modelData.status === "DONE" ? "#06231a" : "#092440")
                border.color: modelData.status === "ACTIVE" ? "#00d2ff" : (modelData.status === "DONE" ? "#22c55e" : "#164673")
                border.width: modelData.status === "ACTIVE" ? 2 : 1

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    spacing: 10

                    Text { text: "Step " + modelData.id; color: "#38bdf8"; font.bold: true; font.pixelSize: 12; Layout.preferredWidth: 50 }
                    Text { text: modelData.name; color: "#ffffff"; font.bold: true; font.pixelSize: 12; Layout.preferredWidth: 160; elide: Text.ElideRight }
                    Text { text: modelData.desc; color: "#94a3b8"; font.pixelSize: 11; Layout.fillWidth: true; elide: Text.ElideRight }
                    Text {
                        text: modelData.status
                        color: modelData.status === "DONE" ? "#4ade80" : (modelData.status === "ACTIVE" ? "#38bdf8" : "#64748b")
                        font.bold: true
                        font.pixelSize: 11
                        Layout.preferredWidth: 60
                        horizontalAlignment: Text.AlignRight
                    }
                }
            }
        }
    }
}
