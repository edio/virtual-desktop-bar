import QtQuick 2.11
import QtQuick.Controls 2.11
import org.kde.kirigami 2.9 as Kirigami

Kirigami.FormLayout {
    id : page

    // Multiple screens/monitors
    property alias cfg_MultipleScreensFilterOccupiedDesktops: multipleScreensFilterOccupiedDesktopsCheckBox.checked

    // Mouse wheel handling
    property alias cfg_MouseWheelSwitchDesktopOnScroll: mouseWheelSwitchDesktopOnScrollCheckBox.checked
    property alias cfg_MouseWheelInvertDesktopSwitchingDirection: mouseWheelInvertDesktopSwitchingDirectionCheckBox.checked
    property alias cfg_MouseWheelWrapDesktopNavigationWhenScrolling: mouseWheelWrapDesktopNavigationWhenScrollingCheckBox.checked

    CheckBox {
        Kirigami.FormData.label: i18n("Multiple outpus:")
        id: multipleScreensFilterOccupiedDesktopsCheckBox
        text: "NOT Show workspaces from all outputs"
    }

    CheckBox {
        Kirigami.FormData.label: i18n("Mouse wheel handling:")
        id: mouseWheelSwitchDesktopOnScrollCheckBox
        text: "Switch desktops by scrolling the wheel"
    }

    CheckBox {
        id: mouseWheelInvertDesktopSwitchingDirectionCheckBox
        enabled: mouseWheelSwitchDesktopOnScrollCheckBox.checked
        text: "Invert wheel scrolling desktop switching direction"
    }

    CheckBox {
        id: mouseWheelWrapDesktopNavigationWhenScrollingCheckBox
        enabled: mouseWheelSwitchDesktopOnScrollCheckBox.checked
        text: "Wrap desktop navigation after reaching first or last one"
    }
}
