#include "DatabaseManager.h"
#include <QSqlError>
#include <QDebug>

DatabaseManager::DatabaseManager(QObject *parent) : QObject(parent), m_currentUserId(-1)
{
}

DatabaseManager::~DatabaseManager()
{
    if (m_db.isOpen())
        m_db.close();
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
    // Таблица сотрудников
    query.exec("CREATE TABLE IF NOT EXISTS employees ("
               "id INTEGER PRIMARY KEY AUTOINCREMENT, "
               "login TEXT UNIQUE, password TEXT, full_name TEXT)");
    // Таблица пациентов
    query.exec("CREATE TABLE IF NOT EXISTS patients ("
               "id INTEGER PRIMARY KEY AUTOINCREMENT, "
               "full_name TEXT, diagnosis TEXT, room_number TEXT, passport_data TEXT, "
               "created_by INTEGER)");
    // Таблица посещений
    query.exec("CREATE TABLE IF NOT EXISTS visits ("
               "id INTEGER PRIMARY KEY AUTOINCREMENT, "
               "patient_id INTEGER, visitor_full_name TEXT, visitor_passport TEXT, "
               "room_number TEXT, visit_time DATETIME DEFAULT CURRENT_TIMESTAMP, "
               "created_by INTEGER, "
               "FOREIGN KEY(patient_id) REFERENCES patients(id))");

    // Добавим тестового сотрудника, если никого нет
    QSqlQuery check("SELECT COUNT(*) FROM employees");
    if (check.next() && check.value(0).toInt() == 0) {
        query.prepare("INSERT INTO employees (login, password, full_name) VALUES (?, ?, ?)");
        query.addBindValue("admin");
        query.addBindValue("admin");
        query.addBindValue("Администратор");
        query.exec();
    }

    return true;
}

bool DatabaseManager::login(const QString &login, const QString &password)
{
    QSqlQuery query;
    query.prepare("SELECT id FROM employees WHERE login = ? AND password = ?");
    query.addBindValue(login);
    query.addBindValue(password);
    if (query.exec() && query.next()) {
        m_currentUserId = query.value(0).toInt();
        emit currentUserIdChanged();
        return true;
    }
    return false;
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
    // При желании можно проверить, что пациент существует
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