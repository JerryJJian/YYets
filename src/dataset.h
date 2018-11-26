#ifndef DATASET_H
#define DATASET_H

#include <QObject>
#include <QVariantHash>

class DataSet : public QObject
{
    Q_OBJECT
public:
    explicit DataSet(QObject *parent = nullptr);

    Q_INVOKABLE QString data(const QString &key) const;
    Q_INVOKABLE bool dataListContains(const QString &key, const QString value, const QString &splitBy = StringListSeparator) const;
    Q_INVOKABLE QStringList dataList(const QString &key, const QString &splitBy = StringListSeparator) const;
    Q_INVOKABLE int dataListSize(const QString &key, const QString &splitBy = StringListSeparator) const;
    Q_INVOKABLE QString dataListAt(const QString &key, int index, const QString &splitBy = StringListSeparator) const;

signals:
    void refreshView(const QString &key = QString());

public slots:
    void setData(const QString &key, const QVariant &data);
    void update(const QVariantHash &data);

private:
    struct PrivateData
    {
        QHash<QString, QString> printableData;
        bool enableRefresh;
    } d;

    static const QString StringListSeparator;
};

#endif // DATASET_H
