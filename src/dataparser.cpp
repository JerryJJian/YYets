#include "dataparser.h"
#include "datarequest.h"
#include "listmodel.h"
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonValue>
#include <QJsonParseError>
#include <QDateTime>
#include <QtMath>
#include <QApplication>
#include <QDesktopWidget>
#include "articlelistitem.h"
#include "commentlistitem.h"
#include "dataset.h"
#include "movielistitem.h"
#include "objectpool.h"
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
            articleData.insert("dateline",  handleDatetime(articleData.value("dateline").toInt()));
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
        QStringList ids;
        for (auto res : resArray)
            ids << res.toObject().value("id").toString();

        QList<int> followed = ObjectPool::instance()->sqlDataAccess()->checkFollowed(ids);
        qDebug() << followed;
        for (auto res : resArray)
        {
            QVariantHash resItem(res.toObject().toVariantHash());
            resItem.insert("dateline",   handleDatetime(resItem.value("dateline").toInt()));
            resItem.insert("itemupdate", handleDatetime(resItem.value("itemupdate").toInt()));
            resItem.insert("close_time", handleDatetime(resItem.value("close_time").toInt()));
            resItem.insert("updatetime", handleDatetime(resItem.value("updatetime").toInt()));
            resItem.insert("followed", followed.indexOf(resItem.value("id").toInt()) >=0 ? 1 : 0);
            ListItem *item = new ResourceListItem(resItem);
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
        for (int y=years.first().toInt(); y<=QDate::currentDate().year();++y)
            years.prepend(QString::number(y));
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
    case DataRequest::FOLLOWEDLIST:
    {
        items.clear();
        QJsonArray resArray = doc.object().value("data").toObject().value("list").toArray();
        for (auto res : resArray)
        {
            QVariantHash itemData(res.toObject().toVariantHash());
            QStringList itKeys;
            for (auto it : itemData.value("category").toList())
                itKeys << it.toString();
            itemData.insert("category", itKeys.join("|"));
            itKeys.clear();
            for (auto it : itemData.value("lang").toList())
                itKeys << it.toString();

            itemData.insert("lang", itKeys.join("|"));
            itemData.insert("dateline",   handleDatetime(itemData.value("dateline").toInt()));
            itemData.insert("itemupdate", handleDatetime(itemData.value("itemupdate").toInt()));
            itemData.insert("close_time", handleDatetime(itemData.value("close_time").toInt()));
            itemData.insert("updatetime", handleDatetime(itemData.value("updatetime").toInt()));
            if (!itemData.value("prevue").isNull())
            {
                QVariantMap prevue(itemData.value("prevue").toMap());
                itemData.insert("prevue_episode", QString("S%1E%2").arg(prevue.value("season").toString()).arg(prevue.value("episode").toString()));
                itemData.insert("prevue_play_time", prevue.value("play_time"));
                itemData.insert("prevue_week", prevue.value("week"));
            }
            ListItem *item = new ResourceListItem(itemData);
            items << item;
        }
        QVariantHash metaData;
        metaData.insert("page", doc.object().value("data").toObject().value("page").toInt());
        emit updateData(type, metaData, items);
    } break;
    case DataRequest::RESOURCE:
    {
        items.clear();
        QVariantHash resHash = doc.object().value("data").toObject().value("resource").toObject().toVariantHash();
        if (!resHash.value("prevue").isNull())
        {
            QVariantMap prevue(resHash.value("prevue").toMap());
            resHash.insert("prevue_episode", QString("S%1E%2").arg(prevue.value("season").toString()).arg(prevue.value("episode").toString()));
            resHash.insert("prevue_play_time", prevue.value("play_time"));
            resHash.insert("prevue_week", prevue.value("week"));
        }
        QString keyword(resHash.value("cnname").toString());
        if (keyword.isEmpty())
            keyword = resHash.value("enname").toString();

        resHash.insert("search_keywords", keyword);

        if (ObjectPool::instance()->sqlDataAccess()->hasFollowed(resHash.value("id").toInt()))
            ObjectPool::instance()->sqlDataAccess()->updateFollowed(resHash.value("id").toInt(),
                                                                    QJsonDocument::fromVariant(resHash).toJson(),
                                                                    resHash.value("prevue_play_time").toString().isEmpty()
                                                                    ? handleDatetime(resHash.value("itemupdate").toInt(), "yyyy-MM-dd")
                                                                    : resHash.value("prevue_play_time").toString());
        resHash.insert("resource",  QJsonDocument::fromVariant(resHash).toJson());

        resHash.insert("dateline",   handleDatetime(resHash.value("dateline").toInt()));
        resHash.insert("itemupdate", handleDatetime(resHash.value("itemupdate").toInt()));
        resHash.insert("itemupdate_day", handleDatetime(resHash.value("itemupdate").toInt(), "yyyy-MM-dd"));
        resHash.insert("close_time", handleDatetime(resHash.value("close_time").toInt()));
        resHash.insert("updatetime", handleDatetime(resHash.value("updatetime").toInt()));
        resHash.insert("premiere_time", handleDatetime(resHash.value("updatetime").toInt(), "yyyy/MM/dd"));

        QVariantList seasonList = doc.object().value("data").toObject().value("season").toArray().toVariantList();
        QStringList seasons;
        QVariantMap historyData = ObjectPool::instance()->sqlDataAccess()->history(resHash.value("id").toInt()).toMap();
        qDebug() << "#" << resHash.value("id").toInt() << historyData;
        for (auto season : seasonList)
        {
            QVariantMap seasonMap(season.toMap());
            QString seasonNum(seasonMap.value("season").toString());
            seasons.append(seasonNum);
            QStringList episodeList;
            for (auto ep : seasonMap.value("episode").toList())
                episodeList << ep.toString();
            resHash.insert(QString("season/%1").arg(seasonNum), episodeList.join("|"));
            resHash.insert(QString("season/%1/visit").arg(seasonNum), historyData.value(seasonNum).toStringList());
        }
        if (seasonList.size() > 0)
            resHash.insert("season", seasons.join("|"));

        resHash.insert("comments_count", doc.object().value("data").toObject().value("comments_count").toString());

        // comments
        QJsonArray comments = doc.object().value("data").toObject().value("comments_hot").toArray();
        for (auto comment : comments)
        {
            QVariantHash commentData(comment.toObject().toVariantHash());
            commentData.insert("dateline",  handleDatetime(commentData.value("dateline").toInt()));
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
            articleData.insert("dateline",  handleDatetime(articleData.value("dateline").toInt()));
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
        articleData.insert("dateline", handleDatetime(articleData.value("dateline").toInt()));
        articleData.insert("updatetime", handleDatetime(articleData.value("dateline").toInt()));
        articleData.insert("comments_count", object.value("comments_count").toString());
//        articleData.insert("content", object.value("content").toString()
//                           .replace("<img", "<img width=\"100%\""));

        QList<QVariantMap> contents = handleHtml(object.value("content").toString());
        QStringList contentTypes;
        QStringList contentValues;
        for (auto content : contents)
        {
            contentTypes << content.value("type").toString();
            contentValues << content.value("value").toString();
        }
        articleData.insert("content/types", contentTypes);
        articleData.insert("content/values", contentValues);
        articleData.insert("content/size", contentTypes.size());

        // extend content
        QJsonObject extendObject = object.value("extend").toObject();
        if (!extendObject.isEmpty())
        {
            QStringList extContents;
            for (auto ext : extendObject.value("articleContent").toArray())
                extContents << ext.toString();
            articleData.insert("extend/articleContent", extContents);

            QStringList extTrailers;
            for (auto ext : extendObject.value("article_trailer").toArray())
                extTrailers << ext.toString();
            articleData.insert("extend/article_trailer", extTrailers);

            QStringList extRids;
            for (auto ext : extendObject.value("rids").toArray())
                extRids << ext.toString();
            articleData.insert("extend/rids", extRids);
            articleData.insert("extend", extContents.size());
        }
        else
        {
            articleData.insert("extend", 0);
        }


        // resource
        QStringList resources;
        for (auto res : object.value("resource").toArray())
        {
            QJsonObject resObj = res.toObject();
            QString id(resObj.value("id").toString());
            resources << id;
            articleData.insert("resource/"+id+"/id",       resObj.value("id").toString());
            articleData.insert("resource/"+id+"/cnname",   resObj.value("cnname").toString());
            articleData.insert("resource/"+id+"/remark",   resObj.value("remark").toString());
            articleData.insert("resource/"+id+"/content",  resObj.value("content").toString());
            articleData.insert("resource/"+id+"/enname",   resObj.value("enname").toString());
            articleData.insert("resource/"+id+"/score",    resObj.value("score").toString());
            articleData.insert("resource/"+id+"/poster_s", resObj.value("poster_s").toString());
            articleData.insert("resource/"+id+"/poster_b", resObj.value("poster_b").toString());
        }
        articleData.insert("resource", resources.join("|"));

        // relative
        QStringList relatedArticles;
        for (auto related : object.value("relative").toArray())
        {
            QJsonObject relatedObj = related.toObject();
            QString id(relatedObj.value("id").toString());
            relatedArticles << id;
            articleData.insert("relative/"+id+"/poster_s", relatedObj.value("poster_s").toString());
            articleData.insert("relative/"+id+"/poster_b", relatedObj.value("poster_b").toString());
            articleData.insert("relative/"+id+"/poster_m", relatedObj.value("poster_m").toString());
            articleData.insert("relative/"+id+"/title", relatedObj.value("title").toString());
            articleData.insert("relative/"+id+"/id", relatedObj.value("id").toString());
            articleData.insert("relative/"+id+"/dateline",  handleDatetime(relatedObj.value("dateline").toInt()));
        }
        articleData.insert("relative", relatedArticles.join("|"));

        // comments
        for (auto comment : object.value("comments_hot").toArray())
        {
            QVariantHash commentData(comment.toObject().toVariantHash());
            commentData.insert("dateline",  handleDatetime(commentData.value("dateline").toInt()));
            if (!comment.toObject().value("reply").isNull())
            {
                QJsonObject reply = comment.toObject().value("reply").toObject();
                for (auto key : reply.keys())
                    commentData.insert("reply_"+key, reply.value(key));

                commentData.insert("reply_dateline", QDateTime::fromSecsSinceEpoch(commentData.value("reply_dateline").toInt()).toString("yyyy-MM-dd hh:mm:ss"));
                commentData.insert("reply", reply.value("id"));
            }
            else
            {
                commentData.insert("reply", "");
            }

            ListItem *item = new CommentListItem(commentData);
            items << item;
        }

        emit updateData(type, articleData, items);
    } break;
    case DataRequest::SEARCHRESOURCE:
    {
        items.clear();
        QJsonArray objects = doc.object().value("data").toObject().value("list").toArray();
        for (auto object : objects)
        {
            QVariantHash itemdata(object.toVariant().toHash());
            itemdata.insert("pubtime", handleDatetime(itemdata.value("pubtime").toInt(), "yyyy/MM/dd"));
            itemdata.insert("uptime",  handleDatetime(itemdata.value("uptime").toInt()));
            ListItem *item = new SearchResourceListItem(itemdata);
            items << item;
        }
        emit updateData(type, doc.object().value("data").toObject().value("count").toVariant(), items);
    } break;
    }

}

