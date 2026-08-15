import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: pidRoot
    color: "#061322"

    // Property bindings for external telemetry updates
    property double stirrerRpm: 25.0
    property bool stirrerRunning: true
    property double homoRpm: 600.0
    property bool homoRunning: false
    property double mfgTemp: 40.1
    property double mfgPressure: -209.8
    property double loopTemp: 23.2
    property bool lidLiftActive: false
    property int agitatorFrame: 0

    // Zoom and pan properties
    property real zoomLevel: 1.0

    signal componentTapped(string tagName)

    // Agitator 3D rotation frame animation loop
    Timer {
        interval: Math.max(30, Math.min(300, 3000 / Math.max(1, pidRoot.stirrerRpm)))
        running: pidRoot.stirrerRunning
        repeat: true
        onTriggered: {
            pidRoot.agitatorFrame = (pidRoot.agitatorFrame + 1) % 24
        }
    }

    Flickable {
        id: flick
        anchors.fill: parent
        contentWidth: Math.max(width, 1100 * pidRoot.zoomLevel)
        contentHeight: Math.max(height, 700 * pidRoot.zoomLevel)
        clip: true

        Item {
            width: Math.max(flick.width, 1100 * pidRoot.zoomLevel)
            height: Math.max(flick.height, 700 * pidRoot.zoomLevel)

            Item {
                id: canvasHolder
                anchors.centerIn: parent
                width: 1000 * pidRoot.zoomLevel
                height: 640 * pidRoot.zoomLevel

                // LAYER 1: PROCESS PIPING (Canvas)
                Canvas {
                    id: pipeCanvas
                    anchors.fill: parent

                    onPaint: {
                        var ctx = getContext("2d");
                        ctx.clearRect(0, 0, width, height);
                        var s = pidRoot.zoomLevel;

                        ctx.lineWidth = 3.0 * s;
                        ctx.lineCap = "round";
                        ctx.lineJoin = "round";

                        var normalPipe = "#29b6f6";
                        var activePipe = "#00e676";

                        // 1. Upper Jacket Pipe
                        ctx.strokeStyle = activePipe;
                        ctx.beginPath();
                        ctx.moveTo(330 * s, 195 * s);
                        ctx.lineTo(290 * s, 195 * s);
                        ctx.lineTo(290 * s, 220 * s);
                        ctx.lineTo(330 * s, 220 * s);
                        ctx.stroke();

                        // 2. Lower Jacket Pipe
                        ctx.strokeStyle = activePipe;
                        ctx.beginPath();
                        ctx.moveTo(330 * s, 320 * s);
                        ctx.lineTo(290 * s, 320 * s);
                        ctx.lineTo(290 * s, 350 * s);
                        ctx.lineTo(330 * s, 350 * s);
                        ctx.stroke();

                        // 3. Right Upper Jacket
                        ctx.beginPath();
                        ctx.moveTo(670 * s, 195 * s);
                        ctx.lineTo(710 * s, 195 * s);
                        ctx.lineTo(710 * s, 220 * s);
                        ctx.lineTo(670 * s, 220 * s);
                        ctx.stroke();

                        // 4. Right Lower Jacket
                        ctx.beginPath();
                        ctx.moveTo(670 * s, 320 * s);
                        ctx.lineTo(710 * s, 320 * s);
                        ctx.lineTo(710 * s, 350 * s);
                        ctx.lineTo(670 * s, 350 * s);
                        ctx.stroke();

                        // 5. Homogenizer Bottom Outlet & Recirculation Loop
                        ctx.strokeStyle = pidRoot.homoRunning ? activePipe : normalPipe;
                        ctx.beginPath();
                        ctx.moveTo(500 * s, 450 * s);
                        ctx.lineTo(500 * s, 524 * s);
                        ctx.stroke();

                        ctx.beginPath();
                        ctx.moveTo(524 * s, 536 * s);
                        ctx.lineTo(620 * s, 536 * s);
                        ctx.lineTo(620 * s, 528 * s);
                        ctx.stroke();

                        ctx.beginPath();
                        ctx.moveTo(644 * s, 536 * s);
                        ctx.lineTo(700 * s, 536 * s);
                        ctx.lineTo(700 * s, 370 * s);
                        ctx.lineTo(572 * s, 370 * s);
                        ctx.lineTo(572 * s, 368 * s);
                        ctx.stroke();

                        // 6. Solids / Liquids Suction Inlets
                        ctx.strokeStyle = activePipe;
                        ctx.beginPath();
                        ctx.moveTo(380 * s, 546 * s);
                        ctx.lineTo(420 * s, 546 * s);
                        ctx.moveTo(380 * s, 572 * s);
                        ctx.lineTo(420 * s, 572 * s);
                        ctx.stroke();

                        // 7. Venting & Air Lines at Top
                        ctx.strokeStyle = normalPipe;
                        ctx.beginPath();
                        ctx.moveTo(386 * s, 50 * s);
                        ctx.lineTo(386 * s, 85 * s);
                        ctx.moveTo(474 * s, 50 * s);
                        ctx.lineTo(474 * s, 85 * s);
                        ctx.stroke();
                    }
                }

                // LAYER 2: VESSEL GRAPHIC (1B1001 - UNIMIX 50)
                Rectangle {
                    x: 330 * pidRoot.zoomLevel
                    y: 85 * pidRoot.zoomLevel
                    width: 340 * pidRoot.zoomLevel
                    height: 380 * pidRoot.zoomLevel
                    color: "transparent"
                    border.color: "#38bdf8"
                    border.width: 3
                    radius: 30

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: -10 * pidRoot.zoomLevel
                        color: "transparent"
                        border.color: "#1e4976"
                        border.width: 2
                        radius: 38
                        z: -1
                    }

                    Rectangle {
                        anchors.top: parent.top
                        anchors.topMargin: 12 * pidRoot.zoomLevel
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 140 * pidRoot.zoomLevel
                        height: 24 * pidRoot.zoomLevel
                        color: "#08223c"
                        border.color: "#164673"
                        radius: 4

                        Text {
                            anchors.centerIn: parent
                            text: "1B1001 (UNIMIX 50)"
                            color: "#ffffff"
                            font.bold: true
                            font.pixelSize: 11
                        }
                    }

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.margins: 4
                        height: parent.height * 0.55
                        color: "#0d4373"
                        opacity: 0.4
                        radius: 26
                    }
                }

                // LAYER 3: 3D ROTATING AGITATOR (EKATO PARAVISC)
                Item {
                    x: 412 * pidRoot.zoomLevel
                    y: 110 * pidRoot.zoomLevel
                    width: 176 * pidRoot.zoomLevel
                    height: 260 * pidRoot.zoomLevel

                    Image {
                        id: agitatorImg
                        anchors.fill: parent
                        source: "../assets/ekato_paravisc.svg"
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }

                    Rectangle {
                        anchors.top: parent.top
                        anchors.topMargin: -35 * pidRoot.zoomLevel
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 14 * pidRoot.zoomLevel
                        height: 40 * pidRoot.zoomLevel
                        color: "#6b8ea8"
                        border.color: "#1b436c"
                        border.width: 1
                    }

                    Rectangle {
                        anchors.top: parent.top
                        anchors.topMargin: -75 * pidRoot.zoomLevel
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 50 * pidRoot.zoomLevel
                        height: 40 * pidRoot.zoomLevel
                        color: pidRoot.stirrerRunning ? "#0f4a7c" : "#09223a"
                        border.color: pidRoot.stirrerRunning ? "#00e676" : "#215c9b"
                        border.width: 2
                        radius: 4

                        Text {
                            anchors.centerIn: parent
                            text: "1M1501\nSTIRRER"
                            color: "#ffffff"
                            font.bold: true
                            font.pixelSize: 8
                            horizontalAlignment: Text.AlignHCenter
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: pidRoot.componentTapped("1M1501")
                        }
                    }
                }

                // LAYER 4: HYDRAULIC LID LIFT
                Rectangle {
                    x: 730 * pidRoot.zoomLevel
                    y: 85 * pidRoot.zoomLevel
                    width: 28 * pidRoot.zoomLevel
                    height: 280 * pidRoot.zoomLevel
                    color: "#0a2644"
                    border.color: "#1a558a"
                    border.width: 1
                    radius: 3

                    Rectangle {
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 12 * pidRoot.zoomLevel
                        height: parent.height * 0.4
                        color: "#94b6d4"
                    }

                    Text {
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 8
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "LIFT\n1M4001"
                        color: "#91b8db"
                        font.pixelSize: 7
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: pidRoot.componentTapped("1M4001")
                    }
                }

                // LAYER 5: BOTTOM HOMOGENIZER
                Rectangle {
                    x: 470 * pidRoot.zoomLevel
                    y: 565 * pidRoot.zoomLevel
                    width: 60 * pidRoot.zoomLevel
                    height: 46 * pidRoot.zoomLevel
                    color: pidRoot.homoRunning ? "#0f4a7c" : "#09223a"
                    border.color: pidRoot.homoRunning ? "#00e676" : "#215c9b"
                    border.width: 2
                    radius: 4

                    Text {
                        anchors.centerIn: parent
                        text: "1M2003\nHOMO"
                        color: "#ffffff"
                        font.bold: true
                        font.pixelSize: 9
                        horizontalAlignment: Text.AlignHCenter
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: pidRoot.componentTapped("1M2003")
                    }
                }

                // LAYER 6: PROCESS VALVES
                // Valve K 163 002
                Rectangle {
                    x: 456 * pidRoot.zoomLevel
                    y: 512 * pidRoot.zoomLevel
                    width: 28 * pidRoot.zoomLevel
                    height: 28 * pidRoot.zoomLevel
                    color: "#0a2644"
                    border.color: "#00e676"
                    border.width: 2
                    radius: 4

                    Text {
                        anchors.centerIn: parent
                        text: "K163"
                        color: "#ffffff"
                        font.bold: true
                        font.pixelSize: 8
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: pidRoot.componentTapped("K 163 002")
                    }
                }

                // Valve V 142 201 (Bottom Drain)
                Rectangle {
                    x: 606 * pidRoot.zoomLevel
                    y: 436 * pidRoot.zoomLevel
                    width: 28 * pidRoot.zoomLevel
                    height: 28 * pidRoot.zoomLevel
                    color: "#0a2644"
                    border.color: "#38bdf8"
                    border.width: 2
                    radius: 4

                    Text {
                        anchors.centerIn: parent
                        text: "V142"
                        color: "#ffffff"
                        font.bold: true
                        font.pixelSize: 8
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: pidRoot.componentTapped("V 142 201")
                    }
                }

                // Valve K 143 002 (Suction Solids)
                Rectangle {
                    x: 406 * pidRoot.zoomLevel
                    y: 532 * pidRoot.zoomLevel
                    width: 28 * pidRoot.zoomLevel
                    height: 28 * pidRoot.zoomLevel
                    color: "#0a2644"
                    border.color: "#38bdf8"
                    border.width: 2
                    radius: 4

                    Text {
                        anchors.centerIn: parent
                        text: "K143"
                        color: "#ffffff"
                        font.bold: true
                        font.pixelSize: 8
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: pidRoot.componentTapped("K 143 002")
                    }
                }

                // Valve 1K1001 (Vent Valve Top)
                Rectangle {
                    x: 372 * pidRoot.zoomLevel
                    y: 50 * pidRoot.zoomLevel
                    width: 28 * pidRoot.zoomLevel
                    height: 28 * pidRoot.zoomLevel
                    color: "#0a2644"
                    border.color: "#38bdf8"
                    border.width: 2
                    radius: 4

                    Text {
                        anchors.centerIn: parent
                        text: "1K10"
                        color: "#ffffff"
                        font.bold: true
                        font.pixelSize: 8
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: pidRoot.componentTapped("1K1001 Vent")
                    }
                }

                // LAYER 7: TRANSMITTER CARDS OVERLAY
                Rectangle {
                    x: 230 * pidRoot.zoomLevel
                    y: 35 * pidRoot.zoomLevel
                    width: 110 * pidRoot.zoomLevel
                    height: 48 * pidRoot.zoomLevel
                    color: "#0d2644e6"
                    border.color: "#215c9b"
                    border.width: 1
                    radius: 4

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 4
                        spacing: 1
                        Text { text: "SCR 182001"; color: "#7aabcf"; font.pixelSize: 9; Layout.alignment: Qt.AlignHCenter }
                        Text { text: "Stirrer Speed"; color: "#91b8db"; font.pixelSize: 8; Layout.alignment: Qt.AlignHCenter }
                        Text { text: pidRoot.stirrerRpm.toFixed(1) + " rpm"; color: "#38bdf8"; font.bold: true; font.pixelSize: 12; Layout.alignment: Qt.AlignHCenter }
                    }
                }

                Rectangle {
                    x: 520 * pidRoot.zoomLevel
                    y: 35 * pidRoot.zoomLevel
                    width: 110 * pidRoot.zoomLevel
                    height: 48 * pidRoot.zoomLevel
                    color: "#0d2644e6"
                    border.color: "#215c9b"
                    border.width: 1
                    radius: 4

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 4
                        spacing: 1
                        Text { text: "SCR 163001"; color: "#7aabcf"; font.pixelSize: 9; Layout.alignment: Qt.AlignHCenter }
                        Text { text: "Homo Speed"; color: "#91b8db"; font.pixelSize: 8; Layout.alignment: Qt.AlignHCenter }
                        Text { text: Math.round(pidRoot.homoRpm) + " rpm"; color: "#38bdf8"; font.bold: true; font.pixelSize: 12; Layout.alignment: Qt.AlignHCenter }
                    }
                }

                Rectangle {
                    x: 210 * pidRoot.zoomLevel
                    y: 95 * pidRoot.zoomLevel
                    width: 110 * pidRoot.zoomLevel
                    height: 48 * pidRoot.zoomLevel
                    color: "#0d2644e6"
                    border.color: "#215c9b"
                    border.width: 1
                    radius: 4

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 4
                        spacing: 1
                        Text { text: "PIC 161001"; color: "#7aabcf"; font.pixelSize: 9; Layout.alignment: Qt.AlignHCenter }
                        Text { text: "Vessel Press"; color: "#91b8db"; font.pixelSize: 8; Layout.alignment: Qt.AlignHCenter }
                        Text { text: pidRoot.mfgPressure.toFixed(1) + " mbar"; color: "#00e5ff"; font.bold: true; font.pixelSize: 12; Layout.alignment: Qt.AlignHCenter }
                    }
                }

                Rectangle {
                    x: 690 * pidRoot.zoomLevel
                    y: 95 * pidRoot.zoomLevel
                    width: 110 * pidRoot.zoomLevel
                    height: 48 * pidRoot.zoomLevel
                    color: "#0d2644e6"
                    border.color: "#215c9b"
                    border.width: 1
                    radius: 4

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 4
                        spacing: 1
                        Text { text: "TIC 162001"; color: "#7aabcf"; font.pixelSize: 9; Layout.alignment: Qt.AlignHCenter }
                        Text { text: "Product Temp"; color: "#91b8db"; font.pixelSize: 8; Layout.alignment: Qt.AlignHCenter }
                        Text { text: pidRoot.mfgTemp.toFixed(1) + " °C"; color: "#ff9100"; font.bold: true; font.pixelSize: 12; Layout.alignment: Qt.AlignHCenter }
                    }
                }
            }
        }
    }

    // Mini-map & Zoom Controls
    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 12
        width: 130
        height: 74
        color: "#0a2644e6"
        border.color: "#215c9b"
        border.width: 1
        radius: 6

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 6
            spacing: 4

            Text {
                text: "P&ID SCHEMATIC"
                color: "#91b8db"
                font.bold: true
                font.pixelSize: 9
                Layout.alignment: Qt.AlignHCenter
            }

            RowLayout {
                spacing: 6
                Layout.alignment: Qt.AlignHCenter

                Button {
                    text: "−"
                    Layout.preferredWidth: 26
                    Layout.preferredHeight: 24
                    onClicked: pidRoot.zoomLevel = Math.max(0.7, pidRoot.zoomLevel - 0.15)
                }

                Text {
                    text: Math.round(pidRoot.zoomLevel * 100) + "%"
                    color: "#ffffff"
                    font.bold: true
                    font.pixelSize: 11
                }

                Button {
                    text: "+"
                    Layout.preferredWidth: 26
                    Layout.preferredHeight: 24
                    onClicked: pidRoot.zoomLevel = Math.min(2.5, pidRoot.zoomLevel + 0.15)
                }
            }

            Button {
                text: "Reset View"
                Layout.fillWidth: true
                Layout.preferredHeight: 18
                onClicked: pidRoot.zoomLevel = 1.0
            }
        }
    }
}
