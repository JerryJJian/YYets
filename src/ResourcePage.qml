import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Page {

    title: qsTr("Resource Name")
    signal openResourceItem(int id, int season, int episode)

    Connections {
        target: resourceData
        onRefreshView: {
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

            for (var i=0; i<resourceData.dataListSize("season"); ++i) {
                var episode = new Array();
                var season = resourceData.dataListAt("season", i);
                for (var j=0; j<resourceData.dataListSize("season/"+season); ++j)
                    episode[j] = resourceData.dataListAt("season/"+season, j);

                seasonModel.append({"season": resourceData.dataListAt("season", i), "episode": episode })
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
        anchors.top: parent.top;       anchors.topMargin: 30
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
                    StateChangeScript { script: dataRequest.requestResourceItem(resourceData.data("id"))}
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
                                    hoverEnabled: true
                                    text: resourceData.dataListAt("season/"+season, index)
                                    onClicked: {
                                        var se = ""
                                        if (season != -1)
                                            se = "S" + season + "E" + text;
                                        resourceData.setData("current_item", se)
                                        openResourceItem(resourceData.data("id"), season, text)
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

            delegate: Rectangle {
                width: parent.width
                height: Math.max(sessionInfo.implicitHeight, avatarItem.height) + userLabel.implicitHeight + 30

                Label {
                    id: userLabel
                    anchors.top: parent.top; anchors.topMargin: 10
                    anchors.left: parent.left;
                    anchors.leftMargin: Math.abs((avatarImg.width - avatarItem.width)/2)

                    height: implicitHeight + font.pixelSize
                    text: nickname + " [" + group_name + "]"
                    font.bold: true
                    verticalAlignment: Text.AlignVCenter
                }

                Row {
                    id: infobar
                    anchors.top: userLabel.top
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                    spacing: 3

                    Label {
                        text: dateline + "  "
                        color: "gray"
                        font.pixelSize: Qt.application.font.pixelSize * 0.9
                    }

                    Image {
                        height: Qt.application.font.pixelSize
                        width: height
                        source: "images/good.png"
                    }
                    Label { color: "gray"; text: "(" + good + ")  "; font.pixelSize: Qt.application.font.pixelSize * 0.9 }

                    Image {
                        height: Qt.application.font.pixelSize
                        width: height
                        source: "images/bad.png"
                    }
                    Label { color: "gray"; text: "(" + bad + ")"; font.pixelSize: Qt.application.font.pixelSize * 0.9 }
                }

                Item {
                    id: avatarItem
                    width:  64
                    height: 64
                    anchors.left: userLabel.left
                    anchors.top:  userLabel.bottom;
                    anchors.topMargin: (avatarImg.height - avatarItem.height) / 2

                    Image {
                        id: avatarImg
                        anchors.centerIn: parent
                        width:  sourceSize.width > sourceSize.height ? avatarItem.width : sourceSize.width * height / sourceSize.height
                        height: sourceSize.width < sourceSize.height ? avatarItem.width : sourceSize.height * width / sourceSize.width
                        source: avatar_s
                        cache:  true
                    }
                }

                Column {
                    id: sessionInfo
                    anchors.left: avatarItem.right
                    anchors.right: parent.right
                    anchors.top: avatarItem.anchors.top
                    anchors.topMargin: avatarItem.anchors.topMargin
                    spacing: Qt.application.font.pixelSize / 2

                    Label {
                        text: content
                        width: parent.width
                        lineHeight: 1.5
                        padding: font.pixelSize
                        wrapMode: Text.WrapAnywhere
                    }

                    Rectangle {
                        width: parent.width - Qt.application.font.pixelSize * 2
                        height: visible ? (reContentLabel.implicitHeight + reUserLabel.implicitHeight) : 0
                        border.color: "#EEEEEE"
                        border.width: 1
                        radius: Qt.application.font.pixelSize / 3
                        visible: reply !== ""

                        Label {
                            id: replyFlag
                            padding: 3
                            anchors.left: parent.left; anchors.leftMargin: 3
                            anchors.top: parent.top; anchors.topMargin: 3
                            text: qsTr("Reply")
                            color: "white"
                            font.pixelSize: Qt.application.font.pixelSize * 0.8
                            background: Rectangle { color: "#282828"; radius: Qt.application.font.pixelSize / 2 }
                        }

                        Label {
                            id: reUserLabel
                            anchors.top: parent.top
                            anchors.left: replyFlag.right
                            padding: font.pixelSize / 3
                            font.bold: true
                            color: "gray"
                            lineHeight: 1.5
                            text: reply_nickname + " [" + reply_group_name + "]"
                        }

                        Row {
                            id: replyInfobar
                            anchors.top: parent.top
                            anchors.topMargin: 5
                            anchors.right: parent.right
                            anchors.rightMargin: 5
                            spacing: 3

                            Label {
                                text: reply_dateline + "  "
                                color: "gray"
                                font.pixelSize: Qt.application.font.pixelSize * 0.9
                            }

                            Image {
                                height: Qt.application.font.pixelSize
                                width: height
                                source: "images/good.png"
                            }
                            Label { color: "gray"; text: "(" + reply_good + ")  "; font.pixelSize: Qt.application.font.pixelSize * 0.9 }

                            Image {
                                height: Qt.application.font.pixelSize
                                width: height
                                source: "images/bad.png"
                            }
                            Label { color: "gray"; text: "(" + reply_bad + ")"; font.pixelSize: Qt.application.font.pixelSize * 0.9 }
                        }

                        Label {
                            id: reContentLabel
                            padding: font.pixelSize / 2
                            width: parent.width
                            wrapMode: Text.WrapAnywhere
                            anchors.left: parent.left
                            anchors.top: reUserLabel.bottom
                            lineHeight: 1.5
                            color: "gray"
                            text: reply_content
                        }
                    }
                }

                Rectangle { width: parent.width; height: 1; color: "#ECECEC"; anchors.bottom: parent.bottom }

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
