#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QVariantMap>

class DatabaseManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int currentUserId READ currentUserId WRITE setCurrentUserId NOTIFY currentUserIdChanged)
public:
    explicit DatabaseManager(QObject *parent = nullptr);
    ~DatabaseManager();

    bool init();

    Q_INVOKABLE bool login(const QString &login, const QString &password);
    Q_INVOKABLE bool addPatient(const QString &fullName, const QString &diagnosis,
                                const QString &room, const QString &passport);
    Q_INVOKABLE bool addVisit(int patientId, const QString &visitorName,
                              const QString &visitorPassport, const QString &room);

    // Модели будут отдельно, но для удобства можно получить списки
    int currentUserId() const;
    void setCurrentUserId(int id);

signals:
    void currentUserIdChanged();

private:
    QSqlDatabase m_db;
    int m_currentUserId;
};

#endif // DATABASEMANAGER_H