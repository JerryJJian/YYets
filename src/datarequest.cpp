#include "datarequest.h"
#include "datarequest_p.h"
#include "objectpool.h"

#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QUrl>

const QString DataRequestPrivate::RequestURL("http://mobil.allappapi.com/index.php?accesskey=519fc5ab85c8015b175449477561a827&client=2&%1&g=api/v1");

DataRequest::DataRequest(QNetworkAccessManager *network, QObject *parent)
    : QObject(*(new DataRequestPrivate(network)), parent)
{

}

void DataRequest::requestIndex(int mediaSize, int articleSize)
{
    Q_D(DataRequest);

    QString url(DataRequestPrivate::RequestURL.arg("a=index&m=index&tlimit=%1&alimit=%2"));
    setIsUpdatingIndex(d->startRequest(INDEX, QUrl(url.arg(mediaSize).arg(articleSize))));
}

void DataRequest::requestResource(int id)
{
    Q_D(DataRequest);
    QString url(DataRequestPrivate::RequestURL.arg("a=resource&m=index&id=%1"));
    d->startRequest(RESOURCE, QUrl(url.arg(id)));
}

void DataRequest::requestResourceItem(int id, int season, int episode)
{
    Q_D(DataRequest);
    QString url(DataRequestPrivate::RequestURL.arg("a=resource_item&m=index%1&id=%2"));
    d->startRequest(ITEM, QUrl(url.arg(season >= 0 ? QString("&season=%1&episode=%2").arg(season).arg(episode) : "").arg(id)));
    setIsUpdatingResItem(true);
}

void DataRequest::requestArticleList(int page)
{
    Q_D(DataRequest);
    QString url(DataRequestPrivate::RequestURL.arg("a=article_list&page=%1"));
    d->startRequest(ARTICLELIST, QUrl(url.arg(page)));
}

void DataRequest::requestArticle(int id)
{
    Q_D(DataRequest);
    QString url(DataRequestPrivate::RequestURL.arg("a=article&id=%1"));
    d->startRequest(ARTICLE, QUrl(url.arg(id)));
}

void DataRequest::requestResourceList(int page, int countPerPage, QString area, QString sort, QString channel, QString year)
{
    Q_D(DataRequest);
    QString url(DataRequestPrivate::RequestURL.arg("a=resource_list&page=%1&limit=%2&area=%3&sort=%4&channel=%5&year=%6"));
    d->startRequest(RESOURCELIST, QUrl(url.arg(page).arg(countPerPage).arg(area).arg(sort).arg(channel).arg(year)));
}

void DataRequest::searchResource(QString type, QString text, int page, int limit)
{
    Q_D(DataRequest);
    QString url(DataRequestPrivate::RequestURL.arg("a=search&st=%1&k=%2&page=%3&limit=%4"));
    d->startRequest(SEARCHRESOURCE, QUrl(url.arg(type).arg(text).arg(page).arg(limit)));
}

void DataRequest::requestFollowedList(int page, int size)
{
    emit dataReady(FOLLOWEDLIST, ObjectPool::instance()->sqlDataAccess()->followedList(page, size));
}

bool DataRequest::getIsUpdatingResList() const
{
    Q_D(const DataRequest);
    return d->m_isUpdatingResList;
}

void DataRequest::setIsUpdatingResList(bool isUpdatingResList)
{
    Q_D(DataRequest);
    if (d->m_isUpdatingResList == isUpdatingResList)
        return ;
    d->m_isUpdatingResList = isUpdatingResList;
    emit isUpdatingResListChanged(d->m_isUpdatingResList);
}

bool DataRequest::getIsSearching() const
{
    Q_D(const DataRequest);
    return d->m_isSearching;
}

void DataRequest::setIsSearching(bool isSearching)
{
    Q_D(DataRequest);
    if (d->m_isSearching == isSearching)
        return ;
    d->m_isSearching = isSearching;
    emit isSearchingChanged(d->m_isSearching);
}

int DataRequest::getResourcePage() const
{
    Q_D(const DataRequest);
    return d->m_resourcePage;
}

void DataRequest::setResourcePage(int resourcePage)
{
    Q_D(DataRequest);
    if (d->m_resourcePage == resourcePage)
        return ;

    d->m_resourcePage = resourcePage;
    emit resourcePageChanged(d->m_resourcePage);
}

int DataRequest::getArticlePage() const
{
    Q_D(const DataRequest);
    return d->m_articlePage;
}

void DataRequest::setArticlePage(int articlePage)
{
    Q_D(DataRequest);
    if (d->m_articlePage == articlePage)
        return ;

    d->m_articlePage = articlePage;
    emit articlePageChanged(d->m_articlePage);
}

bool DataRequest::getIsUpdatingArticle() const
{
    Q_D(const DataRequest);
    return d->m_isUpdatingArticle;
}

void DataRequest::setIsUpdatingArticle(bool isUpdatingArticle)
{
    Q_D(DataRequest);
    if (d->m_isUpdatingArticle == isUpdatingArticle)
        return ;

    d->m_isUpdatingArticle = isUpdatingArticle;
    emit isUpdatingArticleChanged(d->m_isUpdatingArticle);
}

bool DataRequest::getIsUpdatingResItem() const
{
    Q_D(const DataRequest);
    return d->m_isUpdatingResItem;
}

void DataRequest::setIsUpdatingResItem(bool isUpdatingResItem)
{
    Q_D(DataRequest);
    if (d->m_isUpdatingResItem == isUpdatingResItem)
        return ;

    d->m_isUpdatingResItem = isUpdatingResItem;
    emit isUpdatingResItemChanged(d->m_isUpdatingResItem);
}

bool DataRequest::getIsUpdatingIndex() const
{
    Q_D(const DataRequest);
    return d->m_isUpdatingIndex;
}

void DataRequest::setIsUpdatingIndex(bool value)
{
    Q_D(DataRequest);
    if (d->m_isUpdatingIndex == value)
        return ;

    d->m_isUpdatingIndex = value;
    emit isUpdatingIndexChanged(d->m_isUpdatingIndex);
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

    QNetworkReply *reply = m_network->get(request);
    if (reply == NULL)
        return false;

    reply->setReadBufferSize(0);
    reply->setTextModeEnabled(true);
    qDebug()<<"REQUEST:" << url.toString() << "\n\t> Header:" << reply->rawHeaderList();
    Q_Q(DataRequest);


    QObject::connect(reply, &QNetworkReply::finished, [=](){ emit q->dataReady(type, reply->readAll()); });
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

