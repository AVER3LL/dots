/*
 * QML Colors for Everforest Theme
 */
pragma Singleton
import QtQuick

QtObject {
    id: root

    // Primary colors
    readonly property color primary: "#a7c080"
    readonly property color _onPrimary: "#1e2326"
    readonly property color primaryContainer: "#4f5b58"
    readonly property color _onPrimaryContainer: "#d3c6aa"
    readonly property color inversePrimary: "#4f5b58"
    readonly property color primaryFixed: "#a7c080"
    readonly property color primaryFixedDim: "#93b074"
    readonly property color _onPrimaryFixed: "#1e2326"
    readonly property color _onPrimaryFixedVariant: "#3e4a47"

    // Secondary colors
    readonly property color secondary: "#83c092"
    readonly property color _onSecondary: "#1e2326"
    readonly property color secondaryContainer: "#4a5d5a"
    readonly property color _onSecondaryContainer: "#d3c6aa"
    readonly property color secondaryFixed: "#83c092"
    readonly property color secondaryFixedDim: "#73b086"
    readonly property color _onSecondaryFixed: "#1e2326"
    readonly property color _onSecondaryFixedVariant: "#394d4a"

    // Tertiary colors
    readonly property color tertiary: "#dbbc7f"
    readonly property color _onTertiary: "#1e2326"
    readonly property color tertiaryContainer: "#5d4f4a"
    readonly property color _onTertiaryContainer: "#d3c6aa"
    readonly property color tertiaryFixed: "#dbbc7f"
    readonly property color tertiaryFixedDim: "#c7a873"
    readonly property color _onTertiaryFixed: "#1e2326"
    readonly property color _onTertiaryFixedVariant: "#4c4039"

    // Error colors
    readonly property color error: "#e67e80"
    readonly property color _onError: "#1e2326"
    readonly property color errorContainer: "#5d4a4a"
    readonly property color _onErrorContainer: "#d3c6aa"

    // Surface colors
    readonly property color surface: "#2b3339"
    readonly property color _onSurface: "#d3c6aa"
    readonly property color surfaceVariant: "#374145"
    readonly property color _onSurfaceVariant: "#859289"
    readonly property color surfaceDim: "#161b1e"
    readonly property color surfaceBright: "#5a6569"
    readonly property color surfaceContainerLowest: "#161b1e"
    readonly property color surfaceContainerLow: "#1a1f22"
    readonly property color surfaceContainer: "#374145"
    readonly property color surfaceContainerHigh: "#424e52"
    readonly property color surfaceContainerHighest: "#4d595d"
    readonly property color inverseSurface: "#d3c6aa"
    readonly property color inverseOnSurface: "#374145"

    // Background colors
    readonly property color background: "#1e2326"
    readonly property color _onBackground: "#d3c6aa"

    // Outline colors
    readonly property color outline: "#859289"
    readonly property color outlineVariant: "#4a5d5a"

    // Other colors
    readonly property color shadow: "#000000"
    readonly property color scrim: "#000000"
    readonly property color sourceColor: "#a7c080"
}