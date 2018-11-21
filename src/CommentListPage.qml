import QtQuick 2.0
import QtQuick.Controls 2.4

Page {

    title: qsTr("Comments")

    ListView {
        id: commentList
        clip: true
        model: commentListModel

        delegate: CommentItemDelegate {
            width: parent.width
            p_user: nickname + " [" + group_name + "]"
            p_dateline: dateline + " "
            p_good: "("+(good === "" ? 0 : good)+") "
            p_bad: "("+(bad===""?0:bad)+")"
            p_content: content
            p_avatar_s: avatar_s
            p_replyShown: reply !== ""
            p_reply_user: reply_nickname + " [" + reply_group_name + "]"
            p_reply_dateline: reply_dateline + " "
            p_reply_good: "("+(reply_good === "" ? 0 : reply_good)+") "
            p_reply_bad: "("+(reply_bad===""?0:reply_bad)+")"
            p_reply_avatar_s: reply_avatar_s
            p_reply_content: reply_content
        }


        states: [
            State {
                name: "loadmore"
                when: commentList.contentHeight > 0 && (commentList.contentY > commentList.contentHeight - commentList.height - commentList.headerItem.height + 64)
                StateChangeScript {
                    script: {
                        console.log("loadmore")
                    }
                }
            },
            State {
                name: "refresh"
                when: commentList.contentY < -64 - commentList.headerItem.height
                StateChangeScript {
                    script: {
                        console.log("refresh")
                    }
                }
            }
        ]

        BusyIndicator {
            id: busyIndicator
            anchors.centerIn: parent
            visible: running
            running: false
        }
    }
}