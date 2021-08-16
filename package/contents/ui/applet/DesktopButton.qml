import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

import "../common/Utils.js" as Utils

Component {
    Rectangle {
        readonly property string objectType: "DesktopButton"

        property int number: 0
        property string id: ""
        property string name: ""
        property bool isCurrent: false
        property bool isEmpty: false
        property bool isUrgent: false

        property bool isVisible: {
            // TODO handle multimonitor here
            return true;
        }

        onIsVisibleChanged: {
            container.updateNumberOfVisibleDesktopButtons();
            Qt.callLater(function() {
                if (isVisible) {
                    show();
                } else {
                    hide();
                }
            });
        }

        property alias _label: label
        property alias _indicator: indicator

        Layout.fillWidth: isVerticalOrientation
        Layout.fillHeight: !isVerticalOrientation

        clip: true
        color: "transparent"
        opacity: 1

        readonly property int animationWidthDuration: 100
        readonly property int animationColorDuration: 150
        readonly property int animationOpacityDuration: 150

        /* Indicator */
        Rectangle {
            id: indicator

            visible: config.DesktopIndicatorsStyle != 5

            color: {
                if (isCurrent) {
                    return config.DesktopIndicatorsCustomColorForCurrentDesktop || theme.buttonFocusColor;
                }
                if (!isEmpty && config.DesktopIndicatorsCustomColorForOccupiedIdleDesktops) {
                    return config.DesktopIndicatorsCustomColorForOccupiedIdleDesktops;
                }
                if (isUrgent && config.DesktopIndicatorsCustomColorForDesktopsNeedingAttention) {
                    return config.DesktopIndicatorsCustomColorForDesktopsNeedingAttention;
                }
                return theme.textColor;
            }

            opacity: {
                if (isCurrent) {
                    return 1.0;
                }
                if (mouseArea.containsMouse) {
                    return config.DesktopIndicatorsStyle == 5 ? 1.0 : 0.75;
                }
                if (config.DesktopIndicatorsDoNotOverrideOpacityOfCustomColors) {
                    if ((isCurrent && config.DesktopIndicatorsCustomColorForCurrentDesktop) ||
                        (!isEmpty && config.DesktopIndicatorsCustomColorForOccupiedIdleDesktops) ||
                        (isUrgent && config.DesktopIndicatorsCustomColorForDesktopsNeedingAttention)) {
                        return 1.0;
                    }
                }
                return config.DesktopIndicatorsStyle == 5 ? 0.5 : 0.25;
            }

            width: {
                if (isVerticalOrientation) {
                    if (config.DesktopIndicatorsStyle == 1) {
                        return config.DesktopIndicatorsStyleLineThickness;
                    }
                    if (config.DesktopIndicatorsStyle == 4) {
                        return parent.width;
                    }
                    if (config.DesktopButtonsSetCommonSizeForAll &&
                        container.largestDesktopButton &&
                        container.largestDesktopButton != parent &&
                        container.largestDesktopButton._label.implicitWidth > label.implicitWidth) {
                        return container.largestDesktopButton._indicator.width;
                    }
                    return label.implicitWidth + 2 * config.DesktopButtonsHorizontalMargin;
                }
                if (config.DesktopIndicatorsStyle == 1) {
                    return config.DesktopIndicatorsStyleLineThickness;
                }
                return parent.width + 0.5 - 2 * config.DesktopButtonsSpacing;
            }

            height: {
                if (config.DesktopIndicatorsStyle == 4) {
                    if (isVerticalOrientation) {
                        return parent.height + 0.5 - 2 * config.DesktopButtonsSpacing;
                    }
                    return parent.height;
                }
                if (config.DesktopIndicatorsStyle > 0) {
                    return label.implicitHeight + 2 * config.DesktopButtonsVerticalMargin;
                }
                return config.DesktopIndicatorsStyleLineThickness;
            }

            x: {
                if (isVerticalOrientation) {
                    if (config.DesktopIndicatorsStyle != 1) {
                        return (parent.width - width) / 2;
                    }
                    return config.DesktopIndicatorsInvertPosition ?
                           parent.width - config.DesktopIndicatorsStyleLineThickness : 0;
                }
                if (config.DesktopIndicatorsStyle == 1 &&
                    config.DesktopIndicatorsInvertPosition) {
                    return parent.width - width - (config.DesktopButtonsSpacing || 0);
                }
                return config.DesktopButtonsSpacing || 0;
            }

            y: {
                if (config.DesktopIndicatorsStyle > 0) {
                    return (parent.height - height) / 2;
                }
                if (isTopLocation) {
                    return !config.DesktopIndicatorsInvertPosition ? parent.height - height : 0;
                }
                return !config.DesktopIndicatorsInvertPosition ? 0 : parent.height - height;
            }

            radius: {
                if (config.DesktopIndicatorsStyle == 2) {
                    return config.DesktopIndicatorsStyleBlockRadius;
                }
                if (config.DesktopIndicatorsStyle == 3) {
                    return 300;
                }
                return 0;
            }
        }

        /* Label */
        Text {
            id: label

            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            text: name

            color: config.DesktopIndicatorsStyle == 5 ?
                   indicator.color :
                   config.DesktopLabelsCustomColor || theme.textColor

            opacity: {
                if (config.DesktopIndicatorsStyle == 5) {
                    return indicator.opacity;
                }
                if (isCurrent) {
                    return 1.0;
                }
                if (config.DesktopLabelsDimForIdleDesktops) {
                    if (mouseArea.containsMouse) {
                        return 1.0;
                    }
                    return 0.75;
                }
                return 1.0;
            }

            font.family: config.DesktopLabelsCustomFont || theme.defaultFont.family
            font.pixelSize: config.DesktopLabelsCustomFontSize || theme.defaultFont.pixelSize
            font.bold: isCurrent && config.DesktopLabelsBoldFontForCurrentDesktop
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.MiddleButton

            property var tooltipTimer

            function killTooltipTimer() {
                if (tooltipTimer) {
                    tooltipTimer.stop();
                    tooltipTimer = null;
                }
            }

            onEntered: {
                container.lastHoveredButton = parent;
            }

            onClicked: {
                if (mouse.button == Qt.LeftButton) {
                    backend.showDesktop(number);
                }
            }
        }

        function updateLabel() {
            label.text = Qt.binding(function() {
                var labelText = name;

                if (config.DesktopLabelsDisplayAsUppercased) {
                    labelText = labelText.toUpperCase();
                }

                return labelText;
            });
        }

        function update(desktopInfo) {
            number = desktopInfo.number;
            id = desktopInfo.id;
            name = desktopInfo.name;
            isCurrent = desktopInfo.isCurrent;
            isEmpty = desktopInfo.isEmpty;
            isUrgent = desktopInfo.isUrgent;

            updateLabel();
        }

        function show() {
            if (!isVisible) {
                return;
            }

            visible = true;
            var self = this;

            if (container.numberOfVisibleDesktopButtons == 1) {
                widthBehavior.enabled = heightBehavior.enabled = false;
            }

            implicitWidth = Qt.binding(function() {
                if (isVerticalOrientation) {
                    return parent.width;
                }

                var newImplicitWidth = label.implicitWidth +
                                       2 * config.DesktopButtonsHorizontalMargin +
                                       2 * config.DesktopButtonsSpacing;

                if (config.DesktopButtonsSetCommonSizeForAll &&
                    container.largestDesktopButton &&
                    container.largestDesktopButton != self &&
                    container.largestDesktopButton.implicitWidth > newImplicitWidth) {
                    return container.largestDesktopButton.implicitWidth;
                }

                return newImplicitWidth;
            });

            implicitHeight = Qt.binding(function() {
                if (!isVerticalOrientation) {
                    return parent.height;
                }
                return label.implicitHeight +
                       2 * config.DesktopButtonsVerticalMargin +
                       2 * config.DesktopButtonsSpacing;
            });

            opacity = 1;
        }

        function hide(callback, force) {
            if (!force && isVisible) {
                return;
            }

            opacity = 0;

            if (container.numberOfVisibleDesktopButtons == 1) {
                widthBehavior.enabled = heightBehavior.enabled = false;
            }

            var resetDimensions = function() {
                implicitWidth = isVerticalOrientation ? parent.width : 0;
                implicitHeight = isVerticalOrientation ? 0: parent.height;
            }

            var self = this;
            var postHideCallback = callback ? callback : function() {
                self.visible = false;
            };

            resetDimensions();
            postHideCallback();
        }

        onImplicitWidthChanged: {
            Utils.delay(100, container.updateLargestDesktopButton);
        }
    }
}
