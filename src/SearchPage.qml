import QtQuick 2.13
import QtQuick.Controls 2.13
import QtGraphicalEffects 1.13

Page {
    title: qsTr("Search")

    signal openResource(int id)
    signal openArticle(int id)

    property string searchType: "resource"
    property int pageNum: 0
    readonly property int pageSize: 10

    Connections {
        target: window
        onSetSearchType: {
            if (searchType !== type) {
                searchType = type
                if (searchText.text !== "") {
                    findButton.clicked()
                }
            }
        }
    }

    ToolButton {
        id: findButton
        anchors.right: parent.right; anchors.rightMargin: 10
        anchors.top: parent.top; anchors.topMargin: 10
        icon.source: "images/find.png"
        onClicked: {
            searchResourceModel.clear()
            dataRequest.searchResource(searchType, searchText.text)
        }
    }

    TextField {
        id: searchText
        anchors.top: findButton.top
        anchors.bottom: findButton.bottom
        anchors.left: parent.left; anchors.leftMargin: 10
        anchors.right: findButton.left; anchors.rightMargin: 10
        placeholderText: qsTr("Input the text...")
    }

    ListView {
        id: searchResultList
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: findButton.bottom
        anchors.bottom: parent.bottom
        clip: true
        model: searchResourceModel
        delegate: Rectangle {
            width: searchResultList.width
            height: Math.max(posterImg.height, infoColumn.implicitHeight + infoColumn.anchors.topMargin * 2)

            Item {
                id: posterImg
                width:  100
                height: 100
                anchors.left:  parent.left
                anchors.top:   parent.top

                Image {
                    id: img
                    anchors.centerIn: parent
                    width:  sourceSize.width > sourceSize.height ? 90 : sourceSize.width * height / sourceSize.height
                    height: sourceSize.width < sourceSize.height ? 90 : sourceSize.height * width / sourceSize.width
                    source: poster_m
                    cache:  true

                    layer.enabled: true
                    layer.effect: DropShadow {
                        horizontalOffset: 3
                        verticalOffset: 3
                        radius: 8.0
                        opacity: 0.33
                        samples: 17
                        color: "black"
                    }
                }
            }

            Column {
                id: infoColumn
                anchors.left: posterImg.right
                anchors.right: parent.right; anchors.rightMargin: spacing
                anchors.top: posterImg.top; anchors.topMargin: 10
                spacing: Qt.application.font.pixelSize / 3

                Label {
                    text: title
                    width: parent.width
                    wrapMode: Text.WrapAnywhere
                }

                Flow {
                    id: tagFlow
                    spacing: Qt.application.font.pixelSize / 2
                    property int flowWidth: (channelLabel.visible ? channelLabel.width + spacing : 0) +
                                            (prefixLabel.visible ? prefixLabel.width + spacing : 0) +
                                            (suffixLabel.visible ? suffixLabel.width + spacing : 0)



                    Label {
                        id: channelLabel
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
                        id: prefixLabel
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
                        id: suffixLabel
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
                        width: Math.min(implicitWidth + font.pixelSize, infoColumn.width - tagFlow.flowWidth)
                        height: implicitHeight + font.pixelSize / 2
                        font.pixelSize: Qt.application.font.pixelSize * 0.66;
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WrapAnywhere
                        color: "#FFFFFF"
                        background: Rectangle {
                            radius: Qt.application.font.pixelSize / 3
                            color: "#303030"
                        }
                    }
                }

                Label {
                    width: parent.width;
                    text: uptime + " - " + pubtime
                    font.pixelSize: font.pixelSize * 0.8;
                    color: "gray"
                }

            }
            Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: "#ededed" }
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                onClicked: {
                    if (searchType === "resource")
                        openResource(itemid)
                    else
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
                when: !!searchResultList.dragging && !dataRequest.isSearching && searchResultList.contentHeight > 0 && (searchResultList.contentY > searchResultList.contentHeight - searchResultList.height + 64)
                StateChangeScript {
                    script: {
                        if (searchText.text === "" || searchResourceModel.count % pageSize !== 0)
                            return ;

                        if (!dataRequest.isUpdatingResList)
                            dataRequest.searchResource(searchType, searchText.text, pageNum + 1, pageSize)
                    }
                }
            }
        ]

        Connections {
            target: searchResourceModel
            onDataModelAppended: {
                pageNum = Math.ceil(searchResourceModel.count / pageSize)
            }
        }
    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: dataRequest.isSearching
    }
}
