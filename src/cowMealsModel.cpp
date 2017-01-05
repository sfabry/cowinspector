#include "cowmealsmodel.h"

#include <QtDebug>
#include <QtSql>

CowMealsModel::CowMealsModel(QObject *parent) :
    QueryModel(parent)
{
    QTimer::singleShot(250, this, &CowMealsModel::refresh);
}

void CowMealsModel::refresh()
{
    QSqlDatabase db = QSqlDatabase::database();
    if (!db.isOpen()) return;

    QSqlQuery query(db);
    query.prepare("select box, fooda, foodb, entry, exit from meals where cow = :cow order by id desc limit 250");
    query.bindValue(":cow", m_cowNumber);
    if (!query.exec()) qWarning() << tr("[CowMealsModel query error] %1").arg(query.lastError().text());
    else this->setQuery(query);
}

void CowMealsModel::setCowNumber(int cowNumber)
{
    if (m_cowNumber == cowNumber)
        return;

    m_cowNumber = cowNumber;
    emit cowNumberChanged(cowNumber);
    refresh();
}
