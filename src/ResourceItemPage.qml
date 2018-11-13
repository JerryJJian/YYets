import QtQuick 2.11
import QtQuick.Controls 2.4

Page {
    title: qsTr("Resource Page")



    ListView {

        anchors.fill: parent

        model: resItemModel

        delegate: Rectangle {

            id: delegate
            color: "#F2F2F2"
            width: parent.width
            height: 40

            Row {
                id: labelRow
                height: formatLabel.height
                anchors.left: parent.left; anchors.leftMargin: 20
                anchors.top: parent.top; anchors.topMargin: 10
                Label {
                    id: formatLabel;
                    background: Rectangle {
                        height: parent.implicitHeight * 1.5
                        width: parent.implicitWidth * 1.2
                        color: "#F3F3F3"
                    }
                    anchors.verticalCenter: parent.verticalCenter
                    text: foramt
                }
                Label {
                    id: formatTipLabel;
                    background: Rectangle {
                        height: parent.implicitHeight * 1.5
                        width: parent.implicitWidth * 1.2
                        color: "#2475ec"
                    }
                    anchors.verticalCenter: parent.verticalCenter
                    text: format_tip
                }
            }

//            Flow {
//                anchors.left: parent.left; anchors.leftMargin: 20
//                anchors.top: labelRow.bottom; anchors.topMargin: 10

//                Repeater {
//                    model: ListModel { id: itemModel }
//                }
//            }


        }


    }
}
