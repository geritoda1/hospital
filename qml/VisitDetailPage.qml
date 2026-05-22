import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    property var visitData: ({})
    background: BackgroundWithDots { }

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
                MouseArea {
                    id: backMouse; anchors.fill: parent; hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: stackView.pop()
                }
            }
            Text {
                text: "Детали посещения"
                font.pixelSize: 16; font.weight: Font.SemiBold
                color: "#FFFFFF"
            }
        }
    }

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
                implicitHeight: 100
                radius: 18
                color: Qt.rgba(1,1,1,0.05)
                border.color: Qt.rgba(1,1,1,0.10); border.width: 1

                Row {
                    anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; margins: 20 }
                    spacing: 16
                    Rectangle {
                        width: 56; height: 56; radius: 28
                        color: Qt.rgba(0.16, 0.66, 0.55, 0.20)
                        Text { text: "🚪"; font.pixelSize: 28; anchors.centerIn: parent }
                    }
                    Column {
                        spacing: 4
                        Text {
                            text: visitData.visitorName || "—"
                            font.pixelSize: 16; font.weight: Font.Bold
                            color: "#FFFFFF"
                        }
                        Text {
                            text: "→ " + (visitData.patientName || "—")
                            font.pixelSize: 12
                            color: Qt.rgba(1,1,1,0.60)
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: detailsCol.implicitHeight + 40
                radius: 18
                color: Qt.rgba(1,1,1,0.05)
                border.color: Qt.rgba(1,1,1,0.10); border.width: 1

                ColumnLayout {
                    id: detailsCol
                    anchors { left: parent.left; right: parent.right; top: parent.top; margins: 24 }
                    spacing: 0

                    Repeater {
                        model: [
                            { icon: "🩺", label: "Пациент",            value: visitData.patientName       || "—" },
                            { icon: "👥", label: "Посетитель",         value: visitData.visitorName       || "—" },
                            { icon: "📋", label: "Паспорт посетителя", value: visitData.visitorPassport   || "—" },
                            { icon: "🏠", label: "Палата",             value: visitData.roomNumber        || "—" },
                            { icon: "🕐", label: "Время посещения",    value: visitData.visitTime         || "—" },
                            { icon: "👔", label: "Сотрудник",          value: visitData.employeeName      || "Неизвестен" },
                        ]
                        delegate: Column {
                            Layout.fillWidth: true
                            Rectangle {
                                width: parent.width
                                height: 1
                                color: Qt.rgba(1,1,1,0.10)
                                visible: index > 0
                                Layout.bottomMargin: 8
                            }
                            Row {
                                width: parent.width
                                height: 48
                                spacing: 14
                                Rectangle {
                                    width: 32; height: 32; radius: 8
                                    color: Qt.rgba(1,1,1,0.05)
                                    Text { text: modelData.icon; font.pixelSize: 16; anchors.centerIn: parent }
                                }
                                Column {
                                    spacing: 2
                                    Text {
                                        text: modelData.label
                                        font.pixelSize: 10; color: Qt.rgba(1,1,1,0.40)
                                    }
                                    Text {
                                        text: modelData.value
                                        font.pixelSize: 13; font.weight: Font.Medium
                                        color: "#FFFFFF"
                                    }
                                }
                            }
                            Item { height: 8 }
                        }
                    }
                }
            }

            PrimaryButton {
                text: "← Назад к истории"
                Layout.fillWidth: true
                onClicked: stackView.pop()
            }
            Item { height: 24 }
        }
    }
}