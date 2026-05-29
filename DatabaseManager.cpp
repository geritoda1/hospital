#include "DatabaseManager.h"
#include <QSqlError>
#include <QDebug>
#include <QCryptographicHash>
#include <QDateTime>   // <-- добавить эту строку


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
    // Таблица сотрудников
    query.exec("CREATE TABLE IF NOT EXISTS employees ("
               "id INTEGER PRIMARY KEY AUTOINCREMENT, "
               "login TEXT UNIQUE, password TEXT, full_name TEXT)");

    // Таблица пациентов (без treatment/attending_doctor)
    query.exec("CREATE TABLE IF NOT EXISTS patients ("
               "id INTEGER PRIMARY KEY AUTOINCREMENT, "
               "full_name TEXT, diagnosis TEXT, room_number TEXT, passport_data TEXT, "
               "doctor_id INTEGER, discharged INTEGER DEFAULT 0, created_by INTEGER, "
               "FOREIGN KEY(doctor_id) REFERENCES doctors(id))");

    // Таблица врачей
    query.exec("CREATE TABLE IF NOT EXISTS doctors ("
               "id INTEGER PRIMARY KEY AUTOINCREMENT, "
               "full_name TEXT NOT NULL, phone TEXT, position TEXT, passport_data TEXT)");

    // Таблица лечений
    query.exec("CREATE TABLE IF NOT EXISTS treatments ("
               "id INTEGER PRIMARY KEY AUTOINCREMENT, "
               "patient_id INTEGER NOT NULL, description TEXT NOT NULL, "
               "created_at DATETIME DEFAULT CURRENT_TIMESTAMP, "
               "FOREIGN KEY(patient_id) REFERENCES patients(id))");

    // Таблица посещений
    query.exec("CREATE TABLE IF NOT EXISTS visits ("
               "id INTEGER PRIMARY KEY AUTOINCREMENT, "
               "patient_id INTEGER, visitor_full_name TEXT, visitor_passport TEXT, "
               "room_number TEXT, visit_time DATETIME DEFAULT CURRENT_TIMESTAMP, "
               "created_by INTEGER, "
               "FOREIGN KEY(patient_id) REFERENCES patients(id))");

    // Добавляем столбец discharged, если его нет (миграция)
    QSqlQuery alterDischarged;
    alterDischarged.exec("ALTER TABLE patients ADD COLUMN discharged INTEGER DEFAULT 0");
    if (alterDischarged.lastError().isValid())
        qDebug() << "Note: discharged column already exists";

    // Добавляем doctor_id, если его нет
    QSqlQuery alterDoctorId;
    alterDoctorId.exec("ALTER TABLE patients ADD COLUMN doctor_id INTEGER");
    if (alterDoctorId.lastError().isValid())
        qDebug() << "Note: doctor_id column already exists";

    return true;
}

// -------------------- Авторизация --------------------
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
    return query.exec();
}

// -------------------- Пациенты --------------------
bool DatabaseManager::addPatient(const QString &fullName, const QString &diagnosis,
                                 const QString &room, const QString &passport, int doctorId)
{
    if (m_currentUserId < 0) return false;
    QSqlQuery query;
    query.prepare("INSERT INTO patients (full_name, diagnosis, room_number, passport_data, doctor_id, created_by) "
                  "VALUES (?, ?, ?, ?, ?, ?)");
    query.addBindValue(fullName);
    query.addBindValue(diagnosis);
    query.addBindValue(room);
    query.addBindValue(passport);
    query.addBindValue(doctorId > 0 ? doctorId : QVariant());
    query.addBindValue(m_currentUserId);
    return query.exec();
}

bool DatabaseManager::dischargePatient(int patientId)
{
    if (m_currentUserId < 0) return false;
    QSqlQuery query;
    query.prepare("UPDATE patients SET discharged = 1 WHERE id = ?");
    query.addBindValue(patientId);
    return query.exec();
}

// -------------------- Врачи --------------------
bool DatabaseManager::addDoctor(const QString &fullName, const QString &phone,
                                const QString &position, const QString &passport)
{
    QSqlQuery query;
    query.prepare("INSERT INTO doctors (full_name, phone, position, passport_data) VALUES (?, ?, ?, ?)");
    query.addBindValue(fullName);
    query.addBindValue(phone);
    query.addBindValue(position);
    query.addBindValue(passport);
    return query.exec();
}

bool DatabaseManager::updateDoctor(int doctorId, const QString &fullName, const QString &phone,
                                   const QString &position, const QString &passport)
{
    QSqlQuery query;
    query.prepare("UPDATE doctors SET full_name=?, phone=?, position=?, passport_data=? WHERE id=?");
    query.addBindValue(fullName);
    query.addBindValue(phone);
    query.addBindValue(position);
    query.addBindValue(passport);
    query.addBindValue(doctorId);
    return query.exec();
}

bool DatabaseManager::deleteDoctor(int doctorId)
{
    // Проверяем, есть ли пациенты, привязанные к этому врачу
    QSqlQuery check;
    check.prepare("SELECT COUNT(*) FROM patients WHERE doctor_id = ? AND discharged = 0");
    check.addBindValue(doctorId);
    if (check.exec() && check.next() && check.value(0).toInt() > 0) {
        qDebug() << "Cannot delete doctor: has active patients";
        return false;
    }
    QSqlQuery query;
    query.prepare("DELETE FROM doctors WHERE id = ?");
    query.addBindValue(doctorId);
    return query.exec();
}

QVariantList DatabaseManager::getDoctors()
{
    QVariantList list;
    QSqlQuery query("SELECT id, full_name, phone, position, passport_data FROM doctors ORDER BY full_name");
    while (query.next()) {
        QVariantMap map;
        map["id"] = query.value(0).toInt();
        map["fullName"] = query.value(1).toString();
        map["phone"] = query.value(2).toString();
        map["position"] = query.value(3).toString();
        map["passportData"] = query.value(4).toString();
        list.append(map);
    }
    return list;
}

// -------------------- Лечение --------------------
bool DatabaseManager::addTreatment(int patientId, const QString &description)
{
    QSqlQuery query;
    query.prepare("INSERT INTO treatments (patient_id, description) VALUES (?, ?)");
    query.addBindValue(patientId);
    query.addBindValue(description);
    return query.exec();
}

QVariantList DatabaseManager::getTreatmentsForPatient(int patientId)
{
    QVariantList list;
    QSqlQuery query;
    query.prepare("SELECT id, description, created_at FROM treatments WHERE patient_id = ? ORDER BY created_at DESC");
    query.addBindValue(patientId);
    if (query.exec()) {
        while (query.next()) {
            QVariantMap map;
            map["id"] = query.value(0).toInt();
            map["description"] = query.value(1).toString();
            map["createdAt"] = query.value(2).toDateTime().toString("dd.MM.yyyy hh:mm");
            list.append(map);
        }
    }
    return list;
}

// -------------------- Посещения --------------------
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