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
    Q_PROPERTY(bool isUpdatingArticle READ getIsUpdatingArticle NOTIFY isUpdatingArticleChanged)
    Q_PROPERTY(bool isUpdatingResList READ getIsUpdatingResList NOTIFY isUpdatingResListChanged)
    Q_PROPERTY(int  articlePage READ getArticlePage WRITE setArticlePage NOTIFY articlePageChanged)
    Q_PROPERTY(int  resourcePage READ getResourcePage WRITE setResourcePage NOTIFY resourcePageChanged)
public:
    explicit DataRequest(QNetworkAccessManager *network, QObject *parent = nullptr);

    enum Type
    {
        INDEX = 0,
        RESOURCE,
        ITEM,
        ARTICLELIST,
        ARTICLE,
        RESOURCELIST,
        SEARCH
    };
    Q_ENUM(Type)

    bool getIsUpdatingIndex() const;
    void setIsUpdatingIndex(bool value);

    bool getIsUpdatingResItem() const;
    void setIsUpdatingResItem(bool isUpdatingResItem);

    bool getIsUpdatingArticle() const;
    void setIsUpdatingArticle(bool isUpdatingArticle);

    int getArticlePage() const;
    void setArticlePage(int articlePage);

    int getResourcePage() const;
    void setResourcePage(int resourcePage);

    bool getIsUpdatingResList() const;
    void setIsUpdatingResList(bool isUpdatingResList);

signals:
    void dataReady(int type, const QByteArray &data);
    void downloadProgress(int type, float process);
    void isUpdatingIndexChanged(bool isUpdating);
    void isUpdatingResItemChanged(bool isUpdating);
    void isUpdatingArticleChanged(bool isUpdating);
    void isUpdatingResListChanged(bool isUpdating);
    void articlePageChanged(int page);
    void resourcePageChanged(int page);

public slots:
    void requestIndex(int mediaSize = 10, int articleSize = 10);
    void requestResource(int id);
    void requestResourceItem(int id, int season = -1, int episode = -1);
    void requestArticleList(int page);
    void requestArticle(int id);
    void requestResourceList(int page = 1, int countPerPage = 30, QString area = QString(), QString sort = QString("update"), QString channel = QString(), QString year = QString());
};

#endif // DATAREQUEST_H
