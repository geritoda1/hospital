import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    background: BackgroundWithDots { }

    ScrollView {
        anchors.fill: parent
        contentWidth: availableWidth

        ColumnLayout {
            width: Math.min(520, parent.width - 40)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 24
            spacing: 16

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: formCol.implicitHeight + 40
                radius: 18
                color: Qt.rgba(1,1,1,0.05)
                border.color: Qt.rgba(1,1,1,0.10); border.width: 1

                ColumnLayout {
                    id: formCol
                    anchors { left: parent.left; right: parent.right; top: parent.top; margins: 28 }
                    spacing: 12

                    Text {
                        text: "🏥 Новая госпитализация"
                        font.pixelSize: 18
                        font.weight: Font.Bold
                        color: "#FFFFFF"
                        Layout.bottomMargin: 8
                    }

                    StyledField { id: nameField; placeholderText: "ФИО пациента"; iconText: "👤"; Layout.fillWidth: true }
                    StyledField { id: diagnosisField; placeholderText: "Диагноз"; iconText: "🩺"; Layout.fillWidth: true }
                    StyledField { id: roomField; placeholderText: "Номер палаты"; iconText: "🏠"; Layout.fillWidth: true }
                    StyledField { id: passportField; placeholderText: "Паспортные данные"; iconText: "📋"; Layout.fillWidth: true }

                    Text {
                        text: "ЛЕЧАЩИЙ ВРАЧ"
                        font.pixelSize: 10
                        font.weight: Font.Bold
                        color: Qt.rgba(1,1,1,0.40)
                        font.letterSpacing: 1.1
                        Layout.topMargin: 8
                    }

                    ComboBox {
                        id: doctorCombo
                        Layout.fillWidth: true
                        textRole: "fullName"
                        model: doctorsModel
                        valueRole: "doctorId"
                        font.pixelSize: 13
                        background: Rectangle {
                            radius: 10
                            color: activeFocus ? Qt.rgba(1,1,1,0.10) : Qt.rgba(1,1,1,0.06)
                            border.color: activeFocus ? "#28A98B" : Qt.rgba(1,1,1,0.12)
                            border.width: 1
                        }
                        contentItem: Text {
                            leftPadding: 14
                            text: displayText
                            font: doctorCombo.font
                            color: "#FFFFFF"
                            verticalAlignment: Text.AlignVCenter
                        }
                        indicator: Text {
                            text: "▾"
                            font.pixelSize: 14
                            color: "#9AAABB"
                            anchors.right: parent.right
                            anchors.rightMargin: 12
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        delegate: ItemDelegate {
                            width: parent.width
                            height: 36
                            contentItem: Text { text: model.fullName; font.pixelSize: 13; color: "#1A2533" }
                            background: Rectangle { color: hovered ? "#EBF4FA" : "white" }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: actionCol.implicitHeight + 32
                radius: 18
                color: Qt.rgba(1,1,1,0.05)
                border.color: Qt.rgba(1,1,1,0.10); border.width: 1

                ColumnLayout {
                    id: actionCol
                    anchors { left: parent.left; right: parent.right; top: parent.top; margins: 16 }
                    spacing: 12

                    PrimaryButton {
                        text: "Записать пациента"
                        iconText: "✚"
                        Layout.fillWidth: true
                        onClicked: {
                            resultMsg.message = ""
                            if (nameField.text && diagnosisField.text && roomField.text && passportField.text) {
                                var doctorId = doctorCombo.currentValue || 0
                                if (dbManager.addPatient(nameField.text, diagnosisField.text, roomField.text,
                                                          passportField.text, doctorId)) {
                                    patientsModel.refresh()
                                    nameField.text = diagnosisField.text = roomField.text = passportField.text = ""
                                    doctorCombo.currentIndex = -1
                                    resultMsg.isSuccess = true
                                    resultMsg.message = "Пациент добавлен"
                                } else {
                                    resultMsg.isError = true
                                    resultMsg.message = "Ошибка добавления"
                                }
                            } else {
                                resultMsg.isError = true
                                resultMsg.message = "Заполните все поля"
                            }
                        }
                    }
                    StatusMessage { id: resultMsg; Layout.fillWidth: true }
                }
            }
            Item { height: 24 }
        }
    }
}