import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.0
import QtQuick.Layouts 1.3

import org.kde.plasma.core 2.0 as PlasmaCore

import "../common" as UICommon

Item {

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

    // Other
    property alias cfg_AnimationsEnable: animationsEnableCheckBox.checked

    GridLayout {
        columns: 1

        SectionHeader {
            text: "Buttons"
        }

        RowLayout {
            Label {
                text: "Vertical margins:"
            }

            SpinBox {
                id: desktopButtonsVerticalMarginSpinBox

                enabled: plasmoid.formFactor == PlasmaCore.Types.Vertical ||
                         (cfg_DesktopIndicatorsStyle != 0 &&
                          cfg_DesktopIndicatorsStyle != 4 &&
                          cfg_DesktopIndicatorsStyle != 5)

                value: cfg_DesktopButtonsVerticalMargin
                minimumValue: 0
                maximumValue: 300
                suffix: " px"
            }

            HintIcon {
                visible: !desktopButtonsVerticalMarginSpinBox.enabled
                tooltipText: "Not available for the selected indicator style"
            }
        }

        RowLayout {
            Label {
                text: "Horizontal margins:"
            }

            SpinBox {
                id: desktopButtonsHorizontalMarginSpinBox

                enabled: plasmoid.formFactor != PlasmaCore.Types.Vertical ||
                         (cfg_DesktopIndicatorsStyle != 1 &&
                          cfg_DesktopIndicatorsStyle != 4 &&
                          cfg_DesktopIndicatorsStyle != 5)

                value: cfg_DesktopButtonsHorizontalMargin
                minimumValue: 0
                maximumValue: 300
                suffix: " px"
            }

            HintIcon {
                visible: !desktopButtonsHorizontalMarginSpinBox.enabled
                tooltipText: "Not available for the selected indicator style"
            }
        }

        RowLayout {
            Label {
                enabled: desktopButtonsSpacingSpinBox.enabled
                text: "Spacing between buttons:"
            }

            SpinBox {
                id: desktopButtonsSpacingSpinBox
                value: cfg_DesktopButtonsSpacing
                minimumValue: 0
                maximumValue: 100
                suffix: " px"
            }

            HintIcon {
                visible: !desktopButtonsSpacingSpinBox.enabled
                tooltipText: "Not available if only one button is shown"
            }
        }

        RowLayout {
            spacing: 0

            CheckBox {
                id: desktopButtonsSetCommonSizeForAllCheckBox
                text: "Set common size for all buttons"
            }

            HintIcon {
                tooltipText: "The size is based on the largest button"
            }
        }

        SectionHeader {
            text: "Labels"
        }

        RowLayout {
            spacing: 0

            CheckBox {
                id: desktopLabelsCustomFontCheckBox
                checked: cfg_DesktopLabelsCustomFont
                onCheckedChanged: {
                    if (checked) {
                        var currentIndex = desktopLabelsCustomFontComboBox.currentIndex;
                        var selectedFont = desktopLabelsCustomFontComboBox.model[currentIndex].value;
                        cfg_DesktopLabelsCustomFont = selectedFont;
                    } else {
                        cfg_DesktopLabelsCustomFont = "";
                    }
                }
                text: "Custom font:"
            }

            ComboBox {
                id: desktopLabelsCustomFontComboBox
                enabled: desktopLabelsCustomFontCheckBox.checked
                implicitWidth: 130

                Component.onCompleted: {
                    var array = [];
                    var fonts = Qt.fontFamilies()
                    for (var i = 0; i < fonts.length; i++) {
                        array.push({text: fonts[i], value: fonts[i]});
                    }
                    model = array;

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
                        var selectedItem = model[currentIndex];
                        if (selectedItem) {
                            var selectedFont = selectedItem.value;
                            cfg_DesktopLabelsCustomFont = selectedFont;
                        }
                    }
                }
            }
        }

        RowLayout {
            spacing: 0

            CheckBox {
                id: desktopLabelsCustomFontSizeCheckBox
                checked: cfg_DesktopLabelsCustomFontSize > 0
                onCheckedChanged: cfg_DesktopLabelsCustomFontSize = checked ?
                                  desktopLabelsCustomFontSizeSpinBox.value : 0
                text: "Custom font size:"
            }

            SpinBox {
                id: desktopLabelsCustomFontSizeSpinBox
                enabled: desktopLabelsCustomFontSizeCheckBox.checked
                value: cfg_DesktopLabelsCustomFontSize || theme.defaultFont.pixelSize
                minimumValue: 5
                maximumValue: 100
                suffix: " px"
                onValueChanged: {
                    if (desktopLabelsCustomFontSizeCheckBox.checked) {
                        cfg_DesktopLabelsCustomFontSize = value;
                    }
                }
            }
        }

        RowLayout {
            spacing: 0

            CheckBox {
                id: desktopLabelsCustomColorCheckBox
                enabled: cfg_DesktopIndicatorsStyle != 5
                checked: cfg_DesktopLabelsCustomColor
                onCheckedChanged: cfg_DesktopLabelsCustomColor = checked ?
                                  desktopLabelsCustomColorButton.color : ""
                text: "Custom text color:"
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

            Item {
                width: 8
            }

            HintIcon {
                visible: desktopLabelsCustomColorCheckBox.checked ||
                         !desktopLabelsCustomColorCheckBox.enabled
                tooltipText: cfg_DesktopIndicatorsStyle != 5 ?
                             "Click the colored box to choose a different color" :
                             "Not available if labels are used as indicators"
            }
        }

        RowLayout {
            spacing: 0

            CheckBox {
                id: desktopLabelsDimForIdleDesktopsCheckBox
                enabled: cfg_DesktopIndicatorsStyle != 5
                text: "Dim labels for idle desktops"
            }

            HintIcon {
                visible: !desktopLabelsDimForIdleDesktopsCheckBox.enabled
                tooltipText: "Not available if labels are used as indicators"
            }
        }

        RowLayout {
            spacing: 0

            CheckBox {
                id: desktopLabelsDisplayAsUppercasedCheckBox
                enabled: true
                text: "Display labels as UPPERCASED"
            }

            HintIcon {
                visible: !desktopLabelsDisplayAsUppercasedCheckBox.enabled
                tooltipText: "Not available for the selected label style"
            }
        }

        CheckBox {
            id: desktopLabelsBoldFontForCurrentDesktopCheckBox
            text: "Set bold font for current desktop"
        }

        SectionHeader {
            text: "Indicators"
        }

        RowLayout {
            Label {
                text: "Style:"
            }

            ComboBox {
                id: desktopIndicatorsStyleComboBox
                implicitWidth: 100
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

            SpinBox {
                id: desktopIndicatorsStyleBlockRadiusSpinBox
                visible: cfg_DesktopIndicatorsStyle == 2
                value: cfg_DesktopIndicatorsStyleBlockRadius
                minimumValue: 0
                maximumValue: 300
                suffix: " px corner radius"
            }

            SpinBox {
                id: desktopIndicatorsStyleLineThicknessSpinBox
                visible: cfg_DesktopIndicatorsStyle < 2
                value: cfg_DesktopIndicatorsStyleLineThickness
                minimumValue: 1
                maximumValue: 10
                suffix: " px thickness"
            }
        }

        RowLayout {
            spacing: 0

            CheckBox {
                id: desktopIndicatorsInvertPositionCheckBox
                enabled: cfg_DesktopIndicatorsStyle < 2
                text: "Invert indicator's position"
            }

            HintIcon {
                visible: !desktopIndicatorsInvertPositionCheckBox.enabled
                tooltipText: "Not available for the selected indicator style"
            }
        }

        RowLayout {
            spacing: 0

            CheckBox {
                id: desktopIndicatorsCustomColorForCurrentDesktopCheckBox
                checked: cfg_DesktopIndicatorsCustomColorForCurrentDesktop
                onCheckedChanged: cfg_DesktopIndicatorsCustomColorForCurrentDesktop = checked ?
                                  desktopIndicatorsCustomColorForCurrentDesktopButton.color : ""
                text: "Custom color for focused workspaces:"
            }

            ColorButton {
                id: desktopIndicatorsCustomColorForCurrentDesktopButton
                enabled: desktopIndicatorsCustomColorForCurrentDesktopCheckBox.checked
                color: cfg_DesktopIndicatorsCustomColorForCurrentDesktop || theme.buttonFocusColor

                colorAcceptedCallback: function(color) {
                    cfg_DesktopIndicatorsCustomColorForCurrentDesktop = color;
                }
            }
        }

        RowLayout {
            spacing: 0

            CheckBox {
                id: desktopIndicatorsCustomColorForOccupiedIdleDesktopsCheckBox
                checked: cfg_DesktopIndicatorsCustomColorForOccupiedIdleDesktops
                onCheckedChanged: cfg_DesktopIndicatorsCustomColorForOccupiedIdleDesktops = checked ?
                                  desktopIndicatorsCustomColorForOccupiedIdleDesktopsButton.color : ""
                text: "Custom color for unfocused workspaces:"
            }

            ColorButton {
                id: desktopIndicatorsCustomColorForOccupiedIdleDesktopsButton
                enabled: desktopIndicatorsCustomColorForOccupiedIdleDesktopsCheckBox.checked
                color: cfg_DesktopIndicatorsCustomColorForOccupiedIdleDesktops || theme.textColor

                colorAcceptedCallback: function(color) {
                    cfg_DesktopIndicatorsCustomColorForOccupiedIdleDesktops = color;
                }
            }
        }

        RowLayout {
            spacing: 0

            CheckBox {
                id: desktopIndicatorsCustomColorForDesktopsNeedingAttentionCheckBox
                checked: cfg_DesktopIndicatorsCustomColorForDesktopsNeedingAttention
                onCheckedChanged: cfg_DesktopIndicatorsCustomColorForDesktopsNeedingAttention = checked ?
                                  desktopIndicatorsCustomColorForDesktopsNeedingAttentionButton.color : ""
                text: "Custom color for urgent workspaces:"
            }

            ColorButton {
                id: desktopIndicatorsCustomColorForDesktopsNeedingAttentionButton
                enabled: desktopIndicatorsCustomColorForDesktopsNeedingAttentionCheckBox.checked
                color: cfg_DesktopIndicatorsCustomColorForDesktopsNeedingAttention || theme.textColor

                colorAcceptedCallback: function(color) {
                    cfg_DesktopIndicatorsCustomColorForDesktopsNeedingAttention = color;
                }
            }
        }

        RowLayout {
            spacing: 0

            CheckBox {
                id: desktopIndicatorsDoNotOverrideOpacityOfCustomColorsCheckBox
                enabled: desktopIndicatorsCustomColorForCurrentDesktopCheckBox.checked ||
                         desktopIndicatorsCustomColorForOccupiedIdleDesktopsCheckBox.checked ||
                         desktopIndicatorsCustomColorForDesktopsNeedingAttentionCheckBox.checked
                text: "Do not override opacity of custom colors"
            }

            HintIcon {
                tooltipText: !desktopIndicatorsDoNotOverrideOpacityOfCustomColorsCheckBox.enabled ?
                             "Not available if custom colors are not used" :
                             "Alpha channel of custom colors will be applied without any modifications"
            }
        }

        SectionHeader {
            text: "Other"
        }

        CheckBox {
            id: animationsEnableCheckBox
            text: "Enable animations"
        }

    }
}
