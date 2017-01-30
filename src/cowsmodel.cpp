#include "cowsmodel.h"

#include <QtDebug>
#include <QtSql>

CowsModel::CowsModel(QObject *parent) :
    QueryModel(parent)
  , m_summaryDate(QDate::currentDate().addDays(-1))
{
    // TODO_M: temp hack to get some data displayed by default
    m_summaryDate = QDate(2016, 12, 9);

    QTimer::singleShot(250, this, &CowsModel::refresh);
}

// TODO_M: Where to read the time of the beginning of the day : see later with box page
void CowsModel::refresh()
{
    QSqlDatabase db = QSqlDatabase::database();
    if (!db.isOpen()) return;

    QSqlQuery query(db);
    query.prepare("with mealdays as (select cow, sum(fooda) as sa, sum(foodb) as sb, date(entry - time '05:00:00') as day from meals group by cow, day order by day desc), "
                  "mealtoday as (select * from mealdays where day = :summaryDay), "
                  "alloc as (select distinct on(cow) cow, fooda, foodb from foodallocation order by cow asc, id desc) "
                  "select alloc.cow as cow, alloc.fooda as alloca, alloc.foodb as allocb, mealtoday.day as day, "
                  "mealtoday.sa as meala, mealtoday.sb as mealb from alloc left outer join mealtoday on (mealtoday.cow = alloc.cow) where (alloc.fooda + alloc.foodb > :minFood) order by cow asc");
    query.bindValue(":summaryDay", m_summaryDate);
    query.bindValue(":minFood", m_showUnallocated ? -1 : 0);
    if (!query.exec()) qWarning() << tr("[CowsModel query error] %1").arg(query.lastError().text());
    else this->setQuery(query);
}

void CowsModel::setSummaryDate(QDate summaryDate)
{
    if (m_summaryDate == summaryDate)
        return;

    m_summaryDate = summaryDate;
    emit summaryDateChanged(summaryDate);
    refresh();
}

void CowsModel::setCowAllocation(int cow, int foodA, int foodB)
{
    QSqlDatabase db = QSqlDatabase::database();
    if (!db.isOpen()) return;

    if (m_lastCowAllocation == cow && m_lastAllocationId > 0) {
        // Update last record
        QSqlQuery query(db);
        query.prepare("UPDATE foodallocation SET fooda = :fooda, foodb = :foodb WHERE id = :id");
        query.bindValue(":fooda",  foodA);
        query.bindValue(":foodb",  foodB);
        query.bindValue(":id",  m_lastAllocationId);
        if (!query.exec()) qWarning() << "[CowBox] meal update query error : " << query.lastError().text();
    }
    else {
        // Insert new record in foodalocation for this cow
        QSqlQuery query(db);
        query.prepare("with cowdata as (select mealcount, mealdelay, eatspeed from foodallocation where cow = :cow order by id desc limit 1) "
                      "insert into foodallocation (cow, fooda, foodb, mealcount, mealdelay, eatspeed) select :cow, :fooda, :foodb, mealcount, mealdelay, eatspeed from cowdata RETURNING id");
        query.bindValue(":cow", cow);
        query.bindValue(":fooda", foodA);
        query.bindValue(":foodb", foodB);
        if (!query.exec()) qWarning() << tr("[CowsModel::setCowAllocation query error] %1 - %2").arg(query.lastQuery()).arg(query.lastError().text());
        else if (query.next()) {
            m_lastAllocationId = query.value(0).toInt();
            m_lastCowAllocation = cow;
        }
    }
}

void CowsModel::setShowUnallocated(bool showUnallocated)
{
    if (m_showUnallocated == showUnallocated)
        return;

    m_showUnallocated = showUnallocated;
    emit showUnallocatedChanged(showUnallocated);
}

