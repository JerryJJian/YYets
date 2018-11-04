#include "datarequest.h"
#include "datarequest_p.h"

#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QUrl>

const QString DataRequestPrivate::RequestURL("http://api1.ousns.net/index.php?accesskey=519fc5ab85c8015b175449477561a827&client=2&%1&g=api/v1");

DataRequest::DataRequest(QNetworkAccessManager *network, QObject *parent)
    : QObject(*(new DataRequestPrivate(network)), parent)
{

}

void DataRequest::requestIndex(int mediaSize, int articleSize)
{
    Q_D(DataRequest);

    QString url(DataRequestPrivate::RequestURL.arg("a=index&m=index&tlimit=%1&alimit=%2"));
    d->startRequest(INDEX, QUrl(url.arg(mediaSize).arg(articleSize)));
}

DataRequestPrivate::DataRequestPrivate(QNetworkAccessManager *network)
    : m_network(network)
{

}

DataRequestPrivate::~DataRequestPrivate()
{

}

bool DataRequestPrivate::startRequest(int type, const QUrl &url)
{
    QNetworkRequest request(url);
    request.setRawHeader("Accept-Encoding", "gzip");
    request.setRawHeader("Connection",      "Keep-Alive");
    request.setRawHeader("User-Agent",      "okhttp/3.5.0");

    QNetworkReply *reply = m_network->get(request);
    if (reply == NULL)
        return false;

    reply->setReadBufferSize(0);
    reply->setTextModeEnabled(true);
    qDebug()<<"REQUEST:" << url.toString() << "\n\t> Header:" << reply->rawHeaderList();
    Q_Q(DataRequest);

    QObject::connect(m_network, &QNetworkAccessManager::finished, reply, [=](QNetworkReply *nr){
        if (nr != reply) return ;
        qDebug()<<"NETWORK:" <<nr->readAll();
    });
    //    QObject::connect(reply, &QNetworkReply::finished, [=](){ emit q->dataReady(type, reply->readAll()); });
    QObject::connect(reply, &QNetworkReply::readyRead, [=](){

        while (!reply->atEnd())
            qDebug() << reply->readAll();

//        emit q->dataReady(type, reply->readAll());
    });
    QObject::connect(reply, QOverload<QNetworkReply::NetworkError>::of(&QNetworkReply::error),
                     [=](QNetworkReply::NetworkError code) {

        qDebug()<<"REQUEST:" << url.toString() << "\n\t ERROR: #" << code << ">" << reply->errorString();
    });
    QObject::connect(reply, &QNetworkReply::downloadProgress, [=](qint64 bytesReceived, qint64 bytesTotal) {
        if (bytesTotal == 0)
        {
            emit q->downloadProgress(type, 0.0);
            return ;
        }

        if (bytesReceived >= bytesTotal)
        {
            emit q->downloadProgress(type, 1.0);
            return ;
        }

        emit q->downloadProgress(type, bytesReceived / bytesTotal);
    });

    return true;
}

