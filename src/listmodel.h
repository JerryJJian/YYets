/****************************************************************************
**
** Copyright (C) 2014 Chen Jian <Jerry.C@foxmail.com>
** All rights reserved.
** Contact: Chen Jian <Jerry.C@foxmail.com>
**
** If you want use this file in the commercial usage, please MUST contact to me.
**
** $QT_BEGIN_LICENSE:LGPL$
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Digia gives you certain additional
** rights.  These rights are described in the Digia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
** If you have questions regarding the use of this file, please contact
** Chen Jian, email: Jerry.C@foxmail.com
** $QT_END_LICENSE$
**
****************************************************************************/

#ifndef LISTMODEL_H
#define LISTMODEL_H

#include <QAbstractListModel>
#include <QList>
#include <QVariant>
#include <QDebug>

class ListItem: public QObject
{
    Q_OBJECT

public:
    ListItem(QObject* parent = 0)
        : QObject(parent),
          m_isSelected(false)
    {}

    ListItem(const QMap<int, QVariant> &data, QObject* parent = 0)
        : QObject(parent), m_data(data),
          m_isSelected(false)
    {}

    virtual ~ListItem() { }

    virtual QString id() const = 0;
    virtual bool selected() const { return m_isSelected; }
    virtual void setSelected(bool selected)
    {
        if (m_isSelected == selected)
            return ;

        m_isSelected = selected;
        emit dataChanged();
    }

    QVariant data(int role) const
    {
        return m_data.value(role, QVariant());
    }

    bool setData(int role, const QVariant &value)
    {
        if (!roleNames().contains(role))
            return false;

        m_data.insert(role, value);
        emit dataChanged();

        return true;
    }

    QHash<int, QByteArray> roleNames() const { return m_roleNames; }
    int role(const QString &name) const { return m_roleNames.key(name.toUtf8(), -1); }
    QByteArray roleName(int role) const { return m_roleNames.value(role, "None"); }

signals:
    void dataChanged();

protected:
    QMap<int, QVariant> m_data;
    QHash<int, QByteArray> m_roleNames;
    bool m_isSelected;
};

class ListModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
    Q_PROPERTY(int effectCount READ getEffectCount NOTIFY effectCountChanged)
    Q_PROPERTY(bool selectedMode READ selectedMode NOTIFY selectedModeChanged)
public:
    explicit ListModel(ListItem *prototype, QObject* parent = 0);
    ~ListModel();
    Q_INVOKABLE int rowCount(const QModelIndex &parent = QModelIndex()) const;
    Q_INVOKABLE int columnCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    bool setData(const QModelIndex & index, const QVariant & value, int role = Qt::EditRole);
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const;
    bool setHeaderData(int section, Qt::Orientation orientation, const QVariant &value, int role = Qt::EditRole);

    ListItem *takeRow(int row);
    ListItem *find(const QString &id) const;
    QModelIndex indexFromItem( const ListItem *item) const;
    bool removeRow(int row, const QModelIndex &parent = QModelIndex());
    bool removeRows(int row, int count, const QModelIndex &parent = QModelIndex());

    virtual QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE QString data(int index, QString roleName);

    Q_INVOKABLE bool selectedMode() const;
    Q_INVOKABLE int getEffectCount() const;
    void setEffectCount(int count);

    Q_INVOKABLE QStringList selectedItems();

public slots:
    void updateRows(const QList<ListItem *> &items);
    void prependRows(const QList<ListItem *> &items);
    void appendRow(ListItem *item);
    void appendRows(const QList<ListItem *> &items);
    void insertRow(int row, ListItem *item);
    void clear();
    void cancelSlectectMode();
    void removeSelectedItems();
    void setColumnIconTranslate(int column, int role, const QString &iconpath);

signals:
    void dataModelUpdated();
    void dataModelChanged();
    void dataModelPrepended();
    void dataModelAppended();
    void selectedModeChanged(bool selectedMode);
    void countChanged(int count);
    void effectCountChanged(int count);

private slots:
    void handleItemChange();

private:
    ListItem *m_prototype;
    QMap<int, int> m_header;
    QList<ListItem *> m_list;
    QHash<ListItem *, int> m_selectedItem;
    QHash<QString, ListItem *> m_index;
    // < column, <role, icon path> >
    QMap<int, QPair<int, QString> > m_iconTrans;
    int m_effectCount;
};

#endif // LISTMODEL_H
