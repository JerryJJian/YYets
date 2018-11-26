#include "dataset.h"

#include <QDateTime>

const QString DataSet::StringListSeparator(QLatin1Literal("|"));

DataSet::DataSet(QObject *parent)
    : QObject(parent)
{

}

QString DataSet::data(const QString &key) const
{
    return d.printableData.value(key);
}

bool DataSet::dataListContains(const QString &key, const QString value, const QString &splitBy) const
{
    return d.printableData.value(key).contains(value);
}

QStringList DataSet::dataList(const QString &key, const QString &splitBy) const
{
    if (d.printableData.value(key).isEmpty())
        return QStringList();

    return d.printableData.value(key).split(splitBy);
}

int DataSet::dataListSize(const QString &key, const QString &splitBy) const
{
    if (d.printableData.value(key).isEmpty())
        return 0;

    return d.printableData.value(key).split(splitBy).size();
}

QString DataSet::dataListAt(const QString &key, int index, const QString &splitBy) const
{
    if (d.printableData.value(key).isEmpty())
        return QString();

    return d.printableData.value(key).split(splitBy).value(index);
}

void DataSet::setData(const QString &key, const QVariant &data)
{
    if (key.endsWith("time"))
    {
        d.printableData.insert(key, QDateTime::fromSecsSinceEpoch(data.toInt()).toString("yyyy-MM-dd hh:mm:ss"));
        if (d.enableRefresh) emit refreshView(key);
        return ;
    }

    if (data.canConvert(QVariant::List))
    {
        QStringList items;
        for (auto item : data.toList())
            items << item.toString();

        d.printableData.insert(key, items.join(StringListSeparator));
        if (d.enableRefresh) emit refreshView(key);
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
        if (d.enableRefresh) emit refreshView(key+"/"+it.key());
        return ;
    }

//    if (data.canConvert(QVariant::String))
    d.printableData.insert(key, data.toString());
    if (d.enableRefresh) emit refreshView(key);
}

void DataSet::update(const QVariantHash &data)
{
    d.enableRefresh = false;
    d.printableData.clear();
    QHashIterator<QString, QVariant> it(data);
    while (it.hasNext())
    {
        it.next();
        setData(it.key(), it.value());
    }
    d.enableRefresh = true;

    emit refreshView();
}
