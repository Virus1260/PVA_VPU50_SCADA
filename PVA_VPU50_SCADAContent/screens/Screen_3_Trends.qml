import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../config"

Item {
    id: trendsContainer
    Layout.fillWidth: true
    Layout.fillHeight: true

    ScadaStateMiddleware { id: stateMiddleware }

    property var persistentHistory: []
    property real inspectX: -1
    property real inspectY: -1
    property real zoomStartRatio: 0.0
    property real zoomEndRatio: 1.0
    property bool isZoomed: false
    property int timeWindowSamples: 60 // 60 samples = 5m at 5s intervals
    property int historyScrollOffset: 0 // 0 = live edge, >0 = offset back into history

    Screen_3_TrendsView {
        id: ui
        anchors.fill: parent
        activeMode: "chart"
        isZoomed: trendsContainer.isZoomed
        isLiveStreaming: true
        activeTimePreset: "5min"
    }

    // Helper: Build Telemetry Row Formatted for the Table
    function refreshTableView() {
        var visibleData = getVisibleDataSlice();
        var sensorModel = ui.sensorListViewItem.model;
        var tableRows = [];

        for (var i = visibleData.length - 1; i >= 0; i--) {
            var pt = visibleData[i];
            var parts = [];
            if (sensorModel) {
                for (var s = 0; s < sensorModel.count; s++) {
                    var ch = sensorModel.get(s);
                    if (ch.active && pt[ch.field] !== undefined) {
                        parts.push(ch.tag + ": " + pt[ch.field].toFixed(1) + " " + ch.unit);
                    }
                }
            }
            tableRows.push({
                time: pt.time,
                channelsText: parts.length > 0 ? parts.join("  |  ") : "No sensors active"
            });
        }
        ui.telemetryList.model = tableRows;
    }

    // Helper: Get Current Visible Slice from History
    function getVisibleDataSlice() {
        var total = trendsContainer.persistentHistory.length;
        if (total === 0) return [];

        var winSize = Math.min(total, trendsContainer.timeWindowSamples);
        var endIdx = total - trendsContainer.historyScrollOffset;
        endIdx = Math.max(winSize, Math.min(total, endIdx));
        var startIdx = Math.max(0, endIdx - winSize);

        var slice = trendsContainer.persistentHistory.slice(startIdx, endIdx);
        if (trendsContainer.isZoomed && slice.length > 2) {
            var zStart = Math.floor(slice.length * trendsContainer.zoomStartRatio);
            var zEnd = Math.min(slice.length, Math.ceil(slice.length * trendsContainer.zoomEndRatio));
            slice = slice.slice(zStart, Math.max(zStart + 2, zEnd));
        }
        return slice;
    }

    // Dynamic Unit Title Calculation
    function updateYAxisTitle() {
        var activeCount = 0;
        var activeUnits = [];
        var sensorModel = ui.sensorListViewItem.model;
        if (!sensorModel) return;

        for (var i = 0; i < sensorModel.count; i++) {
            var item = sensorModel.get(i);
            if (item.active) {
                activeCount++;
                if (activeUnits.indexOf(item.unit) === -1) {
                    activeUnits.push(item.unit);
                }
            }
        }

        if (activeCount === 0) {
            ui.yAxisTitle = "No Sensors Selected (Select from Left Panel)";
        } else if (activeCount === 1) {
            var singleItem = null;
            for (var j = 0; j < sensorModel.count; j++) {
                if (sensorModel.get(j).active) { singleItem = sensorModel.get(j); break; }
            }
            if (singleItem) {
                ui.yAxisTitle = singleItem.tag + " (" + singleItem.unit + ") [Range: " + singleItem.rangeMin + " to " + singleItem.rangeMax + " " + singleItem.unit + "]";
            }
        } else if (activeUnits.length === 1) {
            ui.yAxisTitle = "All Selected Channels (" + activeUnits[0] + ")";
        } else {
            ui.yAxisTitle = "Multi-Variable Process View (% Engineering Scale)";
        }
        ui.trendCanvasItem.requestPaint();
        refreshTableView();
    }

    // Interactive Resizer for Left Sensor Panel
    MouseArea {
        parent: ui.panelSplitterHandle
        anchors.fill: parent
        cursorShape: Qt.SizeHorCursor
        property real startX: 0
        property real startWidth: 0

        onPressed: function(mouse) {
            startX = mouse.x;
            startWidth = ui.sensorPanelWidth;
        }

        onPositionChanged: function(mouse) {
            if (pressed) {
                var newW = Math.max(220, Math.min(420, startWidth + (mouse.x - startX)));
                ui.sensorPanelWidth = newW;
            }
        }
    }

    // Mode Toggle
    MouseArea { parent: ui.chartModeBtn; anchors.fill: parent; onClicked: { ui.activeMode = "chart"; refreshTableView(); } }
    MouseArea { parent: ui.tableModeBtn; anchors.fill: parent; onClicked: { ui.activeMode = "table"; refreshTableView(); } }

    // Live Streaming Toggle (Pause vs Resume Live)
    MouseArea {
        parent: ui.liveStreamBtn
        anchors.fill: parent
        onClicked: {
            ui.isLiveStreaming = !ui.isLiveStreaming;
            if (ui.isLiveStreaming) {
                trendsContainer.historyScrollOffset = 0;
                trendsContainer.zoomStartRatio = 0.0;
                trendsContainer.zoomEndRatio = 1.0;
                trendsContainer.isZoomed = false;
                ui.timeSliderItem.value = 100;
                ui.trendCanvasItem.requestPaint();
                refreshTableView();
            }
        }
    }

    // Reset Zoom
    MouseArea {
        parent: ui.resetZoomBtn
        anchors.fill: parent
        onClicked: {
            trendsContainer.zoomStartRatio = 0.0;
            trendsContainer.zoomEndRatio = 1.0;
            trendsContainer.isZoomed = false;
            ui.dragBoxOverlay.visible = false;
            ui.trendCanvasItem.requestPaint();
            refreshTableView();
        }
    }

    // Time Preset Selectors (1m, 5m, 15m, 1h, 8h, 24h)
    MouseArea { parent: ui.t1MinBtn; anchors.fill: parent; onClicked: { ui.activeTimePreset = "1min"; trendsContainer.timeWindowSamples = 20; updateYAxisTitle(); } }
    MouseArea { parent: ui.t5MinBtn; anchors.fill: parent; onClicked: { ui.activeTimePreset = "5min"; trendsContainer.timeWindowSamples = 60; updateYAxisTitle(); } }
    MouseArea { parent: ui.t15MinBtn; anchors.fill: parent; onClicked: { ui.activeTimePreset = "15min"; trendsContainer.timeWindowSamples = 120; updateYAxisTitle(); } }
    MouseArea { parent: ui.t1HourBtn; anchors.fill: parent; onClicked: { ui.activeTimePreset = "1h"; trendsContainer.timeWindowSamples = 240; updateYAxisTitle(); } }
    MouseArea { parent: ui.t8HourBtn; anchors.fill: parent; onClicked: { ui.activeTimePreset = "8h"; trendsContainer.timeWindowSamples = 480; updateYAxisTitle(); } }
    MouseArea { parent: ui.t24HourBtn; anchors.fill: parent; onClicked: { ui.activeTimePreset = "24h"; trendsContainer.timeWindowSamples = 800; updateYAxisTitle(); } }

    // Timeline History Steppers & Slider (Free X-Axis Panning When Paused)
    MouseArea {
        parent: ui.panStartBtn
        anchors.fill: parent
        onClicked: {
            ui.isLiveStreaming = false;
            var maxOffset = Math.max(0, trendsContainer.persistentHistory.length - trendsContainer.timeWindowSamples);
            trendsContainer.historyScrollOffset = maxOffset;
            ui.timeSliderItem.value = 0;
            ui.trendCanvasItem.requestPaint();
            refreshTableView();
        }
    }

    MouseArea {
        parent: ui.panLeftBtn
        anchors.fill: parent
        onClicked: {
            ui.isLiveStreaming = false;
            var maxOffset = Math.max(0, trendsContainer.persistentHistory.length - trendsContainer.timeWindowSamples);
            trendsContainer.historyScrollOffset = Math.min(maxOffset, trendsContainer.historyScrollOffset + 10);
            var ratio = 1.0 - (trendsContainer.historyScrollOffset / Math.max(1, maxOffset));
            ui.timeSliderItem.value = ratio * 100;
            ui.trendCanvasItem.requestPaint();
            refreshTableView();
        }
    }

    MouseArea {
        parent: ui.panRightBtn
        anchors.fill: parent
        onClicked: {
            trendsContainer.historyScrollOffset = Math.max(0, trendsContainer.historyScrollOffset - 10);
            if (trendsContainer.historyScrollOffset === 0) ui.isLiveStreaming = true;
            var maxOffset = Math.max(0, trendsContainer.persistentHistory.length - trendsContainer.timeWindowSamples);
            var ratio = 1.0 - (trendsContainer.historyScrollOffset / Math.max(1, maxOffset));
            ui.timeSliderItem.value = ratio * 100;
            ui.trendCanvasItem.requestPaint();
            refreshTableView();
        }
    }

    MouseArea {
        parent: ui.panLiveBtn
        anchors.fill: parent
        onClicked: {
            ui.isLiveStreaming = true;
            trendsContainer.historyScrollOffset = 0;
            trendsContainer.zoomStartRatio = 0.0;
            trendsContainer.zoomEndRatio = 1.0;
            trendsContainer.isZoomed = false;
            ui.timeSliderItem.value = 100;
            ui.trendCanvasItem.requestPaint();
            refreshTableView();
        }
    }

    // Timeline Slider Drag
    Connections {
        target: ui.timeSliderItem
        function onMoved() {
            var val = ui.timeSliderItem.value; // 0 to 100
            var maxOffset = Math.max(0, trendsContainer.persistentHistory.length - trendsContainer.timeWindowSamples);
            trendsContainer.historyScrollOffset = Math.floor((1.0 - (val / 100.0)) * maxOffset);
            if (trendsContainer.historyScrollOffset > 0) {
                ui.isLiveStreaming = false;
            } else {
                ui.isLiveStreaming = true;
            }
            ui.trendCanvasItem.requestPaint();
            refreshTableView();
        }
    }

    // Full Sized "Select All" / "Clear All" Buttons
    MouseArea {
        parent: ui.selectAllBtnItem
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
        parent: ui.clearAllBtnItem
        anchors.fill: parent
        onClicked: {
            var model = ui.sensorListViewItem.model;
            for (var i = 0; i < model.count; i++) {
                model.setProperty(i, "active", false);
            }
            updateYAxisTitle();
        }
    }

    // Sensor Item Click Toggling via MouseArea
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

    // Real-Time Sampler (Appends continuously to persistent buffer, freezes viewport if paused)
    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: {
            var now = new Date();
            var timeStr = now.toTimeString().split(' ')[0];

            var t_vessel = stateMiddleware.vesselTemp + (Math.random() * 0.4 - 0.2);
            var t_jacket = t_vessel + 12.5 + (Math.random() * 0.6 - 0.3);
            var vac = stateMiddleware.vacuumPressure + (Math.random() * 2.0 - 1.0);
            var sp_agitator = stateMiddleware.agitatorSpeed + (Math.random() * 0.4 - 0.2);
            var sp_homo = stateMiddleware.homogenizerSpeed + (Math.random() * 10.0 - 5.0);

            var sample = {
                time: timeStr,
                temp_vessel: t_vessel,
                temp_jacket: t_jacket,
                temp_heater1: t_jacket - 4.0 + (Math.random() * 0.3),
                temp_heater2: t_jacket - 4.5 + (Math.random() * 0.3),
                temp_lid: t_vessel - 8.0 + (Math.random() * 0.2),
                vacuum_pressure: vac,
                press_steam: 1.8 + (Math.random() * 0.05 - 0.02),
                press_air: 5.5 + (Math.random() * 0.1 - 0.05),
                speed_agitator: sp_agitator,
                speed_scraper: sp_agitator > 0 ? (sp_agitator * 0.5) : 0.0,
                speed_homo: sp_homo,
                speed_pump: sp_homo > 0 ? 350.0 : 0.0,
                power_kw: (sp_agitator * 0.1) + (sp_homo * 0.003) + 2.5,
                curr_agitator: sp_agitator * 0.08 + 0.5,
                curr_homo: sp_homo * 0.002 + 1.2
            };

            // Maintain up to 1200 historical samples (~100 minutes at 500ms)
            trendsContainer.persistentHistory.push(sample);
            if (trendsContainer.persistentHistory.length > 1200) {
                trendsContainer.persistentHistory.shift();
            }

            // Update live readouts on sensor cards
            var model = ui.sensorListViewItem.model;
            if (model) {
                for (var s = 0; s < model.count; s++) {
                    var f = model.get(s).field;
                    if (sample[f] !== undefined) {
                        var valStr = sample[f].toFixed(1) + " " + model.get(s).unit;
                        model.setProperty(s, "val", valStr);
                    }
                }
            }

            // If in LIVE mode, automatically stay glued to the live edge
            if (ui.isLiveStreaming) {
                trendsContainer.historyScrollOffset = 0;
                ui.timeSliderItem.value = 100;
                ui.trendCanvasItem.requestPaint();
                if (ui.activeMode === "table") {
                    refreshTableView();
                }
            }
        }
    }

    Component.onCompleted: {
        var initial = [];
        var baseTime = new Date();
        baseTime.setMinutes(baseTime.getMinutes() - 10);

        for (var i = 0; i < 80; i++) {
            var sampleTime = new Date(baseTime.getTime() + i * 5000);
            var timeStr = sampleTime.toTimeString().split(' ')[0];

            var tv = 24.5 + (i / 80.0) * 55.0;
            var tj = 28.0 + (i / 80.0) * 58.0;
            var vp = -5.0 - (i / 80.0) * 445.0;
            var sa = i > 10 ? 35.0 : 0.0;
            var sh = i > 30 ? 3200.0 : 0.0;

            initial.push({
                time: timeStr,
                temp_vessel: tv, temp_jacket: tj, temp_heater1: tj - 4.0, temp_heater2: tj - 4.5, temp_lid: tv - 8.0,
                vacuum_pressure: vp, press_steam: 1.8, press_air: 5.5,
                speed_agitator: sa, speed_scraper: sa * 0.5, speed_homo: sh, speed_pump: sh > 0 ? 350.0 : 0.0,
                power_kw: 14.8, curr_agitator: 3.4, curr_homo: 8.9
            });
        }
        persistentHistory = initial;
        updateYAxisTitle();

        // Canvas Paint Routine
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
                } else if (ui.yAxisTitle.indexOf("All Selected Channels (°C)") !== -1) {
                    label = String(100 - i * 20) + "°C";
                } else {
                    label = String(100 - i * 20) + "%";
                }
                ctx.fillText(label, 8, y + 4);
            }

            var visibleData = getVisibleDataSlice();
            if (visibleData.length < 2) return;
            var count = visibleData.length;

            // Draw X-axis timestamps
            ctx.fillStyle = "#64748b";
            ctx.font = "bold 10px sans-serif";
            var stepX = Math.max(1, Math.floor(count / 5));
            for (var k = 0; k < count; k += stepX) {
                var ptX = visibleData[k];
                if (ptX) {
                    var pxTime = ox + (w / (count - 1)) * k;
                    ctx.fillText(ptX.time, pxTime - 18, oy + h + 20);
                }
            }

            // Generic Curve Drawing Function
            function drawDynamicCurve(field, color, minV, maxV) {
                ctx.strokeStyle = color;
                ctx.lineWidth = 2.4;
                ctx.beginPath();
                for (var j = 0; j < count; j++) {
                    var pt = visibleData[j];
                    var val = pt[field];
                    if (val === undefined) val = minV;
                    var normY = 1.0 - Math.max(0.0, Math.min(1.0, (val - minV) / (maxV - minV)));
                    var px = ox + (w / (count - 1)) * j;
                    var py = oy + normY * h;
                    if (j === 0) ctx.moveTo(px, py);
                    else ctx.lineTo(px, py);
                }
                ctx.stroke();
            }

            // Draw all active sensors
            if (sensorModel) {
                for (var c = 0; c < sensorModel.count; c++) {
                    var ch = sensorModel.get(c);
                    if (ch.active) {
                        drawDynamicCurve(ch.field, ch.color, ch.rangeMin, ch.rangeMax);
                    }
                }
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

    // MouseArea on Canvas for Hover Inspection & Free-Size 2D Selection Box
    MouseArea {
        parent: ui.trendCanvasItem
        anchors.fill: parent
        hoverEnabled: true
        property real dragStartX: 0
        property real dragStartY: 0
        property bool isDragging: false

        onPositionChanged: function(mouse) {
            trendsContainer.inspectX = mouse.x;
            trendsContainer.inspectY = mouse.y;
            var w = parent.width - 90;
            var ox = 70;
            var oy = 15;
            var h = parent.height - 50;

            if (isDragging) {
                // Free-size 2D selection rectangle anywhere on canvas
                ui.dragBoxOverlay.visible = true;
                ui.dragBoxOverlay.x = Math.min(dragStartX, mouse.x);
                ui.dragBoxOverlay.y = Math.min(dragStartY, mouse.y);
                ui.dragBoxOverlay.width = Math.abs(mouse.x - dragStartX);
                ui.dragBoxOverlay.height = Math.abs(mouse.y - dragStartY);
                ui.inspectCardItem.visible = false;
            } else if (mouse.x >= ox && mouse.x <= ox + w) {
                var visibleData = getVisibleDataSlice();
                if (visibleData.length > 0) {
                    var ratio = (mouse.x - ox) / w;
                    var idx = Math.floor(visibleData.length * ratio);
                    idx = Math.max(0, Math.min(visibleData.length - 1, idx));
                    var pt = visibleData[idx];

                    if (pt) {
                        ui.inspectionTime = pt.time + " UTC";
                        var sensorModel = ui.sensorListViewItem.model;
                        var inspectItems = [];

                        if (sensorModel) {
                            for (var s = 0; s < sensorModel.count; s++) {
                                var ch = sensorModel.get(s);
                                if (ch.active) {
                                    var valNum = pt[ch.field] !== undefined ? pt[ch.field] : 0.0;
                                    inspectItems.push({
                                        tag: ch.tag,
                                        val: valNum.toFixed(1) + " " + ch.unit,
                                        color: ch.color
                                    });
                                }
                            }
                        }

                        // Populate dynamic inspection tooltip
                        ui.inspectRepeaterItem.clear();
                        for (var k = 0; k < inspectItems.length; k++) {
                            ui.inspectRepeaterItem.append(inspectItems[k]);
                        }

                        ui.inspectCardItem.visible = inspectItems.length > 0;
                        ui.inspectCardItem.height = Math.max(70, Math.min(220, 36 + inspectItems.length * 20));
                        ui.inspectCardItem.x = Math.min(parent.width - ui.inspectCardItem.width - 10, Math.max(ox, mouse.x + 12));
                        ui.inspectCardItem.y = Math.min(parent.height - ui.inspectCardItem.height - 10, Math.max(oy, mouse.y - 20));
                    }
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
            ui.isLiveStreaming = false; // Pause live scroll on manual drag
        }

        onReleased: function(mouse) {
            ui.dragBoxOverlay.visible = false;
            if (isDragging && Math.abs(mouse.x - dragStartX) > 20) {
                var ox = 70;
                var w = parent.width - 90;
                var r1 = Math.max(0.0, Math.min(1.0, (Math.min(dragStartX, mouse.x) - ox) / w));
                var r2 = Math.max(0.0, Math.min(1.0, (Math.max(dragStartX, mouse.x) - ox) / w));
                trendsContainer.zoomStartRatio = r1;
                trendsContainer.zoomEndRatio = r2;
                trendsContainer.isZoomed = true;
                refreshTableView();
            }
            isDragging = false;
            ui.trendCanvasItem.requestPaint();
        }
    }
}
