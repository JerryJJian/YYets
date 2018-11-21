#ifndef COMMENTLISTITEM_H
#define COMMENTLISTITEM_H

#include "listitem.h"

#include <QObject>
#include <qglobal.h>

class CommentListItem : public ListItem
{
    Q_OBJECT
public:
    CommentListItem(QObject *parent = nullptr);
    CommentListItem(const QVariantHash &data, QObject *parent = nullptr);

    enum Roles
    {
        IdRole = Qt::UserRole + 1,
        AuthorRole          ,
        ChannelRole         ,
        ItemidRole          ,
        SubjectRole         ,
        ContentRole         ,
        GoodRole            ,
        BadRole             ,
        ReplyidRole         ,
        ReplyNumRole        ,
        SourceRole          ,
        UpdatetimeRole      ,
        DatelineRole        ,
        DetailRole          ,
        NicknameRole        ,
        GroupNameRole       ,
        AvatarRole          ,
        AvatarSRole         ,
        CommonGroupNameRole ,
        ReplyRole           ,
        Reply_IdRole        ,
        Reply_AuthorRole    ,
        Reply_ChannelRole   ,
        Reply_ItemidRole    ,
        Reply_SubjectRole   ,
        Reply_ContentRole   ,
        Reply_GoodRole      ,
        Reply_BadRole       ,
        Reply_ReplyidRole   ,
        Reply_ReplyNumRole  ,
        Reply_SourceRole    ,
        Reply_UpdatetimeRole,
        Reply_DatelineRole  ,
        Reply_DetailRole    ,
        Reply_NicknameRole  ,
        Reply_GroupNameRole ,
        Reply_AvatarRole    ,
        Reply_AvatarSRole   ,
        Reply_CommonGroupNameRole
    };

    QString id() const;

private:
    void initRoles();
};

#endif // COMMENTLISTITEM_H
