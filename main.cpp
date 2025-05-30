#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QWindow>
#include <QDir>
#include <QUrl>


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QCoreApplication::setApplicationName(QStringLiteral("testqml"));
    QCoreApplication::setApplicationVersion(QStringLiteral("0.1"));

    qputenv("QT_LOGGING_RULES", "qml=true");
    qputenv("QT_ASSUME_STDERR_HAS_CONSOLE", "1");
//    qputenv("QML_IMPORT_TRACE", "1");

    QStringList args(QCoreApplication::arguments());

    QQmlApplicationEngine engine;
    engine.setOutputWarningsToStandardError(true);
    QUrl url(args.value(1, QStringLiteral("qrc:/qml/main.qml")));
    if (url.isRelative())
        url = (QDir::currentPath() + QDir::separator() + url.path());
    qDebug() << "testqml load" << url << QDir::currentPath() << url.path();

    QObject::connect(&engine, &QQmlApplicationEngine::warnings,
        &app, [](const QList<QQmlError> &warnings) {
            qDebug() << "qml:" << warnings;
    });

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [&app, url, &engine](QObject *obj, const QUrl &objUrl) {
            qDebug() << "testqml objectCreated" << engine.rootObjects() << !obj << app.allWindows().count() << url << objUrl.toString();
            if (!obj) {
                QCoreApplication::exit(-1);
                return;
            }

            QWindow * fw = app.allWindows()[0];
            if(fw){
                QObject::connect(fw, &QWindow::windowStateChanged, &app, [](Qt::WindowState windowState) {
                    qDebug() << "testqml windowStateChanged to" << QMetaEnum::fromType<Qt::WindowState>().valueToKey(windowState);
                });

                //fw->setFlags(Qt::Window | Qt::FramelessWindowHint | Qt::WindowStaysOnTopHint | Qt::WindowOverridesSystemGestures);
                //fw->setWindowState(Qt::WindowFullScreen);
                // fw->setOpacity(0.5);
            } else
                qDebug() << "testqml no window!";

            QCoreApplication::connect(&app, &QCoreApplication::aboutToQuit ,&app, []() {
                    qDebug() << "testqml aboutToQuit";
            }, Qt::DirectConnection);

    }, Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}
