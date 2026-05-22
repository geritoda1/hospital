import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    background: Rectangle { color: "#F0F4F8" }

    ScrollView {
        anchors.fill: parent
        contentWidth: availableWidth

        ColumnLayout {
            width: Math.min(560, parent.width - 40)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 24
            spacing: 0

            // Header banner
            Rectangle {
                Layout.fillWidth: true
                height: 72
                radius: 12
                color: "#1A6B9A"

                Row {
                    anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: 20 }
                    spacing: 14
                    Text { text: "🧾"; font.pixelSize: 28; anchors.verticalCenter: parent.verticalCenter }
                    Column {
                        spacing: 3
                        anchors.verticalCenter: parent.verticalCenter
                        Text {
                            text: "Запись пациента"
                            font.pixelSize: 17; font.family: "Segoe UI"; font.weight: Font.Bold
                            color: "#FFFFFF"
                        }
                        Text {
                            text: "Заполните данные для регистрации"
                            font.pixelSize: 12; font.family: "Segoe UI"
                            color: Qt.rgba(1,1,1,0.70)
                        }
                    }
                }
            }

            // Form card
            Rectangle {
                Layout.fillWidth: true
                Layout.topMargin: 16
                implicitHeight: formCol.implicitHeight + 40
                radius: 12
                color: "#FFFFFF"
                border.color: "#DDE6EF"; border.width: 1

                ColumnLayout {
                    id: formCol
                    anchors { left: parent.left; right: parent.right; top: parent.top; margins: 20 }
                    spacing: 4

                    // ФИО
                    Text { text: "ФИО пациента"; font.pixelSize: 12; font.family: "Segoe UI"; font.weight: Font.Medium; color: "#5A6A7A"; Layout.topMargin: 4 }
                    StyledField { id: nameField; placeholderText: "Иванов Иван Иванович"; iconText: "👤"; Layout.fillWidth: true }

                    // Диагноз
                    Text { text: "Диагноз"; font.pixelSize: 12; font.family: "Segoe UI"; font.weight: Font.Medium; color: "#5A6A7A"; Layout.topMargin: 8 }
                    StyledField { id: diagnosisField; placeholderText: "Введите диагноз"; iconText: "🩺"; Layout.fillWidth: true }

                    // Палата
                    Text { text: "Номер палаты"; font.pixelSize: 12; font.family: "Segoe UI"; font.weight: Font.Medium; color: "#5A6A7A"; Layout.topMargin: 8 }
                    StyledField { id: roomField; placeholderText: "Например: 214"; iconText: "🏠"; Layout.fillWidth: true }

                    // Паспорт
                    Text { text: "Паспортные данные"; font.pixelSize: 12; font.family: "Segoe UI"; font.weight: Font.Medium; color: "#5A6A7A"; Layout.topMargin: 8 }
                    StyledField { id: passportField; placeholderText: "Серия и номер"; iconText: "📋"; Layout.fillWidth: true }

                    Item { height: 4 }
                }
            }

            // Action card
            Rectangle {
                Layout.fillWidth: true
                Layout.topMargin: 12
                implicitHeight: actionCol.implicitHeight + 32
                radius: 12
                color: "#FFFFFF"
                border.color: "#DDE6EF"; border.width: 1

                ColumnLayout {
                    id: actionCol
                    anchors { left: parent.left; right: parent.right; top: parent.top; margins: 16 }
                    spacing: 12

                    StatusMessage {
                        id: resultMsg
                        Layout.fillWidth: true
                    }

                    PrimaryButton {
                        text: "Записать пациента"
                        iconText: "✚"
                        Layout.fillWidth: true
                        onClicked: {
                            resultMsg.message = ""
                            if (nameField.text && diagnosisField.text && roomField.text && passportField.text) {
                                if (dbManager.addPatient(nameField.text, diagnosisField.text, roomField.text, passportField.text)) {
                                    patientsModel.refresh()
                                    nameField.text = diagnosisField.text = roomField.text = passportField.text = ""
                                    resultMsg.isSuccess = true; resultMsg.isError = false
                                    resultMsg.message = "Пациент успешно добавлен"
                                } else {
                                    resultMsg.isError = true; resultMsg.isSuccess = false
                                    resultMsg.message = "Ошибка при добавлении пациента"
                                }
                            } else {
                                resultMsg.isError = true; resultMsg.isSuccess = false
                                resultMsg.message = "Пожалуйста, заполните все поля"
                            }
                        }
                    }
                }
            }

            Item { height: 24 }
        }
    }
}
