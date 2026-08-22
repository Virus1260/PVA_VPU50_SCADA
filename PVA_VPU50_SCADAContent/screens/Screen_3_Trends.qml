import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../config"

Item {
    id: trendsContainer
    Layout.fillWidth: true
    Layout.fillHeight: true

    ScadaStateMiddleware { id: stateMiddleware }

    property var telemetryHistory: []
    property real inspectX: -1
    property real zoomStart: 0.0
    property real zoomEnd: 1.0
    property bool isZoomed: false

    // Active sensor flags map (0 to 14)
    property var activeSensors: [true, true, false, false, false, true, false, false, true, false, true, false, false, false, false]

    Screen_3_TrendsView {
        id: ui
        anchors.fill: parent
        activeMode: "chart"
        isZoomed: trendsContainer.isZoomed
        telemetryList.model: trendsContainer.telemetryHistory
    }

    // Dynamic Unit Title Calculation
    function updateYAxisTitle() {
        var activeCount = 0;
        var activeUnits = [];
        var activeNames = [];

        var sensorModel = ui.sensorListViewItem.model;
        if (!sensorModel) return;

        for (var i = 0; i < sensorModel.count; i++) {
            var item = sensorModel.get(i);
            if (item.active) {
                activeCount++;
                if (activeUnits.indexOf(item.unit) === -1) {
                    activeUnits.push(item.unit);
                }
                activeNames.push(item.tag);
            }
        }

        if (activeCount === 0) {
            ui.yAxisTitle = "No Sensors Selected";
        } else if (activeCount === 1) {
            var singleItem = null;
            for (var j = 0; j < sensorModel.count; j++) {
                if (sensorModel.get(j).active) { singleItem = sensorModel.get(j); break; }
            }
            if (singleItem) {
                ui.yAxisTitle = singleItem.tag + " (" + singleItem.unit + ") [Range: " + singleItem.rangeMin + " to " + singleItem.rangeMax + " " + singleItem.unit + "]";
            }
        } else if (activeUnits.length === 1) {
            ui.yAxisTitle = "All Selected Sensors (" + activeUnits[0] + ")";
        } else {
            ui.yAxisTitle = "Multi-Variable Process View (% Engineering Scaled)";
        }
        ui.trendCanvasItem.requestPaint();
    }

    // Chart Mode Toggle Handlers
    MouseArea {
        parent: ui.chartModeBtn
        anchors.fill: parent
        onClicked: ui.activeMode = "chart"
    }

    MouseArea {
        parent: ui.tableModeBtn
        anchors.fill: parent
        onClicked: ui.activeMode = "table"
    }

    MouseArea {
        parent: ui.resetZoomBtn
        anchors.fill: parent
        onClicked: {
            trendsContainer.zoomStart = 0.0;
            trendsContainer.zoomEnd = 1.0;
            trendsContainer.isZoomed = false;
            ui.dragBoxOverlay.visible = false;
            ui.trendCanvasItem.requestPaint();
        }
    }

    // Select All / Deselect All
    MouseArea {
        parent: ui.selectAllSensorsBtn
        anchors.fill: parent
        onClicked: {
            var model = ui.sensorListViewItem.model;
            for (var i = 0; i < model.count; i++) {
                model.setProperty(i, "active", true);
            }
            updateYAxisTitle();
        }
    }

    MouseArea {
        parent: ui.deselectAllSensorsBtn
        anchors.fill: parent
        onClicked: {
            var model = ui.sensorListViewItem.model;
            for (var i = 0; i < model.count; i++) {
                model.setProperty(i, "active", false);
            }
            updateYAxisTitle();
        }
    }

    // Sensor Item Click Toggling via MouseArea over the ListView
    MouseArea {
        parent: ui.sensorListViewItem
        anchors.fill: parent
        onClicked: function(mouse) {
            var idx = ui.sensorListViewItem.indexAt(mouse.x, mouse.y + ui.sensorListViewItem.contentY);
            var model = ui.sensorListViewItem.model;
            if (model && idx >= 0 && idx < model.count) {
                var cur = model.get(idx).active;
                model.setProperty(idx, "active", !cur);
                updateYAxisTitle();
            }
        }
    }

    // Real-Time Sampler
    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: {
            var buf = trendsContainer.telemetryHistory.slice(-80);
            var now = new Date();
            var timeStr = now.toTimeString().split(' ')[0];
            buf.push({
                time: timeStr,
                temp: stateMiddleware.vesselTemp + (Math.random() * 0.4 - 0.2),
                jacket: stateMiddleware.vesselTemp + 12.5 + (Math.random() * 0.6 - 0.3),
                vacuum: stateMiddleware.vacuumPressure + (Math.random() * 2.0 - 1.0),
                agitator: stateMiddleware.agitatorSpeed + (Math.random() * 0.4 - 0.2),
                homo: stateMiddleware.homogenizerSpeed + (Math.random() * 10.0 - 5.0)
            });
            trendsContainer.telemetryHistory = buf;
            ui.trendCanvasItem.requestPaint();
        }
    }

    Component.onCompleted: {
        var initial = [];
        for (var i = 0; i < 40; i++) {
            initial.push({
                time: "09:" + String(10 + Math.floor(i / 2)).padStart(2, '0') + ":" + String((i % 2) * 30).padStart(2, '0'),
                temp: 24.5 + (i / 40.0) * 55.0,
                jacket: 28.0 + (i / 40.0) * 58.0,
                vacuum: -5.0 - (i / 40.0) * 445.0,
                agitator: i > 5 ? 35.0 : 0.0,
                homo: i > 20 ? 3200.0 : 0.0
            });
        }
        telemetryHistory = initial;
        updateYAxisTitle();

        // Connect Canvas Paint
        ui.trendCanvasItem.paint.connect(function() {
            var ctx = ui.trendCanvasItem.getContext("2d");
            ctx.clearRect(0, 0, ui.trendCanvasItem.width, ui.trendCanvasItem.height);

            var w = ui.trendCanvasItem.width - 90;
            var h = ui.trendCanvasItem.height - 50;
            var ox = 70;
            var oy = 15;

            // Grid Lines & Dynamic Y-Axis Labels
            ctx.strokeStyle = "#0d2f52";
            ctx.lineWidth = 1;

            var sensorModel = ui.sensorListViewItem.model;
            var activeCount = 0;
            var singleItem = null;
            if (sensorModel) {
                for (var s = 0; s < sensorModel.count; s++) {
                    if (sensorModel.get(s).active) {
                        activeCount++;
                        singleItem = sensorModel.get(s);
                    }
                }
            }

            for (var i = 0; i <= 5; i++) {
                var y = oy + (h / 5) * i;
                ctx.beginPath();
                ctx.moveTo(ox, y);
                ctx.lineTo(ox + w, y);
                ctx.stroke();

                ctx.fillStyle = "#94a3b8";
                ctx.font = "bold 11px sans-serif";

                var label = "";
                if (activeCount === 1 && singleItem) {
                    var rMin = singleItem.rangeMin;
                    var rMax = singleItem.rangeMax;
                    var v = rMax - (i / 5.0) * (rMax - rMin);
                    label = (v % 1 === 0 ? v.toFixed(0) : v.toFixed(1)) + " " + singleItem.unit;
                } else if (ui.yAxisTitle.indexOf("All Selected Sensors (°C)") !== -1) {
                    label = String(100 - i * 20) + "°C";
                } else {
                    label = String(100 - i * 20) + "%";
                }
                ctx.fillText(label, 8, y + 4);
            }

            // X-Axis Time Ticks
            var data = trendsContainer.telemetryHistory;
            if (data.length < 2) return;

            var startIndex = Math.floor(data.length * trendsContainer.zoomStart);
            var endIndex = Math.min(data.length, Math.ceil(data.length * trendsContainer.zoomEnd));
            var count = Math.max(2, endIndex - startIndex);

            // Draw X-axis timestamps
            ctx.fillStyle = "#64748b";
            ctx.font = "bold 10px sans-serif";
            var stepX = Math.max(1, Math.floor(count / 5));
            for (var k = 0; k < count; k += stepX) {
                var ptX = data[startIndex + k];
                if (ptX) {
                    var pxTime = ox + (w / (count - 1)) * k;
                    ctx.fillText(ptX.time, pxTime - 18, oy + h + 20);
                }
            }

            function drawCurve(prop, color, minV, maxV) {
                ctx.strokeStyle = color;
                ctx.lineWidth = 2.4;
                ctx.beginPath();
                for (var j = 0; j < count; j++) {
                    var pt = data[startIndex + j];
                    var val = pt[prop];
                    var normY = 1.0 - Math.max(0.0, Math.min(1.0, (val - minV) / (maxV - minV)));
                    var px = ox + (w / (count - 1)) * j;
                    var py = oy + normY * h;
                    if (j === 0) ctx.moveTo(px, py);
                    else ctx.lineTo(px, py);
                }
                ctx.stroke();
            }

            if (sensorModel) {
                if (sensorModel.get(0).active) drawCurve("temp", "#38bdf8", 0, 100);
                if (sensorModel.get(1).active) drawCurve("jacket", "#f97316", 0, 100);
                if (sensorModel.get(5).active) drawCurve("vacuum", "#c084fc", -1000, 0);
                if (sensorModel.get(8).active) drawCurve("agitator", "#22c55e", 0, 60);
                if (sensorModel.get(10).active) drawCurve("homo", "#eab308", 0, 6000);
            }

            // Inspection Crosshair
            if (trendsContainer.inspectX >= ox && trendsContainer.inspectX <= ox + w) {
                ctx.strokeStyle = "#f59e0b";
                ctx.lineWidth = 1.6;
                ctx.setLineDash([4, 2]);
                ctx.beginPath();
                ctx.moveTo(trendsContainer.inspectX, oy);
                ctx.lineTo(trendsContainer.inspectX, oy + h);
                ctx.stroke();
                ctx.setLineDash([]);
            }
        });
    }

    // MouseArea on Canvas for Hover Inspection & Real-Time Drag Box Zooming
    MouseArea {
        parent: ui.trendCanvasItem
        anchors.fill: parent
        hoverEnabled: true
        property real dragStartX: 0
        property real dragStartY: 0
        property bool isDragging: false

        onPositionChanged: function(mouse) {
            trendsContainer.inspectX = mouse.x;
            var w = parent.width - 90;
            var ox = 70;
            var oy = 15;
            var h = parent.height - 50;

            if (isDragging) {
                ui.dragBoxOverlay.visible = true;
                ui.dragBoxOverlay.x = Math.max(ox, Math.min(dragStartX, mouse.x));
                ui.dragBoxOverlay.y = oy;
                ui.dragBoxOverlay.width = Math.abs(mouse.x - dragStartX);
                ui.dragBoxOverlay.height = h;
            } else if (mouse.x >= ox && mouse.x <= ox + w) {
                var ratio = (mouse.x - ox) / w;
                var idx = Math.floor(trendsContainer.telemetryHistory.length * ratio);
                if (idx >= 0 && idx < trendsContainer.telemetryHistory.length) {
                    ui.inspectCardItem.visible = true;
                    ui.inspectCardItem.x = Math.min(parent.width - ui.inspectCardItem.width - 10, Math.max(ox, mouse.x + 10));
                    ui.inspectCardItem.y = 15;
                }
            } else {
                ui.inspectCardItem.visible = false;
            }
            ui.trendCanvasItem.requestPaint();
        }

        onExited: {
            ui.inspectCardItem.visible = false;
            trendsContainer.inspectX = -1;
            ui.trendCanvasItem.requestPaint();
        }

        onPressed: function(mouse) {
            dragStartX = mouse.x;
            dragStartY = mouse.y;
            isDragging = true;
        }

        onReleased: function(mouse) {
            ui.dragBoxOverlay.visible = false;
            if (isDragging && Math.abs(mouse.x - dragStartX) > 25) {
                var ox = 70;
                var w = parent.width - 90;
                var r1 = Math.max(0.0, Math.min(1.0, (Math.min(dragStartX, mouse.x) - ox) / w));
                var r2 = Math.max(0.0, Math.min(1.0, (Math.max(dragStartX, mouse.x) - ox) / w));
                trendsContainer.zoomStart = r1;
                trendsContainer.zoomEnd = r2;
                trendsContainer.isZoomed = true;
            }
            isDragging = false;
            ui.trendCanvasItem.requestPaint();
        }
    }
}
