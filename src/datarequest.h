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

signals:
    void dataReady(int type, const QByteArray &data);
    void downloadProgress(int type, float process);
    void isUpdatingIndexChanged(bool isUpdating);

public slots:
    void requestIndex(int mediaSize = 10, int articleSize = 10);
    void requestReource(int id);

};

#endif // DATAREQUEST_H
