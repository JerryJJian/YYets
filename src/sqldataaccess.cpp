#include "sqldataaccess.h"
#include <QDebug>
#include <QSqlRecord>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>
#include <QJsonDocument>
#include <QFile>
#include <QBuffer>
#include <QCryptographicHash>
#include <QCoreApplication>
#include <QDataStream>

SQLDataAccess::SQLDataAccess(QObject *parent)
    : QObject(parent),
#ifdef DATABASE_MYSQL
      m_db(QSqlDatabase::addDatabase("QMYSQL")),
#endif
#ifdef DATABASE_SQLITE
      m_db(QSqlDatabase::addDatabase("QSQLITE", "YYeTs-database")),
#endif
      m_error(0),
      m_errorString(tr("No Error"))
{
}

bool SQLDataAccess::connect(const QString &host,
                            const QString &dbname,
                            int port,
                            const QString &username,
                            const QString &passwd)
{
    if (m_db.isOpen())
        m_db.close();

#ifdef DATABASE_MYSQL
    m_db.setHostName(host);
    m_db.setPort(port);
    m_db.setDatabaseName(dbname);
    m_db.setUserName(username);
    m_db.setPassword(passwd);
    m_db.setConnectOptions("MYSQL_OPT_RECONNECT=1");
#endif
#ifdef DATABASE_SQLITE
    m_db.setDatabaseName(host);
    m_db.setHostName(dbname);
#endif

    if (!m_db.open() && !m_db.isOpen())
    {
        emit errorOccured(tr("Cannot connect Database: %1, at %2:%3").arg(dbname).arg(host).arg(port));
        m_error = -1;
        m_errorString = m_db.lastError().text();
        qDebug() << tr("Cannot connect Database: %1, at %2:%3").arg(dbname).arg(host).arg(port)
                 << m_errorString;
        return false;
    }

#ifdef DATABASE_MYSQL
    m_db.exec("SET NAMES 'gbk'; SET SQL_SAFE_UPDATES=0; ");
#endif

    initTables();

    m_error = 0;
    m_errorString = QObject::tr("No Error");
    return true;
}

void SQLDataAccess::disconnect()
{
    if (m_db.isOpen())
        m_db.close();
}

bool SQLDataAccess::open()
{
    if (m_db.isOpen())
        return true;

    if (!m_db.open() && !m_db.isOpen())
    {
        m_error = -1;
        m_errorString = m_db.lastError().text();
        qDebug() << tr("Cannot connect Database")
                 << m_errorString;
        return false;
    }

#ifdef DATABASE_MYSQL
    m_db.exec("SET NAMES 'gbk'; SET SQL_SAFE_UPDATES=0; ");
#endif

    return m_db.isOpen();
}

bool SQLDataAccess::reOpen()
{
    m_db.close();
    return open();
}

bool SQLDataAccess::isConnected() const
{
    return m_db.isOpen();
}

int SQLDataAccess::execQuery(const QString &sql)
{
    int rows = 0;
    if(!open())
    {
        qDebug() << " open db Error " << m_db.lastError().text();
        return -1;
    }

    QString sqltext(sql.trimmed());
    QSqlQuery query(m_db);
    try
    {
        if (!query.exec(sqltext))
        {
            reOpen();
            if (!query.exec(sqltext))
            {
                emit errorOccured(query.lastError().text());
                m_db.close();
            }
        }

        rows = query.numRowsAffected();

        qDebug() << "[SQL QUERY] >" << rows << ":" << query.lastQuery();

        if (sqltext.startsWith("insert", Qt::CaseInsensitive) && rows > 0)
            rows = query.lastInsertId().toInt();
    }
    catch(...)
    {
        rows = -1;
        qDebug() << "ERROR:" << m_db.lastError().text();
        m_error = -2;
        m_errorString = m_db.lastError().text();
        m_db.close();
        emit errorOccured(query.lastError().text());
    }

    qDebug() << "SQL >" << sqltext << "\n\t#" << query.lastQuery()<< "\n\t#"  << query.lastError().text();

    m_error = 0;
    m_errorString = QObject::tr("No Error");
    return rows;
}

int SQLDataAccess::execQuery(const QString &sql, QList<QSqlRecord> &result)
{
    int rows = 0;

    if(!open())
    {
        qDebug() << " open db Error " << m_db.lastError().text();
        return -1;
    }

    QSqlQuery query(m_db);
    try
    {
        query.setForwardOnly(true);
        if (query.prepare(sql))
            query.exec(sql);

        while(query.next())
            result.append(query.record());

        rows = result.count();
    }
    catch(...)
    {
        rows = -1;
        qDebug() << "ERROR:" << m_db.lastError().text();
        m_error = -2;
        m_errorString = m_db.lastError().text();
        m_db.close();
        emit errorOccured(query.lastError().text());
    }

    qDebug() << "SQL:" << query.lastQuery();
    m_error = 0;
    m_errorString = QObject::tr("No Error");
    return rows;
}

void SQLDataAccess::initTables()
{
    execQuery("CREATE TABLE IF NOT EXISTS `history` ( `id` INTEGER NOT NULL UNIQUE, `data` BLOB, PRIMARY KEY(`id`) );");
    execQuery("CREATE TABLE IF NOT EXISTS `followed` ( `id` INTEGER NOT NULL UNIQUE, "
              " `meta` BLOB, `prevue` TEXT, `lastvisit` INTEGER, PRIMARY KEY(`id`) );");
}

QSqlDatabase SQLDataAccess::database() const
{
    return m_db;
}

int SQLDataAccess::error() const
{
    return m_error;
}

QString SQLDataAccess::errorString() const
{
    return m_errorString;
}

