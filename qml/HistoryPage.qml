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
            Text { text: "📋"; font.pixelSize: 22; anchors.verticalCenter: parent.verticalCenter }
            Text {
                text: "История посещений"
                font.pixelSize: 16; font.family: "Segoe UI"; font.weight: Font.SemiBold
                color: "#1A2533"
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Text {
            anchors { right: parent.right; verticalCenter: parent.verticalCenter; rightMargin: 16 }
            text: visitsModel.count + " записей"
            font.pixelSize: 12; font.family: "Segoe UI"
            color: "#9AAABB"
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
        model: visitsModel
        clip: true

        delegate: Rectangle {
            width: parent ? parent.width : 0
            height: delegateRow.implicitHeight + 20
            radius: 10
            color: "#FFFFFF"
            border.color: "#DDE6EF"; border.width: 1

            // Left accent stripe
            Rectangle {
                width: 4; height: parent.height - 16
                radius: 2
                color: "#1A6B9A"
                anchors { left: parent.left; leftMargin: 8; verticalCenter: parent.verticalCenter }
            }

            Row {
                id: delegateRow
                anchors { left: parent.left; right: arrowText.left; verticalCenter: parent.verticalCenter }
                anchors.leftMargin: 22
                anchors.rightMargin: 8
                spacing: 12

                // Icon
                Rectangle {
                    width: 40; height: 40; radius: 20
                    color: "#EBF4FA"
                    anchors.verticalCenter: parent.verticalCenter
                    Text { text: "👤"; font.pixelSize: 18; anchors.centerIn: parent }
                }

                Column {
                    spacing: 4
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        text: model.visitorName + " → " + model.patientName
                        font.pixelSize: 13; font.family: "Segoe UI"; font.weight: Font.SemiBold
                        color: "#1A2533"
                    }
                    Row {
                        spacing: 10
                        Text {
                            text: "🕐 " + model.visitTime
                            font.pixelSize: 11; font.family: "Segoe UI"
                            color: "#9AAABB"
                        }
                    }
                }
            }

            Text {
                id: arrowText
                text: "›"
                font.pixelSize: 22; color: "#C0CDD8"
                anchors { right: parent.right; rightMargin: 14; verticalCenter: parent.verticalCenter }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.color = "#F7FAFC"
                onExited:  parent.color = "#FFFFFF"
                onClicked: stackView.push("VisitDetailPage.qml", { visitData: model })
                cursorShape: Qt.PointingHandCursor
            }
        }

        // Empty state
        Text {
            anchors.centerIn: parent
            visible: visitsModel.count === 0
            text: "Нет записей о посещениях"
            font.pixelSize: 14; font.family: "Segoe UI"
            color: "#9AAABB"
        }
    }
}
