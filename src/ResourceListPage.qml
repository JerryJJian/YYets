import QtQuick 2.0
import QtQuick.Controls 2.4

Page {
    title: qsTr("Resource")
    signal openResource(int id)
    property int resourceCountPerPage: 30
    property string filterText: ""

    GridView {
        id: resourcelist
        anchors.fill: parent

        model: resourceListModel

        cellWidth: 150
        cellHeight: 180

        delegate: Rectangle {
            width: resourcelist.cellWidth
            height: resourcelist.cellHeight

            Item {
                id: posterImg
                width:  120
                height: 120
                anchors.left:  parent.left
                anchors.right: parent.right
                anchors.top:   parent.top

                Image {
                    id: img
                    anchors.centerIn: parent
                    width:  sourceSize.width > sourceSize.height ? 100 : sourceSize.width * height / sourceSize.height
                    height: sourceSize.width < sourceSize.height ? 100 : sourceSize.height * width / sourceSize.width
                    source: poster_m
                    cache:  true
                }
            }

            Label {
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                width: implicitWidth * 1.5
                height: implicitHeight * 1.5
                background: Rectangle {
                    color: "#4C8AD2"
                    radius: height / 4
                    border.color: "#9DC6F3"
                    border.width: 1
                }
                color: "white"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: score
                font.pixelSize: Qt.application.font.pixelSize * 0.8
            }

            Label {
                id: cnnamelabel
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: posterImg.bottom
                text: cnname
                wrapMode: Text.WordWrap
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: cnnamelabel.bottom; anchors.topMargin: 10
                text: enname
                color: "gray"
                font.pixelSize: Qt.application.font.pixelSize * 0.9
                wrapMode: Text.WordWrap
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                onClicked: openResource(id)
            }
        }

        states: [
            State {
                name: "refresh"
                when: resourcelist.contentY < -64
                StateChangeScript {
                    script: {
                        dataRequest.resourcePage = 1
                        if (!dataRequest.isUpdatingResList)
                            dataRequest.requestResourceList()
                    }
                }
            },
            State {
                name: "loadmore"
                when: resourcelist.contentHeight > 0 && (resourcelist.contentY > resourcelist.contentHeight - resourcelist.height + 64)
                StateChangeScript {
                    script: {
                        if (!dataRequest.isUpdatingResList)
                            dataRequest.requestResourceList(dataRequest.resourcePage + 1, resourceCountPerPage)
                    }
                }
            }
        ]

        Connections {
            target: resourceListModel
            onDataModelAppended: {
                dataRequest.resourcePage = Math.ceil(resourceListModel.count / resourceCountPerPage)
            }
        }
    }

    Connections {
        target: resourceListFilterData
        onRefreshView: {
            filterByAreaModel    = resourceListFilterData.data("area");
            filterByYearModel    = resourceListFilterData.data("year");
            filterBySortModel    = resourceListFilterData.data("sort");
            filterByChannelModel = resourceListFilterData.data("channel");
        }
    }

    Rectangle {
        id: filter

        anchors.left: parent.left; anchors.leftMargin: 10
        anchors.right: parent.right; anchors.rightMargin: 10
        height: filterButton.height

        MouseArea { anchors.fill: parent }

        ListModel { id: filterByAreaModel    }
        ListModel { id: filterByYearModel    }
        ListModel { id: filterBySortModel    }
        ListModel { id: filterByChannelModel }

        Column {
            anchors.left: parent.left
            anchors.right: parent.right
            height: areaRow.height

            Row {
                id: areaRow
                anchors.left: parent.left
                anchors.right: parent.right
                height: areaFlow.implicitHeight

                Label {
                    id: areaLabel
                    text: qsTr("By Area:")
                }

                Flow {
                    id: areaFlow
                    anchors.left: parent.left; anchors.leftMargin: areaLabel.width + 10
                    anchors.right: parent.right
                    Repeater {
                        model: filterByAreaModel
                        Label { text: modelData }
                    }
                }
            }

            Row {
                id: channelRow
                anchors.left: parent.left
                anchors.right: parent.right
                height: areaFlow.implicitHeight

                Label {
                    id: channelLabel
                    text: qsTr("By Area:")
                }

                Flow {
                    id: channelFlow
                    anchors.left: parent.left; anchors.leftMargin: channelLabel.width + 10
                    anchors.right: parent.right
                    Repeater {
                        model: filterByChannelModel
                        Label { text: key }
                    }
                }
            }
        }




    }

    ToolButton {
        id: filterButton
        anchors.top: parent.top; anchors.topMargin: 20
        anchors.right: parent.right; anchors.rightMargin: 20
        icon.source: filterText === "" ? "images/empty_filter.png" : "images/filled_filter.png"
    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: dataRequest.isUpdatingResList
    }

}
