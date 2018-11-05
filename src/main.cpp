#include <QGuiApplication>
#include <QJsonDocument>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "dataparser.h"
#include "datarequest.h"
#include "listmodel.h"
#include "movielistitem.h"
#include <QDebug>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // network request & parser
    QNetworkAccessManager *network = new QNetworkAccessManager(&app);

//    QNetworkReply *reply = network->get(QNetworkRequest(QUrl("http://api1.ousns.net/index.php?accesskey=519fc5ab85c8015b175449477561a827&client=2&a=index&m=index&tlimit=10&alimit=10&g=api/v1")));
//    QObject::connect(reply, &QNetworkReply::finished, [=]() {
//        qDebug() << reply->readAll();
//    });

    network->setNetworkAccessible(QNetworkAccessManager::Accessible);
    DataRequest *dataRequest = new DataRequest(network, &app);
    DataParser  *dataParser  = new DataParser(dataRequest);
    QObject::connect(dataRequest, &DataRequest::dataReady, dataParser, &DataParser::dataReceived);

    ListModel *indexModel = new ListModel(new MovieListItem, dataRequest);
    qDebug() << "Roles#" << indexModel->roleNames();
    QObject::connect(dataParser, &DataParser::updateData, [=](int type, const QList<ListItem*> &items){
        switch (type)
        {
        case DataRequest::INDEX:
        {
            indexModel->updateRows(items);
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
