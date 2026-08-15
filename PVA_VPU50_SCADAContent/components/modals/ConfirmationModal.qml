import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../config"

Rectangle {
    id: confirmRoot
    anchors.fill: parent
    color: "#bb000000"
    visible: false
    z: 999

    ScadaConfig { id: scadaConfig }

    property string title: "Confirm Valve Configuration"
    property string instruction: "Please verify and confirm manual valve positions before beginning sequence."
    property string activeOperationKey: "discharge_product"
    property bool allConfirmed: false
    property var valveList: []

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

    // --- Operation Preset Loader from centralized ScadaConfig ---
    function loadPreset(presetKey) {
        activeOperationKey = presetKey;
        var p = scadaConfig.getPreset(presetKey);
        title = "Confirm Valve Configuration for " + p.name;
        instruction = p.instruction;

        var baseValves = scadaConfig.valveList;
        var list = [];
        var allOk = true;

        for (var i = 0; i < baseValves.length; i++) {
            var v = baseValves[i];
            var exp = (p.expected && p.expected[v.tag]) ? p.expected[v.tag] : "CLOSED";
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
