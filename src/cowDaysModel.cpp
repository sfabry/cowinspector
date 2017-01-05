#include "cowdaysmodel.h"

#include <QtDebug>
#include <QtSql>

CowDaysModel::CowDaysModel(QObject *parent) :
    QueryModel(parent)
{
    QTimer::singleShot(250, this, &CowDaysModel::refresh);
}

// TODO_M: Where to read the time of the beginning of the day : see later with box page
void CowDaysModel::refresh()
{
    QSqlDatabase db = QSqlDatabase::database();
    if (!db.isOpen()) return;

    QSqlQuery query(db);
    query.prepare("select count(cow) as mealcount, sum(fooda) as sa, sum(foodb) as sb, date(entry - time '05:00:00') as day "
                  "from meals where cow = :cow group by day order by day desc limit 15");
    query.bindValue(":cow", m_cowNumber);
    if (!query.exec()) qWarning() << tr("[CowDaysModel query error] %1").arg(query.lastError().text());
    else this->setQuery(query);

    QSqlQuery query2(db);
    query2.prepare("select fooda, foodb, mealcount, mealdelay, eatspeed from foodallocation where cow = :cow order by id desc limit 1");
    query2.bindValue(":cow", m_cowNumber);
    if (!query2.exec() || !query2.next()) qWarning() << tr("[Food allocation query error] %1").arg(query2.lastError().text());
    else {
        setAllocA(query2.value(0).toInt());
        setAllocB(query2.value(1).toInt());
        setMealCount(query2.value(2).toInt());
        setMealDelay(query2.value(3).toInt());
        setEatSpeed(query2.value(4).toInt());
    }

}

void CowDaysModel::setCowNumber(int cowNumber)
{
    if (m_cowNumber == cowNumber)
        return;

    m_cowNumber = cowNumber;
    emit cowNumberChanged(cowNumber);
    refresh();
}

void CowDaysModel::setAllocA(int allocA)
{
    if (m_allocA == allocA)
        return;

    m_allocA = allocA;
    emit allocAChanged(allocA);
}

void CowDaysModel::setAllocB(int allocB)
{
    if (m_allocB == allocB)
        return;

    m_allocB = allocB;
    emit allocBChanged(allocB);
}

void CowDaysModel::setMealCount(int mealCount)
{
    if (m_mealCount == mealCount)
        return;

    m_mealCount = mealCount;
    emit mealCountChanged(mealCount);
}

void CowDaysModel::setMealDelay(int mealDelay)
{
    if (m_mealDelay == mealDelay)
        return;

    m_mealDelay = mealDelay;
    emit mealDelayChanged(mealDelay);
}

void CowDaysModel::setEatSpeed(int eatSpeed)
{
    if (m_eatSpeed == eatSpeed)
        return;

    m_eatSpeed = eatSpeed;
    emit eatSpeedChanged(eatSpeed);
}

void CowDaysModel::commitChanges()
{
    QSqlDatabase db = QSqlDatabase::database();
    if (!db.isOpen()) return;

    // Insert new record in foodalocation for this cow
    QSqlQuery query(db);
    query.prepare("insert into foodallocation (cow, fooda, foodb, mealcount, mealdelay, eatspeed) values (:cow, :fooda, :foodb, :mealcount, :mealdelay, :eatspeed)");
    query.bindValue(":cow", m_cowNumber);
    query.bindValue(":fooda", m_allocA);
    query.bindValue(":foodb", m_allocB);
    query.bindValue(":mealcount", m_mealCount);
    query.bindValue(":mealdelay", m_mealDelay);
    query.bindValue(":eatspeed", m_eatSpeed);
    if (!query.exec()) qWarning() << tr("[CowDaysModel query error] %1").arg(query.lastError().text());
}
