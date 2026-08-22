import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: toolbarRoot
    implicitWidth: 900
    width: 900
    implicitHeight: 52
    height: 52
    color: "#08213b"
    border.color: "#184d7e"
    border.width: 1
    radius: 6

    property string activeTab: "matrix" // "matrix" or "formulation"
    property var recipes: []
    property int selectedIndex: 0
    property bool isExecuting: false

    signal tabChanged(string newTab)
    signal recipeSelected(int index)
    signal newRecipeRequested()
    signal deleteRecipeRequested()
    signal addStepRequested()
    signal executeToggleRequested()

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 12

        // 1. Dual Tab Switcher: [ Formulation ] | [ Recipe Matrix ]
        Rectangle {
            Layout.preferredHeight: 36
            Layout.preferredWidth: 240
            color: "#06182c"
            border.color: "#184d7e"
            border.width: 1
            radius: 5

            RowLayout {
                anchors.fill: parent
                spacing: 0

                // Formulation Tab
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 4
                    color: toolbarRoot.activeTab === "formulation" ? "#164e85" : "transparent"
                    border.color: toolbarRoot.activeTab === "formulation" ? "#00d2ff" : "transparent"
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "Formulation"
                        color: toolbarRoot.activeTab === "formulation" ? "#ffffff" : "#94a3b8"
                        font.bold: toolbarRoot.activeTab === "formulation"
                        font.pixelSize: 12
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: toolbarRoot.tabChanged("formulation")
                    }
                }

                // Recipe Matrix Tab
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 4
                    color: toolbarRoot.activeTab === "matrix" ? "#164e85" : "transparent"
                    border.color: toolbarRoot.activeTab === "matrix" ? "#00d2ff" : "transparent"
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "Recipe Matrix"
                        color: toolbarRoot.activeTab === "matrix" ? "#ffffff" : "#94a3b8"
                        font.bold: toolbarRoot.activeTab === "matrix"
                        font.pixelSize: 12
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: toolbarRoot.tabChanged("matrix")
                    }
                }
            }
        }

        // 2. Recipe Selector Dropdown with Real Interactive Popup Menu
        RowLayout {
            spacing: 6

            Text {
                text: "Recipe:"
                color: "#cbd5e1"
                font.bold: true
                font.pixelSize: 12
            }

            Rectangle {
                id: dropdownBox
                Layout.preferredWidth: 260
                Layout.preferredHeight: 36
                color: "#091a2a"
                border.color: recipeMenu.visible ? "#00d2ff" : "#1a4070"
                border.width: 1
                radius: 4

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10

                    Text {
                        text: toolbarRoot.recipes.length > 0 && toolbarRoot.recipes[toolbarRoot.selectedIndex]
                              ? (toolbarRoot.recipes[toolbarRoot.selectedIndex].name + " (" + toolbarRoot.recipes[toolbarRoot.selectedIndex].steps.length + " steps)")
                              : "Select Recipe..."
                        color: "#ffffff"
                        font.bold: true
                        font.pixelSize: 12
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }

                    Text {
                        text: recipeMenu.visible ? "▲" : "▼"
                        color: "#38bdf8"
                        font.pixelSize: 10
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: recipeMenu.open()
                }

                Menu {
                    id: recipeMenu
                    y: dropdownBox.height + 2
                    width: dropdownBox.width
                    background: Rectangle {
                        color: "#08213b"
                        border.color: "#00d2ff"
                        border.width: 1.5
                        radius: 6
                    }

                    Repeater {
                        model: toolbarRoot.recipes
                        MenuItem {
                            height: 34
                            contentItem: Text {
                                text: modelData.name + " (" + modelData.steps.length + " steps)"
                                color: toolbarRoot.selectedIndex === index ? "#00d2ff" : "#ffffff"
                                font.bold: toolbarRoot.selectedIndex === index
                                font.pixelSize: 12
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: 8
                            }
                            background: Rectangle {
                                color: hovered ? "#164e85" : (toolbarRoot.selectedIndex === index ? "#0c345a" : "transparent")
                            }
                            onTriggered: toolbarRoot.recipeSelected(index)
                        }
                    }
                }
            }
        }

        Item { Layout.fillWidth: true }

        RowLayout {
            spacing: 8
            Layout.alignment: Qt.AlignVCenter

            Rectangle {
                Layout.preferredWidth: 68
                Layout.preferredHeight: 34
                color: "#1e40af"
                border.color: "#3b82f6"
                border.width: 1
                radius: 4
                Text { anchors.centerIn: parent; text: "+ New"; color: "#ffffff"; font.bold: true; font.pixelSize: 12 }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: toolbarRoot.newRecipeRequested()
                }
            }

            // Delete Button
            Rectangle {
                Layout.preferredWidth: 68
                Layout.preferredHeight: 34
                color: "#7f1d1d"
                border.color: "#ef4444"
                border.width: 1
                radius: 4
                Text { anchors.centerIn: parent; text: "Delete"; color: "#fca5a5"; font.bold: true; font.pixelSize: 12 }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: toolbarRoot.deleteRecipeRequested()
                }
            }

            // + Step Button
            Rectangle {
                Layout.preferredWidth: 72
                Layout.preferredHeight: 34
                color: "#14532d"
                border.color: "#22c55e"
                border.width: 1
                radius: 4
                Text { anchors.centerIn: parent; text: "+ Step"; color: "#86efac"; font.bold: true; font.pixelSize: 12 }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: toolbarRoot.addStepRequested()
                }
            }

            // Execute / Pause Button
            Rectangle {
                Layout.preferredWidth: 104
                Layout.preferredHeight: 34
                color: toolbarRoot.isExecuting ? "#15803d" : "#16a34a"
                border.color: "#4ade80"
                border.width: 1.5
                radius: 4
                Text {
                    anchors.centerIn: parent
                    text: toolbarRoot.isExecuting ? "Pause" : "Execute"
                    color: "#ffffff"
                    font.bold: true
                    font.pixelSize: 13
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: toolbarRoot.executeToggleRequested()
                }
            }
        }
    }
}
