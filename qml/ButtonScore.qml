import QtQuick 2.4


    Rectangle{
        width: parent.width
        height:parent.height/10
        property alias text: text.text
        signal clicked()
        signal longTap()
        border.color:"black"
        border.width:1
        Text{
          id: text
//          anchors.horizontalCenter: parent.horizontalCenter
          anchors.verticalCenter: parent.verticalCenter
          anchors.left: parent.left
          textFormat:Text.RichText
          //style:Text.Outline
          //styleColor: ((parent.color === color)?"white":color)
          color: "black"
          text: "Press me"
          Component.onCompleted: {
              if(parent.color === color)
                  color="white";
          }
        }
        Rectangle{
            id:bars
            height: parent.height
            anchors.left: text.right
            anchors.right: parent.right
            color: "transparent"
        }

        MouseArea{
          anchors.fill:parent
          onPressed:{
            parent.color="red";
          }
          onReleased:{
            parent.color="white";
            parent.clicked();
          }
          onPressAndHold:{
            parent.color="yellow";
            parent.longTap();
          }
        }
    }
