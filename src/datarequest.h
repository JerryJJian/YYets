#ifndef DATAREQUEST_H
#define DATAREQUEST_H

#include <QObject>
class QNetworkAccessManager;
class DataRequestPrivate;

class DataRequest : public QObject
{
    Q_OBJECT
    Q_DECLARE_PRIVATE(DataRequest)
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

signals:
    void dataReady(int type, const QByteArray &data);
    void downloadProgress(int type, float process);

public slots:
    void requestIndex(int mediaSize = 10, int articleSize = 10);
    void requestReource(int id);

};

#endif // DATAREQUEST_H
