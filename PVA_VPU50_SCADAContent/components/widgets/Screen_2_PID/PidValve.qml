import QtQuick

Item {
    id: valveRoot
    width: 28
    height: 28

    property string tag: "V101"
    property string subLabel: ""
    property bool isOpen: false
    property bool isVertical: false
    property bool isSolenoid: true

    signal clicked()

    Canvas {
        id: valveCanvas
        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            var cx = width / 2;
            var cy = height / 2;
            var fill = valveRoot.isOpen ? "#15803d" : "#092647";
            var stroke = valveRoot.isOpen ? "#4ade80" : "#38bdf8";

            if (valveRoot.isVertical) {
                // Top Triangle
                ctx.beginPath();
                ctx.moveTo(cx - 6, cy - 7);
                ctx.lineTo(cx + 6, cy - 7);
                ctx.lineTo(cx, cy);
                ctx.closePath();
                ctx.fillStyle = fill;
                ctx.fill();
                ctx.strokeStyle = stroke;
                ctx.lineWidth = 1.2;
                ctx.stroke();

                // Bottom Triangle
                ctx.beginPath();
                ctx.moveTo(cx - 6, cy + 7);
                ctx.lineTo(cx + 6, cy + 7);
                ctx.lineTo(cx, cy);
                ctx.closePath();
                ctx.fillStyle = fill;
                ctx.fill();
                ctx.stroke();
            } else {
                // Left Triangle
                ctx.beginPath();
                ctx.moveTo(cx - 7, cy - 6);
                ctx.lineTo(cx - 7, cy + 6);
                ctx.lineTo(cx, cy);
                ctx.closePath();
                ctx.fillStyle = fill;
                ctx.fill();
                ctx.strokeStyle = stroke;
                ctx.lineWidth = 1.2;
                ctx.stroke();

                // Right Triangle
                ctx.beginPath();
                ctx.moveTo(cx + 7, cy - 6);
                ctx.lineTo(cx + 7, cy + 6);
                ctx.lineTo(cx, cy);
                ctx.closePath();
                ctx.fillStyle = fill;
                ctx.fill();
                ctx.stroke();
            }
        }
    }

    Connections {
        target: valveRoot
        function onIsOpenChanged() { valveCanvas.requestPaint(); }
        function onIsVerticalChanged() { valveCanvas.requestPaint(); }
    }

    // Tag Label
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.top
        anchors.bottomMargin: 1
        text: valveRoot.tag
        color: valveRoot.isOpen ? "#4ade80" : "#93c5fd"
        font.pixelSize: 8
        font.bold: valveRoot.isOpen
    }

    // Sub-Label
    Text {
        visible: valveRoot.subLabel.length > 0
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
        anchors.topMargin: 1
        text: valveRoot.subLabel
        color: "#cbd5e1"
        font.pixelSize: 7
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: valveRoot.clicked()
    }
}
