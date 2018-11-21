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
#include "commentlistitem.h"
#include "dataset.h"
#include "movielistitem.h"
#include "resitemlistitem.h"
#include "resourcelistitem.h"
#include "searchresourcelistitem.h"
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
        items.clear();
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
    case DataRequest::RESOURCELIST:
    {
        items.clear();
        QVariantHash filters;
        QJsonArray resArray = doc.object().value("data").toObject().value("list").toArray();
        for (auto res : resArray)
        {
            ListItem *item = new ResourceListItem(res.toObject().toVariantHash());
            items << item;
        }

        QJsonArray areaArray = doc.object().value("data").toObject().value("area").toArray();
        QStringList areas;
        for (auto area : areaArray)
            areas << area.toString();
        filters.insert("area", areas.join("|"));

        QJsonArray yearArray = doc.object().value("data").toObject().value("year").toArray();
        QStringList years;
        for (auto year : yearArray)
            years << year.toString();
        filters.insert("year", years.join("|"));

        QJsonArray channelArray = doc.object().value("data").toObject().value("channel").toArray();
        QStringList channels;
        QStringList channelVals;
        for (auto channel : channelArray)
        {
            channels << channel.toObject().value("key").toString();
            channelVals << channel.toObject().value("value").toString();
        }
        filters.insert("channel/keys", channels.join("|"));
        filters.insert("channel/values", channelVals.join("|"));

        QJsonArray sortArray = doc.object().value("data").toObject().value("sort").toArray();
        QStringList sortKeys;
        QStringList sortValues;
        for (auto sort : sortArray)
        {
            sortKeys << sort.toObject().value("key").toString();
            sortValues << sort.toObject().value("value").toString();
        }
        filters.insert("sort/keys", sortKeys.join("|"));
        filters.insert("sort/values", sortValues.join("|"));

        emit updateData(type, filters, items);
    } break;
    case DataRequest::RESOURCE:
    {
        items.clear();
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

        // comments
        QJsonArray comments = doc.object().value("data").toObject().value("comments_hot").toArray();
        for (auto comment : comments)
        {
            QVariantHash commentData(comment.toObject().toVariantHash());
            if (!comment.toObject().value("reply").isNull())
            {
                QJsonObject reply = comment.toObject().value("reply").toObject();
                for (auto key : reply.keys())
                    commentData.insert("reply_"+key, reply.value(key));

                commentData.insert("reply", reply.value("id"));
            }
            else
            {
                commentData.insert("reply", "");
            }

            ListItem *item = new CommentListItem(commentData);
            items << item;
        }

        emit updateData(type, resHash, items);
    } break;
    case DataRequest::ITEM:
    {
        items.clear();
        QVariantList rawdata;
        QJsonArray objects = doc.object().value("data").toObject().value("item_list").toArray();
        for (auto object : objects)
        {
            QVariantHash d(object.toVariant().toHash());
            rawdata << d;
            ListItem *item = new ResItemListItem(d);
            items << item;
        }

        QJsonArray playSrcs = doc.object().value("data").toObject().value("play_source").toArray();
        if (!playSrcs.isEmpty())
        {
            QVariantHash psdata;
            psdata.insert("foramt", tr("*"));
            psdata.insert("format_tip", tr("Play Source"));
            psdata.insert("size", "");
            psdata.insert("comments_count", "0");

            QVariantList files;
            for (auto obj : playSrcs)
            {
                QVariantMap psitem(obj.toVariant().toMap());
                psitem.insert("way_name", (psitem.value("way_cn").isNull() ? psitem.value("way_en") : psitem.value("way_cn")));
                files.append(psitem);
            }
            psdata.insert("files", files);

            ListItem *item = new ResItemListItem(psdata);
            items << item;

            rawdata << psdata;
        }

        emit updateData(type, rawdata, items);
    } break;
    case DataRequest::ARTICLELIST:
    {
        items.clear();
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
        items.clear();
        QJsonObject object = doc.object().value("data").toObject();
        QVariantHash articleData(object.toVariantHash());
        articleData.insert("dateline", QDateTime::fromSecsSinceEpoch(articleData.value("dateline").toInt()).toString("yyyy-MM-dd hh:mm:ss"));
        emit updateData(type, articleData, items);
    } break;
    case DataRequest::SEARCHRESOURCE:
    {
        items.clear();
        QJsonArray objects = doc.object().value("data").toObject().value("list").toArray();
        for (auto object : objects)
        {
            QVariantHash itemdata(object.toVariant().toHash());
            itemdata.insert("pubtime", QDateTime::fromSecsSinceEpoch(itemdata.value("pubtime").toInt()).toString("yyyy-MM-dd"));
            itemdata.insert("uptime", QDateTime::fromSecsSinceEpoch(itemdata.value("uptime").toInt()).toString("yyyy-MM-dd"));
            ListItem *item = new SearchResourceListItem(itemdata);
            items << item;
        }
        emit updateData(type, doc.object().value("data").toObject().value("count").toVariant(), items);
    } break;
    }

}

