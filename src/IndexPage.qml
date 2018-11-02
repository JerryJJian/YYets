import QtQuick 2.11
import QtQuick.Controls 2.4

Item {


    ListView {
        anchors.fill: parent
        model: indexModel
        delegate: Rectangle {

            color: gray
            width: parent.width - 10
            height: 80


        }
    }

}
