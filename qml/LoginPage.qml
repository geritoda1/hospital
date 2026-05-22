import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    signal loginSuccess

    ColumnLayout {
        anchors.centerIn: parent
        width: 300
        spacing: 10

        TextField {
            id: loginField
            placeholderText: "Логин"
            Layout.fillWidth: true
        }
        TextField {
            id: passwordField
            placeholderText: "Пароль"
            echoMode: TextField.Password
            Layout.fillWidth: true
        }
        Button {
            text: "Войти"
            Layout.fillWidth: true
            onClicked: {
                if (dbManager.login(loginField.text, passwordField.text)) {
                    loginSuccess()
                } else {
                    errorLabel.text = "Неверный логин или пароль"
                }
            }
        }
        Label {
            id: errorLabel
            color: "red"
            Layout.fillWidth: true
            wrapMode: Text.Wrap
        }
    }
}