import QtQuick 2.13
import QtQuick.Controls 2.13

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
    property alias p_reply_good: replygoodLabel.text
    property alias p_reply_bad: replybadLabel.text
    property alias p_reply_avatar_s: reAvatarImg.source
    property alias p_reply_content: reContentLabel.text


    Label {
        id: userLabel
        anchors.top: parent.top; anchors.topMargin: 5
        anchors.left: parent.left;
        anchors.leftMargin: 5
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
            font.pixelSize: Qt.application.font.pixelSize * 0.66
        }

        Image {
            height: goodLabel.font.pixelSize
            width: height
            source: "images/good.png"
            cache: false
        }
        Label { id: goodLabel; color: "gray"; font.pixelSize: Qt.application.font.pixelSize * 0.66 }

        Image {
            height: badLabel.font.pixelSize
            width: height
            source: "images/bad.png"
            cache: false
        }
        Label { id: badLabel; color: "gray"; font.pixelSize: Qt.application.font.pixelSize * 0.66 }
    }

    Rectangle {
        id: avatarItem
        width:  36
        height: 36
        radius: height / 2
        clip: true
        anchors.left: userLabel.left
        anchors.top:  userLabel.bottom;

        Image {
            id: avatarImg
            anchors.fill: parent
            cache:  true
        }
    }

    Column {
        id: sessionInfo
        anchors.left: avatarItem.right; anchors.leftMargin: 10
        anchors.right: parent.right; anchors.rightMargin: 10
        anchors.top: userLabel.bottom
        spacing: Qt.application.font.pixelSize / 3

        Label {
            id: contentLabel
            width: parent.width
            wrapMode: Text.WrapAnywhere
            lineHeight: 1.5
        }

        Rectangle {
            id: replyArea
            width: parent.width - Qt.application.font.pixelSize * 2
            height: visible ? (reUserLabel.implicitHeight + Math.max(reContentLabel.implicitHeight, reAvatarItem.height) + 10) : 5
            border.color: "#EEEEEE"
            border.width: 1
            radius: Qt.application.font.pixelSize / 3

            Label {
                id: reUserLabel
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.leftMargin: 5
                padding: font.pixelSize / 3
                font.bold: true
                font.pixelSize: Qt.application.font.pixelSize * 0.9
                color: "gray"
                lineHeight: 1.5
            }

            Rectangle {
                id: reAvatarItem
                width:  36
                height: 36
                anchors.left: reUserLabel.left
                anchors.top:  reUserLabel.bottom
                radius: height / 2
                clip: true

                Image {
                    id: reAvatarImg
                    anchors.fill: parent
                    cache:  true
                }
            }

            Row {
                id: replyInfobar
                anchors.top: reUserLabel.top
                anchors.topMargin: 5
                anchors.right: parent.right
                anchors.rightMargin: 10
                spacing: 3

                Image {
                    height: replygoodLabel.font.pixelSize
                    width: height
                    source: "images/good.png"
                    cache: false
                }
                Label { id: replygoodLabel; color: "gray"; font.pixelSize: Qt.application.font.pixelSize * 0.66 }

                Image {
                    height: replybadLabel.font.pixelSize
                    width: height
                    source: "images/bad.png"
                    cache: false
                }
                Label { id: replybadLabel; color: "gray"; font.pixelSize: Qt.application.font.pixelSize * 0.66 }
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
