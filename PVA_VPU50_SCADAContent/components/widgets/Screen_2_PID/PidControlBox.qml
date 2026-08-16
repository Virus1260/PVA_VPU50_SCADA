import QtQuick
import QtQuick.Layouts

Rectangle {
    id: controlBoxRoot
    width: 148
    implicitHeight: mainCol.implicitHeight + 14
    height: implicitHeight
    color: "#091c30"
    border.color: accentColor
    border.width: 1.2
    radius: 6

    property string title: "PID Control"
    property string tag: ""
    property color accentColor: "#38bdf8"
    property bool showTags: true

    // Progressive Row 1 (Required by default)
    property string row1Label: "SP:"
    property string row1Value: "95.0"
    property string row1Unit: "°C"
    property color row1Color: "#22c55e"

    // Progressive Row 2
    property string row2Label: "PV:"
    property string row2Value: "20.7"
    property string row2Unit: "°C"
    property color row2Color: "#38bdf8"

    // Progressive Row 3
    property string row3Label: ""
    property string row3Value: ""
    property string row3Unit: ""
    property color row3Color: "#cbd5e1"

    // Progressive Row 4
    property string row4Label: ""
    property string row4Value: ""
    property string row4Unit: ""
    property color row4Color: "#cbd5e1"

    // Progressive Row 5
    property string row5Label: ""
    property string row5Value: ""
    property string row5Unit: ""
    property color row5Color: "#cbd5e1"

    // Progressive Row 6
    property string row6Label: ""
    property string row6Value: ""
    property string row6Unit: ""
    property color row6Color: "#cbd5e1"

    ColumnLayout {
        id: mainCol
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 7
        spacing: 3

        // Header Title & Tag Badge
        RowLayout {
            Layout.fillWidth: true
            spacing: 4

            Rectangle {
                width: 6
                height: 6
                radius: 3
                color: controlBoxRoot.accentColor
            }

            Text {
                text: controlBoxRoot.title
                color: "#e2e8f0"
                font.bold: true
                font.pixelSize: 9
                Layout.fillWidth: true
                elide: Text.ElideRight
            }

            Text {
                visible: controlBoxRoot.tag !== "" && controlBoxRoot.showTags
                text: controlBoxRoot.tag
                color: controlBoxRoot.accentColor
                font.bold: true
                font.pixelSize: 8
            }
        }

        // Horizontal Separator
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: "#1e3a5f"
        }

        // Progressive Dynamic Data Grid (Automatically adjusts height per active row)
        GridLayout {
            Layout.fillWidth: true
            columns: 2
            rowSpacing: 2
            columnSpacing: 6

            // Row 1
            Text {
                visible: controlBoxRoot.row1Label !== ""
                text: controlBoxRoot.row1Label
                color: "#94a3b8"
                font.pixelSize: 9
            }
            Text {
                visible: controlBoxRoot.row1Label !== ""
                text: controlBoxRoot.row1Value + (controlBoxRoot.row1Unit !== "" ? " " + controlBoxRoot.row1Unit : "")
                color: controlBoxRoot.row1Color
                font.bold: true
                font.pixelSize: 9
                Layout.alignment: Qt.AlignRight
            }

            // Row 2
            Text {
                visible: controlBoxRoot.row2Label !== ""
                text: controlBoxRoot.row2Label
                color: "#94a3b8"
                font.pixelSize: 9
            }
            Text {
                visible: controlBoxRoot.row2Label !== ""
                text: controlBoxRoot.row2Value + (controlBoxRoot.row2Unit !== "" ? " " + controlBoxRoot.row2Unit : "")
                color: controlBoxRoot.row2Color
                font.bold: true
                font.pixelSize: 9
                Layout.alignment: Qt.AlignRight
            }

            // Row 3
            Text {
                visible: controlBoxRoot.row3Label !== ""
                text: controlBoxRoot.row3Label
                color: "#94a3b8"
                font.pixelSize: 9
            }
            Text {
                visible: controlBoxRoot.row3Label !== ""
                text: controlBoxRoot.row3Value + (controlBoxRoot.row3Unit !== "" ? " " + controlBoxRoot.row3Unit : "")
                color: controlBoxRoot.row3Color
                font.bold: true
                font.pixelSize: 9
                Layout.alignment: Qt.AlignRight
            }

            // Row 4
            Text {
                visible: controlBoxRoot.row4Label !== ""
                text: controlBoxRoot.row4Label
                color: "#94a3b8"
                font.pixelSize: 9
            }
            Text {
                visible: controlBoxRoot.row4Label !== ""
                text: controlBoxRoot.row4Value + (controlBoxRoot.row4Unit !== "" ? " " + controlBoxRoot.row4Unit : "")
                color: controlBoxRoot.row4Color
                font.bold: true
                font.pixelSize: 9
                Layout.alignment: Qt.AlignRight
            }

            // Row 5
            Text {
                visible: controlBoxRoot.row5Label !== ""
                text: controlBoxRoot.row5Label
                color: "#94a3b8"
                font.pixelSize: 9
            }
            Text {
                visible: controlBoxRoot.row5Label !== ""
                text: controlBoxRoot.row5Value + (controlBoxRoot.row5Unit !== "" ? " " + controlBoxRoot.row5Unit : "")
                color: controlBoxRoot.row5Color
                font.bold: true
                font.pixelSize: 9
                Layout.alignment: Qt.AlignRight
            }

            // Row 6
            Text {
                visible: controlBoxRoot.row6Label !== ""
                text: controlBoxRoot.row6Label
                color: "#94a3b8"
                font.pixelSize: 9
            }
            Text {
                visible: controlBoxRoot.row6Label !== ""
                text: controlBoxRoot.row6Value + (controlBoxRoot.row6Unit !== "" ? " " + controlBoxRoot.row6Unit : "")
                color: controlBoxRoot.row6Color
                font.bold: true
                font.pixelSize: 9
                Layout.alignment: Qt.AlignRight
            }
        }
    }
}
