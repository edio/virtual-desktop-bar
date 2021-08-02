import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

import "../common" as UICommon

Item {

    // Multiple screens/monitors
    property alias cfg_MultipleScreensFilterOccupiedDesktops: multipleScreensFilterOccupiedDesktopsCheckBox.checked

    // Mouse wheel handling
    property alias cfg_MouseWheelSwitchDesktopOnScroll: mouseWheelSwitchDesktopOnScrollCheckBox.checked
    property alias cfg_MouseWheelInvertDesktopSwitchingDirection: mouseWheelInvertDesktopSwitchingDirectionCheckBox.checked
    property alias cfg_MouseWheelWrapDesktopNavigationWhenScrolling: mouseWheelWrapDesktopNavigationWhenScrollingCheckBox.checked

    GridLayout {
        columns: 1

        SectionHeader {
            text: "Multiple screens/monitors"
        }

        CheckBox {
            id: multipleScreensFilterOccupiedDesktopsCheckBox
            text: "Filter occupied desktops by screen/monitor"
        }

        SectionHeader {
            text: "Mouse wheel handling"
        }

        CheckBox {
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
}
