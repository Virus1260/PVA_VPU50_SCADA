pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls

Item {
    id: rootWindow
    width: 1280
    height: 720

    // --- Industrial Process State Variables ---
    property double r1TargetSpeed: 25.0
    property double r1ActualSpeed: 0.0
    property double r1Power: 0.0
    property double r1Current: 0.0
    property int r1RuntimeSeconds: 0

    property double r2TargetSpeed: 600.0
    property double r2ActualSpeed: 0.0
    property double r2Power: 0.0
    property double r2Current: 0.0
    property int r2RuntimeSeconds: 0

    property int r3RuntimeSeconds: 0

    property double vacuumPressure: -209.8
    property int r4RuntimeSeconds: 330

    property int r5RuntimeSeconds: 0

    property double productTemp: 40.1
    property double targetTemp: 89.0
    property double jacketDeltaT: 23.2
    property double tempGradient: 12.1
    property int r6RuntimeSeconds: 0

    property var alarmList: [
        "SYSTEM READY - RECIPE [UNIMIX_BATCH_01] STANDBY",
        "INFO: AGITATOR MOTOR [M01] READY FOR SEQUENCE",
        "NOTICE: VACUUM CHAMBER SEAL INTEGRITY VERIFIED",
        "STATUS: HEATING JACKET PROPORTIONAL REGULATION ACTIVE"
    ]
    property int alarmIndex: 0

    property var screenTitles: [
        "SYSTEM READY - RECIPE [UNIMIX_BATCH_01] STANDBY",
        "P&ID VIEW - UNIMIX 50 SKID & PROCESS UTILITY VALVES",
        "PROCESS TRENDS - MULTI-CHANNEL HISTORICAL LOG",
        "ALARM ANNUNCIATOR - ACTIVE PROCESS NOTIFICATIONS",
        "RECIPES - STEP-BY-STEP PHASE EXECUTION MANAGER",
        "ELECTRONIC BATCH RECORD - 21 CFR PART 11 AUDIT LOG",
        "PROCESS PLAYBACK - HISTORICAL BATCH TRACE",
        "MAINTENANCE - HARDWARE I/O DIAGNOSTICS & OVERRIDE"
    ]

    function formatTime(totalSecs) {
        var hrs = Math.floor(totalSecs / 3600);
        var mins = Math.floor((totalSecs % 3600) / 60);
        var secs = totalSecs % 60;
        return String(hrs).padStart(2, '0') + ":" + String(mins).padStart(2, '0') + ":" + String(secs).padStart(2, '0');
    }

    Loader {
        id: uiLoader
        anchors.fill: parent
        source: "Main_frame_screen.ui.qml"

        onLoaded: {
            console.log("EKATO EPOS SCADA Main Frame initialized successfully.");

            var ui = uiLoader.item;
            if (!ui) return;

            var ctrl = ui.controlView;

            // -------------------------------------------------------------
            // 1. ROW 1: AGITATOR SPEED & INTERACTIVE CONTROLS
            // -------------------------------------------------------------
            if (ctrl && ctrl.row1MinusBtn) {
                ctrl.row1MinusBtn.clicked.connect(function() {
                    if (ctrl.row1Media && ctrl.row1Media.isPlaying) return;
                    rootWindow.r1TargetSpeed = Math.max(25.0, rootWindow.r1TargetSpeed - 2.5);
                    ctrl.row1SpeedControl.targetVal = rootWindow.r1TargetSpeed;
                });
            }

            if (ctrl && ctrl.row1PlusBtn) {
                ctrl.row1PlusBtn.clicked.connect(function() {
                    if (ctrl.row1Media && ctrl.row1Media.isPlaying) return;
                    rootWindow.r1TargetSpeed = Math.min(120.0, rootWindow.r1TargetSpeed + 2.5);
                    ctrl.row1SpeedControl.targetVal = rootWindow.r1TargetSpeed;
                });
            }

            if (ctrl && ctrl.row1SpeedControl) {
                // Slider drag / click signal
                ctrl.row1SpeedControl.targetValChangedByUser.connect(function(newVal) {
                    rootWindow.r1TargetSpeed = newVal;
                });

                // Setpoint box clicked -> Open Keypad Modal
                ctrl.row1SpeedControl.setpointRequested.connect(function(title, tag, current, min, max, unit) {
                    if (ctrl.row1Media && ctrl.row1Media.isPlaying) return;
                    if (ui.keypadModal) {
                        ui.keypadModal.title = title;
                        ui.keypadModal.targetTag = tag;
                        ui.keypadModal.minVal = min;
                        ui.keypadModal.maxVal = max;
                        ui.keypadModal.unit = unit;
                        ui.keypadModal.currentInput = current.toFixed(1);
                        ui.keypadModal.visible = true;
                    }
                });
            }

            if (ctrl && ctrl.row1Media) {
                ctrl.row1Media.playClicked.connect(function() {
                    rootWindow.r1Power = 3.8;
                    rootWindow.r1Current = 11.5;
                    ctrl.row1PowerCard.primaryValue = rootWindow.r1Power.toFixed(1);
                    ctrl.row1CurrentCard.primaryValue = rootWindow.r1Current.toFixed(1);
                });

                ctrl.row1Media.stopClicked.connect(function() {
                    rootWindow.r1Power = 0.0;
                    rootWindow.r1Current = 0.0;
                    rootWindow.r1RuntimeSeconds = 0;
                    if (ctrl.row1Runtime) ctrl.row1Runtime.timeText = "00:00:00";
                    ctrl.row1PowerCard.primaryValue = "0.0";
                    ctrl.row1CurrentCard.primaryValue = "0.0";
                });
            }

            if (ctrl && ctrl.row1ModeSelector) {
                ctrl.row1ModeSelector.clicked.connect(function() {
                    if (ui.agitatorModal) ui.agitatorModal.visible = true;
                });
            }

            // -------------------------------------------------------------
            // 2. ROW 2: HOMOGENIZER SPEED & INTERACTIVE CONTROLS
            // -------------------------------------------------------------
            if (ctrl && ctrl.row2MinusBtn) {
                ctrl.row2MinusBtn.clicked.connect(function() {
                    if (ctrl.row2Media && ctrl.row2Media.isPlaying) return;
                    rootWindow.r2TargetSpeed = Math.max(600.0, rootWindow.r2TargetSpeed - 100.0);
                    ctrl.row2SpeedControl.targetVal = rootWindow.r2TargetSpeed;
                });
            }

            if (ctrl && ctrl.row2PlusBtn) {
                ctrl.row2PlusBtn.clicked.connect(function() {
                    if (ctrl.row2Media && ctrl.row2Media.isPlaying) return;
                    rootWindow.r2TargetSpeed = Math.min(4800.0, rootWindow.r2TargetSpeed + 100.0);
                    ctrl.row2SpeedControl.targetVal = rootWindow.r2TargetSpeed;
                });
            }

            if (ctrl && ctrl.row2SpeedControl) {
                // Slider drag / click signal
                ctrl.row2SpeedControl.targetValChangedByUser.connect(function(newVal) {
                    rootWindow.r2TargetSpeed = newVal;
                });

                // Setpoint box clicked -> Open Keypad Modal
                ctrl.row2SpeedControl.setpointRequested.connect(function(title, tag, current, min, max, unit) {
                    if (ctrl.row2Media && ctrl.row2Media.isPlaying) return;
                    if (ui.keypadModal) {
                        ui.keypadModal.title = title;
                        ui.keypadModal.targetTag = tag;
                        ui.keypadModal.minVal = min;
                        ui.keypadModal.maxVal = max;
                        ui.keypadModal.unit = unit;
                        ui.keypadModal.currentInput = current.toFixed(0);
                        ui.keypadModal.visible = true;
                    }
                });
            }

            if (ctrl && ctrl.row2Media) {
                ctrl.row2Media.playClicked.connect(function() {
                    rootWindow.r2Power = 8.5;
                    rootWindow.r2Current = 24.2;
                    ctrl.row2PowerCard.primaryValue = rootWindow.r2Power.toFixed(1);
                    ctrl.row2CurrentCard.primaryValue = rootWindow.r2Current.toFixed(1);
                });

                ctrl.row2Media.stopClicked.connect(function() {
                    rootWindow.r2Power = 0.0;
                    rootWindow.r2Current = 0.0;
                    rootWindow.r2RuntimeSeconds = 0;
                    if (ctrl.row2Runtime) ctrl.row2Runtime.timeText = "00:00:00";
                    ctrl.row2PowerCard.primaryValue = "0.0";
                    ctrl.row2CurrentCard.primaryValue = "0.0";
                });
            }

            if (ctrl && ctrl.row2ModeSelector) {
                ctrl.row2ModeSelector.clicked.connect(function() {
                    if (ui.homoModal) ui.homoModal.visible = true;
                });
            }

            // -------------------------------------------------------------
            // 3. ROW 3: CIRCULATION CONTROLS
            // -------------------------------------------------------------
            if (ctrl && ctrl.row3Media) {
                ctrl.row3Media.stopClicked.connect(function() {
                    rootWindow.r3RuntimeSeconds = 0;
                    if (ctrl.row3Runtime) ctrl.row3Runtime.timeText = "00:00:00";
                });
            }

            if (ctrl && ctrl.row3ModeSelector) {
                ctrl.row3ModeSelector.clicked.connect(function() {
                    if (ui.plantModal) ui.plantModal.visible = true;
                });
            }

            // -------------------------------------------------------------
            // 4. ROW 4: VACUUM CONTROLS
            // -------------------------------------------------------------
            if (ctrl && ctrl.row4Media) {
                ctrl.row4Media.stopClicked.connect(function() {
                    rootWindow.r4RuntimeSeconds = 0;
                    if (ctrl.row4Runtime) ctrl.row4Runtime.timeText = "00:00:00";
                });
            }

            if (ctrl && ctrl.row4ModeSelector) {
                ctrl.row4ModeSelector.clicked.connect(function() {
                    if (ui.vacuumModal) ui.vacuumModal.visible = true;
                });
            }

            // -------------------------------------------------------------
            // 5. ROW 5: SUCTION LIQUIDS CONTROLS
            // -------------------------------------------------------------
            if (ctrl && ctrl.row5Media) {
                ctrl.row5Media.stopClicked.connect(function() {
                    rootWindow.r5RuntimeSeconds = 0;
                    if (ctrl.row5Runtime) ctrl.row5Runtime.timeText = "00:00:00";
                });
            }

            if (ctrl && ctrl.row5ModeSelector) {
                ctrl.row5ModeSelector.clicked.connect(function() {
                    if (ui.vacuumModal) ui.vacuumModal.visible = true;
                });
            }

            // -------------------------------------------------------------
            // 6. ROW 6: HEATING CONTROLS
            // -------------------------------------------------------------
            if (ctrl && ctrl.row6Media) {
                ctrl.row6Media.playClicked.connect(function() {
                    console.log("Heating Loop Activated.");
                });
                ctrl.row6Media.stopClicked.connect(function() {
                    rootWindow.r6RuntimeSeconds = 0;
                    if (ctrl.row6Runtime) ctrl.row6Runtime.timeText = "00:00:00";
                });
            }

            // -------------------------------------------------------------
            // 7. HEADER ACKNOWLEDGE BUTTON
            // -------------------------------------------------------------
            if (ui.ackButton) {
                ui.ackButton.clicked.connect(function() {
                    rootWindow.alarmIndex = (rootWindow.alarmIndex + 1) % rootWindow.alarmList.length;
                    ui.header.alarmMessage = rootWindow.alarmList[rootWindow.alarmIndex];
                    ui.header.isAlarmActive = false;
                });
            }

            // -------------------------------------------------------------
            // 8. SIDEBAR SCREEN NAVIGATION HANDLER
            // -------------------------------------------------------------
            if (ui.sidebar) {
                ui.sidebar.activeIndexChanged.connect(function() {
                    var idx = ui.sidebar.activeIndex;
                    if (idx >= 0 && idx < rootWindow.screenTitles.length) {
                        ui.header.alarmMessage = rootWindow.screenTitles[idx];
                    }
                });
            }

            // -------------------------------------------------------------
            // 9. P&ID COMPONENT TAPPING HANDLER
            // -------------------------------------------------------------
            if (ui.pidScreen) {
                ui.pidScreen.componentTapped.connect(function(tagName) {
                    console.log("P&ID Equipment Tapped: " + tagName);
                    if (ui.confirmModal) {
                        ui.confirmModal.title = "Confirm Device Action: " + tagName;
                        ui.confirmModal.tag = tagName;
                        ui.confirmModal.instruction = "Please verify safety interlocks before toggling position of " + tagName + ".";
                        ui.confirmModal.visible = true;
                    }
                });
            }

            // -------------------------------------------------------------
            // 10. MODAL SETPOINT ACCEPTANCE HANDLER (Dynamic Value Putter)
            // -------------------------------------------------------------
            if (ui.keypadModal) {
                ui.keypadModal.accepted.connect(function(val) {
                    if (ui.keypadModal.targetTag.indexOf("1M1501") !== -1 && ctrl) {
                        rootWindow.r1TargetSpeed = val;
                        ctrl.row1SpeedControl.targetVal = val;
                    } else if (ui.keypadModal.targetTag.indexOf("1M2003") !== -1 && ctrl) {
                        rootWindow.r2TargetSpeed = val;
                        ctrl.row2SpeedControl.targetVal = val;
                    }
                    ui.keypadModal.visible = false;
                });

                ui.keypadModal.closed.connect(function() { ui.keypadModal.visible = false; });
            }

            // -------------------------------------------------------------
            // 11. DYNAMIC MODE SELECTION (Updates icon on row immediately)
            // -------------------------------------------------------------
            if (ui.agitatorModal) {
                ui.agitatorModal.modeSelected.connect(function(modeKey) {
                    if (ctrl && ctrl.row1ModeSelector) {
                        ctrl.row1ModeSelector.iconName = modeKey;
                    }
                });
                ui.agitatorModal.closed.connect(function() { ui.agitatorModal.visible = false; });
            }

            if (ui.homoModal) {
                ui.homoModal.modeSelected.connect(function(modeKey) {
                    if (ctrl && ctrl.row2ModeSelector) {
                        ctrl.row2ModeSelector.iconName = modeKey;
                    }
                });
                ui.homoModal.closed.connect(function() { ui.homoModal.visible = false; });
            }

            if (ui.vacuumModal) {
                ui.vacuumModal.modeSelected.connect(function(modeKey) {
                    if (ctrl && ctrl.row5ModeSelector) {
                        ctrl.row5ModeSelector.iconName = modeKey;
                    }
                });
                ui.vacuumModal.closed.connect(function() { ui.vacuumModal.visible = false; });
            }

            if (ui.plantModal) ui.plantModal.closed.connect(function() { ui.plantModal.visible = false; });
            if (ui.confirmModal) ui.confirmModal.closed.connect(function() { ui.confirmModal.visible = false; });
        }
    }

    // --- Fast Process Simulation Loop (250ms) ---
    Timer {
        id: processSimulationTimer
        interval: 250
        running: true
        repeat: true
        onTriggered: {
            if (uiLoader.status !== Loader.Ready) return;
            var ui = uiLoader.item;
            if (!ui) return;
            var ctrl = ui.controlView;
            if (!ctrl) return;

            // 1. Agitator 1 Speed Ramping
            if (ctrl.row1Media && ctrl.row1Media.isPlaying) {
                if (rootWindow.r1ActualSpeed < rootWindow.r1TargetSpeed) {
                    rootWindow.r1ActualSpeed = Math.min(rootWindow.r1TargetSpeed, rootWindow.r1ActualSpeed + 1.2);
                } else if (rootWindow.r1ActualSpeed > rootWindow.r1TargetSpeed) {
                    rootWindow.r1ActualSpeed = Math.max(rootWindow.r1TargetSpeed, rootWindow.r1ActualSpeed - 1.2);
                }
            } else {
                rootWindow.r1ActualSpeed = Math.max(0.0, rootWindow.r1ActualSpeed - 1.5);
            }
            if (ctrl.row1SpeedControl) ctrl.row1SpeedControl.currentVal = rootWindow.r1ActualSpeed;

            // 2. Homogenizer 2 Speed Ramping
            if (ctrl.row2Media && ctrl.row2Media.isPlaying) {
                if (rootWindow.r2ActualSpeed < rootWindow.r2TargetSpeed) {
                    rootWindow.r2ActualSpeed = Math.min(rootWindow.r2TargetSpeed, rootWindow.r2ActualSpeed + 45.0);
                } else if (rootWindow.r2ActualSpeed > rootWindow.r2TargetSpeed) {
                    rootWindow.r2ActualSpeed = Math.max(rootWindow.r2TargetSpeed, rootWindow.r2ActualSpeed - 45.0);
                }
            } else {
                rootWindow.r2ActualSpeed = Math.max(0.0, rootWindow.r2ActualSpeed - 60.0);
            }
            if (ctrl.row2SpeedControl) ctrl.row2SpeedControl.currentVal = rootWindow.r2ActualSpeed;

            // 3. Vacuum Chamber Evacuation Loop
            if (ctrl.row4Media && ctrl.row4Media.isPlaying) {
                if (rootWindow.vacuumPressure > -450.0) {
                    rootWindow.vacuumPressure -= 0.6;
                } else {
                    rootWindow.vacuumPressure = -450.0 + (Math.sin(Date.now() / 1000) * 0.4);
                }
                if (ctrl.row4PressureCard) {
                    ctrl.row4PressureCard.primaryValue = rootWindow.vacuumPressure.toFixed(1);
                    ctrl.row4PressureCard.progressValue = Math.abs(rootWindow.vacuumPressure) / 450.0;
                }
            }

            // 4. Heating Temperature Loop
            if (ctrl.row6Media && ctrl.row6Media.isPlaying) {
                if (rootWindow.productTemp < rootWindow.targetTemp) {
                    rootWindow.productTemp += 0.05;
                }
                var dev = Math.max(0.0, rootWindow.targetTemp - rootWindow.productTemp);
                if (ctrl.row6TempCard) ctrl.row6TempCard.primaryValue = rootWindow.productTemp.toFixed(1);
                if (ctrl.row6DevCard) ctrl.row6DevCard.primaryValue = dev.toFixed(1);
                if (ctrl.row6GradientCard) ctrl.row6GradientCard.progressValue = Math.min(1.0, rootWindow.productTemp / rootWindow.targetTemp);
            }
        }
    }

    // --- Clock & 1-Second Independent Runtime Timers ---
    Timer {
        id: clockTimer
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            if (uiLoader.status !== Loader.Ready) return;
            var ui = uiLoader.item;
            if (!ui) return;
            var ctrl = ui.controlView;

            // Update Header Clock
            if (ui.header) {
                var now = new Date();
                var hours = String(now.getHours()).padStart(2, '0');
                var minutes = String(now.getMinutes()).padStart(2, '0');
                var seconds = String(now.getSeconds()).padStart(2, '0');
                ui.header.timeString = hours + ":" + minutes + ":" + seconds;

                var day = String(now.getDate()).padStart(2, '0');
                var month = String(now.getMonth() + 1).padStart(2, '0');
                var year = now.getFullYear();
                ui.header.dateString = day + "/" + month + "/" + year;
            }

            if (!ctrl) return;

            // 1. Agitator Runtime
            if (ctrl.row1Media && ctrl.row1Media.isPlaying && ctrl.row1Runtime) {
                rootWindow.r1RuntimeSeconds++;
                ctrl.row1Runtime.timeText = rootWindow.formatTime(rootWindow.r1RuntimeSeconds);
            }

            // 2. Homogenizer Runtime
            if (ctrl.row2Media && ctrl.row2Media.isPlaying && ctrl.row2Runtime) {
                rootWindow.r2RuntimeSeconds++;
                ctrl.row2Runtime.timeText = rootWindow.formatTime(rootWindow.r2RuntimeSeconds);
            }

            // 3. Circulation Runtime
            if (ctrl.row3Media && ctrl.row3Media.isPlaying && ctrl.row3Runtime) {
                rootWindow.r3RuntimeSeconds++;
                ctrl.row3Runtime.timeText = rootWindow.formatTime(rootWindow.r3RuntimeSeconds);
            }

            // 4. Vacuum Runtime
            if (ctrl.row4Media && ctrl.row4Media.isPlaying && ctrl.row4Runtime) {
                rootWindow.r4RuntimeSeconds++;
                ctrl.row4Runtime.timeText = rootWindow.formatTime(rootWindow.r4RuntimeSeconds);
            }

            // 5. Suction Liquids Runtime
            if (ctrl.row5Media && ctrl.row5Media.isPlaying && ctrl.row5Runtime) {
                rootWindow.r5RuntimeSeconds++;
                ctrl.row5Runtime.timeText = rootWindow.formatTime(rootWindow.r5RuntimeSeconds);
            }

            // 6. Heating Runtime
            if (ctrl.row6Media && ctrl.row6Media.isPlaying && ctrl.row6Runtime) {
                rootWindow.r6RuntimeSeconds++;
                ctrl.row6Runtime.timeText = rootWindow.formatTime(rootWindow.r6RuntimeSeconds);
            }
        }
    }
}
