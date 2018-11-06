import QtQuick 2.11
import QtQuick.Controls 2.4

Page {

    title: cnname

    Item {
        id: posterImg
        width:  parent.width / 3
        height: width
        anchors.left: parent.left
        anchors.top: parent.top

        Image {
            id: img
            anchors.centerIn: parent
            width:  sourceSize.width > sourceSize.height ? 100 : sourceSize.width * height / sourceSize.height
            height: sourceSize.width < sourceSize.height ? 100 : sourceSize.height * width / sourceSize.width
            source: poster
            cache: true
        }
    }

    Column {
        id: metaInfo
        anchors.left: posterImg.right; anchors.leftMargin: 10
        anchors.right: parent.right;   anchors.rightMargin: 10
        anchors.top: parent.top;       anchors.topMargin: 30
        anchors.bottom: posterImg.bottom

//        Label {
//            id: cnnameLabel
//            text: cnname
//            color: "#EC524B"
//            font.pixelSize: Qt.application.font.pixelSize * 1.6
//            font.bold: true
//        }

        Label {
            id: ennameLabel
            text: enname
        }

        Label {
            id: categoryLabel
            text: channel_cn + "-" + tvstation + "@" + publish_year
        }

        Label {
            id: statusLabel
            text: play_status
        }

        Label {
            id: itemupdateLabel
            text: itemupdate
        }

        Label {
            id: prevueLabel
            text: "@" + pre_play_time + " " + pre_week
        }
    }

    Label {
        id: scoreLabel
        text: score
        color: "#EC524B"
        font.pixelSize: Qt.application.font.pixelSize * 1.6
        font.bold: true
        anchors.top: metaInfo.top;
        anchors.right: metaInfo.right
    }

    TabBar {
        id: contentTab
        anchors.left: parent.left
        anchors.top: posterImg.bottom
        anchors.right: parent.right

    }

}
