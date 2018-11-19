#ifndef DATAREQUEST_P_H
#define DATAREQUEST_P_H

#include <private/qobject_p.h>

class QNetworkAccessManager;
class QNetworkRequest;
class DataRequest;

class DataRequestPrivate : public QObjectPrivate
{
    Q_DECLARE_PUBLIC(DataRequest)
public:
    DataRequestPrivate(QNetworkAccessManager *network);
    ~DataRequestPrivate();

    bool startRequest(int type, const QUrl &url);

    bool m_isUpdatingIndex;
    bool m_isUpdatingResItem;
    bool m_isUpdatingArticle;
    bool m_isUpdatingResList;
    int  m_articlePage;
    int  m_resourcePage;

    QNetworkAccessManager *m_network;
    QNetworkRequest *m_request;


    const static QString RequestURL;
};

#endif // DATAREQUEST_P_H
