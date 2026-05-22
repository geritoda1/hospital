// VisitDetailPage.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    title: "Детали посещения"

    property var visitData: ({})  // объект с данными посещения

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        Label {
            text: "<b>Пациент:</b> " + (visitData.patientName || "—")
            wrapMode: Text.Wrap
            Layout.fillWidth: true
        }
        Label {
            text: "<b>Посетитель:</b> " + (visitData.visitorName || "—")
            wrapMode: Text.Wrap
            Layout.fillWidth: true
        }
        Label {
            text: "<b>Паспорт посетителя:</b> " + (visitData.visitorPassport || "—")
            wrapMode: Text.Wrap
            Layout.fillWidth: true
        }
        Label {
            text: "<b>Палата:</b> " + (visitData.roomNumber || "—")
            wrapMode: Text.Wrap
            Layout.fillWidth: true
        }
        Label {
            text: "<b>Время посещения:</b> " + (visitData.visitTime || "—")
            wrapMode: Text.Wrap
            Layout.fillWidth: true
        }
        Label {
            text: "<b>Сотрудник на смене:</b> " + (visitData.employeeName || "неизвестен")
            wrapMode: Text.Wrap
            Layout.fillWidth: true
        }

        Button {
            text: "Назад"
            Layout.alignment: Qt.AlignHCenter
            onClicked: stackView.pop()
        }
    }
}