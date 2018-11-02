#include <QGuiApplication>
#include <QJsonDocument>
#include <QNetworkAccessManager>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "datarequest.h"
#include "listmodel.h"
#include "movielistitem.h"
#include <QDebug>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    QNetworkAccessManager *network = new QNetworkAccessManager(&app);
    DataRequest *dataRequest = new DataRequest(network, &app);
    ListModel *indexModel = new ListModel(new MovieListItem, dataRequest);

    QObject::connect(dataRequest, &DataRequest::dataReady, dataRequest, [=](int type, const QByteArray &data){
        qDebug()<<Q_FUNC_INFO << ">" << type << data;
        switch (type)
        {
        case DataRequest::INDEX:
        {
            QJsonDocument doc = QJsonDocument::fromJson(data);


        } break;
        }
    });

    dataRequest->requestIndex();

    engine.rootContext()->setContextProperty("dataRequest", dataRequest);
    engine.rootContext()->setContextProperty("indexModel",  indexModel);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
