#include "VirtualDesktopBar.hpp"

#include <functional>

#include <QGuiApplication>
#include <QRegularExpression>
#include <QScreen>
#include <QTimer>
#include <kwindowsystem.h>

VirtualDesktopBar::VirtualDesktopBar(QObject* parent) : QObject(parent),
        dbusInterface("org.kde.KWin", "/VirtualDesktopManager"),
        dbusInterfaceName("org.kde.KWin.VirtualDesktopManager"),
        sendDesktopInfoListLock(false),
        currentDesktopNumber(KWindowSystem::currentDesktop()) {
    currentScreenPrivate = QString();
    setUpSignals();
}

void VirtualDesktopBar::requestDesktopInfoList() {
    sendDesktopInfoList();
}

void VirtualDesktopBar::showDesktop(int number) {
    KWindowSystem::setCurrentDesktop(number);
}

void VirtualDesktopBar::setUpSignals() {
    setUpKWinSignals();
    setUpInternalSignals();
}

void VirtualDesktopBar::setUpKWinSignals() {
    QObject::connect(KWindowSystem::self(), &KWindowSystem::currentDesktopChanged, this, [&] {
        updateLocalDesktopNumbers();
        processChanges([&] { sendDesktopInfoList(); }, sendDesktopInfoListLock);
    });

    QObject::connect(KWindowSystem::self(), &KWindowSystem::numberOfDesktopsChanged, this, [&] {
        processChanges([&] { sendDesktopInfoList(); }, sendDesktopInfoListLock);
    });

    QObject::connect(KWindowSystem::self(), &KWindowSystem::desktopNamesChanged, this, [&] {
        processChanges([&] { sendDesktopInfoList(); }, sendDesktopInfoListLock);
    });

    QObject::connect(KWindowSystem::self(), static_cast<void (KWindowSystem::*)(WId, NET::Properties, NET::Properties2)>
                                            (&KWindowSystem::windowChanged), this, [&](WId, NET::Properties properties, NET::Properties2) {
        if (properties & NET::WMState) {
            processChanges([&] { sendDesktopInfoList(); }, sendDesktopInfoListLock);
        }
    });
}

void VirtualDesktopBar::setUpInternalSignals() {
    QObject::connect(this, &VirtualDesktopBar::cfg_MultipleScreensFilterOccupiedDesktopsChanged, this, [&] {
        sendDesktopInfoList();
    });
}

void VirtualDesktopBar::processChanges(std::function<void()> callback, bool& lock) {
    if (!lock) {
        lock = true;
        QTimer::singleShot(1, [this, callback, &lock] {
            lock = false;
            callback();
        });
    }
}

QList<DesktopInfo> VirtualDesktopBar::getDesktopInfoList() {
    QList<DesktopInfo> desktopInfoList;

    // Getting info about desktops through the KWin's D-Bus service here
    auto reply = dbusInterface.call("Get", dbusInterfaceName, "desktops");

    if (reply.type() == QDBusMessage::ErrorMessage) {
        for (int i = 1; i <= KWindowSystem::numberOfDesktops(); i++) {
            DesktopInfo desktopInfo;
            desktopInfo.id = i;
            desktopInfo.number = i;
            desktopInfo.name = KWindowSystem::desktopName(i);

            desktopInfoList << desktopInfo;
        }
    } else {
        // Extracting data from the D-Bus reply message here
        // More details at https://stackoverflow.com/a/20206377
        auto something = reply.arguments().at(0).value<QDBusVariant>();
        auto somethingSomething = something.variant().value<QDBusArgument>();
        somethingSomething >> desktopInfoList;
    }

    for (auto& desktopInfo : desktopInfoList) {
        desktopInfo.isCurrent = desktopInfo.number == KWindowSystem::currentDesktop();
    }

    return desktopInfoList;
}

void VirtualDesktopBar::sendDesktopInfoList() {
    QVariantList desktopInfoList;
    for (auto& desktopInfo : getDesktopInfoList()) {
        desktopInfoList << desktopInfo.toQVariantMap();
    }
    emit desktopInfoListSent(desktopInfoList);
}

void VirtualDesktopBar::updateLocalDesktopNumbers() {
    currentDesktopNumber = KWindowSystem::currentDesktop();
}

void VirtualDesktopBar::setCurrentScreen(QString screen) {
    this->currentScreenPrivate = screen;
}

QString VirtualDesktopBar::getCurrentScreen() {
    return this->currentScreenPrivate;
}
