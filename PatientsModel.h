#ifndef PATIENTSMODEL_H
#define PATIENTSMODEL_H

#include <QAbstractListModel>
#include <QVector>
#include <QVariantMap>

class PatientsModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum Roles {
        IdRole = Qt::UserRole + 1,
        FullNameRole,
        DiagnosisRole,
        RoomRole,
        PassportRole
    };

    explicit PatientsModel(QObject *parent = nullptr);
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void refresh();

private:
    struct Patient {
        int id;
        QString fullName;
        QString diagnosis;
        QString room;
        QString passport;
    };
    QVector<Patient> m_patients;
};

#endif // PATIENTSMODEL_H