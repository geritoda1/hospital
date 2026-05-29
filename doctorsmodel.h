#ifndef DOCTORSMODEL_H
#define DOCTORSMODEL_H

#include <QAbstractListModel>

class DoctorsModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum Roles {
        IdRole = Qt::UserRole + 1,
        FullNameRole,
        PhoneRole,
        PositionRole,
        PassportRole
    };

    explicit DoctorsModel(QObject *parent = nullptr);
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void refresh();

private:
    struct Doctor {
        int id;
        QString fullName;
        QString phone;
        QString position;
        QString passport;
    };
    QVector<Doctor> m_doctors;
};

#endif // DOCTORSMODEL_H