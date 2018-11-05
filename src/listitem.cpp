#include "listitem.h"

ListItem::ListItem(QObject *parent)
    : QObject(parent)
{
    init();
}

ListItem::ListItem(const QVariantHash &data, QObject *parent)
    : QObject(parent),
      m_dataMap(data)
{
    init();
}

ListItem::~ListItem()
{

}

QString ListItem::id() const
{
    return data(IDRole).toString();
}

bool ListItem::selected() const
{
    return data(SelectedRole).toBool();
}

void ListItem::setSelected(bool selected)
{
    setData(SelectedRole, selected);
}

QVariant ListItem::data(int role) const
{
    return m_dataMap.value(roleName(role), QVariant());
}

bool ListItem::setData(int role, const QVariant &value)
{
    if (!m_roleNameMap.contains(role))
        return false;

    if (data(role) == value)
        return false;

    m_dataMap.insert(roleName(role), value);
    return true;
}

QString ListItem::roleName(int role) const
{
    return QString::fromUtf8(m_roleNameMap.value(role));
}

void ListItem::setRoleName(int role, const QString &name)
{
    m_roleNameMap.insert(role, name.toUtf8());
}

QHash<int, QByteArray> ListItem::roleNames() const
{
    return m_roleNameMap;
}

void ListItem::init()
{
    m_roleNameMap.insert(IDRole,        "listitem.id");
    m_roleNameMap.insert(SelectedRole,  "listitem.selected");
}

