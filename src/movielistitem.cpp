#include "movielistitem.h"

#include <QMetaEnum>

MovieListItem::MovieListItem(QObject *parent)
    : ListItem(parent)
{
    initRoles();
}

MovieListItem::MovieListItem(const QVariantHash &data, QObject *parent)
    : ListItem(data, parent)
{
    initRoles();
}

QString MovieListItem::id() const
{
    return data(IdRole).toString();
}

void MovieListItem::initRoles()
{
    setRoleName(IdRole,              "id"          );
    setRoleName(NameRole,            "cnname"      );
    setRoleName(ChannelRole,         "channel"     );
    setRoleName(AreaRole,            "area"        );
    setRoleName(CategoryRole,        "category"    );
    setRoleName(PublishYearRole,     "publish_year");
    setRoleName(PlayStatusRole,      "play_status" );
    setRoleName(PosterRole,          "poster"      );
    setRoleName(PosterBigRole,       "poster_b"    );
    setRoleName(PosterMiddleRole,    "poster_m"    );
    setRoleName(PosterSmallRole,     "poster_s"    );
}
