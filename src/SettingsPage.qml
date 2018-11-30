import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Dialogs 1.2

Page {

    title: qsTr("Settings")

    ScrollView {
        anchors.fill: parent

        Column {
            anchors.left: parent.left;     anchors.leftMargin: 10
            anchors.top: parent.top;       anchors.topMargin: 10
            anchors.right: parent.right;   anchors.rightMargin: 10
            anchors.bottom: parent.bottom; anchors.bottomMargin: 10
            spacing: 5

            Row {
                id: databaseRow
                width: parent.width
                spacing: 5

                Label {
                    id: databaseLabel
                    text: "DB"
                }

                Button {
                    id: dbSelectButton
                    text: qsTr("Database")
                    onClicked: dbfileDialog.open()
                }
            }


        }



    }

    FileDialog {
        id: dbfileDialog
    }

}