QVariant SQLDataAccess::history(int id)
{
    QString sql("SELECT * FROM `history` WHERE `id`='%1';");
    QList<QSqlRecord> result;
    execQuery(sql.arg(id), result);

    QVariant historyData;
    if (result.size() > 0)
    {
        QByteArray bytes(result.value(0).value("data").toByteArray());
        QDataStream in(&bytes, QIODevice::ReadOnly);
        in >> historyData;
    }

    return historyData;
}

bool SQLDataAccess::addHistory(int id, const QString &season, const QString &episode)
{
    QVariantMap historyMap = history(id).toMap();
    if (historyMap.isEmpty())
    {
        historyMap.insert(season, QStringList(episode));
        QByteArray bytes;
        QDataStream out(&bytes, QIODevice::WriteOnly);
        out << QVariant::fromValue(historyMap);

        QSqlQuery query(m_db);
        if (query.prepare("INSERT INTO `history` (`id`, `data`) VALUES(?, ?);"))
        {
            query.addBindValue(id);
            query.addBindValue(bytes);
            if (query.exec())
            {
                emit historyAdded(id, season, episode);
                return true;
            }
            else
            {
                qDebug() << "ERROR > query.exec(" << query.lastQuery() << ")" << query.lastError().text();
            }
        }
        else
        {
            qDebug() << "ERROR > query.prepare(" << query.lastQuery() << ")" << query.lastError().text();
        }

        return false;
    }


    QStringList eps = historyMap.value(season).toStringList();
    if (eps.indexOf(episode) >= 0)
        return true;

    eps << episode;

    qDebug() << "HISTORY:" << eps;

    historyMap.insert(season, eps);
    QByteArray bytes;
    QDataStream out(&bytes, QIODevice::WriteOnly);
    out << QVariant::fromValue(historyMap);

    QSqlQuery query(m_db);
    if (query.prepare(QString("UPDATE `history` SET `data`=? WHERE `id`='%1';").arg(id)))
    {
        query.addBindValue(bytes);
        if (query.exec())
        {
            emit historyAdded(id, season, episode);
            return true;
        }
        else
        {
            qDebug() << "ERROR > query.exec(" << query.lastQuery() << ")" << query.lastError().text();
        }
    }
    else
    {
        qDebug() << "ERROR > query.prepare(" << query.lastQuery() << ")" << query.lastError().text();
    }

    return false;
}

bool SQLDataAccess::addFollowed(int id, const QByteArray &meta, const QString &prevue, int lastvisit)
{
    QString checkSql("SELECT `id` FROM `followed` WHERE `id`='%1';");
    QList<QSqlRecord> result;
    execQuery(checkSql.arg(id), result);

    if (result.value(0).value("id").toInt() != id)
    {
        QString insertSql("INSERT INTO `followed` (`id`, `meta`, `prevue`, `lastvisit`) VALUES ('%1', ?, '%2', '%3');");
        QSqlQuery query(m_db);
        if (query.prepare(insertSql.arg(id).arg(prevue).arg(lastvisit)))
        {
            query.addBindValue(meta);
            if (query.exec())
                return true;
            else
                qDebug() << "ERROR > query.exec(" << query.lastQuery() << ")" << query.lastError().text();
        }
        else
        {
            qDebug() << "ERROR > query.prepare(" << query.lastQuery() << ")" << query.lastError().text();
        }

        return false;
    }

    return execQuery(QString("DELETE FROM `followed` WHERE `id`='%1';").arg(id)) == 0;
}

void SQLDataAccess::removeFollowed(int id)
{
    execQuery(QString("DELETE FROM `followed` WHERE `id`='%1';").arg(id));
}

QByteArray SQLDataAccess::followedList(int page, int pageSize)
{
    QString sql("SELECT * FROM `followed` ORDER BY `prevue` DESC LIMIT %1, %2;");
    QList<QSqlRecord> result;
    execQuery(sql.arg(((page < 1 ? 1 : page) - 1) * pageSize).arg(pageSize), result);

    QStringList resources;
    for (auto rec : result)
        resources.append(QString::fromUtf8(rec.value("meta").toByteArray()));

    return QString("{\"data\":{\"list\":[%1], \"page\": %2 }}").arg(resources.join(",")).arg(page < 1 ? 1 : page).toUtf8();
}

bool SQLDataAccess::hasFollowed(int id)
{
    QString checkSql("SELECT `id` FROM `followed` WHERE `id`='%1';");
    QList<QSqlRecord> result;
    execQuery(checkSql.arg(id), result);

    return (result.value(0).value("id").toInt() == id);
}

QList<int> SQLDataAccess::checkFollowed(const QStringList &ids)
{
    QString checkSql("SELECT `id` FROM `followed` WHERE `id` IN ('%1');");
    QList<QSqlRecord> result;
    execQuery(checkSql.arg(ids.join("','")), result);

    QList<int> followed;
    for (auto rec : result)
        followed << rec.value("id").toInt();

    return followed;
}

bool SQLDataAccess::updateFollowed(int id, const QByteArray &meta, const QString &prevue)
{
    QString updateSql("UPDATE `followed` SET `meta`=?, `prevue`='%2', `lastvisit`='%3' WHERE `id`='%1';");
    QSqlQuery query(m_db);
    if (query.prepare(updateSql.arg(id).arg(prevue).arg(QDateTime::currentDateTime().toSecsSinceEpoch())))
    {
        query.addBindValue(meta);
        if (query.exec())
            return true;
        else
            qDebug() << "ERROR > query.exec(" << query.lastQuery() << ")" << query.lastError().text();
    }
    else
    {
        qDebug() << "ERROR > query.prepare(" << query.lastQuery() << ")" << query.lastError().text();
    }

    return false;
}
