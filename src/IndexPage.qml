import QtQuick 2.11
import QtQuick.Controls 2.4

ListView {
    model: indexModel

    delegate: Rectangle {
        id: delegate
        color: "#F2F2F2"
        width: parent.width
        height: 120

        Item {
            id: posterImg
            width:  120
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            Image {
                id: img
                anchors.centerIn: parent
                width:  sourceSize.width > sourceSize.height ? 100 : sourceSize.width * height / sourceSize.height
                height: sourceSize.width < sourceSize.height ? 100 : sourceSize.height * width / sourceSize.width
                source: poster
                cache: true
            }
        }

        Text {
            id: title
            anchors.left: posterImg.right
            anchors.leftMargin: 20
            anchors.top: posterImg.top
            anchors.topMargin: 20
            text: cnname
            font.pointSize: 14
            font.bold: true
        }

        Text {
            id: typeText
            anchors.left: title.left
            anchors.top: title.bottom; anchors.topMargin: 15
            text: "#" + channel + ": " + category
        }

        Text {
            anchors.left: typeText.left
            anchors.top: typeText.bottom; anchors.topMargin: 10
            text: "@" + publish_year + " " + play_status
        }

        MouseArea {
            id: ma
            anchors.fill: parent
            onClicked: console.log("open item #" + id)
        }

        Rectangle {
            height: 1
            anchors.left: parent.left
            anchors.right: parent.right;
            anchors.bottom: parent.bottom
            color: "#f0f0f0"
        }
    }
}

