import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: true
    width: 800
    height: 600
    title: "Больница - Система учёта посещений"

    property bool loggedIn: false

    // Менеджер БД и модели проброшены из C++

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: loggedIn ? mainTabs : loginPage
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