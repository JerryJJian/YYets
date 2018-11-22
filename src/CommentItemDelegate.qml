import QtQuick 2.0
import QtQuick.Controls 2.4

Rectangle {

    height: Math.max(sessionInfo.implicitHeight, avatarItem.height) + userLabel.implicitHeight + 30

    property alias p_user: userLabel.text
    property alias p_dateline: datelineLabel.text
    property alias p_good: goodLabel.text
    property alias p_bad: badLabel.text
    property alias p_content: contentLabel.text
    property alias p_avatar_s: avatarImg.source
    property alias p_replyShown: replyArea.visible
    property alias p_reply_user: reUserLabel.text
    property alias p_reply_dateline: reply_datelineLabel.text
    property alias p_reply_good: replygoodLabel.text
    property alias p_reply_bad: replybadLabel.text
    property alias p_reply_avatar_s: reAvatarImg.source
    property alias p_reply_content: reContentLabel.text


    Label {
        id: userLabel
        anchors.top: parent.top; anchors.topMargin: 10
        anchors.left: parent.left;
        anchors.leftMargin: avatarImg.state === Image.Ready ? Math.abs((avatarImg.width - avatarItem.width)/2) : 10

        height: implicitHeight + font.pixelSize
        font.bold: true
        verticalAlignment: Text.AlignVCenter
    }

    Row {
        id: infobar
        anchors.verticalCenter: userLabel.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 5
        spacing: 3

        Label {
            id: datelineLabel
            color: "gray"
            font.pixelSize: Qt.application.font.pixelSize * 0.9
        }

        Image {
            height: Qt.application.font.pixelSize
            width: height
            source: "images/good.png"
            cache: false
        }
        Label { id: goodLabel; color: "gray"; font.pixelSize: Qt.application.font.pixelSize * 0.9 }

        Image {
            height: Qt.application.font.pixelSize
            width: height
            source: "images/bad.png"
            cache: false
        }
        Label { id: badLabel; color: "gray"; font.pixelSize: Qt.application.font.pixelSize * 0.9 }
    }

    Item {
        id: avatarItem
        width:  64
        height: 64
        anchors.left: userLabel.left
        anchors.top:  userLabel.bottom;
        anchors.topMargin: avatarImg.state === Image.Ready ? (avatarImg.height - avatarItem.height) / 2 : 0

        Image {
            id: avatarImg
            anchors.centerIn: parent
            width:  sourceSize.width > sourceSize.height ? avatarItem.width : sourceSize.width * height / sourceSize.height
            height: sourceSize.width < sourceSize.height ? avatarItem.width : sourceSize.height * width / sourceSize.width
            cache:  true
        }
    }

    Column {
        id: sessionInfo
        anchors.left: avatarItem.right
        anchors.right: parent.right
        anchors.top: avatarItem.anchors.top
        anchors.topMargin: avatarItem.anchors.topMargin
        spacing: Qt.application.font.pixelSize / 2

        Label {
            id: contentLabel
            width: parent.width
            lineHeight: 1.5
            padding: font.pixelSize
            wrapMode: Text.WrapAnywhere
        }

        Rectangle {
            id: replyArea
            width: parent.width - Qt.application.font.pixelSize * 2
            height: visible ? (reUserLabel.implicitHeight + Math.max(reContentLabel.implicitHeight, reAvatarItem.height)) : 0
            border.color: "#EEEEEE"
            border.width: 1
            radius: Qt.application.font.pixelSize / 3

            Label {
                id: reUserLabel
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.leftMargin: reAvatarImg.state === Image.Ready ? Math.abs((reAvatarImg.width - reAvatarItem.width)/2) : 10
                padding: font.pixelSize / 3
                font.bold: true
                color: "gray"
                lineHeight: 1.5
            }

            Item {
                id: reAvatarItem
                width:  64
                height: 64
                anchors.left: reUserLabel.left
                anchors.top:  reUserLabel.bottom
                anchors.topMargin: reAvatarImg.state === Image.Ready ? (reAvatarImg.height - reAvatarItem.height) / 2 : 0

                Image {
                    id: reAvatarImg
                    anchors.centerIn: parent
                    width:  sourceSize.width > sourceSize.height ? reAvatarItem.width : sourceSize.width * height / sourceSize.height
                    height: sourceSize.width < sourceSize.height ? reAvatarItem.width : sourceSize.height * width / sourceSize.width
                    cache:  true
                }
            }

            Row {
                id: replyInfobar
                anchors.top: reUserLabel.top
                anchors.topMargin: 5
                anchors.right: parent.right
                anchors.rightMargin: 5
                spacing: 3

                Label {
                    id: reply_datelineLabel
                    color: "gray"
                    font.pixelSize: Qt.application.font.pixelSize * 0.9
                }

                Image {
                    height: Qt.application.font.pixelSize
                    width: height
                    source: "images/good.png"
                    cache: false
                }
                Label { id: replygoodLabel; color: "gray"; font.pixelSize: Qt.application.font.pixelSize * 0.9 }

                Image {
                    height: Qt.application.font.pixelSize
                    width: height
                    source: "images/bad.png"
                    cache: false
                }
                Label { id: replybadLabel; color: "gray"; font.pixelSize: Qt.application.font.pixelSize * 0.9 }
            }

            Label {
                id: reContentLabel
                padding: font.pixelSize / 2
                wrapMode: Text.WrapAnywhere
                anchors.left: reAvatarItem.right
                anchors.leftMargin: reUserLabel.anchors.leftMargin
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.top: reUserLabel.bottom
                lineHeight: 1.5
                color: "gray"
            }
        }
    }

    Rectangle { width: parent.width; height: 1; color: "#ECECEC"; anchors.bottom: parent.bottom }

}
