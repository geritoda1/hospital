import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    background: Rectangle { color: "#F0F4F8" }

    header: Rectangle {
        width: parent.width
        height: 56
        color: "#FFFFFF"
        border.color: "#DDE6EF"; border.width: 1

        Row {
            anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: 16 }
            spacing: 10
            Text { text: "🏥"; font.pixelSize: 22; anchors.verticalCenter: parent.verticalCenter }
            Text {
                text: "Занятость палат"
                font.pixelSize: 16; font.family: "Segoe UI"; font.weight: Font.SemiBold
                color: "#1A2533"
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Row {
            anchors { right: parent.right; verticalCenter: parent.verticalCenter; rightMargin: 12 }
            spacing: 8

            Rectangle {
                width: refreshBtn.implicitWidth + 24
                height: 32; radius: 8
                color: refreshBtn.containsMouse ? "#EBF4FA" : "#F0F4F8"
                border.color: "#DDE6EF"; border.width: 1
                Behavior on color { ColorAnimation { duration: 120 } }

                Text {
                    id: refreshBtnLabel
                    anchors.centerIn: parent
                    text: "↻  Обновить"
                    font.pixelSize: 12; font.family: "Segoe UI"
                    color: "#1A6B9A"
                }
                MouseArea {
                    id: refreshBtn
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: patientsModel.refresh()
                }
            }
        }

        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width; height: 1
            color: "#DDE6EF"
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
            height: contentRow.implicitHeight + 20
            radius: 10
            color: "#FFFFFF"
            border.color: "#DDE6EF"; border.width: 1

            // Room badge
            Rectangle {
                id: roomBadge
                width: 48; height: 48; radius: 10
                color: "#EBF4FA"
                anchors { left: parent.left; leftMargin: 14; verticalCenter: parent.verticalCenter }

                Text {
                    anchors.centerIn: parent
                    text: model.roomNumber
                    font.pixelSize: 13; font.family: "Segoe UI"; font.weight: Font.Bold
                    color: "#1A6B9A"
                }
            }

            Row {
                id: contentRow
                anchors {
                    left: roomBadge.right; right: parent.right
                    verticalCenter: parent.verticalCenter
                    leftMargin: 14; rightMargin: 14
                }
                spacing: 0

                Column {
                    spacing: 5
                    width: parent.width

                    Text {
                        text: model.fullName
                        font.pixelSize: 14; font.family: "Segoe UI"; font.weight: Font.SemiBold
                        color: "#1A2533"
                        elide: Text.ElideRight
                        width: parent.width
                    }

                    Row {
                        spacing: 6
                        Rectangle {
                            width: diagLabel.implicitWidth + 14; height: 20; radius: 5
                            color: "#EBF4FA"
                            Text {
                                id: diagLabel
                                anchors.centerIn: parent
                                text: "🩺  " + model.diagnosis
                                font.pixelSize: 11; font.family: "Segoe UI"
                                color: "#1A6B9A"
                            }
                        }
                    }

                    Text {
                        text: "Паспорт: " + model.passportData
                        font.pixelSize: 11; font.family: "Segoe UI"
                        color: "#9AAABB"
                    }
                }
            }
        }

        Text {
            anchors.centerIn: parent
            visible: patientsModel.count === 0
            text: "Нет пациентов в палатах"
            font.pixelSize: 14; font.family: "Segoe UI"
            color: "#9AAABB"
        }
    }
}
