#pragma once

#include <QDBusInterface>
#include <QList>
#include <QObject>
#include <QString>
#include <QVariantList>

#include <KWindowSystem>

#include "DesktopInfo.hpp"

class VirtualDesktopBar : public QObject {
    Q_OBJECT

public:
    VirtualDesktopBar(QObject* parent = nullptr);

    Q_INVOKABLE void requestDesktopInfoList();

    Q_INVOKABLE void showDesktop(int number);

    Q_PROPERTY(bool cfg_MultipleScreensFilterOccupiedDesktops
               MEMBER cfg_MultipleScreensFilterOccupiedDesktops
               NOTIFY cfg_MultipleScreensFilterOccupiedDesktopsChanged);

    QString getCurrentScreen() const;
    void setCurrentScreen(QString screen);

public Q_SLOTS:
    QString getCurrentScreen();

signals:
    void desktopInfoListSent(QVariantList desktopInfoList);
    void cfg_MultipleScreensFilterOccupiedDesktopsChanged();

private:
    QDBusInterface dbusInterface;
    QString dbusInterfaceName;

    void setUpSignals();
    void setUpKWinSignals();
    void setUpInternalSignals();

    QList<DesktopInfo> getDesktopInfoList();

    bool cfg_MultipleScreensFilterOccupiedDesktops;

    void sendDesktopInfoList();
    bool sendDesktopInfoListLock;

    void processChanges(std::function<void()> callback, bool& lock);

    int currentDesktopNumber;
    void updateLocalDesktopNumbers();

    QString currentScreenPrivate;
};
