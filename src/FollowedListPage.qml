import QtQuick 2.0
import QtQuick.Controls 2.4

Page {
    id: followedPage
    title: qsTr("Followed")
    signal openResource(int id)
    property int pageNum: 1
    property int pageSize: 50

    ListView {
        id: followedList
        anchors.fill: parent

        model: followedListModel

        delegate: Rectangle {
            width: followedList.width
            height: Math.max(posterImg.height, infoColumn.implicitHeight + infoColumn.anchors.topMargin * 2)

            Item {
                id: posterImg
                width:  100
                height: 100
                anchors.left: parent.left
                anchors.top:  parent.top

                Image {
                    id: img
                    anchors.centerIn: parent
                    width:  sourceSize.width > sourceSize.height ? 90 : sourceSize.width * height / sourceSize.height
                    height: sourceSize.width < sourceSize.height ? 90 : sourceSize.height * width / sourceSize.width
                    source: poster_m
                    cache:  true
                }
            }

            Column {
                id: infoColumn
                anchors.top: parent.top; anchors.topMargin: img.status === Image.Ready ? Math.abs(img.height - posterImg.height) / 2 : Qt.application.font.pixelSize
                anchors.left: posterImg.right
                anchors.right: parent.right
                spacing: Qt.application.font.pixelSize / 3

                Label {
                    text: cnname
                    wrapMode: Text.WordWrap
                    font.pixelSize: Qt.application.font.pixelSize
                    font.bold: true
                }

                Label {
                    text: enname
                    color: "gray"
                    font.pixelSize: Qt.application.font.pixelSize * 0.8
                    wrapMode: Text.WordWrap
                }

                Flow {
                    width: parent.width
                    spacing: Qt.application.font.pixelSize / 3

                    Label {
                        id: channelCNLabel
                        text: channel_cn
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
                        visible: text !== ""
                        width: implicitWidth + font.pixelSize
                        height: implicitHeight + font.pixelSize / 2
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: "#FFFFFF";
                        font.pixelSize: Qt.application.font.pixelSize * 0.66
                        background: Rectangle { radius: height / 3; color: "#282828"; }
                        text: category
                    }

                    Label {
                        id: areaLabel
                        text: area
                        visible: text !== "" && text.charAt(0) !== channelCNLabel.text.charAt(0)
                        width: implicitWidth + font.pixelSize
                        height: implicitHeight + font.pixelSize / 2
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: "#FFFFFF";
                        font.pixelSize: Qt.application.font.pixelSize * 0.66
                        background: Rectangle { radius: height / 3; color: "#282828"; }
                    }

                    Label {
                        text: lang
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
                        text: publish_year
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

                Flow {
                    width: parent.width
                    spacing: Qt.application.font.pixelSize / 3

                    Label {
                        text: itemupdate
                        visible: text !== ""
                        width: implicitWidth + font.pixelSize
                        height: implicitHeight + font.pixelSize / 2
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: "#FFFFFF";
                        font.pixelSize: Qt.application.font.pixelSize * 0.66
                        background: Rectangle { radius: height / 3; color: "#26b47f"; }
                    }

                    Label {
                        text: play_status
                        visible: text !== ""
                        width: implicitWidth + font.pixelSize
                        height: implicitHeight + font.pixelSize / 2
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: Qt.application.font.pixelSize * 0.66
                        color: "#FFFFFF";
                        background: Rectangle { radius: height / 3; color: "#26b47f"; }
                    }

                }

                Flow {
                    width: parent.width
                    spacing: Qt.application.font.pixelSize / 3

                    Label {
                        text: prevue_episode
                        visible: text !== ""
                        width: implicitWidth + font.pixelSize
                        height: implicitHeight + font.pixelSize / 2
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: Qt.application.font.pixelSize * 0.66
                        color: "#FFFFFF";
                        background: Rectangle { radius: height / 3; color: "#F26B3A"; }
                    }
                    Label {
                        text: prevue_play_time
                        visible: text !== ""
                        width: implicitWidth + font.pixelSize
                        height: implicitHeight + font.pixelSize / 2
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: Qt.application.font.pixelSize * 0.66
                        verticalAlignment: Text.AlignVCenter
                        color: "#FFFFFF";
                        background: Rectangle { radius: height / 3; color: "#F26B3A"; }
                    }
                    Label {
                        text: prevue_week
                        visible: text !== ""
                        width: implicitWidth + font.pixelSize
                        height: implicitHeight + font.pixelSize / 2
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: Qt.application.font.pixelSize * 0.66
                        verticalAlignment: Text.AlignVCenter
                        color: "#FFFFFF";
                        background: Rectangle { radius: height / 3; color: "#F26B3A"; }
                    }
                }
            }

            Label {
                anchors.top: infoColumn.top
                anchors.right: infoColumn.right; anchors.rightMargin: font.pixelSize
                width: implicitWidth + font.pixelSize
                height: implicitHeight * 1.5
                background: Rectangle {
                    color: "#4C8AD2"
                    radius: height / 4
                    border.color: "#9DC6F3"
                    border.width: 1
                }
                color: "white"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: score
                font.pixelSize: Qt.application.font.pixelSize * 0.8
            }

            Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: "#ededed" }
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                onClicked: openResource(id)
            }
        }

        states: [
            State {
                name: "refresh"
                when: followedList.contentY < -64
                StateChangeScript {
                    script: {
                        pageNum = 1
                        dataRequest.requestFollowedList(pageNum, pageSize)
                    }
                }
            },
            State {
                name: "loadmore"
                when: followedList.contentHeight > 0 && (followedList.contentY > followedList.contentHeight - followedList.height + 64)
                StateChangeScript {
                    script: {
                        dataRequest.requestFollowedList(pageNum + 1, pageSize)
                    }
                }
            }
        ]

        Connections {
            target: followedListModel
            onDataModelAppended: {
                pageNum = Math.ceil(followedListModel.count / pageSize)
            }
        }
    }

    Component.onCompleted: dataRequest.requestFollowedList(1, pageSize)
}
