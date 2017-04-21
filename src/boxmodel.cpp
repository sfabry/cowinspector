#include "boxmodel.h"

#include <QtDebug>
#include <QtSql>

#include "boxstatsmodel.h"

QTime BoxModel::m_globalNewDayTime = QTime();

BoxModel::BoxModel(QObject *parent) :
    QueryModel(parent),
    m_statModel(new BoxStatsModel(this))
{
    connect(this, &BoxModel::numberChanged, m_statModel, &BoxStatsModel::setNumber);
}

void BoxModel::refresh()
{
    if (m_number < 0) return;

    QSqlDatabase db = QSqlDatabase::database();
    if (!db.isOpen()) return;

    QSqlQuery query(db);
    query.prepare("select boxname, idlestart1, idlestop1, idlestart2, idlestop2, foodspeeda, foodspeedb, calibrationtime, mealminimum, detectiondelay, lastconnected, newdaytime "
                  "from box where boxnumber = :boxnumber");
    query.bindValue(":boxnumber", m_number);
    if (!query.exec()) qWarning() << tr("[BoxModel::refresh query error] %1").arg(query.lastError().text());
    else if (!query.next()) qWarning() << tr("[BoxModel::refresh returned no results for box number : %1").arg(m_number);
    else {
        updateName(query.value(0).toString());
        updateIdleStart1(query.value(1).toTime());
        updateIdleStop1(query.value(2).toTime());
        updateIdleStart2(query.value(3).toTime());
        updateIdleStop2(query.value(4).toTime());
        updateFoodSpeedA(query.value(5).toInt());
        updateFoodSpeedB(query.value(6).toInt());
        updateCalibrationDuration(query.value(7).toInt());
        updateMealMinimum(query.value(8).toInt());
        updateDetectionDelay(query.value(9).toInt());
        updateLastConnected(query.value(10).toDateTime());
        updateNewDayTime(query.value(11).toTime());
    }
}

QTime BoxModel::globalNewDayTime()
{
    if (m_globalNewDayTime.isNull()) {
        QSqlDatabase db = QSqlDatabase::database();

        QSqlQuery query(db);
        query.prepare("select newdaytime from box where boxnumber = :boxnumber");
        query.bindValue(":boxnumber", 1);
        if (!query.exec()) qWarning() << tr("[BoxModel::globalNewDayTime query error] %1").arg(query.lastError().text());
        else if (!query.next()) qWarning() << tr("[BoxModel::globalNewDayTime returned no results for box number : %1").arg(1);
        else {
            m_globalNewDayTime = query.value(0).toTime();
        }
    }

    return m_globalNewDayTime;
}

BoxStatsModel *BoxModel::statsModel() { return m_statModel; }

QJsonObject BoxModel::totalFoodForDay(QDate day)
{
    QJsonObject result;
    result["foodA"] = 0;
    result["foodB"] = 0;

    QSqlDatabase db = QSqlDatabase::database();

    QSqlQuery query(db);
    query.prepare(QString("select sum(fooda) as suma, sum(foodb) as sumb from meals where box = :boxnumber and date(entry - time '%1') = :day").arg(BoxModel::globalNewDayTime().toString("hh:mm:ss")));
    query.bindValue(":boxnumber", m_number);
    query.bindValue(":day", day);
    if (!query.exec()) qWarning() << tr("[BoxModel::totalFoodForDay query error] %1").arg(query.lastError().text());
    else if (!query.next()) qWarning() << tr("[BoxModel::totalFoodForDay returned no results for box number : %1").arg(m_number);
    else {
        result["foodA"] = query.value(0).toInt();
        result["foodB"] = query.value(1).toInt();
    }
    return result;
}

void BoxModel::setNumber(int number)
{
    if (m_number == number) return;

    m_number = number;
    emit numberChanged(number);
    refresh();
}

void BoxModel::setName(QString name)
{
    if (m_name == name) return;

    QSqlDatabase db = QSqlDatabase::database();
    if (!db.isOpen()) return;
    QSqlQuery query(db);
    query.prepare("UPDATE box SET boxname = :boxname WHERE boxnumber = :boxnumber");
    query.bindValue(":boxname", name);
    query.bindValue(":boxnumber", m_number);
    if (!query.exec()) qWarning() << tr("[BoxModel::setName query error] %1").arg(query.lastError().text());

    updateName(name);
}

void BoxModel::updateName(QString name)
{
    m_name = name;
    emit nameChanged(name);
}

