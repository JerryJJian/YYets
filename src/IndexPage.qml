import QtQuick 2.11
import QtQuick.Controls 2.4

ListView {
    model: indexModel
    delegate: Rectangle {

        color: gray
        width: parent.width - 10
        height: 120

        Image {
            id: posterImg
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.verticalCenter: parent.verticalCenter
            width: 66
            height: 100
            source: poster
        }

        Label {
            anchors.left: posterImg.right
            anchors.leftMargin: 20
            anchors.top: posterImg.top
            text: cnname
        }
    }
}

