import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    property var patientData: ({})
    property var treatmentsList: []

    background: BackgroundWithDots { }

    function loadTreatments() {
        treatmentsList = dbManager.getTreatmentsForPatient(patientData.patientId)
        treatmentModel.clear()
        for (var i = 0; i < treatmentsList.length; i++) {
            treatmentModel.append(treatmentsList[i])
        }
    }

    ListModel { id: treatmentModel }

    Popup {
        id: treatmentDialog
        modal: true
        anchors.centerIn: Overlay.overlay
        width: 420
        height: 220
        closePolicy: Popup.CloseOnEscape
        background: Rectangle {
            color: "#0D3349"
            radius: 18
            border.color: "#28A98B"
            border.width: 1
        }
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 16
            Text {
                text: "💊 Добавить лечение"
                font.pixelSize: 18; font.weight: Font.Bold
                color: "#FFFFFF"
            }
            TextField {
                id: treatmentText
                Layout.fillWidth: true
                placeholderText: "Введите описание лечения"
                background: Rectangle {
                    radius: 10
                    color: activeFocus ? Qt.rgba(1,1,1,0.10) : Qt.rgba(1,1,1,0.06)
                    border.color: activeFocus ? "#28A98B" : Qt.rgba(1,1,1,0.12)
                    border.width: 1
                }
                color: "#FFFFFF"
                placeholderTextColor: Qt.rgba(1,1,1,0.40)
                font.pixelSize: 13
            }
            Row {
                spacing: 12
                Layout.alignment: Qt.AlignRight
                Button {
                    text: "Отмена"
                    background: Rectangle {
                        color: parent.pressed ? Qt.rgba(1,1,1,0.20) : (parent.hovered ? Qt.rgba(1,1,1,0.10) : "transparent")
                        radius: 6
                        border.color: Qt.rgba(1,1,1,0.30)
                        border.width: 1
                    }
                    contentItem: Text { text: parent.text; color: Qt.rgba(1,1,1,0.70) }
                    onClicked: treatmentDialog.close()
                }
                Button {
                    text: "Добавить"
                    background: Rectangle {
                        color: parent.pressed ? "#1E8B72" : (parent.hovered ? "#2EBD9C" : "#28A98B")
                        radius: 6
                    }
                    contentItem: Text { text: parent.text; color: "#FFFFFF" }
                    onClicked: {
                        if (treatmentText.text) {
                            dbManager.addTreatment(patientData.patientId, treatmentText.text)
                            loadTreatments()
                            treatmentDialog.close()
                            treatmentText.text = ""
                        }
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
            anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: 8 }
            spacing: 4
            Rectangle {
                width: 36; height: 36; radius: 8
                color: backMouse.pressed ? Qt.rgba(1,1,1,0.20) : (backMouse.containsMouse ? Qt.rgba(1,1,1,0.10) : "transparent")
                Text { text: "‹"; font.pixelSize: 22; color: "#28A98B"; anchors.centerIn: parent }
                MouseArea { id: backMouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: stackView.pop() }
            }
            Text { text: "Карта пациента"; font.pixelSize: 16; font.weight: Font.SemiBold; color: "#FFFFFF" }
        }
    }

    ScrollView {
        anchors.fill: parent
        contentWidth: availableWidth
        ColumnLayout {
            width: Math.min(520, parent.width - 40)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top; anchors.topMargin: 24
            spacing: 16

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: infoCol.implicitHeight + 40
                radius: 18
                color: Qt.rgba(1,1,1,0.05)
                border.color: Qt.rgba(1,1,1,0.10); border.width: 1
                ColumnLayout {
                    id: infoCol
                    anchors { left: parent.left; right: parent.right; top: parent.top; margins: 24 }
                    spacing: 8
                    Text { text: "👤 " + (patientData.fullName || "—"); font.pixelSize: 16; font.weight: Font.Bold; color: "#FFFFFF" }
                    Text { text: "🩺 Диагноз: " + (patientData.diagnosis || "—"); font.pixelSize: 13; color: Qt.rgba(1,1,1,0.80) }
                    Text { text: "🏠 Палата: " + (patientData.roomNumber || "—"); font.pixelSize: 13; color: Qt.rgba(1,1,1,0.80) }
                    Text { text: "📄 Паспорт: " + (patientData.passportData || "—"); font.pixelSize: 13; color: Qt.rgba(1,1,1,0.80) }
                    Text { text: "👨‍⚕️ Лечащий врач: " + (patientData.doctorName || "не назначен"); font.pixelSize: 13; color: Qt.rgba(1,1,1,0.80) }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                radius: 18
                color: Qt.rgba(1,1,1,0.05)
                border.color: Qt.rgba(1,1,1,0.10); border.width: 1
                ColumnLayout {
                    anchors { left: parent.left; right: parent.right; top: parent.top; margins: 20 }
                    spacing: 12
                    Row {
                        spacing: 12
                        Text { text: "💊 Лечение"; font.pixelSize: 14; font.weight: Font.Bold; color: "#FFFFFF" }
                        Button {
                            text: "+ Добавить"
                            flat: true
                            contentItem: Text { text: parent.text; font.pixelSize: 11; color: "#28A98B" }
                            onClicked: treatmentDialog.open()
                        }
                    }
                    Repeater {
                        model: treatmentModel
                        delegate: Rectangle {
                            width: parent.width
                            height: treatmentRow.implicitHeight + 20
                            color: Qt.rgba(1,1,1,0.03)
                            radius: 8
                            Row {
                                id: treatmentRow
                                anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; margins: 12 }
                                spacing: 12
                                Text { text: "💊"; font.pixelSize: 14; anchors.verticalCenter: parent.verticalCenter }
                                Column {
                                    spacing: 4
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width - 60
                                    Text { text: model.description; font.pixelSize: 12; color: "#FFFFFF"; wrapMode: Text.Wrap; width: parent.width }
                                    Text { text: model.createdAt; font.pixelSize: 10; color: Qt.rgba(1,1,1,0.50) }
                                }
                            }
                        }
                    }
                    Item { height: 10 }
                }
            }
            Item { height: 24 }
        }
    }

    Component.onCompleted: loadTreatments()
}