/*
 * QML Colors for Noir Theme
 */
pragma Singleton
import QtQuick

QtObject {
    id: root

    // Primary colors
    readonly property color primary: "#f0f0f0"
    readonly property color _onPrimary: "#1a1a1a"
    readonly property color primaryContainer: "#3c3c3c"
    readonly property color _onPrimaryContainer: "#f0f0f0"
    readonly property color inversePrimary: "#f0f0f0"
    readonly property color primaryFixed: "#f0f0f0"
    readonly property color primaryFixedDim: "#d0d0d0"
    readonly property color _onPrimaryFixed: "#1a1a1a"
    readonly property color _onPrimaryFixedVariant: "#3c3c3c"

    // Secondary colors
    readonly property color secondary: "#d0d0d0"
    readonly property color _onSecondary: "#1a1a1a"
    readonly property color secondaryContainer: "#4d4d4d"
    readonly property color _onSecondaryContainer: "#f0f0f0"
    readonly property color secondaryFixed: "#d0d0d0"
    readonly property color secondaryFixedDim: "#b0b0b0"
    readonly property color _onSecondaryFixed: "#1a1a1a"
    readonly property color _onSecondaryFixedVariant: "#4d4d4d"

    // Tertiary colors
    readonly property color tertiary: "#b0b0b0"
    readonly property color _onTertiary: "#1a1a1a"
    readonly property color tertiaryContainer: "#606060"
    readonly property color _onTertiaryContainer: "#f0f0f0"
    readonly property color tertiaryFixed: "#b0b0b0"
    readonly property color tertiaryFixedDim: "#909090"
    readonly property color _onTertiaryFixed: "#1a1a1a"
    readonly property color _onTertiaryFixedVariant: "#606060"

    // Error colors
    readonly property color error: "#909090"
    readonly property color _onError: "#1a1a1a"
    readonly property color errorContainer: "#707070"
    readonly property color _onErrorContainer: "#f0f0f0"

    // Surface colors
    readonly property color surface: "#1e1e1e"
    readonly property color _onSurface: "#f0f0f0"
    readonly property color surfaceVariant: "#2a2a2a"
    readonly property color _onSurfaceVariant: "#d0d0d0"
    readonly property color surfaceDim: "#0f0f0f"
    readonly property color surfaceBright: "#4a4a4a"
    readonly property color surfaceContainerLowest: "#1a1a1a"
    readonly property color surfaceContainerLow: "#0d0d0d"
    readonly property color surfaceContainer: "#2a2a2a"
    readonly property color surfaceContainerHigh: "#353535"
    readonly property color surfaceContainerHighest: "#404040"
    readonly property color inverseSurface: "#f0f0f0"
    readonly property color inverseOnSurface: "#2a2a2a"

    // Background colors
    readonly property color background: "#131313"
    readonly property color _onBackground: "#f0f0f0"

    // Outline colors
    readonly property color outline: "#808080"
    readonly property color outlineVariant: "#606060"

    // Other colors
    readonly property color shadow: "#1a1a1a"
    readonly property color scrim: "#1a1a1a"
    readonly property color sourceColor: "#f0f0f0"
}