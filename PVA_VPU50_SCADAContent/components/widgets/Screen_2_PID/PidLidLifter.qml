import QtQuick
import QtQuick.Layouts

Item {
    id: lifterRoot
    width: 170
    height: 440

    property bool isLidRaised: false
    property bool showTags: true

    // 1. TOP HORIZONTAL LIFTING ARM (Extending from Lid Right Shoulder)
    Rectangle {
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.right: screwColumn.horizontalCenter
        height: 6
        color: "#64748b"
        radius: 2
    }

    // 2. VERTICAL ELECTRIC PRECISION SCREW COLUMN
    Rectangle {
        id: screwColumn
        anchors.left: parent.left
        anchors.leftMargin: 80
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.bottom: electricGearBox.top
        width: 5
        color: "#cbd5e1"

        // Screw Thread Hatchings
        Canvas {
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);
                ctx.strokeStyle = "#94a3b8";
                ctx.lineWidth = 1;
                for (var y = 0; y < height; y += 8) {
                    ctx.beginPath();
                    ctx.moveTo(0, y);
                    ctx.lineTo(width, y + 3);
                    ctx.stroke();
                }
            }
        }
    }

    // 3. TOP POSITION & INTERLOCK SENSORS (Spaced cleanly without overlapping)
    ColumnLayout {
        anchors.left: screwColumn.right
        anchors.leftMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 4
        spacing: 4
        visible: lifterRoot.showTags

        RowLayout {
            spacing: 5
            Rectangle { width: 8; height: 8; radius: 4; color: lifterRoot.isLidRaised ? "#22c55e" : "#64748b" }
            Text { text: "GOSH 164 003"; color: "#8cb5dc"; font.pixelSize: 8 }
        }
        RowLayout {
            spacing: 5
            Rectangle { width: 8; height: 8; radius: 4; color: !lifterRoot.isLidRaised ? "#22c55e" : "#64748b" }
            Text { text: "GOSL 164 002"; color: "#8cb5dc"; font.pixelSize: 8 }
        }
        RowLayout {
            spacing: 5
            Rectangle { width: 8; height: 8; radius: 4; color: "#eab308" }
            Text { text: "GZ 164 001"; color: "#8cb5dc"; font.pixelSize: 8 }
        }
    }

    // 4. BOTTOM ELECTRIC SCREW-JACK GEARBOX BASE
    Rectangle {
        id: electricGearBox
        anchors.left: screwColumn.left
        anchors.leftMargin: -12
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 60
        width: 30
        height: 24
        radius: 3
        color: "#1e3a5f"
        border.color: "#3b82f6"
        border.width: 1.2

        Text {
            anchors.centerIn: parent
            text: "GEAR"
            color: "#93c5fd"
            font.bold: true
            font.pixelSize: 6
        }
    }

    // 5. ELECTRIC DRIVE MOTOR M 164 001 (Electric Actuator)
    RowLayout {
        anchors.left: electricGearBox.right
        anchors.leftMargin: 8
        anchors.verticalCenter: electricGearBox.verticalCenter
        spacing: 6

        Rectangle {
            width: 22
            height: 22
            radius: 11
            color: "#0d2847"
            border.color: "#3b82f6"
            border.width: 1.5

            Text {
                anchors.centerIn: parent
                text: "M"
                color: "#ffffff"
                font.bold: true
                font.pixelSize: 10
            }
        }

        ColumnLayout {
            spacing: 0
            visible: lifterRoot.showTags
            Text { text: "M 164 001"; color: "#ffffff"; font.bold: true; font.pixelSize: 8 }
            Text { text: "Lid Motor"; color: "#8cb5dc"; font.pixelSize: 7 }
        }
    }
}
