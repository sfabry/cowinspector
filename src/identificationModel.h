#ifndef IDENTIFICATIONMODEL_H
#define IDENTIFICATIONMODEL_H

#include "querymodel.h"

class IdentificationModel : public QueryModel
{
    Q_OBJECT

public:
    explicit IdentificationModel(QObject *parent = 0);
    void refresh() override;

};

#endif // IDENTIFICATIONMODEL_H
