import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    signal loginSuccess

    RegisterDialog { id: registerDialog }

    background: Rectangle { color: "#0D3349" }

    // Animated background dots
    Canvas {
        id: bgCanvas
        anchors.fill: parent
        property real t: 0

        onTChanged: requestPaint()

        NumberAnimation on t {
            from: 0; to: Math.PI * 2
            duration: 12000
            loops: Animation.Infinite
            running: true
        }

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            var dots = [
                { x: 0.12, y: 0.20, r: 90,  a: 0.06 },
                { x: 0.85, y: 0.10, r: 130, a: 0.05 },
                { x: 0.75, y: 0.80, r: 100, a: 0.07 },
                { x: 0.20, y: 0.85, r: 70,  a: 0.05 },
                { x: 0.50, y: 0.50, r: 160, a: 0.03 },
            ]
            for (var i = 0; i < dots.length; i++) {
                var d = dots[i]
                var ox = Math.sin(t + i * 1.3) * 18
                var oy = Math.cos(t + i * 0.9) * 14
                var grd = ctx.createRadialGradient(
                    d.x * width + ox, d.y * height + oy, 0,
                    d.x * width + ox, d.y * height + oy, d.r
                )
                grd.addColorStop(0, Qt.rgba(0.10, 0.55, 0.75, d.a + 0.04))
                grd.addColorStop(1, Qt.rgba(0.10, 0.55, 0.75, 0))
                ctx.fillStyle = grd
                ctx.beginPath()
                ctx.arc(d.x * width + ox, d.y * height + oy, d.r, 0, Math.PI * 2)
                ctx.fill()
            }
        }
    }

    // Subtle grid lines
    Canvas {
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d")
            ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.025)
            ctx.lineWidth = 1
            var step = 40
            for (var x = 0; x < width; x += step) {
                ctx.beginPath(); ctx.moveTo(x, 0); ctx.lineTo(x, height); ctx.stroke()
            }
            for (var y = 0; y < height; y += step) {
                ctx.beginPath(); ctx.moveTo(0, y); ctx.lineTo(width, y); ctx.stroke()
            }
        }
    }

    // Left branding panel (hidden on narrow screens)
    Rectangle {
        visible: parent.width > 700
        width: parent.width * 0.42
        height: parent.height
        color: "transparent"

        Column {
            anchors.centerIn: parent
            spacing: 24

            // Cross / logo
            Item {
                width: 80; height: 80
                anchors.horizontalCenter: parent.horizontalCenter

                Rectangle { width: 16; height: 80; radius: 8; color: "#28A98B"; anchors.centerIn: parent }
                Rectangle { width: 80; height: 16; radius: 8; color: "#28A98B"; anchors.centerIn: parent }

                Rectangle {
                    width: 80; height: 80; radius: 40
                    color: "transparent"
                    border.color: Qt.rgba(0.16, 0.66, 0.55, 0.35)
                    border.width: 2
                    anchors.centerIn: parent
                }
                Rectangle {
                    width: 96; height: 96; radius: 48
                    color: "transparent"
                    border.color: Qt.rgba(0.16, 0.66, 0.55, 0.15)
                    border.width: 1
                    anchors.centerIn: parent
                }
            }

            Text {
                text: "МедСистема"
                font.pixelSize: 32; font.family: "Segoe UI"; font.weight: Font.Bold
                color: "#FFFFFF"
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text {
                text: "Система учёта пациентов\nи регистрации посещений"
                font.pixelSize: 14; font.family: "Segoe UI"
                color: Qt.rgba(1,1,1,0.45)
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                lineHeight: 1.5
            }

            // Feature pills
            Column {
                spacing: 10
                anchors.horizontalCenter: parent.horizontalCenter

                Repeater {
                    model: ["✦  Учёт пациентов и палат", "✦  История посещений", "✦  Управление сотрудниками"]
                    delegate: Rectangle {
                        width: 240; height: 34; radius: 17
                        color: Qt.rgba(1,1,1,0.06)
                        border.color: Qt.rgba(1,1,1,0.10); border.width: 1
                        anchors.horizontalCenter: parent.horizontalCenter
                        Text {
                            anchors.centerIn: parent
                            text: modelData
                            font.pixelSize: 12; font.family: "Segoe UI"
                            color: Qt.rgba(1,1,1,0.60)
                        }
                    }
                }
            }
        }
    }

    // Divider
    Rectangle {
        visible: parent.width > 700
        x: parent.width * 0.42
        width: 1; height: parent.height
        color: Qt.rgba(1,1,1,0.07)
    }

    // Right: login card
    Item {
        x: parent.width > 700 ? parent.width * 0.42 : 0
        width: parent.width > 700 ? parent.width * 0.58 : parent.width
        height: parent.height

        Rectangle {
            anchors.centerIn: parent
            width: Math.min(380, parent.width - 48)
            height: cardCol.implicitHeight + 56
            radius: 18
            color: Qt.rgba(1,1,1,0.05)
            border.color: Qt.rgba(1,1,1,0.10); border.width: 1

            // Glass reflection top
            Rectangle {
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width * 0.6; height: 1
                color: Qt.rgba(1,1,1,0.20)
                radius: 1
            }

            ColumnLayout {
                id: cardCol
                anchors { left: parent.left; right: parent.right; top: parent.top; margins: 28 }
                spacing: 0

                // Header
                Text {
                    text: "Добро пожаловать"
                    font.pixelSize: 22; font.family: "Segoe UI"; font.weight: Font.Bold
                    color: "#FFFFFF"
                    Layout.bottomMargin: 4
                }
                Text {
                    text: "Войдите в систему для продолжения"
                    font.pixelSize: 13; font.family: "Segoe UI"
                    color: Qt.rgba(1,1,1,0.45)
                    Layout.bottomMargin: 28
                }

                // Login field
                Text { text: "ЛОГИН"; font.pixelSize: 10; font.family: "Segoe UI"; font.weight: Font.Bold; font.letterSpacing: 1.2; color: Qt.rgba(1,1,1,0.40); Layout.bottomMargin: 6 }
                Rectangle {
                    Layout.fillWidth: true
                    height: 46; radius: 10
                    color: loginField.activeFocus ? Qt.rgba(1,1,1,0.10) : Qt.rgba(1,1,1,0.06)
                    border.color: loginField.activeFocus ? "#28A98B" : Qt.rgba(1,1,1,0.12)
                    border.width: loginField.activeFocus ? 2 : 1
                    Behavior on color { ColorAnimation { duration: 150 } }
                    Behavior on border.color { ColorAnimation { duration: 150 } }

                    Row {
                        anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: 12 }
                        spacing: 10
                        Text { text: "⌘"; font.pixelSize: 14; color: loginField.activeFocus ? "#28A98B" : Qt.rgba(1,1,1,0.30); anchors.verticalCenter: parent.verticalCenter; Behavior on color { ColorAnimation { duration: 150 } } }
                        TextField {
                            id: loginField
                            placeholderText: "Введите логин"
                            width: cardCol.width - 56 - 28
                            background: Item {}
                            color: "#FFFFFF"; placeholderTextColor: Qt.rgba(1,1,1,0.25)
                            font.pixelSize: 13; font.family: "Segoe UI"
                            selectByMouse: true
                        }
                    }
                }

                Item { height: 14 }

                // Password field
                Text { text: "ПАРОЛЬ"; font.pixelSize: 10; font.family: "Segoe UI"; font.weight: Font.Bold; font.letterSpacing: 1.2; color: Qt.rgba(1,1,1,0.40); Layout.bottomMargin: 6 }
                Rectangle {
                    Layout.fillWidth: true
                    height: 46; radius: 10
                    color: passwordField.activeFocus ? Qt.rgba(1,1,1,0.10) : Qt.rgba(1,1,1,0.06)
                    border.color: passwordField.activeFocus ? "#28A98B" : Qt.rgba(1,1,1,0.12)
                    border.width: passwordField.activeFocus ? 2 : 1
                    Behavior on color { ColorAnimation { duration: 150 } }
                    Behavior on border.color { ColorAnimation { duration: 150 } }

                    Row {
                        anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: 12 }
                        spacing: 10
                        Text { text: "◉"; font.pixelSize: 14; color: passwordField.activeFocus ? "#28A98B" : Qt.rgba(1,1,1,0.30); anchors.verticalCenter: parent.verticalCenter; Behavior on color { ColorAnimation { duration: 150 } } }
                        TextField {
                            id: passwordField
                            placeholderText: "Введите пароль"
                            echoMode: TextField.Password
                            width: cardCol.width - 56 - 28
                            background: Item {}
                            color: "#FFFFFF"; placeholderTextColor: Qt.rgba(1,1,1,0.25)
                            font.pixelSize: 13; font.family: "Segoe UI"
                            selectByMouse: true
                            Keys.onReturnPressed: loginBtn.doLogin()
                        }
                    }
                }

                Item { height: 8 }

                // Error message
                Rectangle {
                    Layout.fillWidth: true
                    height: errorMsg.text !== "" ? 38 : 0
                    visible: height > 0
                    radius: 8
                    color: Qt.rgba(0.88, 0.32, 0.32, 0.15)
                    border.color: Qt.rgba(0.88, 0.32, 0.32, 0.30); border.width: 1
                    Behavior on height { NumberAnimation { duration: 180 } }
                    Layout.topMargin: errorMsg.text !== "" ? 8 : 0

                    Row {
                        anchors.centerIn: parent
                        spacing: 8
                        Text { text: "✕"; font.pixelSize: 12; color: "#F08080"; anchors.verticalCenter: parent.verticalCenter }
                        Text { id: errorMsg; font.pixelSize: 12; font.family: "Segoe UI"; color: "#F08080"; anchors.verticalCenter: parent.verticalCenter }
                    }
                }

                Item { height: 20 }

                // Login button
                Rectangle {
                    id: loginBtn
                    Layout.fillWidth: true; height: 46; radius: 10
                    color: loginMouse.pressed ? "#1E8B72" : loginMouse.containsMouse ? "#2EBD9C" : "#28A98B"
                    Behavior on color { ColorAnimation { duration: 120 } }

                    function doLogin() {
                        errorMsg.text = ""
                        if (dbManager.login(loginField.text, passwordField.text)) {
                            loginSuccess()
                        } else {
                            errorMsg.text = "Неверный логин или пароль"
                        }
                    }

                    // Shine line
                    Rectangle {
                        anchors.top: parent.top; anchors.topMargin: 1
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width * 0.5; height: 1
                        color: Qt.rgba(1,1,1,0.30); radius: 1
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Войти"
                        font.pixelSize: 14; font.family: "Segoe UI"; font.weight: Font.SemiBold
                        color: "#FFFFFF"
                    }

                    scale: loginMouse.pressed ? 0.97 : 1.0
                    Behavior on scale { NumberAnimation { duration: 100 } }

                    MouseArea {
                        id: loginMouse
                        anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                        onClicked: loginBtn.doLogin()
                    }
                }

                Item { height: 12 }

                // Divider
                Row {
                    Layout.fillWidth: true
                    spacing: 10
                    Rectangle { height: 1; width: (cardCol.width - divText.implicitWidth - 20 - 56) / 2; color: Qt.rgba(1,1,1,0.12); anchors.verticalCenter: parent.verticalCenter }
                    Text { id: divText; text: "или"; font.pixelSize: 12; font.family: "Segoe UI"; color: Qt.rgba(1,1,1,0.30); anchors.verticalCenter: parent.verticalCenter }
                    Rectangle { height: 1; width: (cardCol.width - divText.implicitWidth - 20 - 56) / 2; color: Qt.rgba(1,1,1,0.12); anchors.verticalCenter: parent.verticalCenter }
                }

                Item { height: 12 }

                // Register button
                Rectangle {
                    Layout.fillWidth: true; height: 46; radius: 10
                    color: regMouse.containsMouse ? Qt.rgba(1,1,1,0.10) : Qt.rgba(1,1,1,0.05)
                    border.color: Qt.rgba(1,1,1,0.15); border.width: 1
                    Behavior on color { ColorAnimation { duration: 120 } }

                    Text {
                        anchors.centerIn: parent
                        text: "Зарегистрироваться"
                        font.pixelSize: 13; font.family: "Segoe UI"
                        color: Qt.rgba(1,1,1,0.65)
                    }

                    scale: regMouse.pressed ? 0.97 : 1.0
                    Behavior on scale { NumberAnimation { duration: 100 } }

                    MouseArea {
                        id: regMouse
                        anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                        onClicked: registerDialog.open()
                    }
                }

                Item { height: 4 }
            }
        }
    }
}
