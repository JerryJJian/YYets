#ifndef DATAPARSER_H
#define DATAPARSER_H

#include <QObject>

class DataParser : public QObject
{
    Q_OBJECT
public:
    explicit DataParser(QObject *parent = nullptr);

signals:

public slots:
};

#endif // DATAPARSER_H