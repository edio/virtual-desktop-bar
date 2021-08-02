import QtQuick 2.7

import org.kde.kquickcontrolsaddons 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0

import org.kde.plasma.virtualdesktopbar 1.2

Item {
    id: root

    DesktopButtonTooltip { id: tooltip }

    Plasmoid.fullRepresentation: Container {}
    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation

    property QtObject config: plasmoid.configuration
    property Item container: plasmoid.fullRepresentationItem

    property bool isTopLocation: plasmoid.location == PlasmaCore.Types.TopEdge
    property bool isVerticalOrientation: plasmoid.formFactor == PlasmaCore.Types.Vertical

    VirtualDesktopBar {
        id: backend
        cfg_MultipleScreensFilterOccupiedDesktops: config.MultipleScreensFilterOccupiedDesktops
    }

    Connections {
        target: backend
        onDesktopInfoListSent: container.update(desktopInfoList)
    }

    Component.onCompleted: {
        Qt.callLater(function() {
            backend.requestDesktopInfoList();
        });
    }

    function action_removeDesktop() {
        backend.removeDesktop(container.lastHoveredButton.number);
    }

    function action_addDesktop() {
        backend.addDesktop();
    }

    function action_removeLastDesktop() {
        backend.removeDesktop(container.lastDesktopButton.number);
    }
}
