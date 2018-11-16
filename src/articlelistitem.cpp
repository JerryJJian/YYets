#include "articlelistitem.h"

ArticleListItem::ArticleListItem(QObject *parent)
    : ListItem (parent)
{
    initRoles();
}

ArticleListItem::ArticleListItem(const QVariantHash &data, QObject *parent)
    : ListItem (data, parent)
{
    initRoles();
}

QString ArticleListItem::id() const
{
    return data(IdRole).toString();
}

void ArticleListItem::initRoles()
{
    setRoleName(IdRole,         "id"         );
    setRoleName(TitleRole,      "title"      );
    setRoleName(IntroRole,      "intro"      );
    setRoleName(DateLineRole,   "dateline"   );
    setRoleName(TypeRole,       "type"       );
    setRoleName(TypeCNRole,     "type_cn"    );
    setRoleName(AuthorRole,     "author"     );
    setRoleName(AuthorNameRole, "author_name");
    setRoleName(ResourceIdRole, "resourceid" );
    setRoleName(ViewsRole,      "views"      );
    setRoleName(PosterRole,     "poster"     );
    setRoleName(PosterBRole,    "poster_b"   );
    setRoleName(PosterMRole,    "poster_m"   );
    setRoleName(PosterSRole,    "poster_s"   );
}
