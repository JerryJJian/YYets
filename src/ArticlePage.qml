import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Page {

    title: qsTr("Article")
    property string commentsCount: "0"
    signal openResource(int id)
    signal openArticle(int id)
    property string article: ""

    Connections {
        target: articleData
        onRefreshView: {
            if (article === "" || article === articleData.data("id")) {
                article = articleData.data("id")
                title = articleData.data("title")
                authorLabel.text  = articleData.data("author")
                timeLabel.text    = articleData.data("dateline") + "/" +  qsTr("Views ") + articleData.data("views")
                introLabel.text   = articleData.data("intro")
//                contentLabel.text = articleData.data("content")
                commentsCount     = articleData.data("comments_count")

                for (var i=0; i<articleData.data("content/size"); ++i) {
                    console.log(articleData.dataListAt("content/types", i))
                    contentModel.append({
                                            "type": articleData.dataListAt("content/types", i),
                                            "value": articleData.dataListAt("content/values", i)
                                        })
                }

                for (i=0; i<articleData.data("extend"); ++i) {
                    extentContentModel.append({
                                                  "aContent": articleData.dataListAt("extend/articleContent", i),
                                                  "aTrailer": articleData.dataListAt("extend/article_trailer", i),
                                                  "aRid": articleData.dataListAt("extend/rids", i),
                                              })
                }

                console.log(articleData.data("resource"))

                for (i=0; i<articleData.dataListSize("resource"); ++i) {
                    var resourceId = articleData.dataListAt("resource", i)
                    relatedResourceModel.append({
                                                    "id":       resourceId,
                                                    "cnname":   articleData.data("resource/" + resourceId + "/cnname"),
                                                    "remark":   articleData.data("resource/" + resourceId + "/remark"),
                                                    "poster_b": articleData.data("resource/" + resourceId + "/poster_b"),
                                                    "content":  articleData.data("resource/" + resourceId + "/content"),
                                                    "enname":   articleData.data("resource/" + resourceId + "/enname"),
                                                    "score":    articleData.data("resource/" + resourceId + "/score"),
                                                    "poster_s": articleData.data("resource/" + resourceId + "/poster_s")
                                                })
                }

                for (i=0; i<articleData.dataListSize("relative"); ++i) {
                    var articleId = articleData.dataListAt("relative", i)
                    relatedArticleModel.append({
                                                   "id":       articleId,
                                                   "dateline": articleData.data("relative/" + articleId + "/dateline"),
                                                   "title":    articleData.data("relative/" + articleId + "/title"),
                                                   "poster_b": articleData.data("relative/" + articleId + "/poster_b"),
                                                   "poster_m": articleData.data("relative/" + articleId + "/poster_m"),
                                                   "poster_s": articleData.data("relative/" + articleId + "/poster_s")
                                               })
                }
            }
        }
    }

    ListModel { id: contentModel         }
    ListModel { id: extentContentModel   }
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
                if (article === "" || article === articleData.data("id")) {
                    if (type === "article") layout.currentIndex = 0
                    else if (type === "relative") layout.currentIndex = 1
                    else if (type === "comments") layout.currentIndex = 2
                }
            }
        }

        // show article content
        ScrollView {
            contentWidth: width
            ScrollBar.horizontal.interactive: true
            ScrollBar.vertical.interactive: true
            focusReason: Qt.TabFocus

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
                        padding: font.pixelSize
                        color: "gray"
                        visible: text !== ""
                        anchors.fill: parent
                        wrapMode: Text.WordWrap
                    }
                }

