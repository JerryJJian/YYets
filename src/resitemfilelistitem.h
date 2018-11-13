#ifndef RESITEMFILELISTITEM_H
#define RESITEMFILELISTITEM_H

#include "listitem.h"

#include <QObject>
#include <qglobal.h>

class ResItemFileListItem : public ListItem
{
    Q_OBJECT
public:
    ResItemFileListItem(QObject *parent = nullptr);
    ResItemFileListItem(const QVariantHash &data, QObject *parent = nullptr);

    enum Roles
    {
        ItemIdRole = Qt::UserRole + 1,
        WayRole,
        AddressRole,
        PasswdRole,
        DataLineRole,
        WayNameRole
    };

    QString id() const;

private:
    void initRoles();
};

#endif // RESITEMFILELISTITEM_H
