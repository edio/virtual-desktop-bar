import QtQuick 2.13
import QtQuick.Controls 1.6
import QtQuick.Layouts 1.11

GridLayout {
    rowSpacing: 0
    columnSpacing: 0
    flow: isVerticalOrientation ?
          GridLayout.TopToBottom :
          GridLayout.LeftToRight

    property var desktopButtonList: []

    property Item lastHoveredButton
    property Item lastDesktopButton
    property Item currentDesktopButton
    property Item largestDesktopButton
    property int numberOfVisibleDesktopButtons

    DesktopButton { id: desktopButtonComponent }

    GridLayout {
        id: desktopButtonContainer
        rowSpacing: parent.rowSpacing
        columnSpacing: parent.columnSpacing
        flow: parent.flow
    }

    Text {
        text: screen
        color: config.DesktopIndicatorsStyle == 4 ?
               indicator.color :
               config.DesktopLabelsCustomColor || theme.textColor
    }

    MouseArea {
        propagateComposedEvents: true

        readonly property int wheelDeltaLimit: 120

        property int currentWheelDelta: 0

        onPressed: {
            var initialDesktopButton = desktopButtonContainer.childAt(mouse.x, mouse.y);
            if (!initialDesktopButton) {
                return;
            }
        }

        onWheel: {
            if (!config.MouseWheelSwitchDesktopOnScroll) {
                return;
            }

            var desktopNumber = 0;

            var change = wheel.angleDelta.y || wheel.angleDelta.x;
            if (!config.MouseWheelInvertDesktopSwitchingDirection) {
                change = -change;
            }

            currentWheelDelta += change;

            if (currentWheelDelta >= wheelDeltaLimit) {
                currentWheelDelta = 0;

                if (currentDesktopButton && currentDesktopButton.number < desktopButtonList.length) {
                    desktopNumber = currentDesktopButton.number + 1;
                } else if (config.MouseWheelWrapDesktopNavigationWhenScrolling) {
                    desktopNumber = 1;
                }
            }

            if (currentWheelDelta <= -wheelDeltaLimit) {
                currentWheelDelta = 0;

                if (currentDesktopButton && currentDesktopButton.number > 1) {
                    desktopNumber = currentDesktopButton.number - 1;
                } else if (config.MouseWheelWrapDesktopNavigationWhenScrolling) {
                    desktopNumber = desktopButtonList.length;
                }
            }

            if (desktopNumber > 0) {
                backend.showDesktop(desktopNumber);
            }
        }
    }

    function update(desktopInfoList) {
        var difference = desktopInfoList.length - desktopButtonList.length;

        if (difference > 0) {
            addDesktopButtons(difference);
        } else if (difference < 0) {
            removeDesktopButtons(desktopInfoList);
        }

        updateDesktopButtons(desktopInfoList);

        lastDesktopButton = desktopButtonList[desktopButtonList.length - 1];
    }

    function addDesktopButtons(difference) {
        var init = desktopButtonList.length == 0;
        var temp = difference;

        while (temp-- > 0) {
            var desktopButton = desktopButtonComponent.createObject(desktopButtonContainer);
            desktopButtonList.push(desktopButton);
        }


    }

    function removeDesktopButtons(desktopInfoList) {
        var list = getRemovedDesktopButtonIndexList(desktopInfoList);

        while (list.length > 0) {
            var index = list.pop();
            var desktopButton = desktopButtonList[index];
            desktopButtonList.splice(index, 1);

            if (lastHoveredButton == desktopButton) {
                lastHoveredButton = null;
            }

            if (currentDesktopButton == desktopButton) {
                currentDesktopButton = null;
            }

            if (largestDesktopButton == desktopButton) {
                largestDesktopButton = null;
            }

            desktopButton.destroy();
        }
    }

    function getRemovedDesktopButtonIndexList(desktopInfoList) {
        var removedDesktopButtonIndexList = [];

        for (var i = 0; i < desktopButtonList.length; i++) {
            var desktopButton = desktopButtonList[i];

            var keepDesktopButton = false;
            for (var j = 0; j < desktopInfoList.length; j++) {
                var desktopInfo = desktopInfoList[j];
                if (desktopButton.id == desktopInfo.id) {
                    keepDesktopButton = true;
                    break;
                }
            }
            if (!keepDesktopButton) {
                removedDesktopButtonIndexList.push(i);
            }
        }

        return removedDesktopButtonIndexList;
    }

    function updateDesktopButtons(desktopInfoList) {
        for (var i = 0; i < desktopButtonList.length; i++) {
            var desktopButton = desktopButtonList[i];
            var desktopInfo = desktopInfoList[i];
            desktopButton.update(desktopInfo);
            desktopButton.show();

            if (desktopButton.isCurrent) {
                currentDesktopButton = desktopButton;
            }
        }
    }

    function updateLargestDesktopButton() {
        var temp = largestDesktopButton;

        for (var i = 0; i < desktopButtonList.length; i++) {
            var desktopButton = desktopButtonList[i];

            if (!temp || temp._label.implicitWidth < desktopButton._label.implicitWidth) {
                temp = desktopButton;
            }
        }

        if (temp != largestDesktopButton) {
            largestDesktopButton = temp;
        }
    }

    function updateNumberOfVisibleDesktopButtons() {
        numberOfVisibleDesktopButtons = desktopButtonList.filter(function(desktopButton) {
            return desktopButton.isVisible;
        }).length;
    }
}
