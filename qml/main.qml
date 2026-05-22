import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 900
    height: 660
    minimumWidth: 700
    minimumHeight: 500
    title: "МедСистема — Учёт посещений"

    // Убираем стандартную рамку окна
    flags: Qt.Window | Qt.FramelessWindowHint

    font.family: "Segoe UI"

    property bool loggedIn: false

    // Область перетаскивания окна (прозрачная полоса сверху)
    Rectangle {
        id: dragArea
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 48
        color: "transparent"
        z: 11

        MouseArea {
            id: dragMouse
            anchors.fill: parent
            property point lastPos: Qt.point(0, 0)
            onPressed: lastPos = Qt.point(mouseX, mouseY)
            onPositionChanged: {
                if (pressed) {
                    var delta = Qt.point(mouseX - lastPos.x, mouseY - lastPos.y)
                    mainWindow.x += delta.x
                    mainWindow.y += delta.y
                }
            }
            cursorShape: Qt.DragMoveCursor
        }
    }

    // Контейнер для всего интерфейса — сдвинут вниз на высоту dragArea
    Item {
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            topMargin: 48
        }
        clip: true

        StackView {
            id: stackView
            anchors.fill: parent
            initialItem: loggedIn ? mainTabs : loginPage

            pushEnter: Transition {
                PropertyAnimation { property: "opacity"; from: 0; to: 1; duration: 200 }
            }
            pushExit: Transition {
                PropertyAnimation { property: "opacity"; from: 1; to: 0; duration: 120 }
            }
            replaceEnter: Transition {
                PropertyAnimation { property: "opacity"; from: 0; to: 1; duration: 250 }
            }
            replaceExit: Transition {
                PropertyAnimation { property: "opacity"; from: 1; to: 0; duration: 150 }
            }
            popEnter: Transition {
                PropertyAnimation { property: "opacity"; from: 0; to: 1; duration: 180 }
            }
            popExit: Transition {
                PropertyAnimation { property: "opacity"; from: 1; to: 0; duration: 100 }
            }
        }
    }

    // Кастомные кнопки управления (поверх всего)
    WindowControls {
        targetWindow: mainWindow
        anchors {
            top: parent.top
            right: parent.right
            topMargin: 10
            rightMargin: 12
        }
        z: 12
    }

    Component {
        id: loginPage
        LoginPage {
            onLoginSuccess: {
                loggedIn = true
                stackView.replace(mainTabs)
            }
        }
    }

    Component {
        id: mainTabs
        MainTabs {
            onLogout: {
                loggedIn = false
                dbManager.currentUserId = -1
                stackView.replace(loginPage)
            }
        }
    }
}