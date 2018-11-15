#ifndef CLIPBOARDPROXY_H
#define CLIPBOARDPROXY_H

#include <QObject>

class ClipBoardProxy : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)
public:
    explicit ClipBoardProxy(QObject *parent = nullptr);

    QString text() const;
    void setText(const QString &txt);

signals:
    void textChanged(const QString &text);

};

#endif // CLIPBOARDPROXY_H
