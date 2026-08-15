import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: ingTableRoot
    color: "#06182c"
    border.color: "#184d7e"
    border.width: 1
    radius: 6
    clip: true

    property var ingredients: []

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8

        Text {
            text: "FORMULATION INGREDIENTS (BOM)"
            color: "#38bdf8"
            font.bold: true
            font.pixelSize: 12
        }

        // Table Header
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 26
            color: "#0d2847"
            radius: 3

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                spacing: 8

                Text { text: "#"; color: "#6b8fbb"; font.bold: true; font.pixelSize: 10; Layout.preferredWidth: 24 }
                Text { text: "Ingredient"; color: "#6b8fbb"; font.bold: true; font.pixelSize: 10; Layout.fillWidth: true }
                Text { text: "Phase"; color: "#6b8fbb"; font.bold: true; font.pixelSize: 10; Layout.preferredWidth: 44; horizontalAlignment: Text.AlignHCenter }
                Text { text: "Qty"; color: "#6b8fbb"; font.bold: true; font.pixelSize: 10; Layout.preferredWidth: 64; horizontalAlignment: Text.AlignRight }
            }
        }

        // Ingredients List
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: ingTableRoot.ingredients
            spacing: 3
            clip: true

            delegate: Rectangle {
                width: parent.width
                height: 30
                color: index % 2 === 0 ? "#092440" : "#071b30"
                border.color: "#164673"
                border.width: 1
                radius: 3

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8
                    spacing: 8

                    Text { text: modelData.sr; color: "#94a3b8"; font.pixelSize: 11; Layout.preferredWidth: 24 }
                    Text { text: modelData.name; color: "#ffffff"; font.bold: true; font.pixelSize: 11; Layout.fillWidth: true; elide: Text.ElideRight }
                    Rectangle {
                        Layout.preferredWidth: 34
                        Layout.preferredHeight: 18
                        radius: 3
                        color: modelData.phase === "A" ? "#1e3a8a" : (modelData.phase === "B" ? "#7c2d12" : (modelData.phase === "C" ? "#14532d" : "#581c87"))
                        Text { anchors.centerIn: parent; text: "Ph " + modelData.phase; color: "#ffffff"; font.bold: true; font.pixelSize: 9 }
                    }
                    Text { text: modelData.qty; color: "#4ade80"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 64; horizontalAlignment: Text.AlignRight }
                }
            }
        }
    }
}