//                Label {
//                    id: contentLabel
//                    wrapMode: Text.Wrap
//                    width: parent.width
//                    font.pixelSize: Qt.application.font.pixelSize
//                }

                Repeater {
                    id: contentArea
                    model: contentModel
                    Item {

                        width: parent.width
                        height: textLabel.implicitHeight + imageLabel.height

                        Label {
                            id: textLabel
                            text: value
                            visible: type === "text"
                            width: parent.width
                            wrapMode: Text.WordWrap
                        }

                        Image {
                            id: imageLabel
                            source: value
                            visible: type === "image"
                            width: Math.min(parent.width, sourceSize.width)
                            height: parent.width > sourceSize.width ? sourceSize.height : (sourceSize.height * width / sourceSize.width)
                        }
                    }
                }

                Label {
                    id: extendContentLabel
                    wrapMode: Text.Wrap
                    width: parent.width
                    font.pixelSize: Qt.application.font.pixelSize
                }

                Repeater {
                    model: extentContentModel

                    Rectangle {
                        radius: Qt.application.font.pixelSize
                        color: "#ECECEC"
                        width: parent.width
                        height: acontentLabel.implicitHeight + atrailerLabel.implicitHeight
                        Label {
                            id: acontentLabel
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            width: parent.width
                            padding: font.pixelSize
                            text: aContent
                            wrapMode: Text.WrapAnywhere
                        }
                        Label {
                            id: atrailerLabel
                            padding: font.pixelSize
                            text: aTrailer
                            visible: text !== ""
                            width: parent.width
                            anchors.top: acontentLabel.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            wrapMode: Text.WrapAnywhere
                            horizontalAlignment: Text.AlignRight
                        }
                    }

                }

            }



        }

        ScrollView {
            contentWidth: width
            ScrollBar.horizontal.interactive: true
            ScrollBar.vertical.interactive: true

            Column {

                width: parent.width
                spacing: 10

                Item {
                    width: parent.width
                    height: resourceLabel.implicitHeight

                    Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: 3
                        color: "#F47023";
                        radius: height / 3
                    }

                    Label {
                        id: resourceLabel
                        text: qsTr("Resources")
                        padding: font.pixelSize / 2
                    }
                }

                Repeater {
                    model: relatedResourceModel

                    Rectangle {
                        color: "#F3F3F3"
                        width: parent.width
                        height: Math.max(resPoster.height, resInfo.implicitHeight + resInfo.anchors.topMargin * 2)

                        Item {
                            id: resPoster
                            width:  80
                            height: 80
                            anchors.left: parent.left
                            anchors.top:  parent.top

                            Image {
                                id: resImage
                                anchors.centerIn: parent
                                width:  sourceSize.width > sourceSize.height ? 64 : sourceSize.width * height / sourceSize.height
                                height: sourceSize.width < sourceSize.height ? 64 : sourceSize.height * width / sourceSize.width
                                cache:  true
                                source: poster_s
                            }
                        }

                        Column {
                            id: resInfo
                            width: parent.width
                            anchors.left: resPoster.right
                            anchors.right: parent.right; anchors.rightMargin: 10
                            anchors.top: parent.top; anchors.topMargin: 10
                            spacing: Qt.application.font.pixelSize * 0.3

                            Label {
                                id: cnnameLabel
                                text: cnname
                                font.pixelSize: Qt.application.font.pixelSize
                                font.bold: true
                                padding: font.pixelSize / 4
                                width: parent.width
                                wrapMode: Text.WrapAnywhere
                            }
                            Label {
                                id: ennameLabel
                                text: enname
                                width: parent.width
                                wrapMode: Text.WrapAnywhere
                                padding: font.pixelSize / 4
                                color: "gray"
                                font.pixelSize: Qt.application.font.pixelSize * 0.8
                            }
                            Label {
                                id: remarkLabel
                                text: remark
                                width: parent.width
                                wrapMode: Text.WrapAnywhere
                                padding: font.pixelSize / 4
                                color: "gray"
                                font.pixelSize: Qt.application.font.pixelSize * 0.8
                            }
                        }

                        Label {
                            id: scoreLabel
                            anchors.top: parent.top; anchors.topMargin: 10
                            anchors.right: parent.right; anchors.rightMargin: 10
                            text: score
                            visible: text !== ""
                            color: "white"
                            padding: font.pixelSize / 3
                            background: Rectangle { color: "#097BED"; radius: height / 3; }
                            font.pixelSize: Qt.application.font.pixelSize * 0.8
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: openResource(id)
                        }
                    }

                }

                // article
                Item {
                    width: parent.width
                    height: articleLabel.implicitHeight

                    Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: 3
                        color: "#26B47F";
                        radius: height / 3
                    }

                    Label {
                        id: articleLabel
                        text: qsTr("Articles")
                        padding: font.pixelSize / 2
                    }
                }

                Repeater {
                    model: relatedArticleModel

                    Rectangle {
                        color: "#F3F3F3"
                        width: parent.width
                        height: Math.max(aPoster.height, aInfo.implicitHeight + aInfo.anchors.topMargin * 2)

                        Item {
                            id: aPoster
                            width:  80
                            height: 80
                            anchors.left: parent.left
                            anchors.top:  parent.top

                            Image {
                                id: aImage
                                anchors.centerIn: parent
                                width:  sourceSize.width > sourceSize.height ? 72 : sourceSize.width * height / sourceSize.height
                                height: sourceSize.width < sourceSize.height ? 72 : sourceSize.height * width / sourceSize.width
                                cache:  true
                                source: poster_m
                            }
                        }

                        Column {
                            id: aInfo
                            anchors.left: aPoster.right
                            anchors.right: parent.right; anchors.rightMargin: 10
                            anchors.top: parent.top; anchors.topMargin: 10
                            spacing: Qt.application.font.pixelSize * 0.3

                            Label {
                                text: title
                                font.pixelSize: Qt.application.font.pixelSize
                                font.bold: true
                                padding: font.pixelSize / 4
                                width: parent.width
                                wrapMode: Text.WrapAnywhere
                            }
                            Label {
                                text: dateline
                                visible: text !== ""  && text !== ""
                                width: parent.width
                                wrapMode: Text.WrapAnywhere
                                padding: font.pixelSize / 4
                                font.pixelSize: Qt.application.font.pixelSize * 0.8
                                color: "gray"
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: openArticle(id)
                        }
                    }
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
                p_reply_good: "("+(reply_good === "" ? 0 : reply_good)+") "
                p_reply_bad: "("+(reply_bad===""?0:reply_bad)+")"
                p_reply_avatar_s: reply_avatar_s
                p_reply_content: reply_content
            }
        }
    }

}
