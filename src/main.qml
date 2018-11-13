import QtQuick 2.11
import QtQuick.Controls 2.4

ApplicationWindow {
    id: window
    visible: true
    width: 640
    height: 480
    title: qsTr("Tabs")

    header: ToolBar {
        contentHeight: toolButton.implicitHeight

        ToolButton {
            id: toolButton
            text: stackView.depth > 1 ? "\u25C0" : "\u2630"
            font.pixelSize: Qt.application.font.pixelSize * 1.6
            onClicked: {
                if (stackView.depth > 1) {
                    stackView.pop()
                } else {
                    drawer.open()
                }
            }
        }

        Label {
            text: stackView.currentItem.title
            anchors.centerIn: parent
        }
    }

    Drawer {
        id: drawer
        width: window.width * 0.66
        height: window.height

        Column {
            anchors.fill: parent

            ItemDelegate {
                text: qsTr("Top")
                width: parent.width
                onClicked: {
                    while (stackView.depth > 0) stackView.pop()
                    stackView.push(indexPage)
                    drawer.close()
                }
            }
        }
    }
    property Component resourceItemPage: ResourceItemPage { }

    property Component resourcePage: ResourcePage {
        onOpenResourceItem: {
            stackView.push(resourceItemPage)
            stackView.currentItem.forceActiveFocus()
            dataRequest.requestResourceItem(id, season, episode)
        }
    }

    property Component indexPage: IndexPage {
        onOpenResource: {
            stackView.push(resourcePage)
            stackView.currentItem.forceActiveFocus()
            dataRequest.requestResource(id)
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: indexPage

        onCurrentItemChanged: {
            currentItem.forceActiveFocus();
        }
    }
}
