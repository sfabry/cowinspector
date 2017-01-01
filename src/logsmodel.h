#ifndef LOGSMODEL_H
#define LOGSMODEL_H

#include "querymodel.h"

class LogsModel : public QueryModel
{
    Q_OBJECT
    Q_PROPERTY(bool debugActive READ debugActive WRITE setDebugActive NOTIFY debugActiveChanged)
    Q_PROPERTY(bool warnActive READ warnActive WRITE setWarnActive NOTIFY warnActiveChanged)

public:
    explicit LogsModel(QObject *parent = 0);
    void refresh() override;

    bool debugActive() const { return m_debugActive; }
    bool warnActive() const  { return m_warnActive; }

signals:
    void debugActiveChanged(bool debugActive);
    void warnActiveChanged(bool warnActive);

public slots:
    void setDebugActive(bool debugActive);
    void setWarnActive(bool warnActive);

private:
    bool m_debugActive = true;
    bool m_warnActive = true;
};

#endif // LOGSMODEL_H
