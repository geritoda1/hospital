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
        width: 400
        height: 200
        ColumnLayout {
            anchors.fill: parent; anchors.margins: 20
            Text { text: "Добавить лечение"; font.pixelSize: 18; font.weight: Font.Bold; color: "#FFFFFF" }
            TextField {
                id: treatmentText
                Layout.fillWidth: true
                placeholderText: "Описание лечения"
                background: Rectangle { radius: 8; color: Qt.rgba(1,1,1,0.10); border.color: "#28A98B" }
                color: "white"
            }
            Row {
                spacing: 12
                Layout.alignment: Qt.AlignRight
                Button { text: "Отмена"; onClicked: treatmentDialog.close() }
                Button {
                    text: "Добавить"
                    background: Rectangle { color: "#28A98B"; radius: 6 }
                    contentItem: Text { text: parent.text; color: "white" }
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
                implicitHeight: treatmentCol.implicitHeight + 40
                radius: 18
                color: Qt.rgba(1,1,1,0.05)
                border.color: Qt.rgba(1,1,1,0.10); border.width: 1
                ColumnLayout {
                    id: treatmentCol
                    anchors { left: parent.left; right: parent.right; top: parent.top; margins: 24 }
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
                    ListView {
                        Layout.fillWidth: true
                        height: treatmentModel.count * 60
                        model: treatmentModel
                        delegate: Rectangle {
                            width: parent.width; height: 50
                            color: "transparent"
                            Column {
                                Text { text: model.description; font.pixelSize: 12; color: "#FFFFFF" }
                                Text { text: model.createdAt; font.pixelSize: 10; color: Qt.rgba(1,1,1,0.50) }
                            }
                        }
                    }
                }
            }
            Item { height: 24 }
        }
    }

    Component.onCompleted: loadTreatments()
}