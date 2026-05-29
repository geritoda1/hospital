#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSqlDatabase>
#include <QDir>
#include <QFile>
#include <QDebug>
#include "DatabaseManager.h"
#include "PatientsModel.h"
#include "VisitsModel.h"
#include "DoctorsModel.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    DatabaseManager dbManager;
    if (!dbManager.init()) {
        return -1;
    }

    PatientsModel patientsModel;
    VisitsModel visitsModel;
    DoctorsModel doctorsModel;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("dbManager", &dbManager);
    engine.rootContext()->setContextProperty("patientsModel", &patientsModel);
    engine.rootContext()->setContextProperty("visitsModel", &visitsModel);
    engine.rootContext()->setContextProperty("doctorsModel", &doctorsModel);

    // Загружаем из файловой системы (папка qml копируется POST_BUILD)
    QString qmlPath = QCoreApplication::applicationDirPath() + "/qml/main.qml";
    if (!QFile::exists(qmlPath)) {
        qDebug() << "Ошибка: не найден" << qmlPath;
        return -1;
    }
    QUrl url = QUrl::fromLocalFile(qmlPath);
    engine.load(url);

    return app.exec();
}