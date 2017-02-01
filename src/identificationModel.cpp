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

void IdentificationModel::assignCow(int cow, const QString &rfid)
{
    if (cow == 0) return;

    QSqlDatabase db = QSqlDatabase::database();
    if (!db.isOpen()) return;
    QSqlQuery query(db);

    // Check if identification does not already contains this cow, or this RFID !
    // TODO_M: see later how we will deal with those cases
    if (rowOf(cow, "cownumber") >= 0) {
        qWarning() << "This cow is already set to another RFID";
        return;
    }

    // Update identification table
    query.prepare("UPDATE identification SET cownumber = :cow WHERE rfid = :rfid");
    query.bindValue(":cow",  cow);
    query.bindValue(":rfid",  rfid);
    if (!query.exec()) qWarning() << tr("[IdentificationModel UPDATE identification query error] %1").arg(query.lastError().text());

    // Insert a default food allocation
    query.prepare("insert into foodallocation (cow, fooda, foodb) values (:cow, 2000, 0)");
    query.bindValue(":cow",  cow);
    if (!query.exec()) qWarning() << tr("[IdentificationModel insert into foodallocation query error] %1").arg(query.lastError().text());
}
