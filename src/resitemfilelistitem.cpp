#include "resitemfilelistitem.h"

ResItemFileListItem::ResItemFileListItem(QObject *parent)
    : ListItem (parent)
{

}

ResItemFileListItem::ResItemFileListItem(const QVariantHash &data, QObject *parent)
    : ListItem (data, parent)
{

}

QString ResItemFileListItem::id() const
{
    return data(ItemIdRole).toString();
}

void ResItemFileListItem::initRoles()
{
    setRoleName(ItemIdRole,   "itemid");
    setRoleName(WayRole,      "way");
    setRoleName(AddressRole,  "address");
    setRoleName(PasswdRole,   "passwd");
    setRoleName(DataLineRole, "dateline");
    setRoleName(WayNameRole,  "way_name");
}
