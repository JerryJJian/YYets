#ifndef OBJECTPOOL_H
#define OBJECTPOOL_H

#include "settings.h"
#include "sqldataaccess.h"

#include <QObject>
#include <qglobal.h>
#include <QSettings>

class ObjectPool : public QObject
{
    Q_OBJECT
public:
    // object destruction
    static ObjectPool *instance();
    ~ObjectPool();
    SQLDataAccess *sqlDataAccess() const;
    Settings *settings() const;

signals:

public slots:

private:
    // settings construction
    ObjectPool(QObject *parent = nullptr);
    static ObjectPool *m_instance;// objectpool instance

    SQLDataAccess *m_sqlDataAccess;
    Settings *m_settings;

};

#endif // OBJECTPOOL_H
