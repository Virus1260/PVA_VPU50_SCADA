import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: confirmRoot
    anchors.fill: parent
    color: "#bb000000"
    visible: false
    z: 999

    property string title: "Confirm Valve Configuration"
    property string instruction: "Please verify and confirm manual valve positions before beginning sequence."
    property string activeOperationKey: "discharge_product"
    property bool allConfirmed: false

    property var valveList: [
        { tag: "V101", name: "Main Vessel Discharge Valve", isSolenoid: true, expectedStatus: "OPEN", previousStatus: "CLOSED", currentStatus: "OPEN", confirmed: true },
        { tag: "V102", name: "External Circulation Return Valve", isSolenoid: true, expectedStatus: "OPEN", previousStatus: "CLOSED", currentStatus: "OPEN", confirmed: true },
        { tag: "V103", name: "Recirculation Divert Valve", isSolenoid: true, expectedStatus: "CLOSED", previousStatus: "CLOSED", currentStatus: "CLOSED", confirmed: true },
        { tag: "V201", name: "CIP Rinse Water Valve", isSolenoid: true, expectedStatus: "CLOSED", previousStatus: "CLOSED", currentStatus: "CLOSED", confirmed: true },
        { tag: "V202", name: "CIP Drain Discharge Valve", isSolenoid: true, expectedStatus: "CLOSED", previousStatus: "CLOSED", currentStatus: "CLOSED", confirmed: true },
        { tag: "V203", name: "CIP Air Drying Valve", isSolenoid: true, expectedStatus: "CLOSED", previousStatus: "CLOSED", currentStatus: "CLOSED", confirmed: true },
        { tag: "V301", name: "Liquid Port Charging Valve", isSolenoid: false, expectedStatus: "CLOSED", previousStatus: "-", currentStatus: "-", confirmed: false },
        { tag: "V302", name: "Solids Funnel Charging Valve", isSolenoid: false, expectedStatus: "CLOSED", previousStatus: "-", currentStatus: "-", confirmed: false },
        { tag: "V303", name: "Bottom Suction Valve", isSolenoid: false, expectedStatus: "OPEN", previousStatus: "-", currentStatus: "-", confirmed: false }
    ]

    signal confirmed(string operationKey)
    signal aborted()
    signal closed()

    MouseArea {
        anchors.fill: parent
        onClicked: {}
    }

    Rectangle {
        id: modalBox
        anchors.centerIn: parent
        width: Math.max(680, Math.min(parent.width * 0.75, 840))
        height: Math.max(500, Math.min(parent.height * 0.85, 620))
        color: "#08213b"
        border.color: "#184d7e"
        border.width: 2
        radius: 12
        clip: true

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 12

            // 1. Top Header Bar
            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: confirmRoot.title
                    color: "#ffffff"
                    font.bold: true
                    font.pixelSize: 17
                    Layout.fillWidth: true
                }
                Rectangle {
                    width: 30
                    height: 30
                    color: closeMouse.containsMouse ? "#c82333" : "#103358"
                    border.color: "#215c9b"
                    border.width: 1
                    radius: 4
                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        color: "#ffffff"
                        font.bold: true
                        font.pixelSize: 13
                    }
                    MouseArea {
                        id: closeMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: { confirmRoot.aborted(); confirmRoot.closed(); }
                    }
                }
            }

            // 2. Warning & Safety Interlock Banner
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 54
                radius: 8
                border.width: 1.5
                color: confirmRoot.allConfirmed ? "#064e3b" : "#451a03"
                border.color: confirmRoot.allConfirmed ? "#22c55e" : "#f59e0b"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 14
                    anchors.rightMargin: 14
                    spacing: 12

                    Text {
                        text: confirmRoot.allConfirmed ? "✓" : "⚠"
                        color: confirmRoot.allConfirmed ? "#22c55e" : "#f59e0b"
                        font.bold: true
                        font.pixelSize: 22
                    }

                    Text {
                        text: confirmRoot.allConfirmed ?
                            ("ALL MANUAL VALVES VERIFIED: Positioning confirmed. Press CONFIRM POSITIONING to begin process sequence.") :
                            ("MANDATORY SAFETY INTERLOCK: " + confirmRoot.instruction + " You MUST physically verify and check all manual butterfly valves below to unlock start.")
                        color: confirmRoot.allConfirmed ? "#a7f3d0" : "#fef08a"
                        font.bold: true
                        font.pixelSize: 11
                        wrapMode: Text.Wrap
                        Layout.fillWidth: true
                    }
                }
            }

            // 3. 5-Column Scrollable Valve Status Matrix Table
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#05162a"
                border.color: "#1d4ed8"
                border.width: 1.5
                radius: 8
                clip: true

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 4

                    // Table Column Headers
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 32
                        color: "#0f2b4c"
                        border.color: "#1d4ed8"
                        border.width: 1
                        radius: 4

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12
                            spacing: 8

                            Text { text: "VALVE TAG"; color: "#38bdf8"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 110 }
                            Text { text: "EXPECTED"; color: "#38bdf8"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 90 }
                            Text { text: "PREVIOUS"; color: "#38bdf8"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 80 }
                            Text { text: "CURRENT"; color: "#38bdf8"; font.bold: true; font.pixelSize: 11; Layout.preferredWidth: 80 }
                            Text { text: "MANUAL CONFIRMATION"; color: "#38bdf8"; font.bold: true; font.pixelSize: 11; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter }
                        }
                    }

                    // Table Rows ListView
                    ListView {
                        id: valveListView
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        spacing: 3
                        model: confirmRoot.valveList

                        delegate: Rectangle {
                            width: valveListView.width
                            height: 38
                            radius: 4
                            color: index % 2 === 0 ? "#0a2540" : "#06192e"

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 12
                                spacing: 8

                                // Column 1: Valve Tag & Type
                                ColumnLayout {
                                    Layout.preferredWidth: 110
                                    spacing: 0
                                    Text {
                                        text: modelData.tag
                                        color: "#ffffff"
                                        font.bold: true
                                        font.pixelSize: 12
                                    }
                                    Text {
                                        text: modelData.isSolenoid ? "Solenoid (Auto)" : "Manual Butterfly"
                                        color: "#94a3b8"
                                        font.pixelSize: 9
                                    }
                                }

                                // Column 2: Expected Status Pill
                                Rectangle {
                                    Layout.preferredWidth: 80
                                    Layout.preferredHeight: 24
                                    radius: 4
                                    border.width: 1
                                    color: modelData.expectedStatus === "OPEN" ? "#14532d" : "#7c2d12"
                                    border.color: modelData.expectedStatus === "OPEN" ? "#22c55e" : "#ea580c"

                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData.expectedStatus
                                        color: modelData.expectedStatus === "OPEN" ? "#4ade80" : "#fdba74"
                                        font.bold: true
                                        font.pixelSize: 11
                                    }
                                }

                                // Column 3: Previous Status
                                Text {
                                    text: modelData.previousStatus
                                    color: "#94a3b8"
                                    font.pixelSize: 11
                                    Layout.preferredWidth: 80
                                }

                                // Column 4: Current Status
                                Text {
                                    text: modelData.currentStatus
                                    color: modelData.isSolenoid ? (modelData.currentStatus === "OPEN" ? "#4ade80" : "#f87171") : "#94a3b8"
                                    font.bold: modelData.isSolenoid
                                    font.pixelSize: 11
                                    Layout.preferredWidth: 80
                                }

                                // Column 5: Manual Confirmation Checkbox
                                RowLayout {
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignHCenter

                                    Item { Layout.fillWidth: true }

                                    // Manual Butterfly Checkbox
                                    Rectangle {
                                        width: 28
                                        height: 28
                                        radius: 4
                                        border.width: 1.5
                                        visible: !modelData.isSolenoid
                                        color: modelData.confirmed ? "#16a34a" : "#0f172a"
                                        border.color: modelData.confirmed ? "#4ade80" : "#f59e0b"

                                        Text {
                                            anchors.centerIn: parent
                                            text: modelData.confirmed ? "✓" : ""
                                            color: "#ffffff"
                                            font.bold: true
                                            font.pixelSize: 16
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                confirmRoot.toggleManualValve(index);
                                            }
                                        }
                                    }

                                    // Auto Solenoid Indicator Text
                                    Text {
                                        text: "Auto (PLC Controlled)"
                                        color: "#64748b"
                                        font.pixelSize: 10
                                        visible: modelData.isSolenoid
                                    }

                                    Item { Layout.fillWidth: true }
                                }
                            }
                        }
                    }
                }
            }

            // 4. Action Buttons Row (Abort & Confirm Positioning)
            RowLayout {
                Layout.fillWidth: true
                spacing: 16

                // ABORT BUTTON (Red)
                Rectangle {
                    Layout.preferredWidth: 160
                    Layout.preferredHeight: 46
                    color: abortMouse.pressed ? "#991b1b" : "#dc2626"
                    border.color: "#f87171"
                    border.width: 1
                    radius: 6

                    Text {
                        anchors.centerIn: parent
                        text: "ABORT"
                        color: "#ffffff"
                        font.bold: true
                        font.pixelSize: 14
                    }

                    MouseArea {
                        id: abortMouse
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            confirmRoot.aborted();
                            confirmRoot.closed();
                        }
                    }
                }

                // CONFIRM POSITIONING BUTTON (Green when unlocked, dark grey when locked)
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 46
                    color: confirmRoot.allConfirmed ? (confirmMouse.pressed ? "#15803d" : "#22c55e") : "#1e293b"
                    border.color: confirmRoot.allConfirmed ? "#4ade80" : "#475569"
                    border.width: 1.5
                    radius: 6
                    enabled: confirmRoot.allConfirmed

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 8

                        Text {
                            text: confirmRoot.allConfirmed ? "✓" : "🔒"
                            color: confirmRoot.allConfirmed ? "#000000" : "#94a3b8"
                            font.bold: true
                            font.pixelSize: 16
                        }

                        Text {
                            text: confirmRoot.allConfirmed ? "CONFIRM POSITIONING" : "CHECK ALL MANUAL VALVES TO UNLOCK"
                            color: confirmRoot.allConfirmed ? "#0b1d33" : "#94a3b8"
                            font.bold: true
                            font.pixelSize: 14
                        }
                    }

                    MouseArea {
                        id: confirmMouse
                        anchors.fill: parent
                        enabled: confirmRoot.allConfirmed
                        cursorShape: confirmRoot.allConfirmed ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: {
                            confirmRoot.confirmed(confirmRoot.activeOperationKey);
                            confirmRoot.closed();
                        }
                    }
                }
            }
        }
    }

    // --- Logic to Toggle Manual Valve & Check All Confirmed ---
    function toggleManualValve(idx) {
        var list = [];
        for (var i = 0; i < valveList.length; i++) {
            var item = valveList[i];
            if (i === idx) {
                item.confirmed = !item.confirmed;
            }
            list.push(item);
        }
        valveList = list;
        checkAllConfirmed();
    }

    function checkAllConfirmed() {
        var allOk = true;
        for (var i = 0; i < valveList.length; i++) {
            if (!valveList[i].isSolenoid && !valveList[i].confirmed) {
                allOk = false;
                break;
            }
        }
        allConfirmed = allOk;
    }

    // --- Operation Preset Loader from config/valves.json ---
    function loadPreset(presetKey) {
        activeOperationKey = presetKey;
        var presets = {
            "discharge_product": {
                name: "Discharge Product",
                instruction: "Product Discharge requires opening V101 & V102 solenoid valves, and manually setting V303 Butterfly Valve to OPEN position.",
                expected: { V101: "OPEN", V102: "OPEN", V103: "CLOSED", V201: "CLOSED", V202: "CLOSED", V203: "CLOSED", V301: "CLOSED", V302: "CLOSED", V303: "OPEN" }
            },
            "discharge_circulation_pipe": {
                name: "Discharge Circulation Pipe",
                instruction: "Discharge Circulation Pipe requires opening V101 & V102 solenoid valves, and closing all manual charging ports.",
                expected: { V101: "OPEN", V102: "OPEN", V103: "CLOSED", V201: "CLOSED", V202: "CLOSED", V203: "CLOSED", V301: "CLOSED", V302: "CLOSED", V303: "CLOSED" }
            },
            "recirculation": {
                name: "External Circulation",
                instruction: "External Circulation requires opening V102 & V103 solenoid valves, and closing all manual charging ports.",
                expected: { V101: "CLOSED", V102: "OPEN", V103: "OPEN", V201: "CLOSED", V202: "CLOSED", V203: "CLOSED", V301: "CLOSED", V302: "CLOSED", V303: "CLOSED" }
            },
            "cip_discharge": {
                name: "CIP Discharge",
                instruction: "CIP Drain Discharge requires opening V202 Drain Discharge solenoid valve.",
                expected: { V101: "CLOSED", V102: "CLOSED", V103: "CLOSED", V201: "CLOSED", V202: "OPEN", V203: "CLOSED", V301: "CLOSED", V302: "CLOSED", V303: "CLOSED" }
            },
            "cip_drying": {
                name: "CIP Drying",
                instruction: "CIP Air Drying requires opening V203 Air Drying solenoid valve.",
                expected: { V101: "CLOSED", V102: "CLOSED", V103: "CLOSED", V201: "CLOSED", V202: "CLOSED", V203: "OPEN", V301: "CLOSED", V302: "CLOSED", V303: "CLOSED" }
            },
            "cip_rinse": {
                name: "CIP Rinse Water",
                instruction: "CIP Water Rinse requires opening V201 Rinse & V202 Drain solenoid valves.",
                expected: { V101: "CLOSED", V102: "CLOSED", V103: "CLOSED", V201: "OPEN", V202: "OPEN", V203: "CLOSED", V301: "CLOSED", V302: "CLOSED", V303: "CLOSED" }
            },
            "suction_liquids": {
                name: "Suction Liquids",
                instruction: "Liquid Port Charging requires manually turning V301 Butterfly Valve to OPEN position.",
                expected: { V101: "CLOSED", V102: "CLOSED", V103: "CLOSED", V201: "CLOSED", V202: "CLOSED", V203: "CLOSED", V301: "OPEN", V302: "CLOSED", V303: "CLOSED" }
            },
            "suction_solids": {
                name: "Suction Solids",
                instruction: "Solids Powder Funnel Charging requires manually turning V302 Butterfly Valve to OPEN position.",
                expected: { V101: "CLOSED", V102: "CLOSED", V103: "CLOSED", V201: "CLOSED", V202: "CLOSED", V203: "CLOSED", V301: "CLOSED", V302: "OPEN", V303: "CLOSED" }
            },
            "suction_bottom": {
                name: "Suction Bottom",
                instruction: "Bottom Port Suction requires manually turning V303 Butterfly Valve to OPEN position.",
                expected: { V101: "CLOSED", V102: "CLOSED", V103: "CLOSED", V201: "CLOSED", V202: "CLOSED", V203: "CLOSED", V301: "CLOSED", V302: "CLOSED", V303: "OPEN" }
            }
        };

        // Normalize aliases:
        var normKey = String(presetKey || "").toLowerCase();
        if (normKey.indexOf("ext_") === 0) normKey = normKey.substring(4);
        if (normKey === "discharge_circulation" || normKey === "discharge circulation" || normKey === "discharge circulation pipe") {
            normKey = "discharge_circulation_pipe";
        } else if (normKey === "discharge_product" || normKey === "discharge product") {
            normKey = "discharge_product";
        } else if (normKey === "cip_rinse" || normKey === "cip rinse") {
            normKey = "cip_rinse";
        } else if (normKey === "cip_discharge" || normKey === "cip discharge") {
            normKey = "cip_discharge";
        } else if (normKey === "cip_drying" || normKey === "cip drying") {
            normKey = "cip_drying";
        } else if (normKey === "suction_liquids" || normKey === "suction liquids") {
            normKey = "suction_liquids";
        } else if (normKey === "suction_solids" || normKey === "suction solids") {
            normKey = "suction_solids";
        } else if (normKey === "suction_bottom" || normKey === "suction bottom") {
            normKey = "suction_bottom";
        }

        var p = presets[normKey] || presets["discharge_circulation_pipe"];
        title = "Confirm Valve Configuration for " + p.name;
        instruction = p.instruction;

        var baseValves = [
            { tag: "V101", name: "Main Vessel Discharge Valve", isSolenoid: true },
            { tag: "V102", name: "External Circulation Return Valve", isSolenoid: true },
            { tag: "V103", name: "Recirculation Divert Valve", isSolenoid: true },
            { tag: "V201", name: "CIP Rinse Water Valve", isSolenoid: true },
            { tag: "V202", name: "CIP Drain Discharge Valve", isSolenoid: true },
            { tag: "V203", name: "CIP Air Drying Valve", isSolenoid: true },
            { tag: "V301", name: "Liquid Port Charging Valve", isSolenoid: false },
            { tag: "V302", name: "Solids Funnel Charging Valve", isSolenoid: false },
            { tag: "V303", name: "Bottom Suction Valve", isSolenoid: false }
        ];

        var list = [];
        var allOk = true;
        for (var i = 0; i < baseValves.length; i++) {
            var v = baseValves[i];
            var exp = p.expected[v.tag] || "CLOSED";
            var isSol = v.isSolenoid;
            var isConfirmed = false;
            if (isSol) {
                isConfirmed = true;
            } else {
                // If the manual valve is expected OPEN, operator MUST confirm it:
                isConfirmed = (exp === "CLOSED");
                if (!isConfirmed) allOk = false;
            }

            list.push({
                tag: v.tag,
                name: v.name,
                isSolenoid: isSol,
                expectedStatus: exp,
                previousStatus: isSol ? "CLOSED" : "-",
                currentStatus: isSol ? exp : (exp === "OPEN" ? "VERIFY OPEN" : "CLOSED"),
                confirmed: isConfirmed
            });
        }
        valveList = list;
        allConfirmed = allOk;
        visible = true;
    }
}
