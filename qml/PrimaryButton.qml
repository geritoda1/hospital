import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: root
    property bool isDestructive: false
    property string iconText: ""

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
            if (root.isDestructive) return root.pressed ? "#C04040" : root.hovered ? "#D04848" : "#E05252"
            return root.pressed ? "#124E72" : root.hovered ? "#1A5E88" : "#1A6B9A"
        }
        Behavior on color { ColorAnimation { duration: 120 } }

        // Subtle bottom shadow
        layer.enabled: true
        layer.effect: null

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: "transparent"
            border.color: Qt.rgba(0,0,0,0.08)
            border.width: 1
        }
    }

    scale: pressed ? 0.97 : 1.0
    Behavior on scale { NumberAnimation { duration: 100 } }
}
