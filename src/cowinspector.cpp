#include "cowinspector.h"

#include <QSettings>
#include <QtSql>
#include <QtDebug>

CowInspector* CowInspector::m_instance = nullptr;

CowInspector::CowInspector(QObject *parent) :
    QObject(parent)
  , m_settings(new QSettings("cowinspector.ini", QSettings::IniFormat, this))
{
    reconnectDatabase();
}

CowInspector *CowInspector::instance()
{
    if (m_instance == nullptr) m_instance = new CowInspector();
    return m_instance;
}

QString CowInspector::databaseIp() const
{
    return m_settings->value("database/ip").toString();
}

QString CowInspector::databaseName() const
{
    return m_settings->value("database/name").toString();
}

QString CowInspector::databasePassword() const
{
    return m_settings->value("database/password").toString();
}

QString CowInspector::databaseUsername() const
{
    return m_settings->value("database/username").toString();
}

void CowInspector::setDatabaseIp(QString databaseIp)
{
    m_settings->setValue("database/ip", databaseIp);
    emit databaseIpChanged(databaseIp);
}

void CowInspector::setDatabaseName(QString databaseName)
{
    m_settings->setValue("database/name", databaseName);
    emit databaseNameChanged(databaseName);
}

void CowInspector::setDatabaseUsername(QString databaseUsername)
{
    m_settings->setValue("database/username", databaseUsername);
    emit databaseUsernameChanged(databaseUsername);
}

void CowInspector::setDatabasePassword(QString databasePassword)
{
    m_settings->setValue("database/password", databasePassword);
    emit databasePasswordChanged(databasePassword);
}

void CowInspector::reconnectDatabase()
{
    // disconnect from current database and remove the connection
    QString connectName;
    {
        QSqlDatabase db = QSqlDatabase::database();
        if (db.isValid()) connectName = db.connectionName();
        if (db.isOpen()) db.close();
    }
    if (!connectName.isEmpty()) QSqlDatabase::removeDatabase(connectName);

    // Open new connection
    QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL");
    db.setHostName(databaseIp());
    db.setPort(5432);
    db.setDatabaseName(databaseName());
    db.setUserName(databaseUsername());
    db.setPassword(databasePassword());

    if (db.open()) qInfo() << "Database opened successfully";
    else qWarning() << "Database open error : " << db.lastError().text();

}
