#include "PatientsModel.h"
#include <QSqlQuery>

PatientsModel::PatientsModel(QObject *parent) : QAbstractListModel(parent)
{
    refresh();
}

int PatientsModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_patients.size();
}

QVariant PatientsModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_patients.size())
        return QVariant();
    const Patient &p = m_patients.at(index.row());
    switch (role) {
    case IdRole: return p.id;
    case FullNameRole: return p.fullName;
    case DiagnosisRole: return p.diagnosis;
    case RoomRole: return p.room;
    case PassportRole: return p.passport;
    case DoctorNameRole: return p.doctorName;
    default: return QVariant();
    }
}

QHash<int, QByteArray> PatientsModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole] = "patientId";
    roles[FullNameRole] = "fullName";
    roles[DiagnosisRole] = "diagnosis";
    roles[RoomRole] = "roomNumber";
    roles[PassportRole] = "passportData";
    roles[DoctorNameRole] = "doctorName";
    return roles;
}

void PatientsModel::refresh()
{
    beginResetModel();
    m_patients.clear();
    QSqlQuery query(
        "SELECT p.id, p.full_name, p.diagnosis, p.room_number, p.passport_data, "
        "COALESCE(d.full_name, 'Не назначен') as doctor_name "
        "FROM patients p LEFT JOIN doctors d ON p.doctor_id = d.id "
        "WHERE p.discharged = 0 ORDER BY p.full_name"
        );
    while (query.next()) {
        Patient p;
        p.id = query.value(0).toInt();
        p.fullName = query.value(1).toString();
        p.diagnosis = query.value(2).toString();
        p.room = query.value(3).toString();
        p.passport = query.value(4).toString();
        p.doctorName = query.value(5).toString();
        m_patients.append(p);
    }
    endResetModel();
}