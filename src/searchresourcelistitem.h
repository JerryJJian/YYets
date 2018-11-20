#ifndef SEARCHRESOURCELISTITEM_H
#define SEARCHRESOURCELISTITEM_H

#include "listitem.h"

#include <QObject>

class SearchResourceListItem : public ListItem
{
    Q_OBJECT
public:
    explicit SearchResourceListItem(QObject *parent = 0);
    explicit SearchResourceListItem(const QVariantHash &data, QObject *parent = 0);

    enum Roles
    {
        IdRole = UserRole + 1,
        PosterBRole,
        PosterSRole,
        PosterMRole,
        PrefixRole,
        ItemidRole,
        TypeRole,
        CharacterRole,
        UptimeRole,
        ChannelRole,
        PubtimeRole,
        VersionRole,
        TitleRole,
        SuffixRole
    };

    QString id() const;

private:
    void initRoles();
};

#endif // SEARCHRESOURCELISTITEM_H
