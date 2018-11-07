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
            categoryLabel.text = resourceData.data("channel_cn") + (resourceData.data("tvstation") === "" ? "" : " - ") + resourceData.data("tvstation") + " @" + resourceData.data("premiere")
            statusLabel.text = resourceData.data("play_status")
            itemupdateLabel.text = resourceData.data("updatetime")
            remarkLabel.text = resourceData.data("remark")
            prevueLabel.text = "Prevue @" + resourceData.data("pre_play_time") + " " + resourceData.data("pre_week")
            favoritesLabel.text = "\u2764 " + resourceData.data("favorites")
            scoreLabel.text = resourceData.data("score")
            content.text = resourceData.data("content")
            prevueLabel.visible = resourceData.data("pre_play_time") !== ""
            busyIndicator.running = false
        }
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
//        anchors.bottom: posterImg.bottom
        spacing: ennameLabel.height

        Label { id: ennameLabel     }
        Label { id: categoryLabel   }
        Label { id: statusLabel     }
        Label { id: itemupdateLabel }
        Label { id: remarkLabel     }
        Label { id: prevueLabel     }
        Label { id: favoritesLabel  }
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
            text: qsTr("Contents")
        }

        TabButton {
            text: qsTr("Resources")
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
        Label {
            id: content
        }
        Rectangle {
            color: 'plum'
            implicitWidth: 300
            implicitHeight: 200
        }
    }


    // ---------------------------------------------------------------
    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: true
    }
}
