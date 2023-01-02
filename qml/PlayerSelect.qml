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
        var records = Db.getPlayers();
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
            text: player_name
            color: player_color
            onClicked:{
              pagesLoader.backPage( JSON.parse( JSON.stringify(recordsListModel.get(index))) );
            }
            onLongTap:{
                console.log("PlayerSelect.qml load: PlayerEdit.qml "+JSON.stringify(recordsListModel.get(index)));
                pagesLoader.loadPage("PlayerEdit.qml",JSON.parse( JSON.stringify(recordsListModel.get(index))) );
            }
            Image{
                autoTransform : true
                anchors.left: parent.left
                height: parent.height-parent.border.width
                width: parent.height-parent.border.width
                fillMode:Image.PreserveAspectFit
                sourceSize.width: parent.height
                sourceSize.height: parent.height
                source: (player_photo)?player_photo:"qrc:/qml/default-player_photo.png"
                onStatusChanged: {
                    if (status == Image.Error){
                        source = "qrc:/qml/default-player_photo.png";
                    }
                }
            }
        }
    }
    ListView {
        anchors.top: btnCancel.bottom
        anchors.bottom: btnNewPlayer.top
        model: recordsListModel
        delegate: recordsDelegate
    }

    ButtonBig {
        id:btnNewPlayer
      anchors.bottom: parent.bottom
      text: "New player"
      onClicked:{
         pagesLoader.loadPage("PlayerEdit.qml");
      }
    }

    Component.onCompleted:{
        pagesLoader.title = "Player select";
        updateRecords();
    }
}
