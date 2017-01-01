#include <QGuiApplication>
#include <QtQml>
#include <QQuickStyle>

#include "qmllive/livenodeengine.h"
#include "qmllive/remotereceiver.h"

#include "cowinspector.h"
#include "logsmodel.h"
#include "cowsmodel.h"
#include "identificationModel.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    qmlRegisterType<LogsModel>("CowInspector", 1, 0, "LogsModel");
    qmlRegisterType<CowsModel>("CowInspector", 1, 0, "CowsModel");
//    qmlRegisterType<IdentificationModel>("CowInspector", 1, 0, "IdentificationModel");

    QQuickStyle::setStyle("Material");
    QQmlApplicationEngine engine(QUrl("qml/desktop.qml"));
    engine.rootContext()->setContextProperty("ci", CowInspector::instance());

    // Set node for live qml updates
    LiveNodeEngine node;
    node.setQmlEngine(&engine);
    node.setWorkspace(app.applicationDirPath(), LiveNodeEngine::AllowUpdates);

    // Listen to ipc call from remote QmlLiveBench
    RemoteReceiver receiver;
    receiver.registerNode(&node);
    receiver.listen(10234);

    app.exec();
    return 0;
}
