import QtQuick 2.7
//import QtQuick.Controls 1.4
import QtQuick.Window 2.1
import QtMultimedia 5.4
import "Database.js" as Db

Rectangle {
    // http://doc.qt.io/qt-5/qt.html#ScreenOrientation-enum
    readonly property variant rotatetable: ({0:{0:0,1:0,2:0,4:0,8:0},270:[270,270,0,270,90,270,270,270,180]})
    Camera {
        id: camera
        captureMode :Camera.CaptureStillImage
        imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash
        //flash.mode: Camera.FlashRedEyeReduction
        imageProcessing {
            //whiteBalanceMode: Camera.WhiteBalanceTungsten
            //contrast: 0.66
            //saturation: -0.5
        }

        imageCapture {
            onImageSaved: {
                console.log("Image "+camera.metaData.orientation+" path "+path);
                photoPreview.source = "file://"+path;
                photoApparat.visible = false;
                //camera.imageCapture.setMetadata("Orientation",rotatetable[camera.orientation][Screen.orientation] )
            }

        }
    }

    VideoOutput {
        id:photoApparat
        source: camera
        autoOrientation:false
        orientation: rotatetable[camera.orientation][Screen.orientation]
        focus : visible
        width: parent.width
        anchors.top: parent.top
        anchors.bottom:confirmPhoto.top

        MouseArea {
            anchors.fill: parent;
            onClicked: {
                camera.imageCapture.setMetadata("Orientation",rotatetable[camera.orientation][Screen.orientation]);
                camera.imageCapture.capture();
            }
        }
        Component.onCompleted: {
            console.log("Set VideoOutput orientation "+rotatetable[camera.orientation][Screen.orientation]+" cam="+camera.orientation+" scr="+Screen.orientation);
        }
    }

    Image{
        id:photoPreview
        autoTransform : true
        anchors.top: parent.top
        anchors.bottom:confirmPhoto.top
        width: parent.width
        fillMode:Image.PreserveAspectFit
        sourceSize.width: parent.height
        visible: !photoApparat.visible
        MouseArea {
            anchors.fill: parent;
            onClicked: photoApparat.visible = true;
        }
        onStatusChanged: {
            if (status == Image.Error){
                source = "qrc:/qml/default-player_photo.png";
            }
        }
        onSourceChanged: {
            console.log("Preview "+source);
        }
    }

    ButtonBig {
      id:confirmPhoto
      anchors.bottom: parent.bottom
      text: (photoPreview.visible)?"Confirm":"Cancel"
      onClicked:{
          if(photoPreview.visible){
              pagesLoader.backPage({"photo":photoPreview.source.toString()});
          }else{
              pagesLoader.backPage();
          }
      }
    }
    Text{
        text:"vso:"+photoApparat.orientation+"\ncso:"+camera.orientation+"\ns0:"+Screen.orientation+"\nir:"+photoPreview.rotation
    }

}
