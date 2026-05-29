import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    background: BackgroundWithDots { }

    Popup {
        id: confirmDialog
        modal: true
        anchors.centerIn: Overlay.overlay
        width: 320
        height: 180
        closePolicy: Popup.CloseOnEscape
        property string text: ""
        property var acceptCallback: null
        background: Rectangle {
            color: "#0D3349"
            radius: 12
            border.color: "#28A98B"
            border.width: 1
        }
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12
            Text {
                text: confirmDialog.text
                color: "#FFFFFF"
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                font.pixelSize: 13
            }
            Row {
                spacing: 12
                Layout.alignment: Qt.AlignRight
                Button {
                    text: "Да"
                    background: Rectangle {
                        color: parent.pressed ? "#1E8B72" : (parent.hovered ? "#2EBD9C" : "#28A98B")
                        radius: 6
                    }
                    contentItem: Text { text: parent.text; color: "#FFFFFF" }
                    onClicked: {
                        if (confirmDialog.acceptCallback) confirmDialog.acceptCallback()
                        confirmDialog.close()
                    }
                }
                Button {
                    text: "Нет"
                    background: Rectangle {
                        color: parent.pressed ? Qt.rgba(1,1,1,0.20) : (parent.hovered ? Qt.rgba(1,1,1,0.10) : "transparent")
                        radius: 6
                        border.color: Qt.rgba(1,1,1,0.30)
                        border.width: 1
                    }
                    contentItem: Text { text: parent.text; color: Qt.rgba(1,1,1,0.70) }
                    onClicked: confirmDialog.close()
                }
            }
        }
    }

    Timer { id: hideTimer; interval: 3000; onTriggered: statusMessage.visible = false }

    header: Rectangle {
        width: parent.width; height: 56
        color: Qt.rgba(1,1,1,0.08)
        border.color: Qt.rgba(1,1,1,0.10); border.width: 1
        Row {
            anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: 16 }
            spacing: 10
            Text { text: "🏥"; font.pixelSize: 20; color: "#FFFFFF" }
            Text { text: "Палаты и пациенты"; font.pixelSize: 16; font.weight: Font.SemiBold; color: "#FFFFFF" }
        }
        Button {
            anchors { right: parent.right; verticalCenter: parent.verticalCenter; rightMargin: 12 }
            text: "↻ Обновить"
            flat: true
            contentItem: Text { text: parent.text; font.pixelSize: 12; color: Qt.rgba(1,1,1,0.70) }
            background: Rectangle {
                radius: 6
                color: parent.pressed ? Qt.rgba(1,1,1,0.15) : (parent.hovered ? Qt.rgba(1,1,1,0.10) : "transparent")
            }
            onClicked: patientsModel.refresh()
        }
    }

    ColumnLayout {
        anchors.fill: parent; spacing: 0
        ListView {
            Layout.fillWidth: true; Layout.fillHeight: true
            Layout.margins: 12; spacing: 8
            model: patientsModel; clip: true
            delegate: Rectangle {
                width: parent.width; height: 130
                radius: 12; color: Qt.rgba(1,1,1,0.05)
                border.color: Qt.rgba(1,1,1,0.10); border.width: 1

                // Основной контент карточки (кликабельный)
                Item {
                    anchors.fill: parent
                    anchors.rightMargin: 50 // Оставляем место для кнопки
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            var patientInfo = {
                                patientId: model.patientId,
                                fullName: model.fullName,
                                diagnosis: model.diagnosis,
                                roomNumber: model.roomNumber,
                                passportData: model.passportData,
                                doctorName: model.doctorName
                            }
                            stackView.push("PatientDetailPage.qml", { patientData: patientInfo })
                        }
                    }
                    Row {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 14
                        Rectangle {
                            width: 48; height: 48; radius: 12
                            color: Qt.rgba(0.16, 0.66, 0.55, 0.20)
                            Text { text: model.roomNumber; font.pixelSize: 16; font.weight: Font.Bold; color: "#28A98B"; anchors.centerIn: parent }
                        }
                        Column {
                            spacing: 4
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width - 120
                            Text { text: model.fullName; font.pixelSize: 14; font.weight: Font.SemiBold; color: "#FFFFFF"; elide: Text.ElideRight; width: parent.width }
                            Text { text: "🩺 " + model.diagnosis; font.pixelSize: 11; color: Qt.rgba(1,1,1,0.60); width: parent.width; elide: Text.ElideRight }
                            Text { text: "📄 " + model.passportData; font.pixelSize: 10; color: Qt.rgba(1,1,1,0.40) }
                            Text { text: "👨‍⚕️ " + (model.doctorName || "Не назначен"); font.pixelSize: 10; color: Qt.rgba(1,1,1,0.50); width: parent.width; elide: Text.ElideRight }
                        }
                    }
                }

                // Кнопка выписки (справа, не перехватывает клик)
                Rectangle {
                    anchors { right: parent.right; verticalCenter: parent.verticalCenter; rightMargin: 12 }
                    width: 36; height: 36; radius: 8
                    color: dischargeMouse.pressed ? "#B33A3A" : (dischargeMouse.containsMouse ? Qt.rgba(0.88, 0.32, 0.32, 0.8) : Qt.rgba(0.88, 0.32, 0.32, 0.5))
                    Behavior on color { ColorAnimation { duration: 120 } }
                    Text { anchors.centerIn: parent; text: "✕"; font.pixelSize: 16; color: "#FFFFFF" }
                    MouseArea {
                        id: dischargeMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            confirmDialog.text = "Выписать пациента \"" + model.fullName + "\" из палаты " + model.roomNumber + "?"
                            confirmDialog.acceptCallback = function() {
                                if (dbManager.dischargePatient(model.patientId)) {
                                    patientsModel.refresh()
                                    statusMessage.isSuccess = true
                                    statusMessage.message = "Пациент выписан"
                                } else {
                                    statusMessage.isError = true
                                    statusMessage.message = "Ошибка выписки"
                                }
                                statusMessage.visible = true
                                hideTimer.restart()
                            }
                            confirmDialog.open()
                        }
                    }
                }
            }
            Text {
                anchors.centerIn: parent
                visible: patientsModel.count === 0
                text: "Нет активных пациентов"
                font.pixelSize: 14; color: Qt.rgba(1,1,1,0.50)
            }
        }
        StatusMessage { id: statusMessage; Layout.fillWidth: true; Layout.margins: 12; visible: false }
    }
}