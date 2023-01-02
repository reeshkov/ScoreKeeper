#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QDebug>
//#include <gnu/libc-version.h>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qDebug()<< QString("Qt version: %1").arg(qVersion());
    //qDebug()<<"libc version:"<<gnu_get_libc_version();

    QQmlApplicationEngine engine;
    qDebug() << "qml :" << engine.rootObjects() ;
    qDebug() << "QQmlApplicationEngine.offlineStoragePath:" << engine.offlineStoragePath() ;
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));
    return app.exec();
}
