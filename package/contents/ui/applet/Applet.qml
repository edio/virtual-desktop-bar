import QtQuick 2.13
import QtQuick.Window 2.13

import QtQuick.Layouts 1.3
import QtQuick.Controls 1.3
import QtQuick.Dialogs 1.3
import QtQuick.Controls.Styles 1.3

import org.kde.kquickcontrolsaddons 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0

import org.kde.plasma.virtualdesktopbar 1.2

Item {
    id: root

    Plasmoid.fullRepresentation: Container {}
    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation

    property QtObject config: plasmoid.configuration
    property Item container: plasmoid.fullRepresentationItem

    property bool isTopLocation: plasmoid.location == PlasmaCore.Types.TopEdge
    property bool isVerticalOrientation: plasmoid.formFactor == PlasmaCore.Types.Vertical
    property string version: plasmoid.metaData.version
    property int screenWidth: plasmoid.screenGeometry.width
    property string screen: Screen.name

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

    Screen.onNameChanged: {
        screen = Screen.name
    }
}
