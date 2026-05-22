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
            Text { text: "📋"; font.pixelSize: 20; color: "#FFFFFF" }
            Text {
                text: "История посещений"
                font.pixelSize: 16; font.family: "Segoe UI"; font.weight: Font.SemiBold
                color: "#FFFFFF"
            }
        }
        Text {
            anchors { right: parent.right; verticalCenter: parent.verticalCenter; rightMargin: 16 }
            text: visitsModel.count + " записей"
            font.pixelSize: 12; color: Qt.rgba(1,1,1,0.50)
        }
    }

    ListView {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8
        model: visitsModel
        clip: true

        delegate: Rectangle {
            width: parent ? parent.width : 0
            height: 70
            radius: 12
            color: Qt.rgba(1,1,1,0.05)
            border.color: Qt.rgba(1,1,1,0.10); border.width: 1

            Row {
                anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; leftMargin: 16; rightMargin: 16 }
                spacing: 12

                Rectangle {
                    width: 40; height: 40; radius: 10
                    color: Qt.rgba(0.16, 0.66, 0.55, 0.20)
                    Text { text: "👤"; font.pixelSize: 20; anchors.centerIn: parent }
                }

                Column {
                    spacing: 4
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width - 90
                    Text {
                        text: model.visitorName + " → " + model.patientName
                        font.pixelSize: 13; font.weight: Font.SemiBold
                        color: "#FFFFFF"
                        elide: Text.ElideRight
                        width: parent.width
                    }
                    Text {
                        text: "🕐 " + model.visitTime
                        font.pixelSize: 11; color: Qt.rgba(1,1,1,0.50)
                    }
                }

                Text {
                    text: "›"
                    font.pixelSize: 22
                    color: Qt.rgba(1,1,1,0.30)
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.color = Qt.rgba(1,1,1,0.10)
                onExited: parent.color = Qt.rgba(1,1,1,0.05)
                onClicked: stackView.push("VisitDetailPage.qml", { visitData: model })
                cursorShape: Qt.PointingHandCursor
            }
        }

        Text {
            anchors.centerIn: parent
            visible: visitsModel.count === 0
            text: "Нет посещений"
            font.pixelSize: 14
            color: Qt.rgba(1,1,1,0.50)
        }
    }
}