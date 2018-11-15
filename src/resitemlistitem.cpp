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
    QStringList files;
    for (auto d : data.value("files").toList())
        files << d.toMap().value("way_name").toString();
    setData(FilesListRole, files);
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
    setRoleName(FilesListRole,     "filelist");
    setRoleName(FilesRole,         "files");
    setRoleName(CommentsCountRole, "comments_count");
}
