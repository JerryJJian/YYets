#ifndef OBJECTPOOL_H
#define OBJECTPOOL_H

#include "sqldataaccess.h"

#include <QObject>
#include <qglobal.h>

class ObjectPool : public QObject
{
    Q_OBJECT
public:
    static ObjectPool *instance();
    // object destruction
    ~ObjectPool();
    SQLDataAccess *sqlDataAccess() const;


signals:

public slots:

private:
    // settings construction
    ObjectPool(QObject *parent = nullptr);
    static ObjectPool *m_instance;// objectpool instance

    SQLDataAccess *m_sqlDataAccess;

};

#endif // OBJECTPOOL_H
