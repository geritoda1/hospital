import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: root
    property bool isDestructive: false
    property string iconText: ""

    flat: true  // отключаем системную тему

    topPadding: 13
    bottomPadding: 13
    leftPadding: 20
    rightPadding: 20

    contentItem: Row {
        spacing: 8
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            visible: root.iconText !== ""
            text: root.iconText
            font.pixelSize: 15
            color: "#FFFFFF"
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            text: root.text
            font.pixelSize: 14
            font.family: "Segoe UI"
            font.weight: Font.Medium
            color: "#FFFFFF"
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    background: Rectangle {
        radius: 10
        color: {
            if (root.isDestructive) {
                if (root.pressed) return "#B33A3A"
                if (root.hovered) return "#D95C5C"
                return "#E05252"
            }
            if (root.pressed) return "#0E4A6A"
            if (root.hovered) return "#2A7BAA"
            return "#1A6B9A"
        }
        Behavior on color { ColorAnimation { duration: 120 } }
    }

    scale: pressed ? 0.97 : 1.0
    Behavior on scale { NumberAnimation { duration: 100 } }
}