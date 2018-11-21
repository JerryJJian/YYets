import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Page {

    title: qsTr("Article")
    property string commentsCount: "0"

    Connections {
        target: articleData
        onRefreshView: {
            title = articleData.data("title")
            authorLabel.text  = articleData.data("author")
            timeLabel.text    = articleData.data("dateline") + "/" +  qsTr("Views ") + articleData.data("views")
            introLabel.text   = articleData.data("intro")
            contentLabel.text = articleData.data("content")
            commentsCount     = articleData.data("comments_count")

            relatedResourceModel = articleData.dataList("resource")

//            for (var i=0; i<articleData.dataListSize("resource"); ++i) {
//                relatedResourceModel.append({
//                                                "id":       articleData.data("resource/" + articleData.dataListAt("resource", i) + "/id"),
//                                                "cnname":   articleData.data("resource/" + articleData.dataListAt("resource", i) + "/cnname"),
//                                                "remark":   articleData.data("resource/" + articleData.dataListAt("resource", i) + "/remark"),
//                                                "poster_b": articleData.data("resource/" + articleData.dataListAt("resource", i) + "/poster_b"),
//                                                "content":  articleData.data("resource/" + articleData.dataListAt("resource", i) + "/content"),
//                                                "enname":   articleData.data("resource/" + articleData.dataListAt("resource", i) + "/enname"),
//                                                "score":    articleData.data("resource/" + articleData.dataListAt("resource", i) + "/score"),
//                                                "poster_s": articleData.data("resource/" + articleData.dataListAt("resource", i) + "/poster_s")
//                                            })
//            }
//            relatedResourceModel.sync()

            for (var i=0; i<articleData.dataListSize("relative"); ++i) {
                relatedArticleModel.append({
                                               "id":       articleData.data("relative/" + articleData.dataListAt("relative", i) + "/id"),
                                               "dateline": articleData.data("relative/" + articleData.dataListAt("relative", i) + "/dateline"),
                                               "title":    articleData.data("relative/" + articleData.dataListAt("relative", i) + "/title"),
                                               "poster_b": articleData.data("relative/" + articleData.dataListAt("relative", i) + "/poster_b"),
                                               "poster_m": articleData.data("relative/" + articleData.dataListAt("relative", i) + "/poster_m"),
                                               "poster_s": articleData.data("relative/" + articleData.dataListAt("relative", i) + "/poster_s")
                                           })
            }
//            relatedArticleModel.sync()

        }
    }

    ListModel { id: relatedResourceModel }
    ListModel { id: relatedArticleModel  }

    StackLayout {
        id: layout
        anchors.left: parent.left; anchors.leftMargin: 15
        anchors.right: parent.right; anchors.rightMargin: 15
        anchors.top: parent.top; anchors.topMargin: 15
        anchors.bottom: parent.bottom; anchors.bottomMargin: 15
        currentIndex: 0

        Connections {
            target: window
            onShowArticleView: {
                if (type === "article") layout.currentIndex = 0
                else if (type === "relative") layout.currentIndex = 1
                else if (type === "comments") layout.currentIndex = 2
            }
        }

        // show article content
        ScrollView {
            contentWidth: width
            ScrollBar.horizontal.interactive: true
            ScrollBar.vertical.interactive: true

            Column {
                id: articleContent
                spacing: 15
                anchors.fill: parent

                Item {
                    width: parent.width
                    height: authorLabel.contentHeight
                    Label {
                        id: authorLabel
                        color: "gray"
                        anchors.left: parent.left
                    }
                    Label {
                        id: timeLabel
                        color: "gray"
                        anchors.right: parent.right
                    }
                }

                Rectangle {
                    color: "#EBECF0"
                    width: parent.width
                    height: introLabel.implicitHeight

                    Label {
                        id: introLabel
                        color: "gray"
                        anchors.fill: parent
                        wrapMode: Text.WordWrap
                    }
                }

                Text {
                    id: contentLabel
                    wrapMode: Text.Wrap
                    width: parent.width
                    font.pixelSize: Qt.application.font.pixelSize * 1.2
                }

            }

        }

        ScrollView {
            contentWidth: width
            ScrollBar.horizontal.interactive: true
            ScrollBar.vertical.interactive: true

            Column {

                width: parent.width
                spacing: 3

                Label {
                    text: qsTr("Relative Resources")
                }

                Repeater {
                    model: relatedResourceModel

                    Rectangle {
//                        color: "#F3F3F3"
                        width: parent.width
                        height: Math.max(resPoster.height, resInfo.implicitHeight)
                        property string resId: modelData

                        Item {
                            id: resPoster
                            width:  64
                            height: 64
                            anchors.left: parent.left
                            anchors.top:  parent.top

                            Image {
                                id: resImage
                                anchors.centerIn: parent
                                width:  sourceSize.width > sourceSize.height ? resPoster.width : sourceSize.width * height / sourceSize.height
                                height: sourceSize.width < sourceSize.height ? resPoster.width : sourceSize.height * width / sourceSize.width
                                cache:  true
                                source: articleData.data("resource/" + resId + "/poster_s")
                            }
                        }

                        Column {
                            id: resInfo
                            width: parent.width
                            spacing: Qt.application.font.pixelSize * 0.3

                            Label {
                                text: articleData.data("resource/" + resId + "/cnname")
                                font.pixelSize: Qt.application.font.pixelSize * 1.6
                                font.bold: true
                                wrapMode: Text.WrapAnywhere
                            }
                            Label {
                                text: articleData.data("resource/" + resId + "/enname")
                                wrapMode: Text.WrapAnywhere
                                color: "gray"
                            }
                            Label {
                                text: articleData.data("resource/" + resId + "/remark")
                                color: "gray"
                            }
                        }

                        Label {
                            anchors.top: resPoster.top
                            anchors.right: parent.right
                            text: articleData.data("resource/" + resId + "/score")
                            visible: text !== ""
                            color: "white"
                            padding: font.pixelSize / 3
                            background: Rectangle { color: "#282828"; radius: height / 3; }
                            font.pixelSize: Qt.application.font.pixelSize * 1.6
                            font.bold: true
                        }

                    }

                    Label { text:resId + "  ? " + modelData }

                }



            }

        }

        ListView {
            clip: true
            model: commentListModel

            footer: Item {
                width: parent.width
                height: commentbutton.height * 1.5

                Button {
                    id: commentbutton
                    anchors.centerIn: parent
                    text: qsTr("Show " + commentsCount + " Comments")
                    icon.source: "images/comment.png"
                }
            }
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
        }
    }

}
