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
                color: "#28A98B"

                Row {
                    anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: 20 }
                    spacing: 14
                    Text { text: "🚪"; font.pixelSize: 28; anchors.verticalCenter: parent.verticalCenter }
                    Column {
                        spacing: 3
                        anchors.verticalCenter: parent.verticalCenter
                        Text {
                            text: "Регистрация посещения"
                            font.pixelSize: 17; font.family: "Segoe UI"; font.weight: Font.Bold
                            color: "#FFFFFF"
                        }
                        Text {
                            text: "Укажите данные посетителя и пациента"
                            font.pixelSize: 12; font.family: "Segoe UI"
                            color: Qt.rgba(1,1,1,0.70)
                        }
                    }
                }
            }

            // Visitor info card
            Rectangle {
                Layout.fillWidth: true
                Layout.topMargin: 16
                implicitHeight: visitorCol.implicitHeight + 40
                radius: 12
                color: "#FFFFFF"
                border.color: "#DDE6EF"; border.width: 1

                ColumnLayout {
                    id: visitorCol
                    anchors { left: parent.left; right: parent.right; top: parent.top; margins: 20 }
                    spacing: 4

                    Row {
                        spacing: 8
                        Rectangle { width: 3; height: 16; radius: 2; color: "#28A98B"; anchors.verticalCenter: parent.verticalCenter }
                        Text { text: "Данные посетителя"; font.pixelSize: 13; font.family: "Segoe UI"; font.weight: Font.SemiBold; color: "#1A2533"; anchors.verticalCenter: parent.verticalCenter }
                    }

                    Text { text: "ФИО посетителя"; font.pixelSize: 12; font.family: "Segoe UI"; font.weight: Font.Medium; color: "#5A6A7A"; Layout.topMargin: 8 }
                    StyledField { id: visitorName; placeholderText: "Петров Пётр Петрович"; iconText: "👥"; Layout.fillWidth: true }

                    Text { text: "Паспорт посетителя"; font.pixelSize: 12; font.family: "Segoe UI"; font.weight: Font.Medium; color: "#5A6A7A"; Layout.topMargin: 8 }
                    StyledField { id: visitorPassport; placeholderText: "Серия и номер"; iconText: "📋"; Layout.fillWidth: true }

                    Text { text: "Палата (куда идти)"; font.pixelSize: 12; font.family: "Segoe UI"; font.weight: Font.Medium; color: "#5A6A7A"; Layout.topMargin: 8 }
                    StyledField { id: roomNumber; placeholderText: "Например: 214"; iconText: "🏠"; Layout.fillWidth: true }

                    Item { height: 4 }
                }
            }

            // Patient selector card
            Rectangle {
                Layout.fillWidth: true
                Layout.topMargin: 12
                implicitHeight: patientCol.implicitHeight + 40
                radius: 12
                color: "#FFFFFF"
                border.color: "#DDE6EF"; border.width: 1

                ColumnLayout {
                    id: patientCol
                    anchors { left: parent.left; right: parent.right; top: parent.top; margins: 20 }
                    spacing: 8

                    Row {
                        spacing: 8
                        Rectangle { width: 3; height: 16; radius: 2; color: "#1A6B9A"; anchors.verticalCenter: parent.verticalCenter }
                        Text { text: "Выбор пациента"; font.pixelSize: 13; font.family: "Segoe UI"; font.weight: Font.SemiBold; color: "#1A2533"; anchors.verticalCenter: parent.verticalCenter }
                    }

                    Text { text: "Пациент"; font.pixelSize: 12; font.family: "Segoe UI"; font.weight: Font.Medium; color: "#5A6A7A" }

                    ComboBox {
                        id: patientCombo
                        Layout.fillWidth: true
                        textRole: "fullName"
                        model: patientsModel
                        valueRole: "patientId"
                        font.pixelSize: 13
                        font.family: "Segoe UI"

                        contentItem: Text {
                            leftPadding: 14
                            text: patientCombo.displayText
                            font: patientCombo.font
                            color: patientCombo.currentIndex >= 0 ? "#1A2533" : "#9AAABB"
                            verticalAlignment: Text.AlignVCenter
                        }

                        background: Rectangle {
                            radius: 10
                            color: patientCombo.activeFocus ? "#EBF4FA" : "#F7FAFC"
                            border.color: patientCombo.activeFocus ? "#1A6B9A" : "#DDE6EF"
                            border.width: patientCombo.activeFocus ? 2 : 1
                        }

                        indicator: Text {
                            text: "▾"
                            font.pixelSize: 14
                            color: "#9AAABB"
                            anchors.right: parent.right
                            anchors.rightMargin: 12
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        implicitHeight: 46

                        popup: Popup {
                            y: patientCombo.height + 4
                            width: patientCombo.width
                            implicitHeight: contentItem.implicitHeight
                            padding: 4

                            background: Rectangle {
                                radius: 10
                                color: "#FFFFFF"
                                border.color: "#DDE6EF"
                                border.width: 1
                            }

                            contentItem: ListView {
                                clip: true
                                implicitHeight: contentHeight
                                model: patientCombo.delegateModel
                                currentIndex: patientCombo.highlightedIndex
                            }
                        }

                        delegate: ItemDelegate {
                            width: parent ? parent.width : 0
                            height: 40
                            contentItem: Text {
                                text: model[patientCombo.textRole]
                                font.pixelSize: 13
                                font.family: "Segoe UI"
                                color: patientCombo.currentIndex === index ? "#1A6B9A" : "#1A2533"
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: 10
                            }
                            background: Rectangle {
                                color: hovered ? "#EBF4FA" : "transparent"
                                radius: 6
                            }
                        }
                    }

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

                    StatusMessage { id: resultMsg; Layout.fillWidth: true }

                    PrimaryButton {
                        text: "Зарегистрировать посещение"
                        iconText: "✔"
                        Layout.fillWidth: true
                        onClicked: {
                            resultMsg.message = ""
                            if (visitorName.text && visitorPassport.text && roomNumber.text && patientCombo.currentValue !== undefined) {
                                var patientId = patientCombo.currentValue
                                if (dbManager.addVisit(patientId, visitorName.text, visitorPassport.text, roomNumber.text)) {
                                    visitsModel.refresh()
                                    visitorName.text = visitorPassport.text = roomNumber.text = ""
                                    resultMsg.isSuccess = true; resultMsg.isError = false
                                    resultMsg.message = "Посещение успешно зарегистрировано"
                                } else {
                                    resultMsg.isError = true; resultMsg.isSuccess = false
                                    resultMsg.message = "Ошибка при регистрации"
                                }
                            } else {
                                resultMsg.isError = true; resultMsg.isSuccess = false
                                resultMsg.message = "Заполните все поля и выберите пациента"
                            }
                        }
                    }
                }
            }

            Item { height: 24 }
        }
    }
}
