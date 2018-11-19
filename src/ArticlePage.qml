import QtQuick 2.0
import QtQuick.Controls 2.4

Page {

    title: qsTr("Article")

    Connections {
        target: articleData
        onRefreshView: {
            title = articleData.data("title")
            authorLabel.text  = articleData.data("author")
            timeLabel.text    = articleData.data("dateline") + "/" +  qsTr("Views ") + articleData.data("views")
            introLabel.text   = articleData.data("intro")
            contentLabel.text = articleData.data("content")
        }
    }

    ScrollView {
        anchors.left: parent.left; anchors.leftMargin: 15
        anchors.right: parent.right; anchors.rightMargin: 15
        anchors.top: parent.top; anchors.topMargin: 15
        anchors.bottom: parent.bottom; anchors.bottomMargin: 15
        contentWidth: width
        contentHeight: articleContent.implicitHeight
        ScrollBar.horizontal.interactive: true
        ScrollBar.vertical.interactive: true

        Column {
            id: articleContent
            spacing: 15
            anchors.fill: parent

            Item {
                width: parent.width
                height: authorLabel.contentHeight
                Label {
                    id: authorLabel
                    color: "gray"
                    anchors.left: parent.left
                }
                Label {
                    id: timeLabel
                    color: "gray"
                    anchors.right: parent.right
                }
            }

            Rectangle {
                color: "#EBECF0"
                width: parent.width
                height: introLabel.implicitHeight

                Label {
                    id: introLabel
                    color: "gray"
                    anchors.fill: parent
                    wrapMode: Text.WordWrap
                }
            }

            Text {
                id: contentLabel
                wrapMode: Text.Wrap
                width: parent.width
            }

        }

    }


}