#include "dataparser.h"
#include "datarequest.h"
#include "listmodel.h"
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonValue>
#include <QJsonParseError>
#include <QDateTime>
#include "articlelistitem.h"
#include "dataset.h"
#include "movielistitem.h"
#include "resitemlistitem.h"
#include <QDebug>


DataParser::DataParser(QObject *parent)
    : QObject(parent)
{

}

void DataParser::dataReceived(int type, const QByteArray &data)
{
    QJsonParseError error;
    QJsonDocument doc = QJsonDocument::fromJson(data, &error);
    if (error.error != QJsonParseError::NoError)
    {
        qDebug() << "ERROR:" << type << error.errorString();
        return ;
    }

    QList<ListItem *> items;
    switch (type)
    {
    case DataRequest::INDEX:
    {
        // update top resources
        QJsonArray objects = doc.object().value("data").toObject().value("top").toArray();
        for (auto object : objects)
        {
            ListItem *item = new MovieListItem(object.toVariant().toHash());
            items << item;
        }
        emit updateData(type, objects.toVariantList(), items);

        items.clear();
        // update articles
        QJsonArray articles = doc.object().value("data").toObject().value("article").toArray();
        for (auto object : articles)
        {
            QVariantHash articleData(object.toVariant().toHash());
            articleData.insert("dateline", QDateTime::fromSecsSinceEpoch(articleData.value("dateline").toInt()).toString("yyyy-MM-dd hh:mm:ss"));
            ListItem *item = new ArticleListItem(articleData);
            items << item;
        }
        emit updateData(DataRequest::ARTICLELIST, articles.toVariantList(), items);
    } break;
    case DataRequest::RESOURCE:
    {
        QVariantHash resHash = doc.object().value("data").toObject().value("resource").toObject().toVariantHash();
        QVariantList seasonList = doc.object().value("data").toObject().value("season").toArray().toVariantList();
        QStringList seasons;
        for (auto season : seasonList)
        {
            QVariantMap seasonMap(season.toMap());
            QString seasonNum(seasonMap.value("season").toString());
            seasons.append(seasonNum);
            QStringList episodeList;
            for (auto ep : seasonMap.value("episode").toList())
                episodeList << ep.toString();
            resHash.insert(QString("season/%1").arg(seasonNum), episodeList.join("|"));
        }
        if (seasonList.size() > 0)
            resHash.insert("season", seasons.join("|"));

        emit updateData(type, resHash);
    } break;
    case DataRequest::ITEM:
    {
        QJsonArray objects = doc.object().value("data").toObject().value("item_list").toArray();
        for (auto object : objects)
        {
            ListItem *item = new ResItemListItem(object.toVariant().toHash());
            items << item;
        }

        emit updateData(type, objects.toVariantList(), items);
    } break;
    case DataRequest::ARTICLELIST:
    {
        QJsonArray objects = doc.object().value("data").toArray();
        for (auto object : objects)
        {
            QVariantHash articleData(object.toVariant().toHash());
            articleData.insert("dateline", QDateTime::fromSecsSinceEpoch(articleData.value("dateline").toInt()).toString("yyyy-MM-dd hh:mm:ss"));
            ListItem *item = new ArticleListItem(articleData);
            items << item;
        }
        emit updateData(type, objects.toVariantList(), items);
    } break;
    case DataRequest::ARTICLE:
    {
        QJsonObject object = doc.object().value("data").toObject();
        QVariantHash articleData(object.toVariantHash());
        articleData.insert("dateline", QDateTime::fromSecsSinceEpoch(articleData.value("dateline").toInt()).toString("yyyy-MM-dd hh:mm:ss"));



        emit updateData(type, articleData, items);
    } break;
    }

}

