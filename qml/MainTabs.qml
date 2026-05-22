import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    signal logout

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            TabBar {
                id: tabBar
                currentIndex: swipeView.currentIndex
                TabButton { text: "Запись пациента" }
                TabButton { text: "Посещение" }
                TabButton { text: "История" }
            }
            Button {
                text: "Выйти"
                Layout.alignment: Qt.AlignRight
                onClicked: logout()
            }
        }
    }

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        AddPatientPage { }
        AddVisitPage { }
        HistoryPage { }
    }
}