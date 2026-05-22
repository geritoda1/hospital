// HistoryPage.qml (альтернативный вариант с использованием отдельной страницы)
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    ListView {
        anchors.fill: parent
        model: visitsModel
        delegate: ItemDelegate {
            width: parent.width
            text: model.visitorName + " → " + model.patientName + " (" + model.visitTime + ")"
            onClicked: {
                stackView.push("VisitDetailPage.qml", { visitData: model })
            }
        }
    }
}