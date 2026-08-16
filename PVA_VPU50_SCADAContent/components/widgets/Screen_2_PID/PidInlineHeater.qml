import QtQuick
import QtQuick.Shapes

Item {
    id: heaterRoot
    width: 32
    height: 48

    property string tag: "W 168 001"
    property bool isHeating: false
    property bool showTags: true

    signal clicked()

    // 1. INLINE HEATER HOUSING (AutoCAD In-line Red Vessel / Heater M Symbol)
    Rectangle {
        id: heaterCircle
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 4
        width: 24
        height: 24
        radius: width / 2
        color: heaterRoot.isHeating ? "#450a0a" : "#08213b"
        border.color: heaterRoot.isHeating ? "#f43f5e" : "#ef4444"
        border.width: 1.6

        // Internal Red Electric Heating M / Chevron Symbol
        Shape {
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                strokeWidth: 1.8
                strokeColor: heaterRoot.isHeating ? "#fda4af" : "#ef4444"
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                joinStyle: ShapePath.MiterJoin

                startX: 6; startY: 18
                PathLine { x: 6; y: 7 }
                PathLine { x: 12; y: 15 }
                PathLine { x: 18; y: 7 }
                PathLine { x: 18; y: 18 }
            }
        }

        // Active heating pulse glow
        SequentialAnimation on opacity {
            running: heaterRoot.isHeating
            loops: Animation.Infinite
            NumberAnimation { to: 0.7; duration: 500 }
            NumberAnimation { to: 1.0; duration: 500 }
        }
    }

    // 2. TAG LABEL
    Text {
        visible: heaterRoot.showTags
        anchors.top: heaterCircle.bottom
        anchors.topMargin: 2
        anchors.horizontalCenter: heaterCircle.horizontalCenter
        text: heaterRoot.tag
        color: "#8cb5dc"
        font.pixelSize: 7
        font.bold: true
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: heaterRoot.clicked()
    }
}
