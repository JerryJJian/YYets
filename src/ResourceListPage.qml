import QtQuick 2.0
import QtQuick.Controls 2.4

Page {
    id: reslistpage
    title: qsTr("Resource")
    signal openResource(int id)
    property int resourceCountPerPage: 30
    property string filterText: ""

    property int filterAreaIndex: 0
    property int filterChannelIndex: 0
    property int filterYearIndex: 0
    property int filterSortIndex: 0

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

                Column {
                    anchors.top: img.top
                    anchors.left: posterImg.left; anchors.leftMargin: 15
                    spacing: Qt.application.font.pixelSize * 0.5
                    Label {
                        width: implicitWidth + font.pixelSize
                        height: implicitHeight * 1.5
                        background: Rectangle {
                            color: "#F26B3A"
                            radius: height / 4
                            border.color: "#9DC6F3"
                            border.width: 1
                        }
                        color: "white"
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: channel_cn
                        font.pixelSize: Qt.application.font.pixelSize * 0.8
                    }
                }
            }

            Label {
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                width: implicitWidth + font.pixelSize
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
                        if (!dataRequest.isUpdatingResList) {
                            dataRequest.requestResourceList(1, resourceCountPerPage,
                                                            filterByAreaModel.get(filterAreaIndex).key,
                                                            filterBySortModel.get(filterSortIndex).key,
                                                            filterByChannelModel.get(filterChannelIndex).key,
                                                            filterByYearModel.get(filterYearIndex).key)
                        }
                    }
                }
            },
            State {
                name: "loadmore"
                when: resourcelist.contentHeight > 0 && (resourcelist.contentY > resourcelist.contentHeight - resourcelist.height + 64)
                StateChangeScript {
                    script: {
                        if (!dataRequest.isUpdatingResList)
                            dataRequest.requestResourceList(dataRequest.resourcePage + 1, resourceCountPerPage,
                                                            filterByAreaModel.get(filterAreaIndex).key,
                                                            filterBySortModel.get(filterSortIndex).key,
                                                            filterByChannelModel.get(filterChannelIndex).key,
                                                            filterByYearModel.get(filterYearIndex).key)
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

    Popup {
        id: filter

        width:  parent.width * 0.8
        height: filterDataColumn.implicitHeight + 60

        Connections {
            target: window
            onShowFilterPopup: filter.open()
        }

        Connections {
            target: resourceListFilterData
            onRefreshView: {
                filterByAreaModel.clear()
                filterByYearModel.clear()
                filterBySortModel.clear()
                filterByChannelModel.clear()

                filterByAreaModel.append({"key": qsTr("All"), "value": "" })
                for (var i=0; i<resourceListFilterData.dataListSize("area"); ++i)
                    filterByAreaModel.append({"key": resourceListFilterData.dataListAt("area", i),
                                              "value": resourceListFilterData.dataListAt("area", i)})

                filterByYearModel.append({"key": qsTr("All"), "value": "" })
                for (i=0; i<resourceListFilterData.dataListSize("year"); ++i)
                    filterByYearModel.append({"key": resourceListFilterData.dataListAt("year", i),
                                              "value": resourceListFilterData.dataListAt("year", i)})

                filterByChannelModel.append({"key": qsTr("All"), "value": ""})
                for (i=0; i<resourceListFilterData.dataListSize("channel/keys"); ++i)
                    filterByChannelModel.append({"key"  : resourceListFilterData.dataListAt("channel/keys", i),
                                                 "value": resourceListFilterData.dataListAt("channel/values", i)})

                for (i=0; i<resourceListFilterData.dataListSize("sort/keys"); ++i) {
                    filterBySortModel.append({"key"  : resourceListFilterData.dataListAt("sort/keys", i),
                                              "value": resourceListFilterData.dataListAt("sort/values", i)})
                }

                reslistpage.title = (filterAreaIndex > 0 ? filterByAreaModel.get(filterAreaIndex).key + " " : "")
                        + (filterChannelIndex > 0 ? filterByChannelModel.get(filterChannelIndex).key + " " : "")
                        + (filterYearIndex > 0 ? filterByYearModel.get(filterYearIndex).key + " " : "" )
                        + filterBySortModel.get(filterSortIndex).key


            }
        }

        ListModel { id: filterByAreaModel    }
        ListModel { id: filterByYearModel    }
        ListModel { id: filterBySortModel    }
        ListModel { id: filterByChannelModel }

        Column {
            id: filterDataColumn
            anchors.top: parent.top; anchors.topMargin: 10
            anchors.left: parent.left
            anchors.right: parent.right

            Flow {
                id: areaFlow
                width: parent.width - 20
                Repeater {
                    model: filterByAreaModel
                    ToolButton {
                        text: key
                        highlighted: filterAreaIndex === index
                        onClicked: filterAreaIndex = index
                    }
                }
            }

            Rectangle { color: "#839496"; height: 1 }

            Flow {
                id: yearFlow
                width: parent.width - 20
                Repeater {
                    model: filterByYearModel
                    ToolButton {
                        text: key
                        highlighted: filterYearIndex === index
                        onClicked: filterYearIndex = index
                    }
                }
            }

            Rectangle { color: "#839496"; height: 1 }
            Flow {
                id: channelFlow
                width: parent.width - 20
                Repeater {
                    model: filterByChannelModel
                    ToolButton {
                        text: key
                        highlighted: filterChannelIndex === index
                        onClicked: filterChannelIndex = index
                    }
                }
            }

            Rectangle { color: "#839496"; height: 1 }
            Flow {
                id: sortFlow
                width: parent.width - 20
                Repeater {
                    model: filterBySortModel
                    ToolButton {
                        text: key
                        highlighted: filterSortIndex === index
                        onClicked: filterSortIndex = index
                    }
                }
            }
            Rectangle { color: "#839496"; height: 1 }
        }

        onClosed: {
            resourceListModel.clear()
            dataRequest.resourcePage = 1
            dataRequest.requestResourceList(1, resourceCountPerPage,
                                            filterByAreaModel.get(filterAreaIndex).key,
                                            filterBySortModel.get(filterSortIndex).key,
                                            filterByChannelModel.get(filterChannelIndex).key,
                                            filterByYearModel.get(filterYearIndex).key)
        }
    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: dataRequest.isUpdatingResList
    }

}
