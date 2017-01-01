#include "identificationmodel.h"

#include <QtDebug>
#include <QtSql>

IdentificationModel::IdentificationModel(QObject *parent) : QueryModel(parent)
{

}

void IdentificationModel::refresh()
{
    QSqlDatabase db = QSqlDatabase::database();
    if (!db.isOpen()) return;

    QSqlQuery query(db);
    query.prepare("SELECT rfid, cardnumber, cownumber FROM identification ORDER BY cardnumber ASC");
    if (!query.exec()) qWarning() << tr("[IdentificationModel query error] %1").arg(query.lastError().text());
    else this->setQuery(query);
}
