import QtQuick 2.11
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.9 as Kirigami

import org.kde.plasma.core 2.0 as PlasmaCore

import "../common" as UICommon

Kirigami.FormLayout {
    id : page

    // Buttons
    property alias cfg_DesktopButtonsVerticalMargin: desktopButtonsVerticalMarginSpinBox.value
    property alias cfg_DesktopButtonsHorizontalMargin: desktopButtonsHorizontalMarginSpinBox.value
    property alias cfg_DesktopButtonsSpacing: desktopButtonsSpacingSpinBox.value
    property alias cfg_DesktopButtonsSetCommonSizeForAll: desktopButtonsSetCommonSizeForAllCheckBox.checked

    // Labels
    property string cfg_DesktopLabelsCustomFont
    property int cfg_DesktopLabelsCustomFontSize
    property string cfg_DesktopLabelsCustomColor
    property alias cfg_DesktopLabelsDimForIdleDesktops: desktopLabelsDimForIdleDesktopsCheckBox.checked
    property alias cfg_DesktopLabelsBoldFontForCurrentDesktop: desktopLabelsBoldFontForCurrentDesktopCheckBox.checked
    property alias cfg_DesktopLabelsDisplayAsUppercased: desktopLabelsDisplayAsUppercasedCheckBox.checked

    // Indicators
    property alias cfg_DesktopIndicatorsStyle: desktopIndicatorsStyleComboBox.currentIndex
    property alias cfg_DesktopIndicatorsStyleBlockRadius: desktopIndicatorsStyleBlockRadiusSpinBox.value
    property alias cfg_DesktopIndicatorsStyleLineThickness: desktopIndicatorsStyleLineThicknessSpinBox.value
    property alias cfg_DesktopIndicatorsInvertPosition: desktopIndicatorsInvertPositionCheckBox.checked
    property string cfg_DesktopIndicatorsCustomColorForCurrentDesktop
    property string cfg_DesktopIndicatorsCustomColorForOccupiedIdleDesktops
    property string cfg_DesktopIndicatorsCustomColorForDesktopsNeedingAttention
    property alias cfg_DesktopIndicatorsDoNotOverrideOpacityOfCustomColors: desktopIndicatorsDoNotOverrideOpacityOfCustomColorsCheckBox.checked

    Kirigami.Separator {
        Kirigami.FormData.label: i18n("Shape")
        Kirigami.FormData.isSection: true
    }

    ColumnLayout {
        Kirigami.FormData.label: i18n("Style:")
        Kirigami.FormData.buddyFor: desktopIndicatorsStyleComboBox

        RowLayout {
            ComboBox {
                id: desktopIndicatorsStyleComboBox
                model: [
                    "Edge line",
                    "Side line",
                    "Block",
                    "Rounded",
                    "Full size",
                    "Just labels"
                ]

                onCurrentIndexChanged: {
                    if (cfg_DesktopIndicatorsStyle == 2) {
                        cfg_DesktopIndicatorsStyleBlockRadius = desktopIndicatorsStyleBlockRadiusSpinBox.value;
                    } else {
                        cfg_DesktopIndicatorsStyleBlockRadius = 2;
                    }
                    if (cfg_DesktopIndicatorsStyle < 2) {
                        cfg_DesktopIndicatorsStyleLineThickness = desktopIndicatorsStyleLineThicknessSpinBox.value;
                    } else {
                        cfg_DesktopIndicatorsStyleLineThickness = 3;
                    }

                }

                Component.onCompleted: {
                    if (cfg_DesktopIndicatorsStyle != 2) {
                        cfg_DesktopIndicatorsStyleBlockRadius = 2;
                    }
                }
            }

            CheckBox {
                id: desktopIndicatorsInvertPositionCheckBox
                visible: cfg_DesktopIndicatorsStyle < 2
                text: "Reverse"
            }
        }

        CheckBox {
            id: desktopButtonsSetCommonSizeForAllCheckBox
            text: i18n("Uniform buttons size")
        }
    }

    GridLayout {
        columns: 2
        Kirigami.FormData.label: i18n("Adjustments:")
        Kirigami.FormData.buddyFor: desktopButtonsSpacingSpinBox

        Label {
            text: i18n("Space between buttons:")
        }
        SpinBox {
            id: desktopButtonsSpacingSpinBox
            value: cfg_DesktopButtonsSpacing
            from: 0
            to: 100
            textFromValue: function(value, locale) { return qsTr("%1 px").arg(value); }
        }

        Label {
            text: i18n("Corner radius")
        }
        SpinBox {
            id: desktopIndicatorsStyleBlockRadiusSpinBox
            enabled: cfg_DesktopIndicatorsStyle == 2
            value: cfg_DesktopIndicatorsStyleBlockRadius
            from: 0
            to: 300
            textFromValue: function(value, locale) { return qsTr("%1 px").arg(value); }
        }

        Label {
            text: i18n("Line thickness")
        }
        SpinBox {
            id: desktopIndicatorsStyleLineThicknessSpinBox
            enabled: cfg_DesktopIndicatorsStyle < 2
            value: cfg_DesktopIndicatorsStyleLineThickness
            from: 1
            to: 10
            textFromValue: function(value, locale) { return qsTr("%1 px").arg(value); }
        }



        Label {
            text: i18n("Horizontal padding:")
        }
        SpinBox {
            id: desktopButtonsHorizontalMarginSpinBox

            enabled: plasmoid.formFactor != PlasmaCore.Types.Vertical ||
                     (cfg_DesktopIndicatorsStyle != 1 &&
                      cfg_DesktopIndicatorsStyle != 4 &&
                      cfg_DesktopIndicatorsStyle != 5)

            value: cfg_DesktopButtonsHorizontalMargin
            from: 0
            to: 300
            textFromValue: function(value, locale) { return qsTr("%1 px").arg(value); }
        }

        Label {
            text: i18n("Vertical padding:")
        }
        SpinBox {
            id: desktopButtonsVerticalMarginSpinBox

            enabled: plasmoid.formFactor == PlasmaCore.Types.Vertical ||
                     (cfg_DesktopIndicatorsStyle != 0 &&
                      cfg_DesktopIndicatorsStyle != 4 &&
                      cfg_DesktopIndicatorsStyle != 5)

            value: cfg_DesktopButtonsVerticalMargin
            from: 0
            to: 300
            textFromValue: function(value, locale) { return qsTr("%1 px").arg(value); }
        }
    }

    Kirigami.Separator {
        Kirigami.FormData.label: i18n("Names")
        Kirigami.FormData.isSection: true
    }

    GridLayout {
        columns: 2
        Kirigami.FormData.label: i18n("Override font:")
        Kirigami.FormData.buddyFor: desktopLabelsCustomFontCheckBox

        CheckBox {
            id: desktopLabelsCustomFontCheckBox
            checked: cfg_DesktopLabelsCustomFont
            onCheckedChanged: {
                if (checked) {
                    var currentIndex = desktopLabelsCustomFontComboBox.currentIndex;
                    var selectedFont = desktopLabelsCustomFontComboBox.model[currentIndex];
                    cfg_DesktopLabelsCustomFont = selectedFont;
                } else {
                    cfg_DesktopLabelsCustomFont = "";
                }
            }
            text: i18n("Family")
        }

        CheckBox {
            id: desktopLabelsCustomFontSizeCheckBox
            checked: cfg_DesktopLabelsCustomFontSize > 0
            onCheckedChanged: cfg_DesktopLabelsCustomFontSize = checked ?
                              desktopLabelsCustomFontSizeSpinBox.value : 0
            text: i18n("Size")
        }

        ComboBox {
            id: desktopLabelsCustomFontComboBox
            enabled: desktopLabelsCustomFontCheckBox.checked

            Component.onCompleted: {
                model = Qt.fontFamilies()

                var foundIndex = find(cfg_DesktopLabelsCustomFont);
                if (foundIndex == -1) {
                    foundIndex = find(theme.defaultFont.family);
                }
                if (foundIndex >= 0) {
                    currentIndex = foundIndex;
                }
            }

            onCurrentIndexChanged: {
                if (enabled && currentIndex) {
                    var selectedFont = model[currentIndex];
                    if (selectedFont) {
                        cfg_DesktopLabelsCustomFont = selectedFont;
                    }
                }
            }
        }

        SpinBox {
            id: desktopLabelsCustomFontSizeSpinBox
            enabled: desktopLabelsCustomFontSizeCheckBox.checked
            value: cfg_DesktopLabelsCustomFontSize || theme.defaultFont.pixelSize
            from: 5
            to: 100
            textFromValue: function(value, locale) { return qsTr("%1 px").arg(value); }
            onValueChanged: {
                if (desktopLabelsCustomFontSizeCheckBox.checked) {
                    cfg_DesktopLabelsCustomFontSize = value;
                }
            }
        }
    }

    ColumnLayout {
        CheckBox {
            id: desktopLabelsBoldFontForCurrentDesktopCheckBox
            text: "Bold if focused"
        }

        CheckBox {
            id: desktopLabelsDisplayAsUppercasedCheckBox
            text: "UPPERCASED"
        }



    }


    Kirigami.Separator {
        Kirigami.FormData.label: i18n("Colors")
        Kirigami.FormData.isSection: true
    }

    GridLayout {
        columns: 2
        Kirigami.FormData.label: i18n("Background:")
        Kirigami.FormData.buddyFor: desktopIndicatorsCustomColorForCurrentDesktopCheckBox

        CheckBox {
            id: desktopIndicatorsCustomColorForCurrentDesktopCheckBox
            checked: cfg_DesktopIndicatorsCustomColorForCurrentDesktop
            onCheckedChanged: cfg_DesktopIndicatorsCustomColorForCurrentDesktop = checked ?
                              desktopIndicatorsCustomColorForCurrentDesktopButton.color : ""
            text: "Focused"
        }

        ColorButton {
            id: desktopIndicatorsCustomColorForCurrentDesktopButton
            enabled: desktopIndicatorsCustomColorForCurrentDesktopCheckBox.checked
            color: cfg_DesktopIndicatorsCustomColorForCurrentDesktop || theme.buttonFocusColor

            colorAcceptedCallback: function(color) {
                cfg_DesktopIndicatorsCustomColorForCurrentDesktop = color;
            }
        }

        CheckBox {
            id: desktopIndicatorsCustomColorForOccupiedIdleDesktopsCheckBox
            checked: cfg_DesktopIndicatorsCustomColorForOccupiedIdleDesktops
            onCheckedChanged: cfg_DesktopIndicatorsCustomColorForOccupiedIdleDesktops = checked ?
                              desktopIndicatorsCustomColorForOccupiedIdleDesktopsButton.color : ""
            text: "Inactive"
        }

        ColorButton {
            id: desktopIndicatorsCustomColorForOccupiedIdleDesktopsButton
            enabled: desktopIndicatorsCustomColorForOccupiedIdleDesktopsCheckBox.checked
            color: cfg_DesktopIndicatorsCustomColorForOccupiedIdleDesktops || theme.textColor

            colorAcceptedCallback: function(color) {
                cfg_DesktopIndicatorsCustomColorForOccupiedIdleDesktops = color;
            }
        }

        CheckBox {
            id: desktopIndicatorsCustomColorForDesktopsNeedingAttentionCheckBox
            checked: cfg_DesktopIndicatorsCustomColorForDesktopsNeedingAttention
            onCheckedChanged: cfg_DesktopIndicatorsCustomColorForDesktopsNeedingAttention = checked ?
                              desktopIndicatorsCustomColorForDesktopsNeedingAttentionButton.color : ""
            text: "Urgent"
        }

        ColorButton {
            id: desktopIndicatorsCustomColorForDesktopsNeedingAttentionButton
            enabled: desktopIndicatorsCustomColorForDesktopsNeedingAttentionCheckBox.checked
            color: cfg_DesktopIndicatorsCustomColorForDesktopsNeedingAttention || theme.textColor

            colorAcceptedCallback: function(color) {
                cfg_DesktopIndicatorsCustomColorForDesktopsNeedingAttention = color;
            }
        }

        CheckBox {
            id: desktopIndicatorsDoNotOverrideOpacityOfCustomColorsCheckBox
            enabled: desktopIndicatorsCustomColorForCurrentDesktopCheckBox.checked ||
                     desktopIndicatorsCustomColorForOccupiedIdleDesktopsCheckBox.checked ||
                     desktopIndicatorsCustomColorForDesktopsNeedingAttentionCheckBox.checked
            text: "Do not dim"
        }

        Item {
            width: 1
        }

    }

    GridLayout {
        columns: 2
        Kirigami.FormData.label: i18n("Foreground:")
        Kirigami.FormData.buddyFor: desktopLabelsCustomColorCheckBox
        CheckBox {
            id: desktopLabelsCustomColorCheckBox
            enabled: cfg_DesktopIndicatorsStyle != 5
            checked: cfg_DesktopLabelsCustomColor
            onCheckedChanged: cfg_DesktopLabelsCustomColor = checked ?
                              desktopLabelsCustomColorButton.color : ""
            text: "All"
        }

        ColorButton {
            id: desktopLabelsCustomColorButton
            enabled: desktopLabelsCustomColorCheckBox.enabled &&
                     desktopLabelsCustomColorCheckBox.checked
            color: cfg_DesktopLabelsCustomColor || theme.textColor

            colorAcceptedCallback: function(color) {
                cfg_DesktopLabelsCustomColor = color;
            }
        }

        CheckBox {
            id: desktopLabelsDimForIdleDesktopsCheckBox
            enabled: cfg_DesktopIndicatorsStyle != 5
            text: "Dim if not focused"
        }

        Item {
            width: 1
        }
    }

}
