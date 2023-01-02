import QtQuick 2.4


    Rectangle{
        width: parent.width
        height:parent.height/10
        property alias text: buttonText.text
        property alias textAlign: buttonText.horizontalAlignment
        signal clicked()
        signal longTap()
        border.color:"black"
        border.width:1
        Text{
          id: buttonText
          anchors.centerIn: parent
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
