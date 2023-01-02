import QtQuick 2.7
import "Database.js" as Db

Rectangle {
    anchors.fill: parent
    ButtonBig {
      id: btnCancel
      anchors.top: parent.top
      text: "Cancel"
      onClicked:{
         pagesLoader.backPage();
      }
    }

    function updateRecords() {
        recordsListModel.clear()

        var records = Db.getColors();

        for (var i = 0; i < records.length; i++) {
            recordsListModel.append(records[i]);
        }
    }
    ListModel {
        id: recordsListModel
    }
    Component{
        id: recordsDelegate
        ButtonBig {
            width:mainWindow.width
            height: mainWindow.height/10
            text: recordsListModel.get(index).color
            color: recordsListModel.get(index).color
            onClicked:{
              pagesLoader.backPage( JSON.parse( JSON.stringify(recordsListModel.get(index))) );
            }
        }
    }
    ListView {
        anchors.top: btnCancel.bottom
        anchors.bottom: parent.bottom
        model: recordsListModel
        delegate: recordsDelegate
    }

    Component.onCompleted:{
        pagesLoader.title = "Color select";
        updateRecords();
    }
}
