#ifndef COWSMODEL_H
#define COWSMODEL_H

#include <QDate>
#include "querymodel.h"

class CowsModel : public QueryModel
{
    Q_OBJECT
    Q_PROPERTY(QDate summaryDate READ summaryDate WRITE setSummaryDate NOTIFY summaryDateChanged)
    Q_PROPERTY(bool showUnallocated READ showUnallocated WRITE setShowUnallocated NOTIFY showUnallocatedChanged)

public:
    explicit CowsModel(QObject *parent = 0);
    void refresh() override;

    QDate summaryDate() const { return m_summaryDate; }
    bool showUnallocated() const { return m_showUnallocated; }

public slots:
    void setSummaryDate(QDate summaryDate);
    void setShowUnallocated(bool showUnallocated);
    void setCowAllocation(int cow, int foodA, int foodB);

signals:
    void summaryDateChanged(QDate summaryDate);
    void showUnallocatedChanged(bool showUnallocated);

private:
    QDate m_summaryDate;
    int m_lastAllocationId = -1;
    int m_lastCowAllocation = -1;
    bool m_showUnallocated = false;
};

#endif // COWSMODEL_H