void BoxModel::setIdleStart1(QTime idleStart1)
{
    if (m_idleStart1 == idleStart1)
        return;

    QSqlDatabase db = QSqlDatabase::database();
    if (!db.isOpen()) return;
    QSqlQuery query(db);
    query.prepare("UPDATE box SET idlestart1 = :idlestart1 WHERE boxnumber = :boxnumber");
    query.bindValue(":idlestart1", idleStart1);
    query.bindValue(":boxnumber", m_number);
    if (!query.exec()) qWarning() << tr("[BoxModel::setIdleStart1 query error] %1").arg(query.lastError().text());

    updateIdleStart1(idleStart1);
}

void BoxModel::updateIdleStart1(QTime idleStart1)
{
    m_idleStart1 = idleStart1;
    emit idleStart1Changed(idleStart1);
}

void BoxModel::setIdleStop1(QTime idleStop1)
{
    if (m_idleStop1 == idleStop1)
        return;

    QSqlDatabase db = QSqlDatabase::database();
    if (!db.isOpen()) return;
    QSqlQuery query(db);
    query.prepare("UPDATE box SET idlestop1 = :idlestop1 WHERE boxnumber = :boxnumber");
    query.bindValue(":idlestop1", idleStop1);
    query.bindValue(":boxnumber", m_number);
    if (!query.exec()) qWarning() << tr("[BoxModel::setIdleStop1 query error] %1").arg(query.lastError().text());

    updateIdleStop1(idleStop1);
}

void BoxModel::updateIdleStop1(QTime idleStop1)
{
    m_idleStop1 = idleStop1;
    emit idleStop1Changed(idleStop1);
}

void BoxModel::setIdleStart2(QTime idleStart2)
{
    if (m_idleStart2 == idleStart2)
        return;

    QSqlDatabase db = QSqlDatabase::database();
    if (!db.isOpen()) return;
    QSqlQuery query(db);
    query.prepare("UPDATE box SET idlestart2 = :idlestart2 WHERE boxnumber = :boxnumber");
    query.bindValue(":idlestart2", idleStart2);
    query.bindValue(":boxnumber", m_number);
    if (!query.exec()) qWarning() << tr("[BoxModel::setIdleStart2 query error] %1").arg(query.lastError().text());

    updateIdleStart2(idleStart2);
}

void BoxModel::updateIdleStart2(QTime idleStart2)
{
    m_idleStart2 = idleStart2;
    emit idleStart2Changed(idleStart2);
}

void BoxModel::setIdleStop2(QTime idleStop2)
{
    if (m_idleStop2 == idleStop2)
        return;

    QSqlDatabase db = QSqlDatabase::database();
    if (!db.isOpen()) return;
    QSqlQuery query(db);
    query.prepare("UPDATE box SET idlestop2 = :idlestop2 WHERE boxnumber = :boxnumber");
    query.bindValue(":idlestop2", idleStop2);
    query.bindValue(":boxnumber", m_number);
    if (!query.exec()) qWarning() << tr("[BoxModel::setIdleStop2 query error] %1").arg(query.lastError().text());

    updateIdleStop2(idleStop2);
}

void BoxModel::updateIdleStop2(QTime idleStop2)
{
    m_idleStop2 = idleStop2;
    emit idleStop2Changed(idleStop2);
}

void BoxModel::setFoodSpeedA(int foodSpeedA)
{
    if (m_foodSpeedA == foodSpeedA)
        return;

    QSqlDatabase db = QSqlDatabase::database();
    if (!db.isOpen()) return;
    QSqlQuery query(db);
    query.prepare("UPDATE box SET foodspeeda = :foodspeeda WHERE boxnumber = :boxnumber");
    query.bindValue(":foodspeeda", foodSpeedA);
    query.bindValue(":boxnumber", m_number);
    if (!query.exec()) qWarning() << tr("[BoxModel::setFoodSpeedA query error] %1").arg(query.lastError().text());

    updateFoodSpeedA(foodSpeedA);
}

void BoxModel::updateFoodSpeedA(int foodSpeedA)
{
    m_foodSpeedA = foodSpeedA;
    emit foodSpeedAChanged(foodSpeedA);
}

