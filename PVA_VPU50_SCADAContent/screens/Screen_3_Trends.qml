import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../config"

Rectangle {
    id: trendsRoot
    color: "#08213b"

    readonly property double currentTemp: ScadaStateMiddleware.vesselTemp
    readonly property double currentPress: ScadaStateMiddleware.vacuumPressure
    readonly property double currentStirrer: ScadaStateMiddleware.agitatorSpeed
    readonly property double currentHomo: ScadaStateMiddleware.homogenizerSpeed

    property var tempHistory: []
    property var pressHistory: []
    property var speedHistory: []

    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: {
            var th = trendsRoot.tempHistory.slice(-60);
            th.push(trendsRoot.currentTemp + (Math.random() * 0.4 - 0.2));
            trendsRoot.tempHistory = th;

            var ph = trendsRoot.pressHistory.slice(-60);
            ph.push(trendsRoot.currentPress + (Math.random() * 2.0 - 1.0));
            trendsRoot.pressHistory = ph;

            var sh = trendsRoot.speedHistory.slice(-60);
            sh.push(trendsRoot.currentStirrer + (Math.random() * 0.5 - 0.25));
            trendsRoot.speedHistory = sh;

            trendCanvas.requestPaint();
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 10

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Text {
                text: "HISTORICAL & REAL-TIME PROCESS TRENDS"
                color: "#ffffff"
                font.bold: true
                font.pixelSize: 16
            }

            Item { Layout.fillWidth: true }

            RowLayout {
                spacing: 6
                Repeater {
                    model: ["15m", "1h", "8h", "24h", "Batch"]
                    delegate: Button {
                        text: modelData
                        Layout.preferredWidth: 50
                        Layout.preferredHeight: 30
                    }
                }
            }

            Button {
                text: "Export CSV"
                Layout.preferredHeight: 30
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#06182c"
            border.color: "#164673"
            border.width: 1
            radius: 4
            clip: true

            Canvas {
                id: trendCanvas
                anchors.fill: parent

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.clearRect(0, 0, width, height);

                    var w = width;
                    var h = height;

                    ctx.strokeStyle = "#0d2f52";
                    ctx.lineWidth = 1;

                    for (var gx = 50; gx < w; gx += 80) {
                        ctx.beginPath();
                        ctx.moveTo(gx, 0);
                        ctx.lineTo(gx, h - 30);
                        ctx.stroke();
                    }

                    for (var gy = 20; gy < h - 30; gy += 40) {
                        ctx.beginPath();
                        ctx.moveTo(50, gy);
                        ctx.lineTo(w, gy);
                        ctx.stroke();
                    }

                    // Temperature curve
                    if (trendsRoot.tempHistory.length > 1) {
                        ctx.strokeStyle = "#ff9100";
                        ctx.lineWidth = 2.5;
                        ctx.beginPath();
                        var pts = trendsRoot.tempHistory;
                        var stepX = (w - 60) / 60;
                        for (var i = 0; i < pts.length; i++) {
                            var px = 50 + i * stepX;
                            var py = (h - 40) - (pts[i] / 100.0) * (h - 60);
                            if (i === 0) ctx.moveTo(px, py);
                            else ctx.lineTo(px, py);
                        }
                        ctx.stroke();
                    }

                    // Pressure curve
                    if (trendsRoot.pressHistory.length > 1) {
                        ctx.strokeStyle = "#00e5ff";
                        ctx.lineWidth = 2.0;
                        ctx.beginPath();
                        var pts2 = trendsRoot.pressHistory;
                        var stepX2 = (w - 60) / 60;
                        for (var j = 0; j < pts2.length; j++) {
                            var px2 = 50 + j * stepX2;
                            var py2 = (h - 40) - (Math.abs(pts2[j]) / 600.0) * (h - 60);
                            if (j === 0) ctx.moveTo(px2, py2);
                            else ctx.lineTo(px2, py2);
                        }
                        ctx.stroke();
                    }

                    // Speed curve
                    if (trendsRoot.speedHistory.length > 1) {
                        ctx.strokeStyle = "#78dc24";
                        ctx.lineWidth = 2.0;
                        ctx.beginPath();
                        var pts3 = trendsRoot.speedHistory;
                        var stepX3 = (w - 60) / 60;
                        for (var k = 0; k < pts3.length; k++) {
                            var px3 = 50 + k * stepX3;
                            var py3 = (h - 40) - (pts3[k] / 150.0) * (h - 60);
                            if (k === 0) ctx.moveTo(px3, py3);
                            else ctx.lineTo(px3, py3);
                        }
                        ctx.stroke();
                    }
                }
            }

            RowLayout {
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.margins: 12
                spacing: 16

                Row {
                    spacing: 6
                    Rectangle { width: 12; height: 12; color: "#ff9100"; radius: 2; anchors.verticalCenter: parent.verticalCenter }
                    Text { text: "Temp TIC162001 (" + trendsRoot.currentTemp.toFixed(1) + " °C)"; color: "#ffffff"; font.pixelSize: 11 }
                }

                Row {
                    spacing: 6
                    Rectangle { width: 12; height: 12; color: "#00e5ff"; radius: 2; anchors.verticalCenter: parent.verticalCenter }
                    Text { text: "Press PIC161001 (" + trendsRoot.currentPress.toFixed(1) + " mbar)"; color: "#ffffff"; font.pixelSize: 11 }
                }

                Row {
                    spacing: 6
                    Rectangle { width: 12; height: 12; color: "#78dc24"; radius: 2; anchors.verticalCenter: parent.verticalCenter }
                    Text { text: "Stirrer 1M1501 (" + trendsRoot.currentStirrer.toFixed(1) + " rpm)"; color: "#ffffff"; font.pixelSize: 11 }
                }
            }
        }
    }
}
