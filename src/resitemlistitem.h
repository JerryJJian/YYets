#ifndef RESITEMLISTITEM_H
#define RESITEMLISTITEM_H

#include "listitem.h"

#include <QObject>
#include <qglobal.h>

class ResItemListItem : public ListItem
{
    Q_OBJECT
public:
    ResItemListItem(QObject *parent = nullptr);
    ResItemListItem(const QVariantHash &data, QObject *parent = nullptr);


    enum Roles
    {
        FormatRole = UserRole + 1,
        FormatTipRole,
        SizeRole,
        FilesRole,
        CommentsCountRole
    };

    QString id() const;

private:
    void initRoles();
};

#endif // RESITEMLISTITEM_H
