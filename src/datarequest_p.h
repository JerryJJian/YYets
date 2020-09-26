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

    bool m_isUpdatingIndex   = false;
    bool m_isUpdatingResItem = false;
    bool m_isUpdatingArticle = false;
    bool m_isUpdatingResList = false;
    bool m_isSearching       = false;
    int  m_articlePage       = 0;
    int  m_resourcePage      = 0;

    QNetworkAccessManager *m_network;
    QNetworkRequest *m_request;


    const static QString RequestURL;
};

#endif // DATAREQUEST_P_H
