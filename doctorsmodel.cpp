#include "DoctorsModel.h"
#include <QSqlQuery>

DoctorsModel::DoctorsModel(QObject *parent) : QAbstractListModel(parent)
{
    refresh();
}

int DoctorsModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_doctors.size();
}

QVariant DoctorsModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_doctors.size())
        return QVariant();
    const Doctor &d = m_doctors.at(index.row());
    switch (role) {
    case IdRole: return d.id;
    case FullNameRole: return d.fullName;
    case PhoneRole: return d.phone;
    case PositionRole: return d.position;
    case PassportRole: return d.passport;
    default: return QVariant();
    }
}

QHash<int, QByteArray> DoctorsModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole] = "doctorId";
    roles[FullNameRole] = "fullName";
    roles[PhoneRole] = "phone";
    roles[PositionRole] = "position";
    roles[PassportRole] = "passportData";
    return roles;
}

void DoctorsModel::refresh()
{
    beginResetModel();
    m_doctors.clear();
    QSqlQuery query("SELECT id, full_name, phone, position, passport_data FROM doctors ORDER BY full_name");
    while (query.next()) {
        Doctor d;
        d.id = query.value(0).toInt();
        d.fullName = query.value(1).toString();
        d.phone = query.value(2).toString();
        d.position = query.value(3).toString();
        d.passport = query.value(4).toString();
        m_doctors.append(d);
    }
    endResetModel();
}