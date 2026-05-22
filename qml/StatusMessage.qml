import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root
    property string message: ""
    property bool isError: false
    property bool isSuccess: false

    visible: message !== ""
    height: message !== "" ? 40 : 0
    radius: 8
    color: isError ? "#FDEAEA" : isSuccess ? "#E6F7EE" : "#EBF4FA"
    border.color: isError ? "#E05252" : isSuccess ? "#2EAA6A" : "#1A6B9A"
    border.width: 1

    Behavior on height { NumberAnimation { duration: 200 } }

    Row {
        anchors.centerIn: parent
        spacing: 8

        Text {
            text: root.isError ? "✕" : root.isSuccess ? "✓" : "ℹ"
            font.pixelSize: 14
            color: root.isError ? "#E05252" : root.isSuccess ? "#2EAA6A" : "#1A6B9A"
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            text: root.message
            font.pixelSize: 13
            font.family: "Segoe UI"
            color: root.isError ? "#C03030" : root.isSuccess ? "#1E8050" : "#124E72"
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
