#ifndef MOVIELISTITEM_H
#define MOVIELISTITEM_H

#include "listmodel.h"

#include <QObject>

class MovieListItem : public ListItem
{
    Q_OBJECT
    Q_ENUMS(Status)
public:
    explicit MovieListItem(QObject *parent = 0);
    explicit MovieListItem(const QVariantMap &data, QObject *parent = 0);

    enum Roles
    {
        IdRole = Qt::UserRole + 1,
        NameRole,
        ChannelRole,
        AreaRole,
        CategoryRole,
        PublishYearRole,
        PlayStatusRole,
        PosterRole,
        PosterBigRole,
        PosterMiddleRole,
        PosterSmallRole,
    };

    QString id() const;

private:
    void initRoles();
};

#endif // MOVIELISTITEM_H
