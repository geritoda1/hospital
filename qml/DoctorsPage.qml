import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    background: BackgroundWithDots { }

    property var editDoctorId: null

    // Диалог добавления/редактирования врача
    Popup {
        id: doctorDialog
        modal: true
        anchors.centerIn: Overlay.overlay
        width: 400
        height: dialogCol.implicitHeight + 50
        closePolicy: Popup.CloseOnEscape

        property bool isEdit: false

        ColumnLayout {
            id: dialogCol
            anchors.fill: parent
            anchors.margins: 20
            spacing: 12

            Text {
                text: doctorDialog.isEdit ? "Редактировать врача" : "Новый врач"
                font.pixelSize: 18; font.weight: Font.Bold
                color: "#FFFFFF"
            }

            StyledField { id: editFullName; placeholderText: "ФИО врача"; iconText: "👨‍⚕️"; Layout.fillWidth: true }
            StyledField { id: editPhone; placeholderText: "Телефон"; iconText: "📞"; Layout.fillWidth: true }
            StyledField { id: editPosition; placeholderText: "Должность (терапевт, хирург...)"; iconText: "🏥"; Layout.fillWidth: true }
            StyledField { id: editPassport; placeholderText: "Паспортные данные"; iconText: "📋"; Layout.fillWidth: true }

            Row {
                spacing: 12
                Layout.alignment: Qt.AlignRight
                Button {
                    text: "Отмена"
                    onClicked: doctorDialog.close()
                }
                Button {
                    text: "Сохранить"
                    background: Rectangle { color: "#28A98B"; radius: 6 }
                    contentItem: Text { text: parent.text; color: "white" }
                    onClicked: {
                        if (doctorDialog.isEdit && editDoctorId) {
                            dbManager.updateDoctor(editDoctorId, editFullName.text, editPhone.text,
                                                   editPosition.text, editPassport.text)
                        } else {
                            dbManager.addDoctor(editFullName.text, editPhone.text, editPosition.text, editPassport.text)
                        }
                        doctorsModel.refresh()
                        doctorDialog.close()
                    }
                }
            }
        }
    }

    header: Rectangle {
        width: parent.width; height: 56
        color: Qt.rgba(1,1,1,0.08)
        border.color: Qt.rgba(1,1,1,0.10); border.width: 1
        Row {
            anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: 16 }
            spacing: 10
            Text { text: "👨‍⚕️"; font.pixelSize: 20; color: "#FFFFFF" }
            Text { text: "Врачи"; font.pixelSize: 16; font.weight: Font.SemiBold; color: "#FFFFFF" }
        }
        Button {
            anchors { right: parent.right; verticalCenter: parent.verticalCenter; rightMargin: 12 }
            text: "+ Добавить врача"
            flat: true
            contentItem: Text { text: parent.text; font.pixelSize: 12; color: Qt.rgba(1,1,1,0.80) }
            background: Rectangle {
                radius: 6
                color: parent.pressed ? Qt.rgba(1,1,1,0.15) : (parent.hovered ? Qt.rgba(1,1,1,0.10) : "transparent")
            }
            onClicked: {
                editDoctorId = null
                editFullName.text = editPhone.text = editPosition.text = editPassport.text = ""
                doctorDialog.isEdit = false
                doctorDialog.open()
            }
        }
    }

    ListView {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8
        model: doctorsModel
        clip: true

        delegate: Rectangle {
            width: parent.width
            height: 100
            radius: 12
            color: Qt.rgba(1,1,1,0.05)
            border.color: Qt.rgba(1,1,1,0.10); border.width: 1

            Row {
                anchors.fill: parent; anchors.margins: 12
                spacing: 14
                Rectangle {
                    width: 48; height: 48; radius: 24
                    color: Qt.rgba(0.16, 0.66, 0.55, 0.20)
                    Text { text: "👨‍⚕️"; font.pixelSize: 24; anchors.centerIn: parent }
                }
                Column {
                    spacing: 4
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width - 140
                    Text { text: model.fullName; font.pixelSize: 14; font.weight: Font.SemiBold; color: "#FFFFFF" }
                    Text { text: "📞 " + model.phone; font.pixelSize: 11; color: Qt.rgba(1,1,1,0.60) }
                    Text { text: "🏥 " + model.position; font.pixelSize: 11; color: Qt.rgba(1,1,1,0.60) }
                    Text { text: "📄 " + model.passportData; font.pixelSize: 10; color: Qt.rgba(1,1,1,0.40) }
                }
                Row {
                    spacing: 8
                    anchors.verticalCenter: parent.verticalCenter
                    Button {
                        text: "✎"
                        font.pixelSize: 14
                        background: Rectangle { color: "transparent"; radius: 6 }
                        contentItem: Text { text: parent.text; color: "#28A98B" }
                        onClicked: {
                            editDoctorId = model.doctorId
                            editFullName.text = model.fullName
                            editPhone.text = model.phone
                            editPosition.text = model.position
                            editPassport.text = model.passportData
                            doctorDialog.isEdit = true
                            doctorDialog.open()
                        }
                    }
                    Button {
                        text: "🗑"
                        font.pixelSize: 14
                        background: Rectangle { color: "transparent"; radius: 6 }
                        contentItem: Text { text: parent.text; color: "#E05252" }
                        onClicked: {
                            if (dbManager.deleteDoctor(model.doctorId)) {
                                doctorsModel.refresh()
                            } else {
                                statusMsg.text = "Нельзя удалить врача: есть активные пациенты"
                                statusMsg.visible = true
                                hideTimer.start()
                            }
                        }
                    }
                }
            }
        }
    }

    Timer { id: hideTimer; interval: 3000; onTriggered: statusMsg.visible = false }
    Text { id: statusMsg; anchors.bottom: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter; color: "#E05252"; visible: false }
}