#include "articlelistitem.h"
#include "clipboardproxy.h"
#include "commentlistitem.h"
#include "dataparser.h"
#include "datarequest.h"
#include "dataset.h"
#include "listmodel.h"
#include "movielistitem.h"
#include "objectpool.h"
#include "resitemlistitem.h"
#include "resourcelistitem.h"
#include "searchresourcelistitem.h"
#include "settings.h"
#include <QDebug>
#include <QFont>
#include <QFontDatabase>
#include <QGuiApplication>
#include <QJsonDocument>
#include <QLocale>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QTranslator>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    int fontID = QFontDatabase::addApplicationFont("/system/fonts/DroidSansFallback.ttf");
    QStringList fontFamilies(QFontDatabase::applicationFontFamilies(fontID));

    if (!fontFamilies.isEmpty())
        app.setFont(QFont(fontFamilies.at(0), app.font().pixelSize() * 1.2));

    QTranslator translator;
    if (translator.load(QString(":/%1.qm").arg(QLocale::system().name())))
        app.installTranslator(&translator);

    QQmlApplicationEngine engine;

    // network request & parser
    QNetworkAccessManager *network = new QNetworkAccessManager(&app);
    network->setNetworkAccessible(QNetworkAccessManager::Accessible);
    DataRequest *dataRequest = new DataRequest(network, &app);
    DataParser  *dataParser  = new DataParser(dataRequest);
    QObject::connect(dataRequest, &DataRequest::dataReady, dataParser, &DataParser::dataReceived);

    ListModel *indexModel = new ListModel(new MovieListItem, dataRequest);
    ListModel *articlesModel = new ListModel(new ArticleListItem, dataRequest);
    DataSet   *resourceData = new DataSet(dataParser);
    ListModel *resItemModel = new ListModel(new ResItemListItem, dataParser);
    DataSet   *articleData = new DataSet(dataParser);
    ListModel *resourceListModel = new ListModel(new ResourceListItem, dataRequest);
    DataSet   *resourceListFilterData = new DataSet(dataParser);
    ListModel *searchResourceModel = new ListModel(new SearchResourceListItem, dataRequest);
    ListModel *commentListModel = new ListModel(new CommentListItem, dataRequest);
    ListModel *followedListModel = new ListModel(new ResourceListItem, dataRequest);

    QObject::connect(dataParser, &DataParser::updateData, [=](int type, const QVariant &rawdata, const QList<ListItem*> &items) {
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
        case DataRequest::FOLLOWEDLIST:
        {
            if (rawdata.toHash().value("page").toInt() <= 1)
                followedListModel->updateRows(items);
            else
                followedListModel->appendRows(items);
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

    engine.rootContext()->setContextProperty("database",               ObjectPool::instance()->sqlDataAccess());
    engine.rootContext()->setContextProperty("settings",               ObjectPool::instance()->settings());
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
    engine.rootContext()->setContextProperty("followedListModel",      followedListModel);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
