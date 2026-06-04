pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Hyprland
import qs.style
import qs.style.motions
import qs.util
import qs.components
import qs

// Responsabilidad única: renderizar un workspace y emitir señales hacia arriba.
// No escribe en el padre — nunca usa Binding con target externo.
Item {
    id: root

    // --- API pública: entradas ---
    required property var modelData
    required property HyprlandMonitor monitor

    // --- API pública: señales ---

    // Emitida cuando la geometría cambia y este pill está enfocado,
    // para que el padre pueda actualizar la posición del sliding background.
    signal focusedGeometryChanged(real x, real width)

    // --- Propiedades derivadas del modelo ---
    readonly property bool isCurrentMonitor: !!root.monitor && !!modelData?.monitor && (modelData.monitor.name === root.monitor.name)
    readonly property bool isActive: modelData.active
    readonly property bool isFocused: modelData.focused
    readonly property var windows: modelData.toplevels.values
    readonly property bool isEmpty: windows.length <= 0
    readonly property bool hasManyWindows: windows.length > 1
    property int _iconRevision: 0

    Instantiator {
        model: root.modelData?.toplevels ?? null
        delegate: Connections {
            required property var modelData   // cada toplevel
            target: modelData?.wayland ?? null

            function onTitleChanged() {
                root._iconRevision++;
            }
            function onAppIdChanged() {
                root._iconRevision++;
            }
        }
    }

    property string icons: {
        void _iconRevision  // force dependency registration — re-evaluates on appId/title changes
        return windows.slice(0,3).map(t => IconMap.getMatch(t?.wayland?.appId ?? "", t?.title ?? "").icon).join(MachineConfig.iconSpacing);
    }

    // --- Sizing ---
    height: 22
    visible: isCurrentMonitor
    clip: true  // enmascara iconos entrantes hasta que el ancho se expande

    readonly property real targetWidth: {
        if (!isCurrentMonitor)
            return 0;
        if (isEmpty || !hasManyWindows)
            return height;
        return iconText.width + (isFocused ? Tokens.appearance.padding.larger : Tokens.appearance.padding.normal);
    }

    width: targetWidth

    // --- Notificar al padre cuando cambia la geometría y estamos enfocados ---
    // Usamos señales en lugar de Binding con target externo.
    onXChanged: if (isFocused && isCurrentMonitor)
        focusedGeometryChanged(x, width)
    onWidthChanged: if (isFocused && isCurrentMonitor)
        focusedGeometryChanged(x, width)
    onIsFocusedChanged: {
        if (isFocused && isCurrentMonitor)
            focusedGeometryChanged(x, width);
    }

    // --- Contenido: íconos de ventanas ---
    Text {
        id: iconText
        anchors.centerIn: parent
        visible: !root.isEmpty

        color: root.isFocused ? Qt.alpha(Theme.on_primary, 0.7) : (root.isActive ? Theme.primary : Theme.tertiary)
        text: root.icons
        textFormat: Text.PlainText
        wrapMode: Text.NoWrap
        font.bold: true
        font.pixelSize: MachineConfig.iconFontSize

        opacity: root.isEmpty ? 0 : 1
        scale: root.isEmpty ? 0.5 : (root.isFocused ? 1.1 : 1.0)

        Behavior on scale {
            Anim {
                type: Anim.DefaultSpatial
            }
        }
        Behavior on opacity {
            Anim {
                type: Anim.DefaultSpatial
            }
        }
        Behavior on color {
            Anim {
                type: Anim.DefaultSpatial
            }
        }
    }

    // --- Contenido: punto indicador (workspace vacío) ---
    Rectangle {
        id: emptyIndicator
        anchors.centerIn: parent
        visible: root.isEmpty

        width: 8
        height: 8
        radius: width / 2

        color: root.isFocused ? Qt.alpha(Theme.on_primary, 0.7) : (root.isActive ? Theme.primary : Theme.outline_variant)
        opacity: root.isEmpty ? 1 : 0
        scale: root.isFocused ? 1.2 : 1.0

        Behavior on scale {
            Anim {
                type: Anim.DefaultSpatial
            }
        }
        Behavior on opacity {
            Anim {
                type: Anim.DefaultSpatial
            }
        }
        Behavior on color {
            Anim {
                type: Anim.DefaultSpatial
            }
        }
    }

    // --- Interacción ---
    Loader {
        anchors.fill: parent
        active: !root.isFocused
        sourceComponent: Component {
            StateLayer {
                anchors.fill: parent
                effectColor: Theme.primary
                radius: Tokens.appearance.rounding.full

                onClicked: {
                    if (root.modelData && !root.isFocused)
                        root.modelData.activate();
                }
            }
        }
    }
}
