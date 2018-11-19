#include "resourcelistitem.h"

ResourceListItem::ResourceListItem(QObject *parent)
    : ListItem(parent)
{
    initRoles();
}

ResourceListItem::ResourceListItem(const QVariantHash &data, QObject *parent)
    : ListItem(data, parent)
{
    initRoles();
}

QString ResourceListItem::id() const
{
    return data(IdRole).toString();
}

void ResourceListItem::initRoles()
{
    setRoleName(IdRole,              "id"               );
    setRoleName(FavoritesRole,       "favorites"        );
    setRoleName(ItemcacheRole,       "itemcache"        );
    setRoleName(FormatRole,          "format"           );
    setRoleName(ZimuzuRole,          "zimuzu"           );
    setRoleName(ChannelCnRole,       "channel_cn"       );
    setRoleName(ImdbRole,            "imdb"             );
    setRoleName(CnnameRole,          "cnname"           );
    setRoleName(RankValueRole,       "rank_value"       );
    setRoleName(ShowTypeRole,        "show_type"        );
    setRoleName(AliasnameRole,       "aliasname"        );
    setRoleName(CategoryRole,        "category"         );
    setRoleName(ViewsRole,           "views"            );
    setRoleName(LangRole,            "lang"             );
    setRoleName(RemarkRole,          "remark"           );
    setRoleName(UpdaterRole,         "updater"          );
    setRoleName(PermissionRole,      "permission"       );
    setRoleName(PublishYearRole,     "publish_year"     );
    setRoleName(PosterBRole,         "poster_b"         );
    setRoleName(PosterRole,          "poster"           );
    setRoleName(TvstationRole,       "tvstation"        );
    setRoleName(PremiereRole,        "premiere"         );
    setRoleName(SpeakerRole,         "speaker"          );
    setRoleName(ChannelRole,         "channel"          );
    setRoleName(AreaRole,            "area"             );
    setRoleName(PageKeywordsRole,    "page_keywords"    );
    setRoleName(MakeCycleRole,       "make_cycle"       );
    setRoleName(EnnameRole,          "enname"           );
    setRoleName(DatelineRole,        "dateline"         );
    setRoleName(CloseTimeRole,       "close_time"       );
    setRoleName(ItemupdateRole,      "itemupdate"       );
    setRoleName(RenewStatusRole,     "renew_status"     );
    setRoleName(RankRole,            "rank"             );
    setRoleName(MiguMusicRole,       "migu_music"       );
    setRoleName(SchoolRole,          "school"           );
    setRoleName(RenewStatusTimeRole, "renew_status_time");
    setRoleName(CloseResourceRole,   "close_resource"   );
    setRoleName(CompanyRole,         "company"          );
    setRoleName(MiguH5Role,          "migu_h5"          );
    setRoleName(OperatorRole,        "operator"         );
    setRoleName(ImdbScoreRole,       "imdb_score"       );
    setRoleName(ScoreCountsRole,     "score_counts"     );
    setRoleName(ScoreRole,           "score"            );
    setRoleName(PageTitleRole,       "page_title"       );
    setRoleName(PremiereTimeRole,    "premiere_time"    );
    setRoleName(PageDescriptionRole, "page_description" );
    setRoleName(LevelRole,           "level"            );
    setRoleName(UpdatecacheRole,     "updatecache"      );
    setRoleName(PlayStatusRole,      "play_status"      );
    setRoleName(WebsiteRole,         "website"          );
    setRoleName(PosterSRole,         "poster_s"         );
    setRoleName(PosterNRole,         "poster_n"         );
    setRoleName(PlayTimeRole,        "play_time"        );
    setRoleName(UpdatetimeRole,      "updatetime"       );
    setRoleName(PosterMRole,         "poster_m"         );
}
