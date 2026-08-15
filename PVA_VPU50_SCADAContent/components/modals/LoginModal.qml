import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../config"

Rectangle {
    id: loginModalRoot
    implicitWidth: 1024
    implicitHeight: 600
    width: 1024
    height: 600
    color: "#bb000000"
    z: 999

    ScadaConfig { id: scadaConfig }

    // Active session details
    property string currentUserId: "operator"
    property string currentUserName: "Line Operator"
    property string currentUserRole: "Operator (Level 1)"
    property int currentUserLevel: 1

    // Target login details
    property string targetUserId: "admin"
    property string targetUserName: "System Administrator"
    property string targetUserRole: "Administrator (Level 5)"
    property int targetUserLevel: 5
    property string targetDescription: "Full unrestricted system access, user management, security audit log export."

    property string enteredPin: ""
    property string errorMessage: ""
    property int failedAttempts: 0

    signal loginSuccess(string userId, string userName, string userRole, int userLevel)
    signal userLoggedOut()
    signal closed()

    MouseArea {
        anchors.fill: parent
        onClicked: {} // Block clicks from propagating
    }

    Rectangle {
        id: modalBox
        anchors.centerIn: parent
        width: 580
        height: 480
        color: "#08213b"
        border.color: "#184d7e"
        border.width: 2
        radius: 12
        clip: true

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 12

            // 1. Header Bar
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Text {
                    text: "🔐 USER AUTHENTICATION & ACCESS CONTROL"
                    color: "#ffffff"
                    font.bold: true
                    font.pixelSize: 16
                    Layout.fillWidth: true
                }

                Rectangle {
                    width: 28
                    height: 28
                    radius: 4
                    color: "#0d365e"
                    border.color: "#1d5b94"
                    border.width: 1
                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        color: "#ffffff"
                        font.bold: true
                        font.pixelSize: 14
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: loginModalRoot.closed()
                    }
                }
            }

            // 2. Active Session Card + Logout Button
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 46
                color: "#0b2a4a"
                border.color: "#1d5b94"
                border.width: 1
                radius: 6

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 10
                    spacing: 10

                    Text {
                        text: "ACTIVE SESSION:"
                        color: "#7dd3fc"
                        font.bold: true
                        font.pixelSize: 11
                    }

                    Text {
                        text: loginModalRoot.currentUserName + " [" + loginModalRoot.currentUserRole + "]"
                        color: "#ffffff"
                        font.bold: true
                        font.pixelSize: 12
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }

                    // Logout Button (Resets to default Operator)
                    Rectangle {
                        Layout.preferredWidth: 84
                        Layout.preferredHeight: 30
                        color: logoutMouse.pressed ? "#7f1d1d" : "#dc2626"
                        radius: 4
                        visible: loginModalRoot.currentUserLevel > 1

                        Text {
                            anchors.centerIn: parent
                            text: "LOGOUT"
                            color: "#ffffff"
                            font.bold: true
                            font.pixelSize: 11
                        }

                        MouseArea {
                            id: logoutMouse
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                loginModalRoot.currentUserId = "operator";
                                loginModalRoot.currentUserName = "Line Operator";
                                loginModalRoot.currentUserRole = "Operator (Level 1)";
                                loginModalRoot.currentUserLevel = 1;
                                loginModalRoot.enteredPin = "";
                                loginModalRoot.errorMessage = "";
                                loginModalRoot.userLoggedOut();
                                loginModalRoot.closed();
                            }
                        }
                    }
                }
            }

            // 3. User Selection Tabs (Operator, Supervisor, QA Officer, Maintenance, Admin)
            RowLayout {
                Layout.fillWidth: true
                spacing: 6

                Repeater {
                    model: scadaConfig.userList

                    delegate: Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 38
                        radius: 5
                        color: loginModalRoot.targetUserId === modelData.id ? "#164e85" : (uMouse.containsMouse ? "#124373" : "#0c345a")
                        border.color: loginModalRoot.targetUserId === modelData.id ? "#00d2ff" : (uMouse.containsMouse ? "#3b82f6" : "#1d5b94")
                        border.width: loginModalRoot.targetUserId === modelData.id ? 2 : 1

                        Text {
                            anchors.centerIn: parent
                            text: modelData.name + "\nL" + modelData.level
                            color: loginModalRoot.targetUserId === modelData.id ? "#ffffff" : "#94a3b8"
                            font.bold: loginModalRoot.targetUserId === modelData.id
                            font.pixelSize: 11
                            horizontalAlignment: Text.AlignHCenter
                        }

                        MouseArea {
                            id: uMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                loginModalRoot.targetUserId = modelData.id;
                                loginModalRoot.targetUserName = modelData.name;
                                loginModalRoot.targetUserRole = modelData.role;
                                loginModalRoot.targetUserLevel = modelData.level;
                                loginModalRoot.targetDescription = modelData.description;
                                loginModalRoot.enteredPin = "";
                                loginModalRoot.errorMessage = "";
                            }
                        }
                    }
                }
            }

            // 4. Role Description & Target Info Card
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 38
                color: "#071b30"
                border.color: "#184d7e"
                border.width: 1
                radius: 6

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    spacing: 8

                    Text {
                        text: "PERMISSIONS:"
                        color: "#38bdf8"
                        font.bold: true
                        font.pixelSize: 11
                    }

                    Text {
                        text: loginModalRoot.targetDescription
                        color: "#cbd5e1"
                        font.pixelSize: 11
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }
                }
            }

            // 5. PIN Input Display & Error Banner
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 46
                color: loginModalRoot.errorMessage !== "" ? "#451a03" : "#05162a"
                border.color: loginModalRoot.errorMessage !== "" ? "#ef4444" : "#00d2ff"
                border.width: 1.5
                radius: 6

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 14
                    anchors.rightMargin: 14
                    spacing: 10

                    Text {
                        text: "ENTER PIN / PASSWORD:"
                        color: "#94a3b8"
                        font.bold: true
                        font.pixelSize: 11
                    }

                    // Masked PIN display dots
                    Text {
                        text: loginModalRoot.enteredPin.length > 0 ? "● ".repeat(loginModalRoot.enteredPin.length) : "••••"
                        color: loginModalRoot.enteredPin.length > 0 ? "#00d2ff" : "#475569"
                        font.bold: true
                        font.pixelSize: 20
                        Layout.fillWidth: true
                    }

                    Text {
                        text: loginModalRoot.errorMessage
                        color: "#f87171"
                        font.bold: true
                        font.pixelSize: 11
                        visible: loginModalRoot.errorMessage !== ""
                    }
                }
            }

            // 6. On-Screen Touchscreen PIN Keypad
            GridLayout {
                columns: 3
                Layout.fillWidth: true
                Layout.fillHeight: true
                columnSpacing: 8
                rowSpacing: 8

                Repeater {
                    model: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "⌫ CLEAR", "0", "✓ LOGIN"]

                    delegate: Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: 6
                        color: modelData === "✓ LOGIN" ? (kMouse.pressed ? "#15803d" : "#22c55e") :
                               modelData === "⌫ CLEAR" ? (kMouse.pressed ? "#991b1b" : "#b91c1c") :
                               (kMouse.pressed ? "#07203a" : (kMouse.containsMouse ? "#185590" : "#0d365e"))
                        border.color: modelData === "✓ LOGIN" ? "#4ade80" : (modelData === "⌫ CLEAR" ? "#f87171" : "#1d5b94")
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: modelData
                            color: modelData === "✓ LOGIN" ? "#08213b" : "#ffffff"
                            font.bold: true
                            font.pixelSize: modelData.length > 1 ? 12 : 16
                        }

                        MouseArea {
                            id: kMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (modelData === "⌫ CLEAR") {
                                    loginModalRoot.enteredPin = "";
                                    loginModalRoot.errorMessage = "";
                                } else if (modelData === "✓ LOGIN") {
                                    loginModalRoot.verifyLogin();
                                } else {
                                    if (loginModalRoot.enteredPin.length < 8) {
                                        loginModalRoot.enteredPin += modelData;
                                        loginModalRoot.errorMessage = "";
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // --- Authentication Verification Function ---
    function verifyLogin() {
        if (scadaConfig.verifyCredentials(targetUserId, enteredPin)) {
            currentUserId = targetUserId;
            currentUserName = targetUserName;
            currentUserRole = targetUserRole;
            currentUserLevel = targetUserLevel;
            failedAttempts = 0;
            errorMessage = "";
            enteredPin = "";
            loginSuccess(currentUserId, currentUserName, currentUserRole, currentUserLevel);
            closed();
        } else {
            failedAttempts++;
            enteredPin = "";
            errorMessage = "Invalid PIN! Attempt " + failedAttempts + " of 3 (Logged to Audit Trail)";
        }
    }
}
