import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Page {

    title: qsTr("Resource Name")

    Connections {
        target: resourceData
        onRefreshView: {
            title = resourceData.data("cnname") === "" ? resourceData.data("enname") : resourceData.data("cnname")
            img.source = resourceData.data("poster_b")
            ennameLabel.text = resourceData.data("enname")
            categoryLabel.text = resourceData.data("channel_cn") +" " + resourceData.data("category") + " " + resourceData.data("area") +"/"+ resourceData.data("lang")
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
        width: metaInfo.height + 30 < 240 ? 240 : metaInfo.height + 30
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
        anchors.left: posterImg.right; anchors.leftMargin: 10
        anchors.right: parent.right;   anchors.rightMargin: 10
        anchors.top: parent.top;       anchors.topMargin: 30
        spacing: ennameLabel.height

        Label { id: ennameLabel    ; color: "#ADADAD" }
        Label { id: categoryLabel  ; color: "#ADADAD" }
        Label { id: statusLabel    ; color: "#ADADAD" }
        Label { id: itemupdateLabel; color: "#ADADAD" }
        Label { id: remarkLabel    ; color: "#ADADAD" }
        Label { id: prevueLabel    ; color: "#ADADAD" }
        Label { id: favoritesLabel ; color: "#ADADAD" }
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
            text: qsTr("Resources")
        }

        TabButton {
            text: qsTr("Contents")
        }

        TabButton {
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
                                    onClicked: dataRequest.requestResourceItem(resourceData.data("id"), season, text)
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

    }


    // ---------------------------------------------------------------
    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: true
    }
}
