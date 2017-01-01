#include "querymodel.h"

#include <QtSql>

QueryModel::QueryModel(QObject *parent) :
    QSqlQueryModel(parent)
{
}

QVariant QueryModel::data(const QModelIndex &index, int role) const
{
    if(role <= Qt::UserRole) return QSqlQueryModel::data(index, role);
    else {
        int columnIdx = role - Qt::UserRole - 1;
        QModelIndex modelIndex = this->index(index.row(), columnIdx);
        QVariant d = QSqlQueryModel::data(modelIndex, Qt::DisplayRole);
        if (d.isNull()) return QVariant(QString());
        else return d;
    }
}

QHash<int, QByteArray> QueryModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    QSqlRecord r = record();
    for (int i = 0; i < r.count(); i++) {
        roles[Qt::UserRole + i + 1] = r.fieldName(i).toLatin1();
    }
    return roles;
}

QVariant QueryModel::data(int row, const QString columnName) const
{
    QSqlRecord r = record(row);
    QVariant v = r.value(columnName);
    if (v.isNull()) return QVariant(QString());
    else return v;
}

QString QueryModel::columnRole(int column) const
{
    QSqlRecord r = record();
    return r.fieldName(column);
}

QJsonObject QueryModel::object(int row) const
{
    QJsonObject o;
    QSqlRecord r = record(row);
    for (int i = 0; i < r.count(); i++) {
        o.insert(r.fieldName(i), QJsonValue::fromVariant(r.value(i)));
    }
    return o;
}

int QueryModel::rowOf(QVariant data, const QString &columnName) const
{
    int role = roleNames().key(columnName.toLatin1());
    int columnIdx = role - Qt::UserRole - 1;
    for (int row = 0; row < rowCount(); row++) {
        QModelIndex modelIndex = this->index(row, columnIdx);
        if (data == QueryModel::data(modelIndex, Qt::DisplayRole)) return row;
    }
    return -1;
}

QVariantMap QueryModel::recordData(int row) const
{
    return object(row).toVariantMap();
}
