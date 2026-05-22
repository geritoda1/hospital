#include "DatabaseManager.h"
#include <QSqlError>
#include <QDebug>
#include <QCryptographicHash>

DatabaseManager::DatabaseManager(QObject *parent) : QObject(parent), m_currentUserId(-1)
{
}

DatabaseManager::~DatabaseManager()
{
    if (m_db.isOpen())
        m_db.close();
}

QString DatabaseManager::hashPassword(const QString &password)
{
    QByteArray salt = "SomeRandomSaltForHospitalApp";
    QByteArray combined = password.toUtf8() + salt;
    QByteArray hash = QCryptographicHash::hash(combined, QCryptographicHash::Sha256);
    return hash.toHex();
}

bool DatabaseManager::init()
{
    m_db = QSqlDatabase::addDatabase("QSQLITE");
    m_db.setDatabaseName("hospital.db");
    if (!m_db.open()) {
        qDebug() << "Cannot open database:" << m_db.lastError().text();
        return false;
    }

    QSqlQuery query;
    query.exec("CREATE TABLE IF NOT EXISTS employees ("
               "id INTEGER PRIMARY KEY AUTOINCREMENT, "
               "login TEXT UNIQUE, password TEXT, full_name TEXT)");
    query.exec("CREATE TABLE IF NOT EXISTS patients ("
               "id INTEGER PRIMARY KEY AUTOINCREMENT, "
               "full_name TEXT, diagnosis TEXT, room_number TEXT, passport_data TEXT, "
               "created_by INTEGER)");
    query.exec("CREATE TABLE IF NOT EXISTS visits ("
               "id INTEGER PRIMARY KEY AUTOINCREMENT, "
               "patient_id INTEGER, visitor_full_name TEXT, visitor_passport TEXT, "
               "room_number TEXT, visit_time DATETIME DEFAULT CURRENT_TIMESTAMP, "
               "created_by INTEGER, "
               "FOREIGN KEY(patient_id) REFERENCES patients(id))");

    // НЕ добавляем тестового пользователя — только таблицы
    return true;
}

bool DatabaseManager::login(const QString &login, const QString &password)
{
    QSqlQuery query;
    query.prepare("SELECT id FROM employees WHERE login = ? AND password = ?");
    query.addBindValue(login);
    query.addBindValue(hashPassword(password));
    if (query.exec() && query.next()) {
        m_currentUserId = query.value(0).toInt();
        emit currentUserIdChanged();
        return true;
    }
    return false;
}

bool DatabaseManager::registerUser(const QString &login, const QString &password, const QString &fullName)
{
    QSqlQuery query;
    query.prepare("INSERT INTO employees (login, password, full_name) VALUES (?, ?, ?)");
    query.addBindValue(login);
    query.addBindValue(hashPassword(password));
    query.addBindValue(fullName);
    if (query.exec()) {
        return true;
    } else {
        qDebug() << "Ошибка регистрации:" << query.lastError().text();
        return false;
    }
}

bool DatabaseManager::addPatient(const QString &fullName, const QString &diagnosis,
                                 const QString &room, const QString &passport)
{
    if (m_currentUserId < 0) return false;
    QSqlQuery query;
    query.prepare("INSERT INTO patients (full_name, diagnosis, room_number, passport_data, created_by) "
                  "VALUES (?, ?, ?, ?, ?)");
    query.addBindValue(fullName);
    query.addBindValue(diagnosis);
    query.addBindValue(room);
    query.addBindValue(passport);
    query.addBindValue(m_currentUserId);
    return query.exec();
}

bool DatabaseManager::addVisit(int patientId, const QString &visitorName,
                               const QString &visitorPassport, const QString &room)
{
    if (m_currentUserId < 0) return false;
    QSqlQuery query;
    query.prepare("INSERT INTO visits (patient_id, visitor_full_name, visitor_passport, room_number, created_by) "
                  "VALUES (?, ?, ?, ?, ?)");
    query.addBindValue(patientId);
    query.addBindValue(visitorName);
    query.addBindValue(visitorPassport);
    query.addBindValue(room);
    query.addBindValue(m_currentUserId);
    return query.exec();
}

int DatabaseManager::currentUserId() const { return m_currentUserId; }
void DatabaseManager::setCurrentUserId(int id) { m_currentUserId = id; }