import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        TextField { id: visitorName; placeholderText: "ФИО посетителя"; Layout.fillWidth: true }
        TextField { id: visitorPassport; placeholderText: "Паспорт посетителя"; Layout.fillWidth: true }
        TextField { id: roomNumber; placeholderText: "Палата (куда идти)"; Layout.fillWidth: true }

        Label { text: "Пациент:" }
        ComboBox {
            id: patientCombo
            Layout.fillWidth: true
            textRole: "fullName"
            model: patientsModel
            valueRole: "patientId"
        }

        Button {
            text: "Зарегистрировать посещение"
            Layout.fillWidth: true
            onClicked: {
                if (visitorName.text && visitorPassport.text && roomNumber.text && patientCombo.currentValue !== undefined) {
                    var patientId = patientCombo.currentValue
                    if (dbManager.addVisit(patientId, visitorName.text, visitorPassport.text, roomNumber.text)) {
                        visitsModel.refresh()
                        visitorName.text = visitorPassport.text = roomNumber.text = ""
                        resultText.text = "Посещение добавлено"
                    } else {
                        resultText.text = "Ошибка"
                    }
                } else {
                    resultText.text = "Заполните все поля и выберите пациента"
                }
            }
        }
        Label { id: resultText; color: "blue" }
    }
}