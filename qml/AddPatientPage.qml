import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        TextField { id: nameField; placeholderText: "ФИО пациента"; Layout.fillWidth: true }
        TextField { id: diagnosisField; placeholderText: "Диагноз"; Layout.fillWidth: true }
        TextField { id: roomField; placeholderText: "Палата"; Layout.fillWidth: true }
        TextField { id: passportField; placeholderText: "Паспортные данные"; Layout.fillWidth: true }

        Button {
            text: "Записать пациента"
            Layout.fillWidth: true
            onClicked: {
                if (nameField.text && diagnosisField.text && roomField.text && passportField.text) {
                    if (dbManager.addPatient(nameField.text, diagnosisField.text, roomField.text, passportField.text)) {
                        patientsModel.refresh()
                        nameField.text = diagnosisField.text = roomField.text = passportField.text = ""
                        resultText.text = "Пациент добавлен"
                    } else {
                        resultText.text = "Ошибка добавления"
                    }
                } else {
                    resultText.text = "Заполните все поля"
                }
            }
        }
        Label { id: resultText; color: "blue" }
    }
}