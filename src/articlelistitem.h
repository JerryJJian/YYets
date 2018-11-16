#ifndef RESITEMFILELISTITEM_H
#define RESITEMFILELISTITEM_H

#include "listitem.h"

#include <QObject>
#include <qglobal.h>

class ArticleListItem : public ListItem
{
    Q_OBJECT
public:
    ArticleListItem(QObject *parent = nullptr);
    ArticleListItem(const QVariantHash &data, QObject *parent = nullptr);

    enum Roles
    {
        IdRole = Qt::UserRole + 1,
        TitleRole,
        IntroRole,
        DateLineRole,
        TypeRole,
        TypeCNRole,
        AuthorRole,
        AuthorNameRole,
        ResourceIdRole,
        ViewsRole,
        PosterRole,
        PosterBRole,
        PosterMRole,
        PosterSRole
    };

    QString id() const;

private:
    void initRoles();
};

#endif // RESITEMFILELISTITEM_H
