#ifndef COWSMODEL_H
#define COWSMODEL_H

#include "querymodel.h"

class CowsModel : public QueryModel
{
    Q_OBJECT

public:
    explicit CowsModel(QObject *parent = 0);
    void refresh() override;

};

#endif // COWSMODEL_H
