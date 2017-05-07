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

void IdentificationModel::deleteCow(int cow)
{
    QSqlDatabase db = QSqlDatabase::database();
    if (!db.isOpen()) return;
    QSqlQuery query(db);

    // Backup dans un nouveau record le total de la vache par box. Code vache name 10000 + cow for example.
    int cowBackup = cow;
    do {
        cowBackup += 10000;
        query.prepare("select count(cow) from meals where cow = :cow");
        query.bindValue(":cow",  cowBackup);
        if (!query.exec()) qWarning() << tr("[IdentificationModel::deleteCow select count query error] %1").arg(query.lastError().text());
    } while(query.size() == 0);
    query.prepare("insert into meals (cow, box, fooda, foodb, entry, exit) "
                  "select :cowBackup, box, sum(fooda) as suma, sum(foodb) as sumb, min(entry) as entry, max(exit) as exit from meals where cow = :cow group by box");
    query.bindValue(":cow",  cow);
    query.bindValue(":cowBackup",  cowBackup);
    if (!query.exec()) qWarning() << tr("[IdentificationModel::deleteCow backup query error] %1").arg(query.lastError().text());

    // Empty meal table
    query.prepare("DELETE from meals WHERE cow = :cow");
    query.bindValue(":cow",  cow);
    if (!query.exec()) qWarning() << tr("[IdentificationModel::deleteCow DELETE meals query error] %1").arg(query.lastError().text());

    // Empty food allocation table
    query.prepare("DELETE from foodallocation WHERE cow = :cow");
    query.bindValue(":cow",  cow);
    if (!query.exec()) qWarning() << tr("[IdentificationModel::deleteCow DELETE foodallocation query error] %1").arg(query.lastError().text());

    // Reset identification record
    query.prepare("UPDATE identification SET cownumber = null WHERE cownumber = :cow");
    query.bindValue(":cow",  cow);
    if (!query.exec()) qWarning() << tr("[IdentificationModel::deleteCow UPDATE identification query error] %1").arg(query.lastError().text());

    refresh();
}
