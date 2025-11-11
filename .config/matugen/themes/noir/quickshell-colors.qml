/*
 * QML Colors for Noir Theme
 */
pragma Singleton
import QtQuick

QtObject {
    id: root

    // Primary colors
    readonly property color primary: "#ffffff"
    readonly property color _onPrimary: "#000000"
    readonly property color primaryContainer: "#333333"
    readonly property color _onPrimaryContainer: "#ffffff"
    readonly property color inversePrimary: "#ffffff"
    readonly property color primaryFixed: "#ffffff"
    readonly property color primaryFixedDim: "#cccccc"
    readonly property color _onPrimaryFixed: "#000000"
    readonly property color _onPrimaryFixedVariant: "#333333"

    // Secondary colors
    readonly property color secondary: "#cccccc"
    readonly property color _onSecondary: "#000000"
    readonly property color secondaryContainer: "#444444"
    readonly property color _onSecondaryContainer: "#ffffff"
    readonly property color secondaryFixed: "#cccccc"
    readonly property color secondaryFixedDim: "#aaaaaa"
    readonly property color _onSecondaryFixed: "#000000"
    readonly property color _onSecondaryFixedVariant: "#444444"

    // Tertiary colors
    readonly property color tertiary: "#aaaaaa"
    readonly property color _onTertiary: "#000000"
    readonly property color tertiaryContainer: "#555555"
    readonly property color _onTertiaryContainer: "#ffffff"
    readonly property color tertiaryFixed: "#aaaaaa"
    readonly property color tertiaryFixedDim: "#888888"
    readonly property color _onTertiaryFixed: "#000000"
    readonly property color _onTertiaryFixedVariant: "#555555"

    // Error colors
    readonly property color error: "#888888"
    readonly property color _onError: "#000000"
    readonly property color errorContainer: "#666666"
    readonly property color _onErrorContainer: "#ffffff"

    // Surface colors
    readonly property color surface: "#1e1e1e"
    readonly property color _onSurface: "#ffffff"
    readonly property color surfaceVariant: "#2a2a2a"
    readonly property color _onSurfaceVariant: "#cccccc"
    readonly property color surfaceDim: "#0f0f0f"
    readonly property color surfaceBright: "#4a4a4a"
    readonly property color surfaceContainerLowest: "#000000"
    readonly property color surfaceContainerLow: "#0d0d0d"
    readonly property color surfaceContainer: "#2a2a2a"
    readonly property color surfaceContainerHigh: "#353535"
    readonly property color surfaceContainerHighest: "#404040"
    readonly property color inverseSurface: "#e6e6e6"
    readonly property color inverseOnSurface: "#2a2a2a"

    // Background colors
    readonly property color background: "#131313"
    readonly property color _onBackground: "#ffffff"

    // Outline colors
    readonly property color outline: "#777777"
    readonly property color outlineVariant: "#555555"

    // Other colors
    readonly property color shadow: "#000000"
    readonly property color scrim: "#000000"
    readonly property color sourceColor: "#ffffff"
}