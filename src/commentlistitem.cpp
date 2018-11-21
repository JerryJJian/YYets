#include "commentlistitem.h"

CommentListItem::CommentListItem(QObject *parent)
    : ListItem (parent)
{
    initRoles();
}

CommentListItem::CommentListItem(const QVariantHash &data, QObject *parent)
    : ListItem (data, parent)
{
    initRoles();
}

QString CommentListItem::id() const
{
    return data(IdRole).toString();
}

void CommentListItem::initRoles()
{
    setRoleName(IdRole             , "id"               );
    setRoleName(AuthorRole         , "author"           );
    setRoleName(ChannelRole        , "channel"          );
    setRoleName(ItemidRole         , "itemid"           );
    setRoleName(SubjectRole        , "subject"          );
    setRoleName(ContentRole        , "content"          );
    setRoleName(GoodRole           , "good"             );
    setRoleName(BadRole            , "bad"              );
    setRoleName(ReplyidRole        , "replyid"          );
    setRoleName(ReplyNumRole       , "reply_num"        );
    setRoleName(SourceRole         , "source"           );
    setRoleName(UpdatetimeRole     , "updatetime"       );
    setRoleName(DatelineRole       , "dateline"         );
    setRoleName(DetailRole         , "detail"           );
    setRoleName(NicknameRole       , "nickname"         );
    setRoleName(GroupNameRole      , "group_name"       );
    setRoleName(AvatarRole         , "avatar"           );
    setRoleName(AvatarSRole        , "avatar_s"         );
    setRoleName(CommonGroupNameRole, "common_group_name");
    setRoleName(ReplyRole          , "reply"            );
    setRoleName(Reply_IdRole             , "reply_id"               );
    setRoleName(Reply_AuthorRole         , "reply_author"           );
    setRoleName(Reply_ChannelRole        , "reply_channel"          );
    setRoleName(Reply_ItemidRole         , "reply_itemid"           );
    setRoleName(Reply_SubjectRole        , "reply_subject"          );
    setRoleName(Reply_ContentRole        , "reply_content"          );
    setRoleName(Reply_GoodRole           , "reply_good"             );
    setRoleName(Reply_BadRole            , "reply_bad"              );
    setRoleName(Reply_ReplyidRole        , "reply_replyid"          );
    setRoleName(Reply_ReplyNumRole       , "reply_reply_num"        );
    setRoleName(Reply_SourceRole         , "reply_source"           );
    setRoleName(Reply_UpdatetimeRole     , "reply_updatetime"       );
    setRoleName(Reply_DatelineRole       , "reply_dateline"         );
    setRoleName(Reply_DetailRole         , "reply_detail"           );
    setRoleName(Reply_NicknameRole       , "reply_nickname"         );
    setRoleName(Reply_GroupNameRole      , "reply_group_name"       );
    setRoleName(Reply_AvatarRole         , "reply_avatar"           );
    setRoleName(Reply_AvatarSRole        , "reply_avatar_s"         );
    setRoleName(Reply_CommonGroupNameRole, "reply_common_group_name");
}
