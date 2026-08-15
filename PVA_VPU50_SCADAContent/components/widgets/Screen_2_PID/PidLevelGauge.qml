import QtQuick
import QtQuick.Layouts

Item {
    id: gaugeRoot
    width: 84
    height: 230

    property real levelPercent: 65.0
    property string tag: "X 165 503"
    property bool showTags: true

    // 1. TOP TAG BADGE (X 165 503)
    Text {
        id: tagLabel
        anchors.top: parent.top
        anchors.horizontalCenter: gaugePill.horizontalCenter
        text: gaugeRoot.tag
        color: "#8cb5dc"
        font.pixelSize: 8
        font.bold: true
        visible: gaugeRoot.showTags
    }

    // 2. SCALE LABELS (1000.0 to 0.0) ALONG LEFT SIDE
    Column {
        anchors.right: gaugePill.left
        anchors.rightMargin: 6
        anchors.top: gaugePill.top
        anchors.bottom: gaugePill.bottom
        anchors.topMargin: 6
        anchors.bottomMargin: 6
        spacing: (gaugePill.height - 12 - (5 * 10)) / 4

        Repeater {
            model: ["1000.0", "750.0", "500.0", "250.0", "0.0"]
            Text {
                text: modelData
                color: "#1e3a5f"
                font.pixelSize: 8
                font.bold: true
                font.family: "Arial"
            }
        }
    }

    // 3. MAIN CAPSULE PILL GAUGE (Elevated Z-Axis Over Agitator)
    Rectangle {
        id: gaugePill
        anchors.right: parent.right
        anchors.top: tagLabel.bottom
        anchors.topMargin: 4
        anchors.bottom: parent.bottom
        width: 28
        radius: 14
        color: "#082342"
        border.color: "#1d5b94"
        border.width: 1.5
        clip: true

        // Inner Shadow / Glow Rim
        Rectangle {
            anchors.fill: parent
            radius: 14
            color: "transparent"
            border.color: "#0f3a68"
            border.width: 1
        }

        // Center Scale Ticks (Dotted / Dashed Line)
        Canvas {
            anchors.fill: parent
            anchors.margins: 6
            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);
                var cx = width / 2;

                // Center dashed vertical guideline
                ctx.beginPath();
                ctx.setLineDash([2, 3]);
                ctx.moveTo(cx, 4);
                ctx.lineTo(cx, height - 4);
                ctx.strokeStyle = "#1d4ed8";
                ctx.lineWidth = 1;
                ctx.stroke();

                // Major horizontal tick marks (25%, 50%, 75%)
                ctx.setLineDash([]);
                for (var i = 1; i <= 3; ++i) {
                    var y = height * (i / 4.0);
                    ctx.beginPath();
                    ctx.moveTo(cx - 4, y);
                    ctx.lineTo(cx + 4, y);
                    ctx.strokeStyle = "#38bdf8";
                    ctx.lineWidth = 1;
                    ctx.stroke();
                }
            }
        }

        // Active Glowing Green Liquid Column
        Rectangle {
            id: liquidFill
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 1.5
            height: Math.max(0, (parent.height - 3) * (Math.max(0, Math.min(100, gaugeRoot.levelPercent)) / 100.0))
            radius: 13
            visible: height > 2

            gradient: Gradient {
                GradientStop { position: 0.0; color: "#4ade80" }
                GradientStop { position: 0.3; color: "#22c55e" }
                GradientStop { position: 1.0; color: "#15803d" }
            }

            Behavior on height {
                NumberAnimation { duration: 400; easing.type: Easing.OutQuad }
            }
        }
    }
}
