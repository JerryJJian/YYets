#ifndef LISTITEM_H
#define LISTITEM_H

#include <QObject>
#include <QMap>
#include <QVariantHash>
#include <QString>

class ListItem: public QObject
{
    Q_OBJECT

public:
    enum Roles
    {
        NoneRole = -1,
        IDRole,
        SelectedRole,
        UserRole
    };

    ListItem(QObject* parent = 0);
    ListItem(const QVariantHash &data, QObject* parent = 0);
    virtual ~ListItem();

    virtual QString id() const;
    virtual bool selected() const;
    virtual void setSelected(bool selected);

    virtual QVariant data(int role) const;
    virtual bool setData(int role, const QVariant &value);

    virtual QString roleName(int role) const;
    virtual void setRoleName(int role, const QString &name);
    virtual QHash<int, QByteArray> roleNames() const;

signals:
    void dataChanged();

private:
    void init();
    QHash<int, QByteArray> m_roleNameMap;
    QVariantHash m_dataMap;
};

#endif // LISTITEM_H
