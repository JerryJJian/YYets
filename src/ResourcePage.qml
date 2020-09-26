import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.13

Page {

    title: qsTr("Resource Name")
    signal openResourceItem(int id, int season, int episode)
    signal openArticle(int id)

    property int commentsCount: 0
    property string resourceId: ""
    property bool followed: false

    Connections {
        target: resourceData
        onRefreshView: {
            resourceId = resourceData.data("id")
            title = resourceData.data("cnname") === "" ? resourceData.data("enname") : resourceData.data("cnname")
            img.source = resourceData.data("poster_m")
            ennameLabel.text = resourceData.data("enname")
            categoryLabel.text = resourceData.data("category")
            channelLabel.text = resourceData.data("channel_cn")
            areaLabel.text = resourceData.data("area")
            langLabel.text = resourceData.data("lang")
            statusLabel.text = resourceData.data("tvstation") + " @" + resourceData.data("premiere")
            itemupdateLabel.text = "\u231A " + resourceData.data("itemupdate") + " No." + resourceData.data("rank") + " \u2665 " + resourceData.data("favorites")
            remarkLabel.text = resourceData.data("remark")
            playStatusLabel.text = resourceData.data("play_status")
            prevue_episode.text = resourceData.data("prevue_episode")
            prevue_play_time.text = resourceData.data("prevue/play_time")
            prevue_week.text = resourceData.data("prevue/week")
//            favoritesLabel.text = "No." + resourceData.data("rank") + " \u2665 " + resourceData.data("favorites")
            scoreLabel.text = resourceData.data("score")
            content.text = resourceData.data("content")
            busyIndicator.running = false
            commentsCount = resourceData.data("comments_count")

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
        width: 150
        height: width
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 0

        Image {
            id: img
            anchors.top: parent.top; anchors.topMargin: 10
            anchors.left: parent.left; anchors.leftMargin: 10
            width:  (sourceSize.width > sourceSize.height ? posterImg.width : sourceSize.width * posterImg.height / sourceSize.height) - 20
            height: (sourceSize.width < sourceSize.height ? posterImg.height : sourceSize.height * posterImg.width / sourceSize.width) - 20
            cache: true
            fillMode: Image.PreserveAspectFit

            layer.enabled: false
            layer.effect: DropShadow {
                horizontalOffset: 0
                verticalOffset: 4
                radius: 8.0
                opacity: 0.33
                samples: 17
                color: "black"
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                bigImagePopup.hdimagefile = resourceData.data("poster_n")
                bigImagePopup.visible = true
            }
        }
    }

    Popup {
        id: bigImagePopup
        width: parent.width
        height: parent.height
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
        property alias hdimagefile: hdimage.source

        Image {
            id: hdimage
            anchors.centerIn: parent
            width:  sourceSize.width > sourceSize.height ? parent.width : sourceSize.width * parent.height / sourceSize.height
            height: sourceSize.width < sourceSize.height ? parent.height : sourceSize.height * parent.width / sourceSize.width
        }

        ProgressBar {
            id: loadingProgress
            value: hdimage.progress
            visible: hdimage.status !== Image.Ready
            anchors.centerIn: parent
        }

        ToolButton {
            anchors.top: parent.top; anchors.topMargin: 10
            anchors.right: parent.right; anchors.rightMargin: 10
            icon.source: "images/close.png"
            onClicked: bigImagePopup.close()
        }
    }

    Column {
        id: metaInfo
        anchors.left: posterImg.right; anchors.leftMargin: (posterImg.width > img.width ? (img.width - posterImg.width) : posterImg.width) + 20
        anchors.right: parent.right;   anchors.rightMargin: 10
        anchors.top: posterImg.top;   anchors.topMargin: 10
        spacing: 5

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
                font.pixelSize: Qt.application.font.pixelSize * 0.66
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
                font.pixelSize: Qt.application.font.pixelSize * 0.66
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
                font.pixelSize: Qt.application.font.pixelSize * 0.66
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
                font.pixelSize: Qt.application.font.pixelSize * 0.66
                background: Rectangle { radius: height / 3; color: "#282828"; }
            }
        }
        Label { id: statusLabel    ; width: parent.width; visible: text !== ""; wrapMode: Text.WordWrap; color: "#808080"; font.pixelSize: Qt.application.font.pixelSize * 0.66}
        Label { id: itemupdateLabel; width: parent.width; visible: text !== ""; wrapMode: Text.WordWrap; color: "#808080"; font.pixelSize: Qt.application.font.pixelSize * 0.66}
        Label { id: remarkLabel    ; width: parent.width; visible: text !== ""; wrapMode: Text.WordWrap; color: "#808080"; font.pixelSize: Qt.application.font.pixelSize * 0.66}

        Flow {
            width: parent.width
            spacing: Qt.application.font.pixelSize / 3

            Label {
                id: playStatusLabel
                visible: text !== ""
                width: implicitWidth + font.pixelSize
                height: implicitHeight + font.pixelSize / 2
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "#FFFFFF";
                font.pixelSize: Qt.application.font.pixelSize * 0.66
                background: Rectangle { radius: height / 3; color: "#097bed"; }
            }

            Label {
                id: prevue_episode
                visible: text !== ""
                width: implicitWidth + font.pixelSize
                height: implicitHeight + font.pixelSize / 2
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "#FFFFFF";
                font.pixelSize: Qt.application.font.pixelSize * 0.66
                background: Rectangle { radius: height / 3; color: "#F26B3A"; }
            }
            Label {
                id: prevue_play_time
                visible: text !== ""
                width: implicitWidth + font.pixelSize
                height: implicitHeight + font.pixelSize / 2
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "#FFFFFF";
                font.pixelSize: Qt.application.font.pixelSize * 0.66
                background: Rectangle { radius: height / 3; color: "#F26B3A"; }
            }
            Label {
                id: prevue_week
                visible: text !== ""
                width: implicitWidth + font.pixelSize
                height: implicitHeight + font.pixelSize / 2
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "#FFFFFF";
                font.pixelSize: Qt.application.font.pixelSize * 0.66
                background: Rectangle { radius: height / 3; color: "#F26B3A"; }
            }
        }
//        Label { id: favoritesLabel ; width: parent.width; visible: text !== ""; wrapMode: Text.WordWrap; color: "#808080"; font.pixelSize: Qt.application.font.pixelSize * 0.66}
    }

    Label {
        id: scoreLabel
        color: "#EC524B"
        font.pixelSize: Qt.application.font.pixelSize * 1.2
        font.bold: true
        anchors.top: metaInfo.top;
        anchors.right: metaInfo.right
    }

    // ---------------------------------------------------------------
    TabBar {
        id: tabbar
        anchors.top: img.height > metaInfo.height + metaInfo.anchors.topMargin * 1.5 ? posterImg.bottom : metaInfo.bottom
        anchors.topMargin: (img.height > metaInfo.height ? img.height - posterImg.height : 0) + 20
        anchors.left: parent.left
        anchors.right: parent.right

        TabButton {
            icon.source: "images/link.png"
            text: qsTr("Resources")
            font.pixelSize: Qt.application.font.pixelSize * 0.9
        }

        TabButton {
            icon.source: "images/introduce.png"
            text: qsTr("Contents")
            font.pixelSize: Qt.application.font.pixelSize * 0.9
        }

        TabButton {
            icon.source: "images/comment.png"
            text: qsTr("Commonts")
	    font.pixelSize: Qt.application.font.pixelSize * 0.9
        }

        TabButton {
            icon.source: "images/link.png"
            text: qsTr("Articles")
	    font.pixelSize: Qt.application.font.pixelSize * 0.9
            onClicked: {
                searchResourceModel.clear()
                searchResultList.pageNum = 1
                dataRequest.searchResource("article", resourceData.data("search_keywords"), searchResultList.pageNum, searchResultList.pageSize)
            }
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

            Item {
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
                            anchors.top: parent.top; anchors.topMargin: 10
                            font.pixelSize: Qt.application.font.pixelSize
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
                                    id: btn
                                    flat: true
                                    width: height
                                    background: Rectangle {
                                        radius: parent.width / 2
                                        color: btn.hovered || btn.pressed ? Material.accentColor : (btn.highlighted ? Material.backgroundDimColor : Material.backgroundColor)
                                    }
                                    highlighted: resourceData.dataListContains("season/"+season+"/visit", text)
                                    hoverEnabled: true
                                    text: resourceData.dataListAt("season/"+season, index)
                                    onClicked: {
                                        var se = ""
                                        if (season != -1)
                                            se = "S" + season + "E" + text;
                                        resourceData.setData("current_item", se)
                                        resourceData.setData("current/season", season)
                                        resourceData.setData("current/episode", text)
                                        highlighted = true
                                        openResourceItem(resourceId, season, text)
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
                p_reply_good: "("+(reply_good === "" ? 0 : reply_good)+") "
                p_reply_bad: "("+(reply_bad===""?0:reply_bad)+")"
                p_reply_avatar_s: reply_avatar_s
                p_reply_content: reply_content
            }
        }

        ListView {
            id: searchResultList
            clip: true
            model: searchResourceModel
            property int pageNum: 1
            property int pageSize: 30

            delegate: Item {
                width: searchResultList.width
                height: Math.max(aPosterImg.height + 20, columnInfo.implicitHeight + columnInfo.anchors.topMargin * 2)

                Image {
                    id: aPosterImg
                    width:  80
                    height: 80
                    anchors.left:  parent.left; anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    fillMode: Image.PreserveAspectFit
                    source: poster_m
                    cache:  true

                    layer.enabled: false
                    layer.effect: DropShadow {
                        horizontalOffset: 0
                        verticalOffset: 4
                        radius: 8.0
                        opacity: 0.33
                        samples: 17
                        color: "black"
                    }
                }

                Column {
                    id: columnInfo
                    anchors.left: aPosterImg.right; anchors.leftMargin: 10
                    anchors.right: parent.right; anchors.rightMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: Qt.application.font.pixelSize * 0.2

                    Label {
                        text: title
                        width: parent.width
                        wrapMode: Text.WrapAnywhere
                    }

                    Flow {
                        spacing: Qt.application.font.pixelSize / 3

                        Label {
                            text: channel;
                            visible: channel !== ""
                            width: implicitWidth + font.pixelSize
                            height: implicitHeight + font.pixelSize / 2
                            font.pixelSize: Qt.application.font.pixelSize * 0.66;
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            color: "#FFFFFF"
                            background: Rectangle {
                                radius: height / 3
                                color: "#303030"
                            }
                        }

                        Label {
                            text: prefix;
                            visible: prefix !== ""
                            width: implicitWidth + font.pixelSize
                            height: implicitHeight + font.pixelSize / 2
                            font.pixelSize: Qt.application.font.pixelSize * 0.66;
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            color: "#FFFFFF"
                            background: Rectangle {
                                radius: height / 3
                                color: "#303030"
                            }
                        }

                        Label {
                            text: suffix;
                            visible: suffix !== ""
                            width: implicitWidth + font.pixelSize
                            height: implicitHeight + font.pixelSize / 2
                            font.pixelSize: Qt.application.font.pixelSize * 0.66;
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            color: "#FFFFFF"
                            background: Rectangle {
                                radius: height / 3
                                color: "#303030"
                            }
                        }

                        Label {
                            text: character;
                            visible: character !== ""
                            width: implicitWidth + font.pixelSize
                            height: implicitHeight + font.pixelSize / 2
                            font.pixelSize: Qt.application.font.pixelSize * 0.66;
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            wrapMode: Text.WrapAnywhere
                            color: "#FFFFFF"
                            background: Rectangle {
                                radius: font.pixelSize / 3
                                color: "#303030"
                            }
                        }
                    }

                    Label {
                        width: parent.width;
                        text: pubtime;
                        font.pixelSize: Qt.application.font.pixelSize * 0.8;
                        color: "gray"
                    }

                }

                Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: "#ededed" }
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    onClicked: {
                        openArticle(itemid)
                    }
                }
            }

            states: [
                State {
                    name: "none"
                    when: searchResultList.contentY === 0
                },
                State {
                    name: "loadmore"
                    when: !searchResultList.dragging && !dataRequest.isSearching && searchResultList.contentHeight > 0 && (searchResultList.contentY > searchResultList.contentHeight - searchResultList.height + 80)
                    StateChangeScript {
                        script: {
                            if (searchResourceModel.count % searchResultList.pageSize !== 0)
                                return ;

                            if (!dataRequest.isUpdatingResList)
                                dataRequest.searchResource("article", resourceData.data("search_keywords"), searchResultList.pageNum + 1, searchResultList.pageSize)
                        }
                    }
                }
            ]

            Connections {
                target: searchResourceModel
                onDataModelAppended: {
                    searchResultList.pageNum = Math.ceil(searchResourceModel.count / searchResultList.pageSize)
                }
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
