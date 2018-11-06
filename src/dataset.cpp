#include "dataset.h"

#include <QDateTime>

DataSet::DataSet(QObject *parent)
    : QObject(parent)
{

}

QString DataSet::data(const QString &key) const
{
    return d.printableData.value(key);
}

void DataSet::setData(const QString &key, const QVariant &data)
{
    if (key.endsWith("_time"))
    {
        d.printableData.insert(key, QDateTime::fromSecsSinceEpoch(data.toInt()).toString("yyyy-MM-dd hh:mm:ss"));
        return ;
    }

    if (data.canConvert(QVariant::List))
    {
        QStringList items;
        for (auto item : data.toList())
            items << item.toString();

        d.printableData.insert(key, items.join("/"));
        return ;
    }

    if (data.canConvert(QVariant::Map))
    {
        QMapIterator<QString, QVariant> it(data.toMap());
        while (it.hasNext())
        {
            it.next();
            d.printableData.insert(key+"/"+it.key(), it.value().toString());
        }
        return ;
    }

//    if (data.canConvert(QVariant::String))
    d.printableData.insert(key, data.toString());
}

void DataSet::update(const QVariantHash &data)
{
    QHashIterator<QString, QVariant> it(data);
    while (it.hasNext())
    {
        it.next();
        setData(it.key(), it.value());
    }
}
