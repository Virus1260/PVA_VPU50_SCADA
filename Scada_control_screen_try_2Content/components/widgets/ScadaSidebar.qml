import QtQuick
import QtQuick.Layouts

Rectangle {
    id: sidebarRoot
    width: 76
    color: "#08213b"

    property int activeIndex: 0

    property var navItems: [
        { name: "Control", icon: "status_stack", label: "Ctrl" },
        { name: "P&ID", icon: "pid_vessel", label: "P&ID" },
        { name: "Trends", icon: "trends_chart", label: "Trend" },
        { name: "Alarms", icon: "alarms_bell", label: "Alm" },
        { name: "Recipes", icon: "recipes_checklist", label: "Rcp" },
        { name: "Audit", icon: "docs_report", label: "EBR" },
        { name: "Playback", icon: "logs_order", label: "Log" },
        { name: "Tools", icon: "tools_maintenance", label: "Diag" }
    ]

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 4
        spacing: 4

        Repeater {
            model: sidebarRoot.navItems

            delegate: Rectangle {
                id: navBtn
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 4

                property bool isActive: sidebarRoot.activeIndex === index

                color: isActive ? "#155590" : "#0d365e"
                border.color: isActive ? "#00d2ff" : "#1a5286"
                border.width: isActive ? 2 : 1

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 2

                    ScadaIcon {
                        iconName: modelData.icon
                        iconColor: "#ffffff"
                        width: 32
                        height: 32
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: modelData.label
                        color: navBtn.isActive ? "#ffffff" : "#8cb5dc"
                        font.bold: navBtn.isActive
                        font.pixelSize: 10
                        Layout.alignment: Qt.AlignHCenter
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: sidebarRoot.activeIndex = index
                }
            }
        }
    }
}
