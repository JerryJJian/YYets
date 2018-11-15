#ifndef DATAREQUEST_H
#define DATAREQUEST_H

#include <QObject>
class QNetworkAccessManager;
class DataRequestPrivate;

class DataRequest : public QObject
{
    Q_OBJECT
    Q_DECLARE_PRIVATE(DataRequest)
    Q_PROPERTY(bool isUpdatingIndex READ getIsUpdatingIndex NOTIFY isUpdatingIndexChanged)
    Q_PROPERTY(bool isUpdatingResItem READ getIsUpdatingResItem NOTIFY isUpdatingResItemChanged)
public:
    explicit DataRequest(QNetworkAccessManager *network, QObject *parent = nullptr);

    enum Type
    {
        INDEX = 0,
        RESOURCE,
        ITEM,
        SEARCH
    };
    Q_ENUM(Type)

    bool getIsUpdatingIndex() const;
    void setIsUpdatingIndex(bool value);

    bool getIsUpdatingResItem() const;
    void setIsUpdatingResItem(bool isUpdatingResItem);

signals:
    void dataReady(int type, const QByteArray &data);
    void downloadProgress(int type, float process);
    void isUpdatingIndexChanged(bool isUpdating);
    void isUpdatingResItemChanged(bool isUpdating);

public slots:
    void requestIndex(int mediaSize = 10, int articleSize = 10);
    void requestResource(int id);
    void requestResourceItem(int id, int season = -1, int episode = -1);
};

#endif // DATAREQUEST_H
