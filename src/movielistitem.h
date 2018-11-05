#ifndef MOVIELISTITEM_H
#define MOVIELISTITEM_H

#include "listitem.h"

#include <QObject>

class MovieListItem : public ListItem
{
    Q_OBJECT
    Q_ENUMS(Status)
public:
    explicit MovieListItem(QObject *parent = 0);
    explicit MovieListItem(const QVariantHash &data, QObject *parent = 0);

    enum Roles
    {
        IdRole = UserRole + 1,
        NameRole,
        ChannelRole,
        AreaRole,
        CategoryRole,
        PublishYearRole,
        PlayStatusRole,
        PosterRole,
        PosterBigRole,
        PosterMiddleRole,
        PosterSmallRole
    };

    QString id() const;

private:
    void initRoles();
};

#endif // MOVIELISTITEM_H
