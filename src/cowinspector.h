#ifndef COWINSPECTOR_H
#define COWINSPECTOR_H

#include <QObject>

class QSettings;

class CowInspector : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString databaseIp READ databaseIp WRITE setDatabaseIp NOTIFY databaseIpChanged)
    Q_PROPERTY(QString databaseName READ databaseName WRITE setDatabaseName NOTIFY databaseNameChanged)
    Q_PROPERTY(QString databaseUsername READ databaseUsername WRITE setDatabaseUsername NOTIFY databaseUsernameChanged)
    Q_PROPERTY(QString databasePassword READ databasePassword WRITE setDatabasePassword NOTIFY databasePasswordChanged)

public:
    explicit CowInspector(QObject *parent = 0);
    static CowInspector* instance();

    QString databaseIp() const;
    QString databaseName() const;
    QString databaseUsername() const;
    QString databasePassword() const;

signals:
    void databaseIpChanged(QString databaseIp);
    void databaseNameChanged(QString databaseName);
    void databaseUsernameChanged(QString databaseUsername);
    void databasePasswordChanged(QString databasePassword);

public slots:
    void setDatabaseIp(QString databaseIp);
    void setDatabaseName(QString databaseName);
    void setDatabaseUsername(QString databaseUsername);
    void setDatabasePassword(QString databasePassword);
    void reconnectDatabase();

private:
    static CowInspector* m_instance;
    QSettings *m_settings;
};

#endif // COWINSPECTOR_H
