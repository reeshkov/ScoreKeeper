import QtQuick 2.7
import QtQuick.Window 2.2
import "Database.js" as Db

Window {
    title: "Carcasson score board"
    //visibility: "FullScreen"
    width: 480
    height: 640

/*
Rectangle{
    property string title:""
    anchors.fill: parent
*/
    id: mainWindow
    visible: true
    readonly property string rootPage:"GamesList.qml"
    //readonly property string rootPage:"qrc:/qml/MakePhoto.qml"

    Loader {
        id: pagesLoader
        anchors.fill: parent
        property alias title: mainWindow.title
        property variant pagesStack: ([])
        property variant pageParameters: ({})
        source: ""

        function loadPage(page,params){
            var o = {};
            for (var key in pagesLoader.pageParameters) { o[key] = pagesLoader.pageParameters[key]; }
            pagesLoader.pagesStack.push({"source":pagesLoader.source.toString(),"params":JSON.parse(JSON.stringify(pagesLoader.pageParameters))});
//            console.log("=====\npush:\nsource: "+pagesLoader.source+
//                "\npageParameters: "+JSON.stringify(pagesLoader.pageParameters)+
//                "\nstack: "+pagesLoader.pagesStack.length+"="+JSON.stringify(pagesLoader.pagesStack));

            params = (typeof params === 'object' && params !== null)? params : {};
            pagesLoader.pageParameters = params;
            pagesLoader.source = page;
        }
        function backPage(params){
            params = (typeof params === 'object' && params !== null)? params : {};
            var pageObject = (0 < pagesLoader.pagesStack.length)?pagesLoader.pagesStack.pop():rootPage;
            //console.log("=====\npop: pageParameters="+JSON.stringify(pageObject));
            for (var key in params) { pageObject.params[key] = params[key]; }
            pagesLoader.pageParameters = pageObject.params;
            pagesLoader.source = pageObject.source;
        }
        function beginPage(){
            pagesLoader.pagesStack = ([]);
            pagesLoader.pageParameters = ({});
            pagesLoader.source = rootPage;
        }
        onSourceChanged:{
            // console.log("===========\nsource: "+pagesLoader.source+
            //     "\npageParameters: "+JSON.stringify(pagesLoader.pageParameters)+
            //     "\nstack: "+pagesLoader.pagesStack.length+"="+JSON.stringify(pagesLoader.pagesStack));
        }
    }

    Component.onCompleted: {
        Screen.orientationUpdateMask = 0xFF;
        Db.init();
        pagesLoader.loadPage(rootPage);
    }
}
