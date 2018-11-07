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

signals:
    void refreshView();

public slots:
    void setData(const QString &key, const QVariant &data);
    void update(const QVariantHash &data);

private:
    struct PrivateData
    {
        QHash<QString, QString> printableData;
        bool enableRefresh;
    } d;
};

#endif // DATASET_H
