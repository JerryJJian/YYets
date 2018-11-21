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
#include "dataset.h"
#include "resitemlistitem.h"
#include "articlelistitem.h"
#include "clipboardproxy.h"
#include "resourcelistitem.h"
#include "searchresourcelistitem.h"
#include "commentlistitem.h"
#include <QDebug>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // network request & parser
    QNetworkAccessManager *network = new QNetworkAccessManager(&app);
    network->setNetworkAccessible(QNetworkAccessManager::Accessible);
    DataRequest *dataRequest = new DataRequest(network, &app);
    DataParser  *dataParser  = new DataParser(dataRequest);
    QObject::connect(dataRequest, &DataRequest::dataReady, dataParser, &DataParser::dataReceived);

    ListModel *indexModel = new ListModel(new MovieListItem, dataRequest);
    ListModel *articlesModel = new ListModel(new ArticleListItem, dataRequest);
    DataSet *resourceData = new DataSet(dataParser);
    ListModel *resItemModel = new ListModel(new ResItemListItem, dataParser);
    DataSet *articleData = new DataSet(dataParser);

    ListModel *resourceListModel = new ListModel(new ResourceListItem, dataRequest);
    DataSet *resourceListFilterData = new DataSet(dataParser);

    ListModel *searchResourceModel = new ListModel(new SearchResourceListItem, dataRequest);

    ListModel *commentListModel = new ListModel(new CommentListItem, dataRequest);

    QObject::connect(dataParser, &DataParser::updateData, [=](int type, const QVariant &rawdata, const QList<ListItem*> &items){
        switch (type)
        {
        case DataRequest::INDEX:
        {
            indexModel->updateRows(items);
            dataRequest->setIsUpdatingIndex(false);
        } break;
        case DataRequest::RESOURCELIST:
        {
            if (dataRequest->getResourcePage() == 0)
                resourceListModel->updateRows(items);
            else
                resourceListModel->appendRows(items);

            if (dataRequest->getResourcePage() <= 1)
                resourceListFilterData->update(rawdata.toHash());
        } break;
        case DataRequest::RESOURCE:
        {
            resourceData->update(rawdata.toHash());
            commentListModel->updateRows(items);
        } break;
        case DataRequest::ITEM:
        {
            resItemModel->updateRows(items);
            dataRequest->setIsUpdatingResItem(false);
        } break;
        case DataRequest::ARTICLELIST:
        {
            articlesModel->appendRows(items);
        } break;
        case DataRequest::ARTICLE:
        {
            articleData->update(rawdata.toHash());
            commentListModel->updateRows(items);
        } break;
        case DataRequest::SEARCHRESOURCE:
        {
            searchResourceModel->appendRows(items);
        } break;
        }
    });

    engine.rootContext()->setContextProperty("clipboard",              new ClipBoardProxy(&app));
    engine.rootContext()->setContextProperty("dataRequest",            dataRequest);
    engine.rootContext()->setContextProperty("indexModel",             indexModel);
    engine.rootContext()->setContextProperty("resourceData",           resourceData);
    engine.rootContext()->setContextProperty("resItemModel",           resItemModel);
    engine.rootContext()->setContextProperty("articlesModel",          articlesModel);
    engine.rootContext()->setContextProperty("articleData",            articleData);
    engine.rootContext()->setContextProperty("resourceListModel",      resourceListModel);
    engine.rootContext()->setContextProperty("resourceListFilterData", resourceListFilterData);
    engine.rootContext()->setContextProperty("searchResourceModel",    searchResourceModel);
    engine.rootContext()->setContextProperty("commentListModel",       commentListModel);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
