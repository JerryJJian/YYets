#ifndef SQLDATAACCESS_H
#define SQLDATAACCESS_H

#include <QObject>
#include <qglobal.h>
#include <QSqlDatabase>
#include <QVariant>
#include <QMap>
#include <QDateTime>

class SQLDataAccess : public QObject
{
    Q_OBJECT
public:
    SQLDataAccess(QObject *parent = nullptr);
    QSqlDatabase database() const;

    bool isConnected() const;
    bool connect(const QString &host, const QString &dbname, int port = 3306, const QString &username = QString(), const QString &passwd = QString());
    void disconnect();
    bool open();
    bool reOpen();

    int execQuery(const QString &sql);
    int execQuery(const QString &sql, QList<QSqlRecord> &result);

    int error() const;
    QString errorString() const;

signals:
    void errorOccured(const QString &errorString);
    void historyAdded(int id, const QString &season, const QString &episode);

public slots:
    // QVariantMap, QMap<QString, QStringList>
    QVariant history(int id);
    bool addHistory(int id, const QString &season = QString(), const QString &episode = QString());
    bool addFollowed(int id, const QByteArray &meta, const QString &prevue, int lastvisit);
    void removeFollowed(int id);
    QByteArray followedList(int page = 1, int pageSize = 10);
    bool hasFollowed(int id);
    QList<int> checkFollowed(const QStringList &ids);
    bool updateFollowed(int id, const QByteArray &meta, const QString &prevue);

private:
    void initTables();

private:
    QSqlDatabase m_db;
    int     m_error;
    QString m_errorString;
};

#endif // SQLDATAACCESS_H
