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
            height: labelRow.height + addressFlow.implicitHeight + 30

            Row {
                id: labelRow
                height: formatLabel.height
                anchors.left: parent.left; anchors.leftMargin: 10
                anchors.top: parent.top; anchors.topMargin: 10
                Label {
                    id: formatLabel;
                    height: implicitHeight * 1.5
                    width: implicitWidth * 1.2
                    background: Rectangle { color: "#F08619" }
                    text: foramt
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                Label {
                    id: formatTipLabel;
                    height: implicitHeight * 1.5
                    width: implicitWidth * 1.2
                    background: Rectangle { color: "#01AFEC" }
                    text: format_tip
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Label {
                id: sizeLabel
                anchors.verticalCenter: labelRow.verticalCenter
                anchors.right: parent.right
                text: size
            }

            Flow {
                id: addressFlow
                anchors.left: parent.left; anchors.leftMargin: 20
                anchors.top: labelRow.bottom; anchors.topMargin: 10
                spacing: 10

                Repeater {
                    model: filelist
                    ToolButton {
                        text: modelData
                        ToolTip.visible: pressed
                        ToolTip.delay: 3
                        ToolTip.text: qsTr("The item address has copied!")
                        onClicked: {
                            clipboard.text = resItemModel.convertToString(resItemModel.query(resItemModel.index, "files", index+"/address"))
                        }
                    }
                }
            }

            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 1
                color: "#FDFDFD"
            }


        }


    }
}
