#include "objectpool.h"

#include <QApplication>


ObjectPool *ObjectPool::m_instance = nullptr;

ObjectPool::ObjectPool(QObject *parent)
    : QObject(parent)
{

    m_sqlDataAccess = new SQLDataAccess(this);
    m_sqlDataAccess->connect(QCoreApplication::applicationDirPath() + "/yyets.db", "yyets-database");
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

