import QtQuick 2.11
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12
import QtQuick.Controls.Material 2.12

Page {
    id: root
    title: qsTr("Top")
    signal openResource(int id)
    signal openArticle(int id)

    ListView {
        id: articleList
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height
        y: 0
        contentY: -headerItem.height

        header: ScrollView {
            width: parent.width
            height: topList.height + 10
            implicitWidth: topList.width
            ScrollBar.horizontal.interactive: true
            ScrollBar.vertical.interactive: false
            ScrollBar.horizontal.policy: ScrollBar.AsNeeded
            ScrollBar.vertical.policy: ScrollBar.AlwaysOff

            onWidthChanged: topList.columns = (width / 150 >= 6 ? 10 : 5)

            Grid {
                id: topList
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                columns: (width / 120 > 5 ? 10 : 5)
                clip: true

                Repeater {
                    model: indexModel

                    delegate: Rectangle {
                        id: delegate
                        color: Material.backgroundColor
                        width:  120
                        height: posterImg.height + titleLable.implicitHeight + 20

                        Image {
                            id: posterImg
                            width:  100
                            height: 100
                            anchors.left:  parent.left
                            anchors.right: parent.right
                            anchors.top:   parent.top
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
                                color: "black"// Material.foreground
                            }
                        }

                        Label {
                            id: titleLable
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: posterImg.bottom; anchors.topMargin: 10
                            anchors.bottom: parent.bottom
                            verticalAlignment: Text.AlignTop
                            text: cnname
                            wrapMode: Text.WordWrap
                        }

                        MouseArea {
                            id: ma
                            anchors.fill: parent
                            onClicked: openResource(id)
                        }
                    }
                }


            }
        }

        model: articlesModel
        delegate: Item {
            width: parent.width
            height: contents.implicitHeight
            Column {
                id: contents
                anchors.top: parent.top; anchors.topMargin: 10
                anchors.bottom: parent.bottom; anchors.bottomMargin: 10
                anchors.left: parent.left; anchors.leftMargin: 10
                anchors.right: parent.right; anchors.rightMargin: 10
                spacing: 10

                Label {
                    width: parent.width
                    text: title
                    wrapMode: Text.WordWrap
                    font.pixelSize: Qt.application.font.pixelSize
                    font.bold: true
                }

                Label {
                    width: parent.width
                    text: intro
                    wrapMode: Text.WordWrap
                    color: "#9CA5B4"
                    font.pixelSize: Qt.application.font.pixelSize * 0.8
                }

                Image {
                    source: poster_b
                    width: parent.width > 480 ? 480 : parent.width
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

                Label {
                    width: parent.width
                    text: type_cn + " " + dateline + qsTr(" views:(") + views + ")"
                    wrapMode: Text.WordWrap
                    color: "#9CA5B4"
                    font.pixelSize: Qt.application.font.pixelSize * 0.8
                }

                Item {
                    width: parent.width
                    height: 20
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: openArticle(id)
            }
        }
    }

    Connections {
        target: articlesModel
        onDataModelAppended: {
            dataRequest.articlePage = Math.ceil(articlesModel.count / 10)
        }
    }

    states: [
        State {
            name: "refresh"
            when: !articleList.dragging && !dataRequest.isUpdatingIndex && articleList.contentY < (-80-articleList.headerItem.height)
            StateChangeScript {
                script: {
                    console.log("refresh")
                    if (!dataRequest.isUpdatingIndex) {
                        articlesModel.clear()
                        dataRequest.articlePage = Math.ceil(articlesModel.count / 10)
                        dataRequest.requestIndex()
                    }
                }
            }
        },
        State {
            name: "loadmore"
            when: !articleList.dragging && !dataRequest.isUpdatingIndex && articleList.contentY > 80 + articleList.headerItem.height
            StateChangeScript {
                script: {
                    console.log("loadmore")
                    if (!dataRequest.isUpdatingIndex) {
                        dataRequest.requestArticleList(dataRequest.articlePage + 1)
                    }
                }
            }
        }
    ]

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        visible: running
        running: dataRequest.isUpdatingIndex
    }
}


