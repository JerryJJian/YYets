import QtQuick 2.11
import QtQuick.Controls 2.4

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

                Repeater {
                    model: indexModel

                    delegate: Rectangle {
                        id: delegate
                        width:  120
                        height: posterImg.height + titleLable.implicitHeight

                        Item {
                            id: posterImg
                            width:  110
                            height: 110
                            anchors.left:  parent.left
                            anchors.right: parent.right
                            anchors.top:   parent.top

                            Image {
                                id: img
                                anchors.centerIn: parent
                                width:  sourceSize.width > sourceSize.height ? 100 : sourceSize.width * height / sourceSize.height
                                height: sourceSize.width < sourceSize.height ? 100 : sourceSize.height * width / sourceSize.width
                                source: poster_m
                                cache:  true
                            }
                        }

                        Label {
                            id: titleLable
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: posterImg.bottom
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
        delegate: Rectangle {
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
                    height: width * 9 / 16
                    cache: true
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
            name: "loadmore"
            when: !dataRequest.isUpdatingIndex && articleList.contentHeight > 0
                  && (articleList.contentY > articleList.contentHeight - articleList.height - articleList.headerItem.height + 64)
            StateChangeScript {
                script: {
                    console.log("loadmore")
                    if (!dataRequest.isUpdatingIndex)
                        dataRequest.requestArticleList(dataRequest.articlePage + 1)
                }
            }
        },
        State {
            name: "refresh"
            when: !dataRequest.isUpdatingIndex && articleList.contentY < -64 - articleList.headerItem.height
            StateChangeScript {
                script: {
                    console.log("refresh")
                    if (!dataRequest.isUpdatingIndex) {
                        articlesModel.clear()
                        dataRequest.requestIndex()
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


