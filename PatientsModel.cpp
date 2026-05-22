#include "PatientsModel.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

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
    return roles;
}

void PatientsModel::refresh()
{
    beginResetModel();
    m_patients.clear();
    QSqlQuery query("SELECT id, full_name, diagnosis, room_number, passport_data FROM patients ORDER BY full_name");
    while (query.next()) {
        Patient p;
        p.id = query.value(0).toInt();
        p.fullName = query.value(1).toString();
        p.diagnosis = query.value(2).toString();
        p.room = query.value(3).toString();
        p.passport = query.value(4).toString();
        m_patients.append(p);
    }
    endResetModel();
}