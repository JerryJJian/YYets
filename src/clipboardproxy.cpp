#include "clipboardproxy.h"
#include <QApplication>
#include <QClipboard>

ClipBoardProxy::ClipBoardProxy(QObject *parent) : QObject(parent)
{

}

QString ClipBoardProxy::text() const
{
    return QApplication::clipboard()->text();
}

void ClipBoardProxy::setText(const QString &txt)
{
    if (txt.compare(text()) == 0)
        return ;

    QApplication::clipboard()->setText(txt);
    emit textChanged(txt);
}
