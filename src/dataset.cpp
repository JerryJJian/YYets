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
    if (key.endsWith("time"))
    {
        d.printableData.insert(key, QDateTime::fromSecsSinceEpoch(data.toInt()).toString("yyyy-MM-dd hh:mm:ss"));
        if (d.enableRefresh) emit refreshView();
        return ;
    }

    if (data.canConvert(QVariant::List))
    {
        QStringList items;
        for (auto item : data.toList())
            items << item.toString();

        d.printableData.insert(key, items.join("/"));
        if (d.enableRefresh) emit refreshView();
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
        if (d.enableRefresh) emit refreshView();
        return ;
    }

//    if (data.canConvert(QVariant::String))
    d.printableData.insert(key, data.toString());
    if (d.enableRefresh) emit refreshView();
}

void DataSet::update(const QVariantHash &data)
{
    d.enableRefresh = false;
    QHashIterator<QString, QVariant> it(data);
    while (it.hasNext())
    {
        it.next();
        setData(it.key(), it.value());
    }
    d.enableRefresh = true;

    emit refreshView();
}
