#ifndef BOXSTATSMODEL_H
#define BOXSTATSMODEL_H

#include "querymodel.h"

class BoxStatsModel : public QueryModel
{
    Q_OBJECT
    Q_PROPERTY(int number READ number WRITE setNumber NOTIFY numberChanged)
    Q_PROPERTY(int days READ days WRITE setDays NOTIFY daysChanged)

public:
    explicit BoxStatsModel(QObject *parent = 0);
    void refresh() override;

    int number() const { return m_number; }
    int days()   const { return m_days; }

signals:
    void numberChanged(int number);
    void daysChanged(int days);

public slots:
    void setNumber(int number);
    void setDays(int days);

private:
    int m_number = -1;
    int m_days = 7;
};

#endif // BOXSTATSMODEL_H
