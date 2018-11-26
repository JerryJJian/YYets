import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Page {

    title: qsTr("Resource Name")
    signal openResourceItem(int id, int season, int episode)
    property int commentsCount: 0
    property string resourceId: ""
    property bool followed: false

    Connections {
        target: resourceData
        onRefreshView: {
            resourceId = resourceData.data("id")
            title = resourceData.data("cnname") === "" ? resourceData.data("enname") : resourceData.data("cnname")
            img.source = resourceData.data("poster_b")
            ennameLabel.text = resourceData.data("enname")
            categoryLabel.text = resourceData.data("category")
            channelLabel.text = resourceData.data("channel_cn")
            areaLabel.text = resourceData.data("area")
            langLabel.text = resourceData.data("lang")
            statusLabel.text = resourceData.data("tvstation") + " @" + resourceData.data("premiere") + " - " + resourceData.data("play_status")
            itemupdateLabel.text = "\u231A " + resourceData.data("updatetime")
            remarkLabel.text = resourceData.data("remark")
            prevueLabel.text = "\u23F3 " + resourceData.data("prevue/play_time") + " " + resourceData.data("prevue/week") + " S" + resourceData.data("prevue/season") + "E" + resourceData.data("prevue/episode")
            favoritesLabel.text = "No." + resourceData.data("rank") + " \u2665 " + resourceData.data("favorites")
            scoreLabel.text = resourceData.data("score")
            content.text = resourceData.data("content")
            prevueLabel.visible = resourceData.data("prevue/play_time") !== ""
            busyIndicator.running = false
            commentsCount = resourceData.data("comments_count")
            followed = database.hasFollowed(resourceData.data("id"))

            if (key === "" || key === "season") {
                seasonModel.clear()
                for (var i=0; i<resourceData.dataListSize("season"); ++i) {
                    var episode = new Array;
                    var visit = new Array;
                    var season = resourceData.dataListAt("season", i);
                    for (var j=0; j<resourceData.dataListSize("season/"+season); ++j) {
                        episode[j] = resourceData.dataListAt("season/"+season, j);
                        visit[j] = resourceData.dataListContains("season/"+season+"/visit", episode[j])
                    }

                    seasonModel.append({"season": resourceData.dataListAt("season", i), "episode": episode, "visit": visit })
                }
            }

            resourceArea.state = (seasonModel.count > 0 ? "tv" : "movie")
        }
    }

    ListModel {
        id: seasonModel
    }

    Item {
        id: posterImg
        width: 240
        height: width
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 0

        Image {
            id: img
            anchors.centerIn: parent
            width:  sourceSize.width > sourceSize.height ? posterImg.width : sourceSize.width * height / sourceSize.height
            height: sourceSize.width < sourceSize.height ? posterImg.width : sourceSize.height * width / sourceSize.width
            cache: true
        }
    }

    Column {
        id: metaInfo
        anchors.left: posterImg.right; anchors.leftMargin: (posterImg.width > img.width ? (img.width - posterImg.width)/2 : 0) + 10
        anchors.right: parent.right;   anchors.rightMargin: 10
        anchors.top: posterImg.top;   anchors.topMargin: 30
        spacing: ennameLabel.height

        Label { id: ennameLabel    ; width: parent.width; wrapMode: Text.WordWrap; }
        Flow {
            width: parent.width
            spacing: 5
            Label {
                id: channelLabel;
                visible: text !== ""
                width: implicitWidth + font.pixelSize
                height: implicitHeight + font.pixelSize / 2
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "#FFFFFF";
                background: Rectangle { radius: height / 3; color: "#282828"; }
            }
            Label {
                id: categoryLabel;
                visible: text !== ""
                width: implicitWidth + font.pixelSize
                height: implicitHeight + font.pixelSize / 2
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "#FFFFFF";
                background: Rectangle { radius: height / 3; color: "#282828"; }
            }
            Label {
                id: areaLabel;
                visible: text !== ""
                width: implicitWidth + font.pixelSize
                height: implicitHeight + font.pixelSize / 2
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "#FFFFFF";
                background: Rectangle { radius: height / 3; color: "#282828"; }
            }
            Label {
                id: langLabel;
                visible: text !== ""
                width: implicitWidth + font.pixelSize
                height: implicitHeight + font.pixelSize / 2
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "#FFFFFF";
                background: Rectangle { radius: height / 3; color: "#282828"; }
            }
        }
        Label { id: statusLabel    ; width: parent.width; visible: text !== ""; wrapMode: Text.WordWrap; color: "#808080"; }
        Label { id: itemupdateLabel; width: parent.width; visible: text !== ""; wrapMode: Text.WordWrap; color: "#808080"; }
        Label { id: remarkLabel    ; width: parent.width; visible: text !== ""; wrapMode: Text.WordWrap; color: "#808080"; }
        Label { id: prevueLabel    ; width: parent.width; visible: text !== ""; wrapMode: Text.WordWrap; color: "#808080"; }
        Label { id: favoritesLabel ; width: parent.width; visible: text !== ""; wrapMode: Text.WordWrap; color: "#808080"; }
    }

    Label {
        id: scoreLabel
        color: "#EC524B"
        font.pixelSize: Qt.application.font.pixelSize * 1.6
        font.bold: true
        anchors.top: metaInfo.top;
        anchors.right: metaInfo.right
    }

    ToolButton {
        id: followButton
        anchors.right: metaInfo.right
        anchors.bottom: tabbar.top
        text: followed ? qsTr("Followed") : qsTr("Follow")
        icon.source: followed ? "images/followed.png" : "images/follow.png"
        highlighted: followed
        onClicked: followed = database.addFollowed(resourceData.data("id"), resourceData.data("resource"), resourceData.data("lastvisit"))
    }

    // ---------------------------------------------------------------
    TabBar {
        id: tabbar
        anchors.top: posterImg.height > metaInfo.height ? posterImg.bottom : metaInfo.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        TabButton {
            icon.source: "images/link.png"
            text: qsTr("Resources")
        }

        TabButton {
            icon.source: "images/introduce.png"
            text: qsTr("Contents")
        }

        TabButton {
            icon.source: "images/comment.png"
            text: qsTr("Commonts")
        }
    }

    StackLayout {
        id: layout
        anchors.top: tabbar.bottom; anchors.topMargin: 10
        anchors.left: parent.left; anchors.leftMargin: 10
        anchors.right: parent.right; anchors.rightMargin: 10
        anchors.bottom: parent.bottom
        currentIndex: tabbar.currentIndex

        ScrollView {
            id: resourceArea
            width: parent.width
            height: parent.height
            contentWidth: width
            clip: true
            ScrollBar.horizontal.interactive: true
            ScrollBar.vertical.interactive: true
            state: "none"
            states: [
                State {
                    name: "none"
                },
                State {
                    name: "tv"
                    PropertyChanges { target: seasonResource;        visible: true }
                    PropertyChanges { target: singleEpisodeResource; visible: false }
                    PropertyChanges { target: resourceArea; contentHeight: seasonResource.implicitHeight }
                },
                State {
                    name: "movie"
                    PropertyChanges { target: seasonResource;        visible: false }
                    PropertyChanges { target: singleEpisodeResource; visible: true }
                    PropertyChanges { target: resourceArea; contentHeight: singleEpisodeResource.implicitHeight }
                    StateChangeScript { script: dataRequest.requestResourceItem(resourceData.data("id")) }
                }
            ]

            Rectangle {
                id: singleEpisodeResource
                anchors.fill: parent
                visible: false
                Button {
                    anchors.top: parent.top; anchors.topMargin: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Open the resource")
                    onClicked: openResourceItem(resourceData.data("id"), -1, -1)
                }
            }

            Column {
                id: seasonResource
                anchors.fill: parent
                visible: false

                Repeater {
                    id: seasonRepeator
                    width: parent.width
                    model: seasonModel

                    Item {
                        width: parent.width
                        height: seasonLabel.height + epsiodFlow.height + 30

                        Rectangle {
                            id: flag
                            color: "#4B8BD3"
                            width: 3
                            height: seasonLabel.height
                            anchors.top: seasonLabel.top
                        }

                        Label {
                            id: seasonLabel
                            text: "Season " + season
                            color: "#4B8BD3"
                            font.bold: true
                            anchors.left: flag.right; anchors.leftMargin: 5
                            anchors.top: parent.top; anchors.topMargin: 15
                            font.pixelSize: Qt.application.font.pixelSize * 1.2
                        }

                        Flow {
                            id: epsiodFlow
                            spacing: 5
                            anchors.top: seasonLabel.bottom; anchors.topMargin: 10
                            anchors.left: parent.left
                            anchors.right: parent.right
                            Repeater {
                                id: episodeRepeator
                                model: episode
                                delegate: RoundButton {
                                    flat: true
                                    width: height
                                    background: Rectangle {
                                        radius: parent.width / 2
                                        anchors.fill: parent
                                        color: hovered || pressed ? "#e3e3e3" : "#F3F3F3"
                                    }
                                    highlighted: resourceData.dataListContains("season/"+season+"/visit", text)
                                    hoverEnabled: true
                                    text: resourceData.dataListAt("season/"+season, index)
                                    onClicked: {
                                        var se = ""
                                        if (season != -1)
                                            se = "S" + season + "E" + text;
                                        openResourceItem(resourceId, season, text)
                                        resourceData.setData("current_item", se)
                                        resourceData.setData("current/season", season)
                                        resourceData.setData("current/episode", text)
                                        highlighted = true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        ScrollView {
            contentWidth: width
            clip: true
            ScrollBar.horizontal.interactive: true
            ScrollBar.vertical.interactive: true

            Label {
                id: content
                anchors.fill: parent
                wrapMode: Label.WordWrap
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


    // ---------------------------------------------------------------
    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: true
    }
}
