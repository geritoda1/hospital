import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    property var visitData: ({})
    background: Rectangle { color: "#F0F4F8" }

    header: Rectangle {
        width: parent.width; height: 56
        color: "#FFFFFF"
        border.color: "#DDE6EF"; border.width: 1

        Row {
            anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: 8 }
            spacing: 4

            Rectangle {
                width: 36; height: 36; radius: 8
                color: backArea.containsMouse ? "#EBF4FA" : "transparent"
                Behavior on color { ColorAnimation { duration: 120 } }
                anchors.verticalCenter: parent.verticalCenter

                Text { text: "‹"; font.pixelSize: 22; color: "#1A6B9A"; anchors.centerIn: parent }

                MouseArea {
                    id: backArea; anchors.fill: parent; hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: stackView.pop()
                }
            }

            Text {
                text: "Детали посещения"
                font.pixelSize: 16; font.family: "Segoe UI"; font.weight: Font.SemiBold
                color: "#1A2533"; anchors.verticalCenter: parent.verticalCenter
            }
        }

        Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: "#DDE6EF" }
    }

    ScrollView {
        anchors.fill: parent
        contentWidth: availableWidth

        ColumnLayout {
            width: Math.min(520, parent.width - 40)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 24
            spacing: 12

            // Avatar / summary card
            Rectangle {
                Layout.fillWidth: true
                height: 90
                radius: 12
                color: "#1A6B9A"

                Row {
                    anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: 20 }
                    spacing: 16

                    Rectangle {
                        width: 56; height: 56; radius: 28
                        color: Qt.rgba(1,1,1,0.15)
                        anchors.verticalCenter: parent.verticalCenter
                        Text { text: "🚪"; font.pixelSize: 28; anchors.centerIn: parent }
                    }

                    Column {
                        spacing: 4
                        anchors.verticalCenter: parent.verticalCenter
                        Text {
                            text: visitData.visitorName || "—"
                            font.pixelSize: 17; font.family: "Segoe UI"; font.weight: Font.Bold
                            color: "#FFFFFF"
                        }
                        Text {
                            text: "Посещает: " + (visitData.patientName || "—")
                            font.pixelSize: 12; font.family: "Segoe UI"
                            color: Qt.rgba(1,1,1,0.75)
                        }
                    }
                }
            }

            // Details card
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: detailsCol.implicitHeight + 32
                radius: 12
                color: "#FFFFFF"
                border.color: "#DDE6EF"; border.width: 1

                ColumnLayout {
                    id: detailsCol
                    anchors { left: parent.left; right: parent.right; top: parent.top; margins: 20 }
                    spacing: 0

                    Repeater {
                        model: [
                            { icon: "🩺", label: "Пациент",              value: visitData.patientName       || "—" },
                            { icon: "👥", label: "Посетитель",           value: visitData.visitorName       || "—" },
                            { icon: "📋", label: "Паспорт посетителя",   value: visitData.visitorPassport   || "—" },
                            { icon: "🏠", label: "Палата",               value: visitData.roomNumber        || "—" },
                            { icon: "🕐", label: "Время посещения",      value: visitData.visitTime         || "—" },
                            { icon: "👔", label: "Сотрудник на смене",   value: visitData.employeeName      || "Неизвестен" },
                        ]

                        delegate: Column {
                            Layout.fillWidth: true
                            spacing: 0

                            Rectangle {
                                width: parent.width
                                height: 1
                                color: "#F0F4F8"
                                visible: index > 0
                            }

                            Row {
                                width: parent.width
                                height: 52
                                spacing: 14
                                leftPadding: 0

                                Rectangle {
                                    width: 36; height: 36; radius: 8
                                    color: "#F0F4F8"
                                    anchors.verticalCenter: parent.verticalCenter
                                    Text { text: modelData.icon; font.pixelSize: 18; anchors.centerIn: parent }
                                }

                                Column {
                                    spacing: 2
                                    anchors.verticalCenter: parent.verticalCenter
                                    Text {
                                        text: modelData.label
                                        font.pixelSize: 11; font.family: "Segoe UI"
                                        color: "#9AAABB"
                                    }
                                    Text {
                                        text: modelData.value
                                        font.pixelSize: 13; font.family: "Segoe UI"; font.weight: Font.Medium
                                        color: "#1A2533"
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // Back button
            PrimaryButton {
                text: "← Назад к истории"
                Layout.fillWidth: true
                onClicked: stackView.pop()
            }

            Item { height: 24 }
        }
    }
}
