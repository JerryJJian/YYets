#ifndef DATAPARSER_H
#define DATAPARSER_H

#include <QObject>
#include <QList>

class ListItem;

class DataParser : public QObject
{
    Q_OBJECT
public:
    explicit DataParser(QObject *parent = nullptr);

signals:
    void updateData(int type, const QVariant &rawdata, const QList<ListItem*> &items = QList<ListItem*>());

public slots:
    void dataReceived(int type, const QByteArray &data);
};

#endif // DATAPARSER_H
