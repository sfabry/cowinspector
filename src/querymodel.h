#ifndef QUERYMODEL_H
#define QUERYMODEL_H

#include <QSqlQueryModel>
#include <QJsonObject>

class QueryModel : public QSqlQueryModel
{
    Q_OBJECT
public:
    explicit QueryModel(QObject *parent = 0);

    virtual QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;
    Q_INVOKABLE QVariant data(int row, const QString columnName) const;
    Q_INVOKABLE QString columnRole(int column) const;
    Q_INVOKABLE QJsonObject object(int row) const;
    Q_INVOKABLE int rowOf(QVariant data, const QString &columnName) const;
    Q_INVOKABLE virtual void refresh() { emit doRefresh(); }

    QVariantMap recordData(int row) const;

signals:
    // If no subclass, simply connect to refresh signal
    void doRefresh();
};

#endif // QUERYMODEL_H
