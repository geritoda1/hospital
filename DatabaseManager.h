#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QVariantMap>
#include <QVariantList>

class DatabaseManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int currentUserId READ currentUserId WRITE setCurrentUserId NOTIFY currentUserIdChanged)
public:
    explicit DatabaseManager(QObject *parent = nullptr);
    ~DatabaseManager();

    bool init();

    // Авторизация
    Q_INVOKABLE bool login(const QString &login, const QString &password);
    Q_INVOKABLE bool registerUser(const QString &login, const QString &password, const QString &fullName);

    // Пациенты
    Q_INVOKABLE bool addPatient(const QString &fullName, const QString &diagnosis,
                                const QString &room, const QString &passport, int doctorId);
    Q_INVOKABLE bool dischargePatient(int patientId);

    // Врачи
    Q_INVOKABLE bool addDoctor(const QString &fullName, const QString &phone,
                               const QString &position, const QString &passport);
    Q_INVOKABLE bool updateDoctor(int doctorId, const QString &fullName, const QString &phone,
                                  const QString &position, const QString &passport);
    Q_INVOKABLE bool deleteDoctor(int doctorId);
    Q_INVOKABLE QVariantList getDoctors();

    // Лечение
    Q_INVOKABLE bool addTreatment(int patientId, const QString &description);
    Q_INVOKABLE QVariantList getTreatmentsForPatient(int patientId);

    // Посещения
    Q_INVOKABLE bool addVisit(int patientId, const QString &visitorName,
                              const QString &visitorPassport, const QString &room);

    int currentUserId() const;
    void setCurrentUserId(int id);

signals:
    void currentUserIdChanged();

private:
    QSqlDatabase m_db;
    int m_currentUserId;
    QString hashPassword(const QString &password);
};

#endif // DATABASEMANAGER_H