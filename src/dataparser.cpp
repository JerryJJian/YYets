#include "dataparser.h"
#include "datarequest.h"
#include "listmodel.h"
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonValue>
#include <QJsonParseError>
#include "dataset.h"
#include "movielistitem.h"
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
        QJsonArray objects = doc.object().value("data").toObject().value("top").toArray();
        for (auto object : objects)
        {
            ListItem *item = new MovieListItem(object.toVariant().toHash());
            items << item;
        }

        emit updateData(type, objects.toVariantList(), items);
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

    } break;
    }

}
