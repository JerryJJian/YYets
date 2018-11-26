#ifndef RESOURCELISTITEM_H
#define RESOURCELISTITEM_H

#include "listitem.h"
#include <QObject>

class ResourceListItem : public ListItem
{
    Q_OBJECT
public:
    explicit ResourceListItem(QObject *parent = nullptr);
    explicit ResourceListItem(const QVariantHash &data, QObject *parent = nullptr);

    enum Roles
    {
        IdRole = Qt::UserRole + 1,
        FavoritesRole,
        ItemcacheRole,
        FormatRole,
        ZimuzuRole,
        ChannelCnRole,
        ImdbRole,
        CnnameRole,
        RankValueRole,
        ShowTypeRole,
        AliasnameRole,
        CategoryRole,
        ViewsRole,
        LangRole,
        RemarkRole,
        UpdaterRole,
        PermissionRole,
        PublishYearRole,
        PosterBRole,
        PosterRole,
        TvstationRole,
        PremiereRole,
        SpeakerRole,
        ChannelRole,
        AreaRole,
        PageKeywordsRole,
        MakeCycleRole,
        EnnameRole,
        DatelineRole,
        CloseTimeRole,
        ItemupdateRole,
        RenewStatusRole,
        RankRole,
        MiguMusicRole,
        SchoolRole,
        RenewStatusTimeRole,
        CloseResourceRole,
        CompanyRole,
        MiguH5Role,
        OperatorRole,
        ImdbScoreRole,
        ScoreCountsRole,
        ScoreRole,
        PageTitleRole,
        PremiereTimeRole,
        PageDescriptionRole,
        LevelRole,
        UpdatecacheRole,
        PlayStatusRole,
        WebsiteRole,
        PosterSRole,
        PosterNRole,
        PlayTimeRole,
        UpdatetimeRole,
        PosterMRole,
        FollowedRole
    };

    QString id() const;

private:
    void initRoles();
};

#endif // RESOURCELISTITEM_H
