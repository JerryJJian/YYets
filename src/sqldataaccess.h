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

public slots:
    QVariant history(int id);
    void addHistory(int id, const QString &season = QString(), const QString &episode = QString());
    void addFollowed(int id, const QString &meta, int lastvisit);
    void removeFollowed(int id);

private:
    void initTables();

private:
    QSqlDatabase m_db;
    int     m_error;
    QString m_errorString;
};

#endif // SQLDATAACCESS_H
