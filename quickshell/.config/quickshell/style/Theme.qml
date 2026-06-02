pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Io

QtObject {
    id: root

    // FileView owns JsonAdapter — watchChanges triggers reload on disk write
    property list<QtObject> _children: [
        FileView {
            id: colorFile
            path: Qt.resolvedUrl("colors.json").toString().replace("file://", "")
            watchChanges: true
            onFileChanged: reload()

            adapter: JsonAdapter {
                id: jsonColors

                property string background: "#131318"
                property string error: "#ffb4ab"
                property string error_container: "#93000a"
                property string inverse_on_surface: "#303036"
                property string inverse_primary: "#565992"
                property string inverse_surface: "#e4e1e9"
                property string on_background: "#e4e1e9"
                property string on_error: "#690005"
                property string on_error_container: "#ffdad6"
                property string on_primary: "#272b60"
                property string on_primary_container: "#e0e0ff"
                property string on_primary_fixed: "#11144b"
                property string on_primary_fixed_variant: "#3e4278"
                property string on_secondary: "#2e2f42"
                property string on_secondary_container: "#e1e0f9"
                property string on_secondary_fixed: "#191a2c"
                property string on_secondary_fixed_variant: "#444559"
                property string on_surface: "#e4e1e9"
                property string on_surface_variant: "#c7c5d0"
                property string on_tertiary: "#46263b"
                property string on_tertiary_container: "#ffd8ed"
                property string on_tertiary_fixed: "#2e1126"
                property string on_tertiary_fixed_variant: "#5e3c52"
                property string outline: "#918f9a"
                property string outline_variant: "#46464f"
                property string primary: "#bfc2ff"
                property string primary_container: "#3e4278"
                property string primary_fixed: "#e0e0ff"
                property string primary_fixed_dim: "#bfc2ff"
                property string scrim: "#000000"
                property string secondary: "#c5c4dd"
                property string secondary_container: "#444559"
                property string secondary_fixed: "#e1e0f9"
                property string secondary_fixed_dim: "#c5c4dd"
                property string shadow: "#000000"
                property string source_color: "#5a5e9c"
                property string surface: "#131318"
                property string surface_bright: "#39383f"
                property string surface_container: "#1f1f25"
                property string surface_container_high: "#2a292f"
                property string surface_container_highest: "#35343a"
                property string surface_container_low: "#1b1b21"
                property string surface_container_lowest: "#0e0e13"
                property string surface_dim: "#131318"
                property string surface_tint: "#bfc2ff"
                property string surface_variant: "#46464f"
                property string tertiary: "#e8b9d4"
                property string tertiary_container: "#5e3c52"
                property string tertiary_fixed: "#ffd8ed"
                property string tertiary_fixed_dim: "#e8b9d4"
            }
        }
    ]

    // Color properties — bind to JsonAdapter, animate on change
    property color background: jsonColors.background
    property color error: jsonColors.error
    property color error_container: jsonColors.error_container
    property color inverse_on_surface: jsonColors.inverse_on_surface
    property color inverse_primary: jsonColors.inverse_primary
    property color inverse_surface: jsonColors.inverse_surface
    property color on_background: jsonColors.on_background
    property color on_error: jsonColors.on_error
    property color on_error_container: jsonColors.on_error_container
    property color on_primary: jsonColors.on_primary
    property color on_primary_container: jsonColors.on_primary_container
    property color on_primary_fixed: jsonColors.on_primary_fixed
    property color on_primary_fixed_variant: jsonColors.on_primary_fixed_variant
    property color on_secondary: jsonColors.on_secondary
    property color on_secondary_container: jsonColors.on_secondary_container
    property color on_secondary_fixed: jsonColors.on_secondary_fixed
    property color on_secondary_fixed_variant: jsonColors.on_secondary_fixed_variant
    property color on_surface: jsonColors.on_surface
    property color on_surface_variant: jsonColors.on_surface_variant
    property color on_tertiary: jsonColors.on_tertiary
    property color on_tertiary_container: jsonColors.on_tertiary_container
    property color on_tertiary_fixed: jsonColors.on_tertiary_fixed
    property color on_tertiary_fixed_variant: jsonColors.on_tertiary_fixed_variant
    property color outline: jsonColors.outline
    property color outline_variant: jsonColors.outline_variant
    property color primary: jsonColors.primary
    property color primary_container: jsonColors.primary_container
    property color primary_fixed: jsonColors.primary_fixed
    property color primary_fixed_dim: jsonColors.primary_fixed_dim
    property color scrim: jsonColors.scrim
    property color secondary: jsonColors.secondary
    property color secondary_container: jsonColors.secondary_container
    property color secondary_fixed: jsonColors.secondary_fixed
    property color secondary_fixed_dim: jsonColors.secondary_fixed_dim
    property color shadow: jsonColors.shadow
    property color source_color: jsonColors.source_color
    property color surface: jsonColors.surface
    property color surface_bright: jsonColors.surface_bright
    property color surface_container: jsonColors.surface_container
    property color surface_container_high: jsonColors.surface_container_high
    property color surface_container_highest: jsonColors.surface_container_highest
    property color surface_container_low: jsonColors.surface_container_low
    property color surface_container_lowest: jsonColors.surface_container_lowest
    property color surface_dim: jsonColors.surface_dim
    property color surface_tint: jsonColors.surface_tint
    property color surface_variant: jsonColors.surface_variant
    property color tertiary: jsonColors.tertiary
    property color tertiary_container: jsonColors.tertiary_container
    property color tertiary_fixed: jsonColors.tertiary_fixed
    property color tertiary_fixed_dim: jsonColors.tertiary_fixed_dim

    property int animationDuration: 600

    Behavior on background {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on error {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on error_container {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on inverse_on_surface {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on inverse_primary {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on inverse_surface {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on on_background {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on on_error {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on on_error_container {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on on_primary {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on on_primary_container {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on on_primary_fixed {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on on_primary_fixed_variant {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on on_secondary {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on on_secondary_container {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on on_secondary_fixed {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on on_secondary_fixed_variant {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on on_surface {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on on_surface_variant {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on on_tertiary {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on on_tertiary_container {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on on_tertiary_fixed {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on on_tertiary_fixed_variant {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on outline {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on outline_variant {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on primary {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on primary_container {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on primary_fixed {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on primary_fixed_dim {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on scrim {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on secondary {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on secondary_container {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on secondary_fixed {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on secondary_fixed_dim {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on shadow {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on source_color {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on surface {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on surface_bright {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on surface_container {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on surface_container_high {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on surface_container_highest {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on surface_container_low {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on surface_container_lowest {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on surface_dim {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on surface_tint {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on surface_variant {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on tertiary {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on tertiary_container {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on tertiary_fixed {
        ColorAnimation {
            duration: animationDuration
        }
    }
    Behavior on tertiary_fixed_dim {
        ColorAnimation {
            duration: animationDuration
        }
    }

}
