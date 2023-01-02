import QtQuick 2.7
import "Database.js" as Db

Rectangle {
    anchors.fill: parent

    ListModel {
        id: recordsListModel
    }
    Component{
        id: recordsDelegate
        ButtonScore {
            width:mainWindow.width
            height: mainWindow.height/10
            text: "Game "+game_id+" date: "+started
            onClicked:{
                pagesLoader.loadPage("GameScores.qml",JSON.parse( JSON.stringify(recordsListModel.get(index)) ));
            }
            Component.onCompleted: {
                var records = Db.getGameWinners(game_id);
                if(0 < records.length){
                    text += "<br/>"+((0<records.length)?"Winners":"Winner")+" score "+records[0].max_score+" : ";
                    for (var i = 0; i < records.length; i++) {
                        text+= ' <font color="'+records[i].player_color+'">'+records[i].player_name+'</font>';
                    }
                }
            }
        }
    }
    ListView {
        anchors.top: parent.top
        anchors.bottom: btnNew.top
        model: recordsListModel
        delegate: recordsDelegate
    }


    ButtonBig {
        id:btnNew
      anchors.bottom: parent.bottom
      text: "New game"
      onClicked:{
         pagesLoader.loadPage("GameScores.qml");
      }
    }

    Component.onCompleted:{
        pagesLoader.title = "Game list";
        recordsListModel.clear()
        var records = Db.getGames();
        for (var i = 0; i < records.length; i++) {
            recordsListModel.append(records[i]);
        }
    }
}
