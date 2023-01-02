import QtQuick 2.7
import QtQuick.Controls 1.4
import "Database.js" as Db

Rectangle {
    anchors.fill: parent
    ButtonBig {
      id:backBtn
      anchors.top: parent.top
      text: "Cancel"
      onClicked:{
         pagesLoader.backPage();
      }
    }

    ButtonBig {
      id:btnPlayer
      anchors.top: backBtn.bottom
      text: "Select player"
      onClicked:{
          pagesLoader.loadPage("PlayerSelect.qml");
      }
    }

    SpinBox {
        id: scoreValue
        anchors.top: btnPlayer.bottom
        height: parent.height/10
        width: parent.width
        minimumValue : 0
        value: 2
        horizontalAlignment: Qt.AlignHCenter
        onValueChanged: {
            pagesLoader.pageParameters.score_value = value;
        }
    }
    Image{
        id:scorePhoto
        autoTransform : true
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: scoreValue.bottom
        anchors.bottom: addPlayer.top
        width: parent.width
        source: "qrc:/qml/default-score_photo.png"
        fillMode:Image.PreserveAspectFit
        MouseArea{
          anchors.fill:parent
          onClicked: {
              pagesLoader.loadPage("MakePhoto.qml");
          }
        }
        onSourceChanged: {
            pagesLoader.pageParameters.score_photo = source.toString();
        }
        onStatusChanged: {
            if (status == Image.Error){
                source = "qrc:/qml/default-score_photo.png";
            }
        }
    }

    ButtonBig {
      id:addPlayer
      anchors.bottom: parent.bottom
      text: "Save"
      onClicked:{
          pagesLoader.pageParameters.score_value = scoreValue.value;
          if("score_id" in pagesLoader.pageParameters){
            Db.editScore(pagesLoader.pageParameters.score_id,
                         pagesLoader.pageParameters.player_id,
                         pagesLoader.pageParameters.score_value,
                         pagesLoader.pageParameters.score_photo);
          }else{
              Db.addScore(pagesLoader.pageParameters.game_id,
                          pagesLoader.pageParameters.player_id,
                          pagesLoader.pageParameters.score_value,
                          pagesLoader.pageParameters.score_photo)
          }
          pagesLoader.backPage({"game_id":pagesLoader.pageParameters.game_id});
      }
    }

    Component.onCompleted:{
        pagesLoader.title = "Score edit";
        //console.log("Score edit "+JSON.stringify(pagesLoader.pageParameters));
        if(!("game_id" in pagesLoader.pageParameters))
            pagesLoader.pageParameters.game_id = Db.addGame("");
        if("player_id" in pagesLoader.pageParameters){
          btnPlayer.text = pagesLoader.pageParameters.player_name;
          btnPlayer.color = pagesLoader.pageParameters.player_color;
        }
        if("score_value" in pagesLoader.pageParameters){
          scoreValue.value = pagesLoader.pageParameters.score_value;
        }
        if("photo" in pagesLoader.pageParameters){
          scorePhoto.source = pagesLoader.pageParameters.photo;
        }else{
            if("score_photo" in pagesLoader.pageParameters){
                scorePhoto.source = pagesLoader.pageParameters.score_photo;
            }else{
                pagesLoader.pageParameters.score_photo = scorePhoto.source.toString();
            }
        }
    }
}
