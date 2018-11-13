#include "resitemlistitem.h"

ResItemListItem::ResItemListItem(QObject *parent)
    : ListItem (parent)
{
    initRoles();
}

ResItemListItem::ResItemListItem(const QVariantHash &data, QObject *parent)
    : ListItem (data, parent)
{
    initRoles();
}

QString ResItemListItem::id() const
{
    return data(FormatRole).toString() + ":" + data(FormatTipRole).toString();
}

void ResItemListItem::initRoles()
{
    setRoleName(FormatRole,        "foramt");
    setRoleName(FormatTipRole,     "format_tip");
    setRoleName(SizeRole,          "size");
    setRoleName(FilesRole,         "files");
    setRoleName(CommentsCountRole, "comments_count");
}
