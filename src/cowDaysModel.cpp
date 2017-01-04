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
                  "from meals where cow = :cow group by day order by day desc");
    query.bindValue(":cow", m_cowNumber);
    if (!query.exec()) qWarning() << tr("[CowDaysModel query error] %1").arg(query.lastError().text());
    else this->setQuery(query);
}

void CowDaysModel::setCowNumber(int cowNumber)
{
    if (m_cowNumber == cowNumber)
        return;

    m_cowNumber = cowNumber;
    emit cowNumberChanged(cowNumber);
    refresh();
}
