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
                        text: "🚪 Регистрация посещения"
                        font.pixelSize: 18
                        font.family: "Segoe UI"
                        font.weight: Font.Bold
                        color: "#FFFFFF"
                        Layout.bottomMargin: 8
                    }

                    StyledField {
                        id: visitorName
                        placeholderText: "ФИО посетителя"
                        iconText: "👥"
                        Layout.fillWidth: true
                    }

                    StyledField {
                        id: visitorPassport
                        placeholderText: "Паспорт посетителя"
                        iconText: "📋"
                        Layout.fillWidth: true
                    }

                    StyledField {
                        id: roomNumber
                        placeholderText: "Палата (куда идти)"
                        iconText: "🏠"
                        Layout.fillWidth: true
                    }

                    Text {
                        text: "ВЫБОР ПАЦИЕНТА"
                        font.pixelSize: 10
                        font.weight: Font.Bold
                        color: Qt.rgba(1,1,1,0.40)
                        font.letterSpacing: 1.1
                        Layout.topMargin: 4
                    }

                    ComboBox {
                        id: patientCombo
                        Layout.fillWidth: true
                        textRole: "fullName"
                        model: patientsModel
                        valueRole: "patientId"
                        font.pixelSize: 13
                        font.family: "Segoe UI"
                        background: Rectangle {
                            radius: 10
                            color: patientCombo.activeFocus ? Qt.rgba(1,1,1,0.10) : Qt.rgba(1,1,1,0.06)
                            border.color: patientCombo.activeFocus ? "#28A98B" : Qt.rgba(1,1,1,0.12)
                            border.width: 1
                        }
                        contentItem: Text {
                            leftPadding: 14
                            text: patientCombo.displayText
                            font: patientCombo.font
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
                            contentItem: Text {
                                text: model.fullName
                                font.pixelSize: 13
                                color: "#1A2533"
                            }
                            background: Rectangle {
                                color: hovered ? "#EBF4FA" : "white"
                            }
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
                        text: "Зарегистрировать посещение"
                        iconText: "✔"
                        Layout.fillWidth: true
                        onClicked: {
                            resultMsg.message = ""
                            if (visitorName.text && visitorPassport.text && roomNumber.text && patientCombo.currentValue !== undefined) {
                                if (dbManager.addVisit(patientCombo.currentValue, visitorName.text, visitorPassport.text, roomNumber.text)) {
                                    visitsModel.refresh()
                                    visitorName.text = visitorPassport.text = roomNumber.text = ""
                                    resultMsg.isSuccess = true
                                    resultMsg.message = "Посещение зарегистрировано"
                                } else {
                                    resultMsg.isError = true
                                    resultMsg.message = "Ошибка регистрации"
                                }
                            } else {
                                resultMsg.isError = true
                                resultMsg.message = "Заполните все поля и выберите пациента"
                            }
                        }
                    }

                    StatusMessage {
                        id: resultMsg
                        Layout.fillWidth: true
                    }
                }
            }
            Item { height: 24 }
        }
    }
}