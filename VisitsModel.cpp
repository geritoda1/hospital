#include "VisitsModel.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QDateTime>

VisitsModel::VisitsModel(QObject *parent) : QAbstractListModel(parent)
{
    refresh();
}

int VisitsModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_visits.size();
}

QVariant VisitsModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_visits.size())
        return QVariant();
    const Visit &v = m_visits.at(index.row());
    switch (role) {
    case IdRole: return v.id;
    case PatientNameRole: return v.patientName;
    case VisitorNameRole: return v.visitorName;
    case VisitorPassportRole: return v.visitorPassport;
    case RoomRole: return v.room;
    case TimeRole: return v.time;
    case EmployeeNameRole: return v.employeeName;
    default: return QVariant();
    }
}

QHash<int, QByteArray> VisitsModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole] = "visitId";
    roles[PatientNameRole] = "patientName";
    roles[VisitorNameRole] = "visitorName";
    roles[VisitorPassportRole] = "visitorPassport";
    roles[RoomRole] = "roomNumber";
    roles[TimeRole] = "visitTime";
    roles[EmployeeNameRole] = "employeeName";
    return roles;
}

void VisitsModel::refresh()
{
    beginResetModel();
    m_visits.clear();
    QSqlQuery query(
        "SELECT v.id, p.full_name, v.visitor_full_name, v.visitor_passport, "
        "v.room_number, v.visit_time, e.full_name "
        "FROM visits v "
        "JOIN patients p ON v.patient_id = p.id "
        "LEFT JOIN employees e ON v.created_by = e.id "
        "ORDER BY v.visit_time DESC"
        );
    while (query.next()) {
        Visit v;
        v.id = query.value(0).toInt();
        v.patientName = query.value(1).toString();
        v.visitorName = query.value(2).toString();
        v.visitorPassport = query.value(3).toString();
        v.room = query.value(4).toString();
        v.time = query.value(5).toDateTime().toString("dd.MM.yyyy hh:mm");
        v.employeeName = query.value(6).toString();
        m_visits.append(v);
    }
    endResetModel();
}