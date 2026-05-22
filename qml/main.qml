import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: true
    width: 900
    height: 660
    minimumWidth: 700
    minimumHeight: 500
    title: "МедСистема — Учёт посещений"

    // Smooth font rendering
    font.family: "Segoe UI"

    property bool loggedIn: false

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
