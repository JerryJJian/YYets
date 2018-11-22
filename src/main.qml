import QtQuick 2.11
import QtQuick.Controls 2.4

ApplicationWindow {
    id: window
    visible: true
    width: 640
    height: 960
    title: qsTr("Ticket")
    readonly property bool inPortrait: window.width < window.height
    signal showFilterPopup()
    signal setSearchType(string type)
    signal showArticleView(string type)

    header: ToolBar {
        anchors.left: parent.left
        anchors.leftMargin: !inPortrait && drawer.position == 1 ? drawer.width : 0
        anchors.right: parent.right

        contentHeight: toolButton.implicitHeight

        ToolButton {
            id: toolButton
            text: stackView.depth > 1 ? "\u25C0" : "\u2630"
            font.pixelSize: Qt.application.font.pixelSize * 1.6
            onClicked: {
                if (stackView.depth > 1) {
                    stackView.pop()
                } else {
                    if (inPortrait)
                        drawer.open()
                    else
                        drawer.position = drawer.position == 0 ? 1 : 0
                }
            }
        }

        Label {
            text: stackView.currentItem.title
            anchors.left: toolButton.right
            anchors.right: toolRow.left
            anchors.verticalCenter: parent.verticalCenter
            clip: true
            horizontalAlignment: Text.AlignHCenter
        }

        Row {
            id: toolRow
            anchors.right: parent.right; anchors.rightMargin: 5
            anchors.verticalCenter: parent.verticalCenter

            ToolButton {
                id: filterButton
                icon.source: "images/filter.png"
                visible: stackView.currentItem.pageType === "resourceListPage"
                onClicked: showFilterPopup()
            }
            ToolButton {
                id: searchResourceButton
                icon.source: "images/movie.png"
                visible: stackView.currentItem.pageType === "searchResourcePage"
                highlighted: visible && stackView.currentItem.searchType === "resource"
                onClicked: {
                    stackView.currentItem.searchType = "resource"
                    setSearchType("resource")
                }
            }
            ToolButton {
                id: searchArticleButton
                icon.source: "images/news.png"
                visible: stackView.currentItem.pageType === "searchResourcePage"
                highlighted: visible && stackView.currentItem.searchType === "article"
                onClicked: {
                    stackView.currentItem.searchType = "article"
                    setSearchType("article")
                }
            }

            ToolButton {
                id: articleContentButton
                icon.source: "images/news.png"
                visible: stackView.currentItem.pageType === "articlePage"
                highlighted: visible && stackView.currentItem.currentView === "article"
                onClicked: {
                    stackView.currentItem.currentView = "article"
                    showArticleView("article")
                }
            }
            ToolButton {
                id: articleRelativeButton
                icon.source: "images/link.png"
                visible: stackView.currentItem.pageType === "articlePage"
                highlighted: visible && stackView.currentItem.currentView === "relative"
                onClicked: {
                    stackView.currentItem.currentView = "relative"
                    showArticleView("relative")
                }
            }
            ToolButton {
                id: articleCommentsButton
                icon.source: "images/comment.png"
                visible: stackView.currentItem.pageType === "articlePage"
                highlighted: visible && stackView.currentItem.currentView === "comments"
                onClicked: {
                    stackView.currentItem.currentView = "comments"
                    showArticleView("comments")
                }
            }
        }

    }

    property Component articlePage: ArticlePage {
        property string pageType: "articlePage"
        property string currentView: "article"
        onOpenResource: {
            stackView.push(resourcePage)
            dataRequest.requestResource(id)
        }
        onOpenArticle: {
            stackView.push(articlePage)
            dataRequest.requestArticle(id)
        }
    }

    property Component resourceItemPage: ResourceItemPage {
        property string pageType: "resourceItemPage"
    }

    property Component resourcePage: ResourcePage {
        property string pageType: "resourcePage"
        onOpenResourceItem: {
            stackView.push(resourceItemPage)
            resItemModel.clear()
            dataRequest.requestResourceItem(id, season, episode)
        }
    }

    property Component indexPage: IndexPage {
        property string pageType: "indexPage"
        onOpenResource: {
            stackView.push(resourcePage)
            dataRequest.requestResource(id)
        }
        onOpenArticle: {
            stackView.push(articlePage)
            dataRequest.requestArticle(id)
        }
    }

    property Component resourceListPage: ResourceListPage {
        property string pageType: "resourceListPage"
        onOpenResource: {
            stackView.push(resourcePage)
            dataRequest.requestResource(id)
        }

    }
    property Component searchResourcePage: SearchPage {
        property string pageType: "searchResourcePage"
        property string searchType: "resource"
        onOpenResource: {
            stackView.push(resourcePage)
            dataRequest.requestResource(id)
        }
        onOpenArticle: {
            stackView.push(articlePage)
            dataRequest.requestArticle(id)
        }
    }
    property Component followedListPage: FollowedListPage {
        property string pageType: "followedListPage"
    }

    Drawer {
        id: drawer
        width: 150
        height: window.height
        modal: inPortrait
        interactive: inPortrait
        position: inPortrait ? 0 : 1
        visible: !inPortrait
        dragMargin: Qt.styleHints.startDragDistance

        Column {
            anchors.fill: parent

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                source: "images/ticket.png"
                width: parent.width * 0.66
                height: width
            }

            ItemDelegate {
                text: qsTr("Top")
                icon.source: "images/top.png"
                width: parent.width
                enabled: stackView.currentItem.pageType !== "indexPage"
                onClicked: {
                    stackView.pop()
                    if (inPortrait) drawer.close()
                    dataRequest.requestIndex()
                }
            }

            ItemDelegate {
                text: qsTr("Resource")
                icon.source: "images/movie.png"
                width: parent.width
                enabled: stackView.currentItem.pageType !== "resourceListPage"
                onClicked: {
                    stackView.pop()
                    stackView.push(resourceListPage)
                    if (inPortrait) drawer.close()
                    dataRequest.requestResourceList()
                }
            }
            ItemDelegate {
                text: qsTr("Search")
                icon.source: "images/find.png"
                width: parent.width
                enabled: stackView.currentItem.pageType !== "searchResourcePage"
                onClicked: {
                    stackView.pop()
                    stackView.push(searchResourcePage)
                    if (inPortrait) drawer.close()
                }
            }
            ItemDelegate {
                text: qsTr("Followed")
                icon.source: "images/follow.png"
                width: parent.width
                enabled: stackView.currentItem.pageType !== "followedListPage"
                onClicked: {
                    stackView.pop()
                    stackView.push(followedListPage)
                    if (inPortrait) drawer.close()
                }
            }
        }
    }

    StackView {
        id: stackView
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: !inPortrait && drawer.position == 1  ? drawer.width : 0
        anchors.right: parent.right
        initialItem: indexPage

        onCurrentItemChanged: {
            if (currentItem){
                currentItem.forceActiveFocus();
            }
        }
    }

    Component.onCompleted: dataRequest.requestIndex()
}
