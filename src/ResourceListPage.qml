import QtQuick 2.13
import QtQuick.Controls 2.13
import QtGraphicalEffects 1.13

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

        cellWidth: 120
        cellHeight: 160

        delegate: Rectangle {
            width: resourcelist.cellWidth
            height: resourcelist.cellHeight

            Item {
                id: posterImg
                width:  110
                height: 110
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

                    layer.enabled: true
                    layer.effect: DropShadow {
                        horizontalOffset: 3
                        verticalOffset: 3
                        radius: 8.0
                        opacity: 0.33
                        samples: 17
                        color: "black"
                    }
                }

                Image {
                    id: followFlag
                    anchors.right: img.right; anchors.rightMargin: - width * 0.33
                    anchors.bottom: parent.bottom
                    height: Qt.application.font.pixelSize * 2
                    width: height
                    source: "images/heart.png"
                    visible: followed
                }

                Column {
                    anchors.top: img.top
                    anchors.left: posterImg.left; anchors.leftMargin: 5
                    spacing: Qt.application.font.pixelSize * 0.1
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
                        font.pixelSize: Qt.application.font.pixelSize * 0.5
                    }
                    Label {
                        width: implicitWidth + font.pixelSize
                        height: implicitHeight * 1.5
                        background: Rectangle {
                            color: "#78C257"
                            radius: height / 4
                            border.color: "#4bbe93"
                            border.width: 1
                        }
                        color: "white"
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: publish_year
                        visible: text !== ""
                        font.pixelSize: Qt.application.font.pixelSize * 0.5
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
                font.pixelSize: Qt.application.font.pixelSize * 0.5
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
                when: !resourcelist.dragging && resourcelist.contentY < -64
                StateChangeScript {
                    script: {
                        dataRequest.resourcePage = 1
                        if (!dataRequest.isUpdatingResList) {
                            dataRequest.requestResourceList(1, resourceCountPerPage,
                                                            filterByAreaModel.get(filterAreaIndex).value,
                                                            filterBySortModel.get(filterSortIndex).value,
                                                            filterByChannelModel.get(filterChannelIndex).value,
                                                            filterByYearModel.get(filterYearIndex).value)
                        }
                    }
                }
            },
            State {
                name: "loadmore"
                when: !resourcelist.dragging && resourcelist.contentHeight > 0 && (resourcelist.contentY > resourcelist.contentHeight - resourcelist.height + 64)
                StateChangeScript {
                    script: {
                        if (!dataRequest.isUpdatingResList)
                            dataRequest.requestResourceList(dataRequest.resourcePage + 1, resourceCountPerPage,
                                                            filterByAreaModel.get(filterAreaIndex).value,
                                                            filterBySortModel.get(filterSortIndex).value,
                                                            filterByChannelModel.get(filterChannelIndex).value,
                                                            filterByYearModel.get(filterYearIndex).value)
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
        x: (parent.width - width) / 2
        width:  parent.width * 0.9
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

            Row {
                id: buttonRow
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: Qt.application.font.pixelSize * 3
                Button {
                    text: qsTr("Close")
                    onClicked: filter.close()
                }
                Button {
                    text: qsTr("Reset")
                    onClicked: {
                        filter.close()
                        if (filterSortIndex !== 0
                                || filterAreaIndex !== 0
                                || filterChannelIndex !== 0
                                || filterYearIndex !== 0) {
                            filterSortIndex = 0
                            filterAreaIndex = 0
                            filterChannelIndex = 0
                            filterYearIndex = 0
                            resourceListModel.clear()
                            dataRequest.resourcePage = 1
                            dataRequest.requestResourceList(1, resourceCountPerPage,
                                                            filterByAreaModel.get(filterAreaIndex).value,
                                                            filterBySortModel.get(filterSortIndex).value,
                                                            filterByChannelModel.get(filterChannelIndex).value,
                                                            filterByYearModel.get(filterYearIndex).value)
                        }

                    }
                }
                Button {
                    text: qsTr("Yes")
                    onClicked: {
                        filter.close()
                        resourceListModel.clear()
                        dataRequest.resourcePage = 1
                        dataRequest.requestResourceList(1, resourceCountPerPage,
                                                        filterByAreaModel.get(filterAreaIndex).value,
                                                        filterBySortModel.get(filterSortIndex).value,
                                                        filterByChannelModel.get(filterChannelIndex).value,
                                                        filterByYearModel.get(filterYearIndex).value)

                    }
                }
            }
        }

    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: dataRequest.isUpdatingResList
    }

}
