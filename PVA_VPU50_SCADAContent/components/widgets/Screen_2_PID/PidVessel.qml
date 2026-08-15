import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes

Item {
    id: vesselRoot
    width: 360
    height: 440

    property string vesselName: "Unimix 50"
    property real levelPercent: 65.0
    property real vesselTemp: 20.7
    property real jacketTemp: 21.2
    property real vacuumPressure: -179.0
    property real weightKg: 154.4
    property bool isHeating: false
    property bool isCooling: false
    property bool showTags: true

    // 1. CONCENTRIC THERMAL JACKET (Wrapping lower shell & bottom dish snugly)
    Shape {
        id: jacketShape
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            strokeWidth: 1.6
            strokeColor: "#1b4c7c"
            fillColor: vesselRoot.isHeating ? "#e06c28" : (vesselRoot.isCooling ? "#0284c7" : "#5b95c9")
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin

            startX: 38; startY: 120
            PathLine { x: 38; y: 310 }
            PathCubic { control1X: 38; control1Y: 336; control2X: 125; control2Y: 360; x: 157; y: 360 }
            PathLine { x: 203; y: 360 }
            PathCubic { control1X: 235; control1Y: 360; control2X: 322; control2Y: 336; x: 322; y: 310 }
            PathLine { x: 322; y: 120 }
            PathLine { x: 310; y: 120 }
            PathLine { x: 310; y: 310 }
            PathCubic { control1X: 310; control1Y: 334; control2X: 235; control2Y: 348; x: 203; y: 348 }
            PathLine { x: 157; y: 348 }
            PathCubic { control1X: 125; control1Y: 348; control2X: 50; control2Y: 334; x: 50; y: 310 }
            PathLine { x: 50; y: 120 }
            PathLine { x: 38; y: 120 }
        }
    }

    // 2. MAIN SOLID SKY-BLUE VESSEL BODY (DIN 28011 Torispherical Profile)
    Shape {
        id: vesselBodyShape
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            strokeWidth: 2.2
            strokeColor: "#1b4c7c"
            fillColor: "#79b2e2"
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin

            startX: 50; startY: 65
            // (A) Top Torispherical Dome
            PathCubic { control1X: 50; control1Y: 41; control2X: 105; control2Y: 28; x: 180; y: 28 }
            PathCubic { control1X: 255; control1Y: 28; control2X: 310; control2Y: 41; x: 310; y: 65 }
            // (B) Cylindrical Shell Walls
            PathLine { x: 310; y: 310 }
            // (C) Bottom Torispherical Dish to Bottom Neck
            PathCubic { control1X: 310; control1Y: 334; control2X: 235; control2Y: 348; x: 203; y: 348 }
            PathLine { x: 157; y: 348 }
            PathCubic { control1X: 125; control1Y: 348; control2X: 50; control2Y: 334; x: 50; y: 310 }
            PathLine { x: 50; y: 65 }
        }

        // Top Seam Line
        ShapePath {
            strokeWidth: 1.2
            strokeColor: "#1b4c7c"
            fillColor: "transparent"
            startX: 50; startY: 65
            PathLine { x: 310; y: 65 }
        }
    }

    // -------------------------------------------------------------------------
    // 3. TELEMETRY BADGES
    // -------------------------------------------------------------------------
    // Product Temperature (TIC 162001) - Top-Left Dome
    Rectangle {
        anchors.left: parent.left
        anchors.leftMargin: 55
        anchors.top: parent.top
        anchors.topMargin: 38
        width: 72
        height: 24
        radius: 3
        color: "#0b2e54"
        border.color: "#1d609e"
        border.width: 1
        visible: vesselRoot.showTags

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 0
            Text { text: "TIC 162001"; color: "#8cb5dc"; font.pixelSize: 7; font.bold: true; Layout.alignment: Qt.AlignHCenter }
            Text { text: vesselRoot.vesselTemp.toFixed(1) + "°C"; color: "#ffffff"; font.bold: true; font.pixelSize: 8; Layout.alignment: Qt.AlignHCenter }
        }
    }

    // Jacket Temperature (TIC 163001) - Lower-Left Dish with Leader Line
    Canvas {
        anchors.fill: parent
        visible: vesselRoot.showTags
        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);
            ctx.beginPath();
            ctx.moveTo(15, 335);
            ctx.lineTo(65, 328);
            ctx.strokeStyle = "#38bdf8";
            ctx.lineWidth = 1.5;
            ctx.stroke();
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.leftMargin: -65
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 95
        width: 74
        height: 24
        radius: 3
        color: "#0b2e54"
        border.color: "#1d609e"
        border.width: 1
        visible: vesselRoot.showTags

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 0
            Text { text: "TIC 163001"; color: "#8cb5dc"; font.pixelSize: 7; font.bold: true; Layout.alignment: Qt.AlignHCenter }
            Text { text: vesselRoot.jacketTemp.toFixed(1) + "°C"; color: "#38bdf8"; font.bold: true; font.pixelSize: 8; Layout.alignment: Qt.AlignHCenter }
        }
    }

    // Weight Indicator (WIRAH 161001) - Right Vessel Wall Load Cell Bracket
    Item {
        anchors.right: parent.right
        anchors.rightMargin: -65
        anchors.top: parent.top
        anchors.topMargin: 235
        width: 86
        height: 28
        visible: vesselRoot.showTags

        // Load Cell Bracket
        Rectangle {
            anchors.left: parent.left
            anchors.leftMargin: -10
            anchors.verticalCenter: parent.verticalCenter
            width: 12
            height: 12
            color: "#1e293b"
            border.color: "#64748b"
            border.width: 1.2
            radius: 2
        }

        // Telemetry Badge
        Rectangle {
            anchors.fill: parent
            radius: 3
            color: "#0b2e54"
            border.color: "#1d609e"
            border.width: 1

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 0
                Text { text: "WIRAH 161001"; color: "#8cb5dc"; font.pixelSize: 7; font.bold: true; Layout.alignment: Qt.AlignHCenter }
                Text { text: vesselRoot.weightKg.toFixed(1) + "kg"; color: "#38bdf8"; font.bold: true; font.pixelSize: 8; Layout.alignment: Qt.AlignHCenter }
            }
        }
    }
}
