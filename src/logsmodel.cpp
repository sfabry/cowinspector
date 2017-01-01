#include "logsmodel.h"

#include <QtDebug>
#include <QtSql>

LogsModel::LogsModel(QObject *parent) : QueryModel(parent)
{

}

void LogsModel::setDebugActive(bool debugActive)
{
    if (m_debugActive == debugActive)
        return;

    m_debugActive = debugActive;
    emit debugActiveChanged(debugActive);
}

void LogsModel::setWarnActive(bool warnActive)
{
    if (m_warnActive == warnActive)
        return;

    m_warnActive = warnActive;
    emit warnActiveChanged(warnActive);
}

void LogsModel::refresh()
{
    QSqlDatabase db = QSqlDatabase::database();
    if (!db.isOpen()) return;

    QSqlQuery query(db);
    query.prepare("SELECT id, time, message, level FROM logevents ORDER BY id DESC");
//    query.bindValue(":deviceId", QString(m_deviceId));
    if (!query.exec()) qWarning() << tr("[LogsModel query error] %1").arg(query.lastError().text());
    else this->setQuery(query);
}
