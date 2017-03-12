#include "boxstatsmodel.h"

#include <QtDebug>
#include <QtSql>

#include "boxmodel.h"

BoxStatsModel::BoxStatsModel(QObject *parent) :
    QueryModel(parent)
{

}

void BoxStatsModel::refresh()
{
    if (m_number < 0) return;

    QSqlDatabase db = QSqlDatabase::database();
    if (!db.isOpen()) return;

    QSqlQuery query(db);
    query.prepare(QString("select sum(fooda) as suma, sum(foodb) as sumb, count(fooda) as cowvisits, sum(case fooda when 0 then (case foodb when 0 then 0 else 1 end) else 1 end) as mealcounts, date(entry - time '%1') as day "
                  "from meals where box = :box group by day order by day asc limit :limit").arg(BoxModel::globalNewDayTime().toString("hh:mm:ss")));
    query.bindValue(":box", m_number);
    query.bindValue(":limit", m_days);
    if (!query.exec()) qWarning() << tr("[BoxStatsModel::refresh query error] %1").arg(query.lastError().text());
    else this->setQuery(query);
}

void BoxStatsModel::setNumber(int number)
{
    if (m_number == number)
        return;

    m_number = number;
    emit numberChanged(number);
    refresh();
}

void BoxStatsModel::setDays(int days)
{
    if (m_days == days)
        return;

    m_days = days;
    emit daysChanged(days);
}
