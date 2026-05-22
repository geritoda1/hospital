import QtQuick 2.15
import QtQuick.Controls 2.15

TextField {
    id: root
    property string iconText: ""
    leftPadding: iconText !== "" ? 40 : 14
    rightPadding: 14
    topPadding: 13
    bottomPadding: 13
    font.pixelSize: 13
    font.family: "Segoe UI"
    color: "#1A2533"
    placeholderTextColor: "#9AAABB"
    selectByMouse: true

    background: Rectangle {
        radius: 10
        color: root.activeFocus ? "#EBF4FA" : "#F7FAFC"
        border.color: root.activeFocus ? "#1A6B9A" : "#DDE6EF"
        border.width: root.activeFocus ? 2 : 1

        Behavior on border.color { ColorAnimation { duration: 150 } }
        Behavior on color { ColorAnimation { duration: 150 } }
    }

    // Optional left icon label
    Text {
        visible: root.iconText !== ""
        text: root.iconText
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: 16
        color: root.activeFocus ? "#1A6B9A" : "#9AAABB"
        Behavior on color { ColorAnimation { duration: 150 } }
    }
}