void BoxModel::setFoodSpeedB(int foodSpeedB)
{
    if (m_foodSpeedB == foodSpeedB)
        return;

    QSqlDatabase db = QSqlDatabase::database();
    if (!db.isOpen()) return;
    QSqlQuery query(db);
    query.prepare("UPDATE box SET foodspeedb = :foodspeedb WHERE boxnumber = :boxnumber");
    query.bindValue(":foodspeedb", foodSpeedB);
    query.bindValue(":boxnumber", m_number);
    if (!query.exec()) qWarning() << tr("[BoxModel::setFoodSpeedB query error] %1").arg(query.lastError().text());

    updateFoodSpeedB(foodSpeedB);
}

void BoxModel::updateFoodSpeedB(int foodSpeedB)
{
    m_foodSpeedB = foodSpeedB;
    emit foodSpeedBChanged(foodSpeedB);
}

void BoxModel::setCalibrationDuration(int calibrationDuration)
{
    if (m_calibrationDuration == calibrationDuration)
        return;

    QSqlDatabase db = QSqlDatabase::database();
    if (!db.isOpen()) return;
    QSqlQuery query(db);
    query.prepare("UPDATE box SET calibrationtime = :calibrationtime WHERE boxnumber = :boxnumber");
    query.bindValue(":calibrationtime", calibrationDuration);
    query.bindValue(":boxnumber", m_number);
    if (!query.exec()) qWarning() << tr("[BoxModel::setCalibrationDuration query error] %1").arg(query.lastError().text());

    updateCalibrationDuration(calibrationDuration);
}

void BoxModel::updateCalibrationDuration(int calibrationDuration)
{
    m_calibrationDuration = calibrationDuration;
    emit calibrationDurationChanged(calibrationDuration);
}

void BoxModel::setMealMinimum(int mealMinimum)
{
    if (m_mealMinimum == mealMinimum)
        return;

    QSqlDatabase db = QSqlDatabase::database();
    if (!db.isOpen()) return;
    QSqlQuery query(db);
    query.prepare("UPDATE box SET mealminimum = :mealminimum WHERE boxnumber = :boxnumber");
    query.bindValue(":mealminimum", mealMinimum);
    query.bindValue(":boxnumber", m_number);
    if (!query.exec()) qWarning() << tr("[BoxModel::setMealMinimum query error] %1").arg(query.lastError().text());

    updateMealMinimum(mealMinimum);
}

void BoxModel::updateMealMinimum(int mealMinimum)
{
    m_mealMinimum = mealMinimum;
    emit mealMinimumChanged(mealMinimum);
}

void BoxModel::setDetectionDelay(int detectionDelay)
{
    if (m_detectionDelay == detectionDelay)
        return;

    QSqlDatabase db = QSqlDatabase::database();
    if (!db.isOpen()) return;
    QSqlQuery query(db);
    query.prepare("UPDATE box SET detectiondelay = :detectiondelay WHERE boxnumber = :boxnumber");
    query.bindValue(":detectiondelay", detectionDelay);
    query.bindValue(":boxnumber", m_number);
    if (!query.exec()) qWarning() << tr("[BoxModel::setDetectionDelay query error] %1").arg(query.lastError().text());

    updateDetectionDelay(detectionDelay);
}

void BoxModel::updateDetectionDelay(int detectionDelay)
{
    m_detectionDelay = detectionDelay;
    emit detectionDelayChanged(detectionDelay);
}

void BoxModel::setNewDayTime(QTime newDayTime)
{
    if (m_newDayTime == newDayTime)
        return;

    QSqlDatabase db = QSqlDatabase::database();
    if (!db.isOpen()) return;
    QSqlQuery query(db);
    query.prepare("UPDATE box SET newdaytime = :newdaytime WHERE boxnumber = :boxnumber");
    query.bindValue(":newdaytime", newDayTime);
    query.bindValue(":boxnumber", m_number);
    if (!query.exec()) qWarning() << tr("[BoxModel::setNewDayTime query error] %1").arg(query.lastError().text());

    updateNewDayTime(newDayTime);
}

void BoxModel::updateNewDayTime(QTime newDayTime)
{
    m_newDayTime = newDayTime;
    m_globalNewDayTime = newDayTime;        // Trick to keep last value as global, we have a design flaw here because that time should always be the same for all boxes
    emit newDayTimeChanged(newDayTime);
}

void BoxModel::updateLastConnected(QDateTime lastConnected)
{
    if (m_lastConnected == lastConnected)
        return;

    m_lastConnected = lastConnected;
    emit lastConnectedChanged(lastConnected);
}
