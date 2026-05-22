// RoomsPage.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    title: "Занятость палат"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        Label {
            text: "Список пациентов по палатам"
            font.bold: true
            font.pixelSize: 16
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: patientsModel
            delegate: ItemDelegate {
                width: parent.width
                height: 80
                Rectangle {
                    anchors.fill: parent
                    color: index % 2 ? "#f0f0f0" : "white"
                }
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 5
                    spacing: 2
                    Label {
                        text: "<b>" + model.fullName + "</b> — палата <b>" + model.roomNumber + "</b>"
                        Layout.fillWidth: true
                    }
                    Label {
                        text: "Диагноз: " + model.diagnosis
                        Layout.fillWidth: true
                        color: "#555"
                    }
                    Label {
                        text: "Паспорт: " + model.passportData
                        Layout.fillWidth: true
                        color: "#777"
                        font.pointSize: 9
                    }
                }
            }
            clip: true
        }

        Button {
            text: "Обновить список"
            Layout.alignment: Qt.AlignHCenter
            onClicked: patientsModel.refresh()
        }
    }
}