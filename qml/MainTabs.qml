import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    signal logout

    background: Rectangle { color: "#F0F4F8" }

    header: Rectangle {
        width: parent.width
        height: 56
        color: "#124E72"

        Row {
            anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: 16 }
            spacing: 10
            Text { text: "🏥"; font.pixelSize: 20; anchors.verticalCenter: parent.verticalCenter }
            Text {
                text: "МедСистема"
                font.pixelSize: 16; font.family: "Segoe UI"; font.weight: Font.Bold
                color: "#FFFFFF"
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        // Tab bar centered
        Row {
            anchors.centerIn: parent
            spacing: 4

            Repeater {
                model: [
                    { text: "Пациент",   icon: "🧾" },
                    { text: "Посещение", icon: "🚪" },
                    { text: "История",   icon: "📋" },
                    { text: "Палаты",    icon: "🏠" },
                ]
                delegate: Rectangle {
                    width: tabLabel.implicitWidth + 28
                    height: 36; radius: 8
                    color: swipeView.currentIndex === index
                           ? Qt.rgba(1,1,1,0.18)
                           : (tabMouse.containsMouse ? Qt.rgba(1,1,1,0.08) : "transparent")
                    Behavior on color { ColorAnimation { duration: 120 } }

                    Row {
                        anchors.centerIn: parent
                        spacing: 6
                        Text { text: modelData.icon; font.pixelSize: 14 }
                        Text {
                            id: tabLabel
                            text: modelData.text
                            font.pixelSize: 13; font.family: "Segoe UI"
                            font.weight: swipeView.currentIndex === index ? Font.SemiBold : Font.Normal
                            color: swipeView.currentIndex === index ? "#FFFFFF" : Qt.rgba(1,1,1,0.65)
                        }
                    }

                    Rectangle {
                        visible: swipeView.currentIndex === index
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width - 16; height: 2; radius: 1
                        color: "#FFFFFF"
                    }

                    MouseArea {
                        id: tabMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: swipeView.currentIndex = index
                    }
                }
            }
        }

        // Logout button
        Rectangle {
            anchors { right: parent.right; verticalCenter: parent.verticalCenter; rightMargin: 12 }
            width: logoutRow.implicitWidth + 20; height: 32; radius: 8
            color: logoutArea.containsMouse ? Qt.rgba(1,1,1,0.15) : Qt.rgba(1,1,1,0.08)
            Behavior on color { ColorAnimation { duration: 120 } }

            Row {
                id: logoutRow
                anchors.centerIn: parent
                spacing: 6
                Text { text: "⎋"; font.pixelSize: 14; color: Qt.rgba(1,1,1,0.80) }
                Text { text: "Выйти"; font.pixelSize: 13; font.family: "Segoe UI"; color: Qt.rgba(1,1,1,0.80) }
            }

            MouseArea {
                id: logoutArea
                anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                onClicked: logout()
            }
        }
    }

    SwipeView {
        id: swipeView
        anchors.fill: parent
        interactive: false  // disable swipe; tabs control navigation

        AddPatientPage { }
        AddVisitPage   { }
        HistoryPage    { }
        RoomsPage      { }
    }
}
