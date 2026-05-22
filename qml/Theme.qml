pragma Singleton
import QtQuick 2.15

QtObject {
    // Colors
    readonly property color background:     "#F0F4F8"
    readonly property color surface:        "#FFFFFF"
    readonly property color surfaceAlt:     "#F7FAFC"
    readonly property color primary:        "#1A6B9A"
    readonly property color primaryDark:    "#124E72"
    readonly property color primaryLight:   "#EBF4FA"
    readonly property color accent:         "#28A98B"
    readonly property color accentLight:    "#E6F7F4"
    readonly property color danger:         "#E05252"
    readonly property color dangerLight:    "#FDEAEA"
    readonly property color success:        "#2EAA6A"
    readonly property color successLight:   "#E6F7EE"
    readonly property color textPrimary:    "#1A2533"
    readonly property color textSecondary:  "#5A6A7A"
    readonly property color textHint:       "#9AAABB"
    readonly property color border:         "#DDE6EF"
    readonly property color borderFocus:    "#1A6B9A"
    readonly property color toolbarBg:      "#124E72"
    readonly property color toolbarText:    "#FFFFFF"
    readonly property color tabActive:      "#FFFFFF"
    readonly property color tabInactive:    "#9BBDD4"

    // Radius
    readonly property int radiusSmall:  6
    readonly property int radiusMed:    10
    readonly property int radiusLarge:  16

    // Font sizes
    readonly property int fontSmall:    11
    readonly property int fontBody:     13
    readonly property int fontMed:      15
    readonly property int fontLarge:    18
    readonly property int fontTitle:    22

    // Spacing
    readonly property int spacingXS:    4
    readonly property int spacingS:     8
    readonly property int spacingM:     16
    readonly property int spacingL:     24
    readonly property int spacingXL:    36
}
