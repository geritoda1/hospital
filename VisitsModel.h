#ifndef VISITSMODEL_H
#define VISITSMODEL_H

#include <QAbstractListModel>
#include <QVector>
#include <QVariantMap>

class VisitsModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum Roles {
        IdRole = Qt::UserRole + 1,
        PatientNameRole,
        VisitorNameRole,
        VisitorPassportRole,
        RoomRole,
        TimeRole,
        EmployeeNameRole
    };

    explicit VisitsModel(QObject *parent = nullptr);
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void refresh();

private:
    struct Visit {
        int id;
        QString patientName;
        QString visitorName;
        QString visitorPassport;
        QString room;
        QString time;
        QString employeeName;
    };
    QVector<Visit> m_visits;
};

#endif // VISITSMODEL_H