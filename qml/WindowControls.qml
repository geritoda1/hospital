// WindowControls.qml
import QtQuick 2.15
import QtQuick.Controls 2.15

Row {
    id: root
    spacing: 8
    z: 10

    property var targetWindow: null

    // Кнопка "Свернуть"
    Rectangle {
        width: 28
        height: 28
        radius: 6
        color: minimizeMouse.pressed ? Qt.rgba(1,1,1,0.20) : (minimizeMouse.containsMouse ? Qt.rgba(1,1,1,0.12) : Qt.rgba(1,1,1,0.08))
        Behavior on color { ColorAnimation { duration: 120 } }

        Text {
            anchors.centerIn: parent
            text: "─"
            font.pixelSize: 16
            color: "#FFFFFF"
        }

        MouseArea {
            id: minimizeMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if (root.targetWindow) root.targetWindow.showMinimized()
                else if (window) window.showMinimized()
            }
        }
    }

    // Кнопка "Закрыть"
    Rectangle {
        width: 28
        height: 28
        radius: 6
        color: closeMouse.pressed ? "#B33A3A" : (closeMouse.containsMouse ? "#D95C5C" : Qt.rgba(1,1,1,0.08))
        Behavior on color { ColorAnimation { duration: 120 } }

        Text {
            anchors.centerIn: parent
            text: "✕"
            font.pixelSize: 14
            color: "#FFFFFF"
        }

        MouseArea {
            id: closeMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: Qt.quit()
        }
    }
}