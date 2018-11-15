import QtQuick 2.11
import QtQuick.Controls 2.4

Page {
    title: resourceData.data("cnname") === "" ? resourceData.data("enname") : resourceData.data("cnname")

    ListView {

        anchors.fill: parent

        model: resItemModel

        delegate: Rectangle {

            id: delegate
            color: "#F2F2F2"
            width: parent.width
            height: labelRow.height + addressFlow.height + 20

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
                anchors.right: parent.right; anchors.rightMargin: 15
                text: size
            }

            MouseArea {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: addressFlow.top
                onPressed: addressFlow.state = (addressFlow.state === "open" ? "close" : "open")
            }

            Flow {
                id: addressFlow
                anchors.left: parent.left; anchors.leftMargin: 20
                anchors.top: labelRow.bottom; anchors.topMargin: 10
                spacing: 10
                clip: true
                state: "close"

                states: [
                    State {
                        name: "open"
                        PropertyChanges {
                            target: addressFlow
                            height: addressFlow.implicitHeight
                        }
                    },
                    State {
                        name: "close"
                        PropertyChanges {
                            target: addressFlow
                            height: 0
                        }
                    }
                ]

                transitions: [
                    Transition {
                        from: "close"; to: "open"
                        NumberAnimation { property: "height"; duration: 300; easing.type: Easing.InOutQuad }
                    },
                    Transition {
                        from: "open"; to: "close"
                        NumberAnimation { property: "height"; duration: 300; easing.type: Easing.InOutQuad }
                    }
                ]

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

    // ---------------------------------------------------------------
    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: dataRequest.isUpdatingResItem
    }
}
