import QtQuick 2.11
import QtQuick.Controls 2.4

ApplicationWindow {
    id: window
    visible: true
    width: 640
    height: 480
    title: qsTr("Tabs")
    readonly property bool inPortrait: window.width < window.height
    property alias inResourceListView: filterButton.visible
    signal showFilterPopup()

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
            anchors.centerIn: parent
        }

        ToolButton {
            id: filterButton
            icon.source: "images/empty_filter.png"
            anchors.right: parent.right
            visible: false
            onClicked: showFilterPopup()
        }

    }

    property Component articlePage: ArticlePage {
        property string pageType: "articlePage"
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
        onOpenResource: {
            stackView.push(resourcePage)
            dataRequest.requestResource(id)
        }

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

            ItemDelegate {
                text: qsTr("Resource")
                width: parent.width
                onClicked: {
                    stackView.push(resourceListPage)
                    if (inPortrait) drawer.close()
                    dataRequest.requestResourceList()
                }
            }
            ItemDelegate {
                text: qsTr("Search")
                width: parent.width
                onClicked: {
                    stackView.push(searchResourcePage)
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
                inResourceListView = currentItem.pageType === "resourceListPage"
                currentItem.forceActiveFocus();
            }
        }
    }

    Component.onCompleted: dataRequest.requestIndex()
}
