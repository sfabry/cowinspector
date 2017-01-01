#include "cowsmodel.h"

#include <QtDebug>
#include <QtSql>

CowsModel::CowsModel(QObject *parent) : QueryModel(parent)
{

}

void CowsModel::refresh()
{
    QSqlDatabase db = QSqlDatabase::database();
    if (!db.isOpen()) return;

    QSqlQuery query(db);
    query.prepare("with mealdays as (select cow, sum(fooda) as sa, sum(foodb) as sb, date(entry - time '05:00:00') as day from meals group by cow, day order by day desc), "
                  "mealtoday as (select * from mealdays where day = '2016-12-09'), "
                  "alloc as (select distinct on(cow) cow, fooda, foodb from foodallocation order by cow asc, id desc) "
                  "select alloc.cow as cow, alloc.fooda as alloca, alloc.foodb as allocb, mealtoday.day as day, "
                  "mealtoday.sa as meala, mealtoday.sb as mealb from alloc left outer join mealtoday on (mealtoday.cow = alloc.cow)");
//    query.bindValue(":deviceId", QString(m_deviceId));
    if (!query.exec()) qWarning() << tr("[CowsModel query error] %1").arg(query.lastError().text());
    else this->setQuery(query);
}
