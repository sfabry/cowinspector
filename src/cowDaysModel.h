#ifndef COWDAYSMODEL_H
#define COWDAYSMODEL_H

#include <QDate>
#include "querymodel.h"

class CowDaysModel : public QueryModel
{
    Q_OBJECT
    Q_PROPERTY(int cowNumber READ cowNumber WRITE setCowNumber NOTIFY cowNumberChanged)


public:
    explicit CowDaysModel(QObject *parent = 0);
    void refresh() override;

    int cowNumber() const { return m_cowNumber; }

public slots:
    void setCowNumber(int cowNumber);

signals:
    void cowNumberChanged(int cowNumber);

private:
    int m_cowNumber = -1;
};

#endif // COWDAYSMODEL_H
