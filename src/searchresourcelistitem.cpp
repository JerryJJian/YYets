#include "searchresourcelistitem.h"
#include <QMetaEnum>

SearchResourceListItem::SearchResourceListItem(QObject *parent)
    : ListItem(parent)
{
    initRoles();
}

SearchResourceListItem::SearchResourceListItem(const QVariantHash &data, QObject *parent)
    : ListItem(data, parent)
{
    initRoles();
}

QString SearchResourceListItem::id() const
{
    return data(IdRole).toString();
}

void SearchResourceListItem::initRoles()
{
    setRoleName(IdRole,        "id"       );
    setRoleName(PosterBRole,   "poster_b" );
    setRoleName(PosterSRole,   "poster_s" );
    setRoleName(PosterMRole,   "poster_m" );
    setRoleName(PrefixRole,    "prefix"   );
    setRoleName(ItemidRole,    "itemid"   );
    setRoleName(TypeRole,      "type"     );
    setRoleName(CharacterRole, "character");
    setRoleName(UptimeRole,    "uptime"   );
    setRoleName(ChannelRole,   "channel"  );
    setRoleName(PubtimeRole,   "pubtime"  );
    setRoleName(VersionRole,   "version"  );
    setRoleName(TitleRole,     "title"    );
    setRoleName(SuffixRole,    "suffix"   );
}
