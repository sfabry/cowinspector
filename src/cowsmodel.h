#ifndef COWSMODEL_H
#define COWSMODEL_H

#include <QDate>
#include "querymodel.h"

class CowsModel : public QueryModel
{
    Q_OBJECT
    Q_PROPERTY(QDate summaryDate READ summaryDate WRITE setSummaryDate NOTIFY summaryDateChanged)


public:
    explicit CowsModel(QObject *parent = 0);
    void refresh() override;

    QDate summaryDate() const { return m_summaryDate; }

public slots:
    void setSummaryDate(QDate summaryDate);

signals:
    void summaryDateChanged(QDate summaryDate);

private:
    QDate m_summaryDate;
};

#endif // COWSMODEL_H
