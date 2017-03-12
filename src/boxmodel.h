#ifndef BOXMODEL_H
#define BOXMODEL_H

#include <QTime>
#include "querymodel.h"

class BoxModel : public QueryModel
{
    Q_OBJECT
    Q_PROPERTY(int number READ number WRITE setNumber NOTIFY numberChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QTime idleStart1 READ idleStart1 WRITE setIdleStart1 NOTIFY idleStart1Changed)
    Q_PROPERTY(QTime idleStop1 READ idleStop1 WRITE setIdleStop1 NOTIFY idleStop1Changed)
    Q_PROPERTY(QTime idleStart2 READ idleStart2 WRITE setIdleStart2 NOTIFY idleStart2Changed)
    Q_PROPERTY(QTime idleStop2 READ idleStop2 WRITE setIdleStop2 NOTIFY idleStop2Changed)
    Q_PROPERTY(int foodSpeedA READ foodSpeedA WRITE setFoodSpeedA NOTIFY foodSpeedAChanged)
    Q_PROPERTY(int foodSpeedB READ foodSpeedB WRITE setFoodSpeedB NOTIFY foodSpeedBChanged)
    Q_PROPERTY(int calibrationDuration READ calibrationDuration WRITE setCalibrationDuration NOTIFY calibrationDurationChanged)
    Q_PROPERTY(int mealMinimum READ mealMinimum WRITE setMealMinimum NOTIFY mealMinimumChanged)
    Q_PROPERTY(int detectionDelay READ detectionDelay WRITE setDetectionDelay NOTIFY detectionDelayChanged)
    Q_PROPERTY(QDateTime lastConnected READ lastConnected NOTIFY lastConnectedChanged)
    Q_PROPERTY(QTime newDayTime READ newDayTime WRITE setNewDayTime NOTIFY newDayTimeChanged)


public:
    explicit BoxModel(QObject *parent = 0);
    void refresh() override;

    int number()                const { return m_number;                }
    QString name()              const { return m_name;                  }
    QTime idleStart1()          const { return m_idleStart1;            }
    QTime idleStop1()           const { return m_idleStop1;             }
    QTime idleStart2()          const { return m_idleStart2;            }
    QTime idleStop2()           const { return m_idleStop2;             }
    int foodSpeedA()            const { return m_foodSpeedA;            }
    int foodSpeedB()            const { return m_foodSpeedB;            }
    int calibrationDuration()   const { return m_calibrationDuration;   }
    int mealMinimum()           const { return m_mealMinimum;           }
    int detectionDelay()        const { return m_detectionDelay;        }
    QDateTime lastConnected()   const { return m_lastConnected;         }
    QTime newDayTime()          const { return m_newDayTime;            }

    static QTime globalNewDayTime();

public slots:
    void setNumber(int number);
    void setName(QString name);
    void setIdleStart1(QTime idleStart1);
    void setIdleStop1(QTime idleStop1);
    void setIdleStart2(QTime idleStart2);
    void setIdleStop2(QTime idleStop2);
    void setFoodSpeedA(int foodSpeedA);
    void setFoodSpeedB(int foodSpeedB);
    void setCalibrationDuration(int calibrationDuration);
    void setMealMinimum(int mealMinimum);
    void setDetectionDelay(int detectionDelay);
    void setNewDayTime(QTime newDayTime);

signals:
    void numberChanged(int number);
    void nameChanged(QString name);
    void idleStart1Changed(QTime idleStart1);
    void idleStop1Changed(QTime idleStop1);
    void idleStart2Changed(QTime idleStart2);
    void idleStop2Changed(QTime idleStop2);
    void foodSpeedAChanged(int foodSpeedA);
    void foodSpeedBChanged(int foodSpeedB);
    void calibrationDurationChanged(int calibrationDuration);
    void mealMinimumChanged(int mealMinimum);
    void detectionDelayChanged(int detectionDelay);
    void lastConnectedChanged(QDateTime lastConnected);
    void newDayTimeChanged(QTime newDayTime);

private:
    void updateName(QString name);
    void updateIdleStart1(QTime idleStart1);
    void updateIdleStop1(QTime idleStop1);
    void updateIdleStart2(QTime idleStart2);
    void updateIdleStop2(QTime idleStop2);
    void updateFoodSpeedA(int foodSpeedA);
    void updateFoodSpeedB(int foodSpeedB);
    void updateCalibrationDuration(int calibrationDuration);
    void updateMealMinimum(int mealMinimum);
    void updateDetectionDelay(int detectionDelay);
    void updateLastConnected(QDateTime lastConnected);
    void updateNewDayTime(QTime newDayTime);

private:
    int m_number = -1;
    QString m_name;
    QTime m_idleStart1;
    QTime m_idleStop1;
    QTime m_idleStart2;
    QTime m_idleStop2;
    int m_foodSpeedA = 7;
    int m_foodSpeedB = 7;
    int m_calibrationDuration = 120;
    int m_mealMinimum = 100;
    int m_detectionDelay = 60;
    QDateTime m_lastConnected;
    QTime m_newDayTime;
    static QTime m_globalNewDayTime;
};



#endif // BOXMODEL_H