QString DataParser::handleDatetime(qint64 secs, const QString &formatString) const
{
    if (secs == 0)
        return QString("0");

    if (!formatString.isEmpty())
        return QDateTime::fromSecsSinceEpoch(secs).toString(formatString);

    int currentSec = QDateTime::currentSecsSinceEpoch();
    int offset = currentSec - secs;

    if (offset < 600)
        return tr("%1 mintes ago").arg(qFloor(offset / 60));
    if (offset < 3600)
        return tr("%1 mintes ago").arg(qFloor(offset / 600) * 10);
    if (offset < 86400) // day
        return tr("%1 hour ago").arg(qFloor(offset / 3600));
    if (offset < 604800) // week
        return tr("%1 days ago").arg(qFloor(offset / 86400));
    if (offset < 3024000) // month
        return tr("%1 weeks ago").arg(qFloor(offset / 604800));

    QDate date(QDateTime::fromSecsSinceEpoch(secs).date());
    QDate curr(QDate::currentDate());
    int years = curr.year() - date.year();
    if (years == 0)
        return tr("%1 months ago").arg(curr.month() - date.month());

    return tr("%1 years ago").arg(years);
}

QList<QVariantMap> DataParser::handleHtml(const QString text) const
{
    // cleanup the html tag
    QRegExp rxClear("<([a-z|A-Z]{1,9}).*>(.*)</([a-z|A-Z]{1,9})>");
    rxClear.setMinimal(true);
    int pos = 0;
    QString newText;
    while ((pos = rxClear.indexIn(text, pos)) != -1)
    {
         newText += rxClear.cap(2);
         pos += rxClear.matchedLength();
    }

    // find all img tag
    QList<QVariantMap> imgs;
    QRegExp rx("<[img|IMG].*[src|SRC]=\\\"(.*)\\\".*>");
    rx.setMinimal(true);
    pos = 0;
    while ((pos = rx.indexIn(newText, pos)) != -1)
    {
         QVariantMap img;
         img.insert("pos", pos);
         img.insert("len", rx.cap(0).length());
         img.insert("img", rx.cap(1));
         imgs << img;

         pos += rx.matchedLength();
    }

    // split html content
    QList<QVariantMap> contents;
    pos = 0;
    for (auto img : imgs)
    {
        int currPos = img.value("pos").toInt();
        if (currPos > pos)
        {
            QVariantMap content;
            content.insert("type", "text");
            content.insert("value", newText.mid(pos, currPos - pos));
            contents << content;
        }

        QVariantMap imgContent;
        imgContent.insert("type", "image");
        imgContent.insert("value", img.value("img"));
        contents << imgContent;

        pos = currPos + img.value("len").toInt();
    }

    if (pos < newText.length())
    {
        QVariantMap content;
        content.insert("type", "text");
        content.insert("value", newText.right(newText.length() - pos));
        contents << content;
    }

    return contents;
}
