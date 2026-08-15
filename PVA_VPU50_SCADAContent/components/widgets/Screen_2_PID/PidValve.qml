import QtQuick

Item {
    id: valveRoot
    width: 32
    height: 32

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
            var fill = valveRoot.isOpen ? "#166534" : "#0d2847";
            var stroke = valveRoot.isOpen ? "#4ade80" : "#4a90d9";

            if (valveRoot.isVertical) {
                // Vertical Valve Triangles
                ctx.beginPath();
                ctx.moveTo(cx - 7, cy - 8);
                ctx.lineTo(cx + 7, cy - 8);
                ctx.lineTo(cx, cy);
                ctx.closePath();
                ctx.fillStyle = fill;
                ctx.fill();
                ctx.strokeStyle = stroke;
                ctx.lineWidth = 1.2;
                ctx.stroke();

                ctx.beginPath();
                ctx.moveTo(cx - 7, cy + 8);
                ctx.lineTo(cx + 7, cy + 8);
                ctx.lineTo(cx, cy);
                ctx.closePath();
                ctx.fillStyle = fill;
                ctx.fill();
                ctx.stroke();

                // Center Actuator Stem
                ctx.beginPath();
                ctx.moveTo(cx - 9, cy);
                ctx.lineTo(cx + 9, cy);
                ctx.strokeStyle = stroke;
                ctx.lineWidth = 1.5;
                ctx.stroke();
            } else {
                // Horizontal Valve Triangles
                ctx.beginPath();
                ctx.moveTo(cx - 8, cy - 7);
                ctx.lineTo(cx - 8, cy + 7);
                ctx.lineTo(cx, cy);
                ctx.closePath();
                ctx.fillStyle = fill;
                ctx.fill();
                ctx.strokeStyle = stroke;
                ctx.lineWidth = 1.2;
                ctx.stroke();

                ctx.beginPath();
                ctx.moveTo(cx + 8, cy - 7);
                ctx.lineTo(cx + 8, cy + 7);
                ctx.lineTo(cx, cy);
                ctx.closePath();
                ctx.fillStyle = fill;
                ctx.fill();
                ctx.stroke();

                // Center Actuator Stem
                ctx.beginPath();
                ctx.moveTo(cx, cy - 8);
                ctx.lineTo(cx, cy + 8);
                ctx.strokeStyle = stroke;
                ctx.lineWidth = 1.5;
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
        anchors.bottomMargin: 2
        text: valveRoot.tag
        color: valveRoot.isOpen ? "#4ade80" : "#8cb5dc"
        font.pixelSize: 10
        font.bold: valveRoot.isOpen
    }

    // Optional Sub-Label (e.g. "Solids", "Liquids", "Bottom")
    Text {
        visible: valveRoot.subLabel.length > 0
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
        anchors.topMargin: 2
        text: valveRoot.subLabel
        color: "#94a3b8"
        font.pixelSize: 9
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: valveRoot.clicked()
    }
}
