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

    TextField {
        id:playerName
        anchors.top: backBtn.bottom
        width: parent.width
        height: parent.height/10
        placeholderText: "Input player name"
        onTextChanged:{
            pagesLoader.pageParameters.player_name = text;
        }
    }

    ButtonBig {
      id:btnColor
      anchors.top: playerName.bottom
      text: "Select color"
      color: "white"
      onClicked:{
          pagesLoader.loadPage("ColorSelect.qml");
      }
    }

    Image{
        autoTransform : true
        id:playerPhoto
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: btnColor.bottom
        anchors.bottom: savePlayer.top
        width: parent.width
        source: "qrc:/qml/default-player_photo.png"
        fillMode:Image.PreserveAspectFit
        MouseArea{
          anchors.fill:parent
          onClicked: {
              pagesLoader.loadPage("MakePhoto.qml");
          }
        }
        onStatusChanged: {
            if (status == Image.Error){
                source = "qrc:/qml/default-player_photo.png";
            }
        }
    }

    ButtonBig {
      id:savePlayer
      anchors.bottom: parent.bottom
      text: "Save"
      onClicked:{
          if("player_id" in pagesLoader.pageParameters){
            Db.editPlayer(pagesLoader.pageParameters.player_id,
                          playerName.text,
                          btnColor.color,
                          playerPhoto.source.toString());
          }else{
              Db.addPlayer(playerName.text,
                           btnColor.color,
                           playerPhoto.source.toString());
          }
          pagesLoader.backPage();
      }
    }

    Component.onCompleted:{
        pagesLoader.title = "Player edit";
        //console.log("Edit score "+JSON.stringify(pagesLoader.pageParameters));
        if("player_id" in pagesLoader.pageParameters){
            playerName.text = pagesLoader.pageParameters.player_name;
            btnColor.color = btnColor.text = pagesLoader.pageParameters.player_color;
            playerPhoto.source = pagesLoader.pageParameters.player_photo;
        }
        if("player_name" in pagesLoader.pageParameters){
            playerName.text = pagesLoader.pageParameters.player_name;
        }
        if("photo" in pagesLoader.pageParameters){
            playerPhoto.source = pagesLoader.pageParameters.photo;
        }
        if("player_color" in pagesLoader.pageParameters){
            btnColor.color = btnColor.text = pagesLoader.pageParameters.player_color;
        }
    }
}


