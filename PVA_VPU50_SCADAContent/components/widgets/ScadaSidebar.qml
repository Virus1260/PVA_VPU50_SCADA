import QtQuick
import QtQuick.Layouts

Rectangle {
    id: sidebarRoot
    width: 88
    color: "#08213b"

    property int activeIndex: 0

    property var navItems: [
        { name: "Control", icon: "status_stack", label: "Control" },
        { name: "P&ID", icon: "pid_vessel", label: "P&ID" },
        { name: "Trends", icon: "trends_chart", label: "Trends" },
        { name: "Alarms", icon: "alarms_bell", label: "Alarms" },
        { name: "Recipes", icon: "recipes_checklist", label: "Recipes" },
        { name: "Reports", icon: "docs_report", label: "Reports" },
        { name: "AuditLog", icon: "logs_order", label: "Audit Log" },
        { name: "Diagnostics", icon: "tools_maintenance", label: "Diagnostics" }
    ]

    ColumnLayout {
        anchors.fill: parent
        anchors.leftMargin: 4
        anchors.rightMargin: 4
        anchors.topMargin: 6
        anchors.bottomMargin: 6
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
                    spacing: 3

                    ScadaIcon {
                        iconName: modelData.icon
                        iconColor: "#ffffff"
                        width: 28
                        height: 28
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: modelData.label
                        color: navBtn.isActive ? "#ffffff" : "#8cb5dc"
                        font.bold: navBtn.isActive
                        font.pixelSize: 10
                        Layout.alignment: Qt.AlignHCenter
                        elide: Text.ElideRight
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
