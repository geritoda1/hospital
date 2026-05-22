import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    background: BackgroundWithDots { }

    header: Rectangle {
        width: parent.width
        height: 56
        color: Qt.rgba(1,1,1,0.08)
        border.color: Qt.rgba(1,1,1,0.10); border.width: 1

        Row {
            anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: 16 }
            spacing: 10
            Text { text: "🏥"; font.pixelSize: 20; color: "#FFFFFF" }
            Text {
                text: "Палаты и пациенты"
                font.pixelSize: 16; font.family: "Segoe UI"; font.weight: Font.SemiBold
                color: "#FFFFFF"
            }
        }

        Button {
            anchors { right: parent.right; verticalCenter: parent.verticalCenter; rightMargin: 12 }
            text: "↻ Обновить"
            flat: true
            contentItem: Text {
                text: parent.text
                font.pixelSize: 12
                color: Qt.rgba(1,1,1,0.70)
            }
            background: Rectangle {
                radius: 6
                color: parent.pressed ? Qt.rgba(1,1,1,0.15) : (parent.hovered ? Qt.rgba(1,1,1,0.10) : "transparent")
            }
            onClicked: patientsModel.refresh()
        }
    }

    ListView {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8
        model: patientsModel
        clip: true

        delegate: Rectangle {
            width: parent ? parent.width : 0
            height: 80
            radius: 12
            color: Qt.rgba(1,1,1,0.05)
            border.color: Qt.rgba(1,1,1,0.10); border.width: 1

            Row {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 14

                Rectangle {
                    width: 48; height: 48; radius: 12
                    color: Qt.rgba(0.16, 0.66, 0.55, 0.20)
                    Text {
                        text: model.roomNumber
                        font.pixelSize: 16; font.weight: Font.Bold
                        color: "#28A98B"
                        anchors.centerIn: parent
                    }
                }

                Column {
                    spacing: 4
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width - 80
                    Text {
                        text: model.fullName
                        font.pixelSize: 14; font.weight: Font.SemiBold
                        color: "#FFFFFF"
                        elide: Text.ElideRight
                        width: parent.width
                    }
                    Text {
                        text: "🩺 " + model.diagnosis
                        font.pixelSize: 11; color: Qt.rgba(1,1,1,0.60)
                        width: parent.width
                        elide: Text.ElideRight
                    }
                    Text {
                        text: "📄 " + model.passportData
                        font.pixelSize: 10; color: Qt.rgba(1,1,1,0.40)
                    }
                }
            }
        }

        Text {
            anchors.centerIn: parent
            visible: patientsModel.count === 0
            text: "Нет пациентов"
            font.pixelSize: 14
            color: Qt.rgba(1,1,1,0.50)
        }
    }
}