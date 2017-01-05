#ifndef COWDAYSMODEL_H
#define COWDAYSMODEL_H

#include <QDate>
#include "querymodel.h"

class CowDaysModel : public QueryModel
{
    Q_OBJECT
    Q_PROPERTY(int cowNumber READ cowNumber WRITE setCowNumber NOTIFY cowNumberChanged)
    Q_PROPERTY(int allocA READ allocA WRITE setAllocA NOTIFY allocAChanged)
    Q_PROPERTY(int allocB READ allocB WRITE setAllocB NOTIFY allocBChanged)
    Q_PROPERTY(int mealCount READ mealCount WRITE setMealCount NOTIFY mealCountChanged)
    Q_PROPERTY(int mealDelay READ mealDelay WRITE setMealDelay NOTIFY mealDelayChanged)
    Q_PROPERTY(int eatSpeed READ eatSpeed WRITE setEatSpeed NOTIFY eatSpeedChanged)

public:
    explicit CowDaysModel(QObject *parent = 0);
    void refresh() override;

    int cowNumber() const { return m_cowNumber; }
    int allocA() const { return m_allocA; }
    int allocB() const { return m_allocB; }
    int mealCount() const { return m_mealCount; }
    int mealDelay() const { return m_mealDelay; }
    int eatSpeed() const { return m_eatSpeed; }

public slots:
    void setCowNumber(int cowNumber);
    void setAllocA(int allocA);
    void setAllocB(int allocB);
    void setMealCount(int mealCount);
    void setMealDelay(int mealDelay);
    void setEatSpeed(int eatSpeed);
    void commitChanges();

signals:
    void cowNumberChanged(int cowNumber);
    void allocAChanged(int allocA);
    void allocBChanged(int allocB);
    void mealCountChanged(int mealCount);
    void mealDelayChanged(int mealDelay);
    void eatSpeedChanged(int eatSpeed);

private:
    int m_cowNumber = -1;
    int m_allocA = 0;
    int m_allocB = 0;
    int m_mealCount = 0;
    int m_mealDelay = 0;
    int m_eatSpeed = 0;
};



#endif // COWDAYSMODEL_H
