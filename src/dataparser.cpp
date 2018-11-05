#include "dataparser.h"
#include "datarequest.h"
#include "listmodel.h"
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonValue>
#include <QJsonParseError>
#include "movielistitem.h"
#include <QDebug>


DataParser::DataParser(QObject *parent)
    : QObject(parent)
{

}

void DataParser::dataReceived(int type, const QByteArray &data)
{
    QList<ListItem *> items;
    switch (type)
    {
    case DataRequest::INDEX:
    {
        QJsonParseError error;
        QJsonDocument doc = QJsonDocument::fromJson(data, &error);

        qDebug() << data << "\n" << doc.object();
        if (error.error != QJsonParseError::NoError)
        {
            qDebug() << "ERROR:" << type << error.errorString();
            return ;
        }

        QJsonArray objects = doc.object().value("data").toObject().value("top").toArray();
        for (auto object : objects)
        {
            ListItem *item = new MovieListItem(object.toVariant().toHash());
            items << item;
        }

        emit updateData(type, items);
    } break;
    case DataRequest::ITEM:
    {

    } break;
    }

}
