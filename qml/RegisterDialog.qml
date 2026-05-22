import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Popup {
    id: registerDialog
    modal: true
    anchors.centerIn: Overlay.overlay
    width: 420
    height: dialogCol.implicitHeight + 56
    padding: 0
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    property alias login:    loginField.text
    property alias password: passwordField.text
    property alias fullName: fullNameField.text

    function open() {
        fullNameField.text = ""
        loginField.text = ""
        passwordField.text = ""
        statusMsg.text = ""
        statusMsg.isSuccess = false
        visible = true
    }
    function close() { visible = false }

    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 200 }
        NumberAnimation { property: "scale";   from: 0.92; to: 1; duration: 200; easing.type: Easing.OutCubic }
    }
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 150 }
        NumberAnimation { property: "scale";   from: 1; to: 0.94; duration: 150 }
    }

    background: Rectangle {
        radius: 18
        color: "#0F2A3D"
        border.color: Qt.rgba(1,1,1,0.12); border.width: 1

        // Top shine
        Rectangle {
            anchors.top: parent.top; anchors.topMargin: 1
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.55; height: 1
            color: Qt.rgba(1,1,1,0.20); radius: 1
        }
    }

    // Overlay dim
    Overlay.modal: Rectangle {
        color: Qt.rgba(0, 0.10, 0.18, 0.75)
    }

    ColumnLayout {
        id: dialogCol
        anchors { left: parent.left; right: parent.right; top: parent.top; margins: 28 }
        spacing: 0

        // Header
        Row {
            Layout.fillWidth: true
            spacing: 12

            Rectangle {
                width: 44; height: 44; radius: 12
                color: Qt.rgba(0.16, 0.66, 0.55, 0.20)
                anchors.verticalCenter: parent.verticalCenter
                // Plus cross icon
                Rectangle { width: 3; height: 22; radius: 2; color: "#28A98B"; anchors.centerIn: parent }
                Rectangle { width: 22; height: 3; radius: 2; color: "#28A98B"; anchors.centerIn: parent }
            }

            Column {
                spacing: 3
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    text: "Регистрация сотрудника"
                    font.pixelSize: 18; font.family: "Segoe UI"; font.weight: Font.Bold
                    color: "#FFFFFF"
                }
                Text {
                    text: "Заполните все поля для создания аккаунта"
                    font.pixelSize: 12; font.family: "Segoe UI"
                    color: Qt.rgba(1,1,1,0.40)
                }
            }

            Item { Layout.fillWidth: true }

            // Close X
            Rectangle {
                width: 30; height: 30; radius: 8
                color: closeArea.containsMouse ? Qt.rgba(1,1,1,0.10) : "transparent"
                Behavior on color { ColorAnimation { duration: 120 } }
                anchors.verticalCenter: parent.verticalCenter
                Text { text: "✕"; font.pixelSize: 14; color: Qt.rgba(1,1,1,0.40); anchors.centerIn: parent }
                MouseArea {
                    id: closeArea; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                    onClicked: registerDialog.close()
                }
            }
        }

        // Divider
        Rectangle {
            Layout.fillWidth: true; height: 1
            color: Qt.rgba(1,1,1,0.08)
            Layout.topMargin: 18; Layout.bottomMargin: 20
        }

        // Fields
        Repeater {
            model: [
                { label: "ФИО СОТРУДНИКА",  placeholder: "Иванов Иван Иванович", icon: "👤", echo: TextInput.Normal,   field: "name" },
                { label: "ЛОГИН",            placeholder: "Придумайте логин",      icon: "⌘",  echo: TextInput.Normal,   field: "login" },
                { label: "ПАРОЛЬ",           placeholder: "Придумайте пароль",     icon: "◉",  echo: TextInput.Password, field: "pass" },
            ]
            delegate: Column {
                Layout.fillWidth: true
                spacing: 0

                Text {
                    text: modelData.label
                    font.pixelSize: 10; font.family: "Segoe UI"; font.weight: Font.Bold
                    color: Qt.rgba(1,1,1,0.35); font.letterSpacing: 1.1
                    bottomPadding: 6
                }

                Rectangle {
                    width: parent.width; height: 44; radius: 10
                    color: innerField.activeFocus ? Qt.rgba(1,1,1,0.10) : Qt.rgba(1,1,1,0.05)
                    border.color: innerField.activeFocus ? "#28A98B" : Qt.rgba(1,1,1,0.10)
                    border.width: innerField.activeFocus ? 2 : 1
                    Behavior on color { ColorAnimation { duration: 150 } }
                    Behavior on border.color { ColorAnimation { duration: 150 } }

                    Row {
                        anchors { left: parent.left; leftMargin: 12; verticalCenter: parent.verticalCenter }
                        spacing: 10
                        Text {
                            text: modelData.icon; font.pixelSize: 14
                            color: innerField.activeFocus ? "#28A98B" : Qt.rgba(1,1,1,0.28)
                            anchors.verticalCenter: parent.verticalCenter
                            Behavior on color { ColorAnimation { duration: 150 } }
                        }
                        TextField {
                            id: innerField
                            objectName: modelData.field
                            placeholderText: modelData.placeholder
                            echoMode: modelData.echo
                            width: dialogCol.width - 56 - 56
                            background: Item {}
                            color: "#FFFFFF"; placeholderTextColor: Qt.rgba(1,1,1,0.22)
                            font.pixelSize: 13; font.family: "Segoe UI"
                            selectByMouse: true

                            // Wire up to aliases via objectName
                            onTextChanged: {
                                if (objectName === "name")  fullNameField.text  = text
                                if (objectName === "login") loginField.text = text
                                if (objectName === "pass")  passwordField.text = text
                            }
                        }
                    }
                }

                Item { height: 14 }
            }
        }

        // Hidden alias fields
        TextField { id: fullNameField; visible: false }
        TextField { id: loginField;    visible: false }
        TextField { id: passwordField; visible: false }

        // Status
        Rectangle {
            Layout.fillWidth: true
            height: statusMsg.text !== "" ? 38 : 0
            visible: height > 0
            radius: 8
            color: statusMsg.isSuccess ? Qt.rgba(0.16, 0.66, 0.55, 0.15) : Qt.rgba(0.88, 0.32, 0.32, 0.15)
            border.color: statusMsg.isSuccess ? Qt.rgba(0.16, 0.66, 0.55, 0.30) : Qt.rgba(0.88, 0.32, 0.32, 0.30)
            border.width: 1
            Behavior on height { NumberAnimation { duration: 180 } }
            Layout.bottomMargin: statusMsg.text !== "" ? 12 : 0

            property bool isSuccess: false

            Row {
                anchors.centerIn: parent
                spacing: 8
                Text {
                    text: parent.parent.isSuccess ? "✓" : "✕"
                    font.pixelSize: 12
                    color: parent.parent.isSuccess ? "#28A98B" : "#F08080"
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    id: statusMsg
                    property bool isSuccess: false
                    font.pixelSize: 12; font.family: "Segoe UI"
                    color: isSuccess ? "#28A98B" : "#F08080"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        // Buttons row
        Row {
            Layout.fillWidth: true
            spacing: 10

            // Cancel
            Rectangle {
                width: (parent.width - 10) * 0.38; height: 44; radius: 10
                color: cancelArea.containsMouse ? Qt.rgba(1,1,1,0.10) : Qt.rgba(1,1,1,0.05)
                border.color: Qt.rgba(1,1,1,0.12); border.width: 1
                Behavior on color { ColorAnimation { duration: 120 } }
                scale: cancelArea.pressed ? 0.97 : 1.0; Behavior on scale { NumberAnimation { duration: 100 } }

                Text {
                    anchors.centerIn: parent
                    text: "Отмена"
                    font.pixelSize: 13; font.family: "Segoe UI"
                    color: Qt.rgba(1,1,1,0.55)
                }
                MouseArea {
                    id: cancelArea; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                    onClicked: registerDialog.close()
                }
            }

            // Confirm
            Rectangle {
                width: (parent.width - 10) * 0.62; height: 44; radius: 10
                color: confirmArea.pressed ? "#1E8B72" : confirmArea.containsMouse ? "#2EBD9C" : "#28A98B"
                Behavior on color { ColorAnimation { duration: 120 } }
                scale: confirmArea.pressed ? 0.97 : 1.0; Behavior on scale { NumberAnimation { duration: 100 } }

                Rectangle {
                    anchors.top: parent.top; anchors.topMargin: 1
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width * 0.5; height: 1
                    color: Qt.rgba(1,1,1,0.30); radius: 1
                }

                Text {
                    anchors.centerIn: parent
                    text: "Зарегистрировать"
                    font.pixelSize: 13; font.family: "Segoe UI"; font.weight: Font.SemiBold
                    color: "#FFFFFF"
                }
                MouseArea {
                    id: confirmArea; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        statusMsg.isSuccess = false
                        if (fullNameField.text === "" || loginField.text === "" || passwordField.text === "") {
                            statusMsg.text = "Пожалуйста, заполните все поля"
                        } else {
                            if (dbManager.registerUser(loginField.text, passwordField.text, fullNameField.text)) {
                                statusMsg.isSuccess = true
                                statusMsg.text = "Аккаунт успешно создан"
                                fullNameField.text = loginField.text = passwordField.text = ""
                                closeTimer.start()
                            } else {
                                statusMsg.text = "Логин уже занят или ошибка БД"
                            }
                        }
                    }
                }
            }
        }

        Item { height: 4 }
    }

    Timer {
        id: closeTimer
        interval: 1200
        onTriggered: registerDialog.close()
    }
}
