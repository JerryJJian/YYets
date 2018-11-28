#include "objectpool.h"

#include <QApplication>
#include <QDir>


ObjectPool *ObjectPool::m_instance = nullptr;

ObjectPool::ObjectPool(QObject *parent)
    : QObject(parent)
{

    m_sqlDataAccess = new SQLDataAccess(this);
#ifdef Q_OS_ANDROID
    m_sqlDataAccess->connect(QDir::currentPath() + "/yyets.db", "yyets-database");
#else
    m_sqlDataAccess->connect(QCoreApplication::applicationDirPath() + "/yyets.db", "yyets-database");
#endif
}


SQLDataAccess *ObjectPool::sqlDataAccess() const
{
    return m_sqlDataAccess;
}

ObjectPool *ObjectPool::instance()
{
    if (m_instance == nullptr)
        m_instance = new ObjectPool();

    return m_instance;
}

ObjectPool::~ObjectPool()
{
    m_sqlDataAccess->disconnect();
}

