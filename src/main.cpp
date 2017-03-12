#include <QGuiApplication>
#include <QtQml>
#include <QQuickStyle>

#include "qmllive/livenodeengine.h"
#include "qmllive/remotereceiver.h"

#include "cowinspector.h"
#include "logsmodel.h"
#include "cowsmodel.h"
#include "identificationModel.h"
#include "cowdaysmodel.h"
#include "cowmealsmodel.h"
#include "boxmodel.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    qmlRegisterType<LogsModel>("CowInspector", 1, 0, "LogsModel");
    qmlRegisterType<CowsModel>("CowInspector", 1, 0, "CowsModel");
    qmlRegisterType<IdentificationModel>("CowInspector", 1, 0, "IdentificationModel");
    qmlRegisterType<CowDaysModel>("CowInspector", 1, 0, "CowDaysModel");
    qmlRegisterType<CowMealsModel>("CowInspector", 1, 0, "CowMealsModel");
    qmlRegisterType<BoxModel>("CowInspector", 1, 0, "BoxModel");
    qmlRegisterType<BoxStatsModel>("CowInspector", 1, 0, "BoxStatsModel");

    const QString& locale("fr");
    QTranslator translator;
    qApp->installTranslator(&translator);
    QString trpath = QCoreApplication::applicationDirPath() + QStringLiteral("/../translations");
    translator.load(QStringLiteral("cowinspector_") + locale, trpath);
    qApp->setProperty("qtc_locale", locale);

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
