import QtQuick 2.0
import QtQuick.Controls 2.4


Page {
    title: qsTr("Search")
    signal openResource(int id)
    property int pageNum: 0
    readonly property int pageSize: 10

    ToolButton {
        id: findButton
        anchors.right: parent.right; anchors.rightMargin: 10
        anchors.top: parent.top; anchors.topMargin: 10
        icon.source: "images/find.png"
        onClicked: {
            searchResourceModel.clear()
            dataRequest.searchResource(searchText.text)
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
            height: posterImg.height

            Item {
                id: posterImg
                width:  120
                height: 120
                anchors.left:  parent.left
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

            Column {
                anchors.left: posterImg.right
                anchors.right: parent.right; anchors.rightMargin: 15
                anchors.top: posterImg.top; anchors.topMargin: (posterImg.height - img.height)/2
                spacing: Qt.application.font.pixelSize

                Label {
                    text: title
                    width: parent.width
                    font.bold: true
                    wrapMode: Text.WrapAnywhere
                }

                Flow {
                    spacing: Qt.application.font.pixelSize / 2

                    Label {
                        text: channel;
                        width: implicitWidth + font.pixelSize
                        height: implicitHeight + font.pixelSize / 2
                        font.pixelSize: Qt.application.font.pixelSize * 0.9;
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
                        font.pixelSize: Qt.application.font.pixelSize * 0.9;
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
                        font.pixelSize: Qt.application.font.pixelSize * 0.9;
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
                        font.pixelSize: Qt.application.font.pixelSize * 0.9;
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        color: "#FFFFFF"
                        background: Rectangle {
                            radius: height / 3
                            color: "#303030"
                        }
                    }
                }

                Label {
                    width: parent.width;
                    text: pubtime;
                    font.pixelSize: Qt.application.font.pixelSize * 0.9;
                    color: "gray"
                }

            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                onClicked: openResource(itemid)
            }
        }

        states: [
            State {
                name: "none"
                when: searchResultList.contentY === 0
            },
            State {
                name: "loadmore"
                when: !dataRequest.isSearching && searchResultList.contentHeight > 0 && (searchResultList.contentY > searchResultList.contentHeight - searchResultList.height + 64)
                StateChangeScript {
                    script: {
                        if (searchText.text === "" || searchResourceModel.count % pageSize !== 0)
                            return ;

                        if (!dataRequest.isUpdatingResList)
                            dataRequest.searchResource(searchText.text, pageNum + 1, pageSize)
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
