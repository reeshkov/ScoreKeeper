import QtQuick 2.7
import "Database.js" as Db

Rectangle {
    anchors.fill: parent
    ButtonBig {
      id: backBtn
      anchors.top: parent.top
      text: "Stop"
      onClicked:{
         pagesLoader.beginPage();
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
            text: player_name+" value= "+score_value
            color: player_color
            onClicked:{
              pagesLoader.loadPage("ScoreEdit.qml",JSON.parse( JSON.stringify(recordsListModel.get(index))) );
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
                        console.log("source: " + source + ": failed to load");
                        source = "qrc:/qml/default-player_photo.png";
                    }
                }
            }
            Image{
                autoTransform : true
                anchors.right: parent.right
                height: parent.height-parent.border.width
                width: parent.height-parent.border.width
                fillMode:Image.PreserveAspectFit
                sourceSize.width: parent.height
                sourceSize.height: parent.height
                source: (score_photo)?score_photo:"qrc:/qml/default-score_photo.png"
                onStatusChanged: {
                    if (status == Image.Error){
                        source = "qrc:/qml/default-score_photo.png";
                    }
                }
            }
        }
    }
    ListView {
        anchors.top: backBtn.bottom
        anchors.bottom: btnAdd.top
        width:parent.width
        model: recordsListModel
        delegate: recordsDelegate
    }

    ButtonBig {
      id:btnAdd
      anchors.bottom: parent.bottom
      text: "Add score"
      onClicked:{
         pagesLoader.loadPage("ScoreEdit.qml",pagesLoader.pageParameters);
      }
    }

    Component.onCompleted:{
        pagesLoader.title = "Game score";
        var records = Db.getGameScores(pagesLoader.pageParameters.game_id);
        for (var i = 0; i < records.length; i++) {
            recordsListModel.append(records[i]);
        }
    }
}
