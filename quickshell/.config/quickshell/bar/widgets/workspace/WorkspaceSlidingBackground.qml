pragma ComponentBehavior: Bound
import QtQuick
import qs.style
import qs.style.motions

// Responsabilidad única: renderizar y animar el fondo deslizante.
// No sabe nada de workspaces — solo reacciona a propiedades externas.
Rectangle {
    id: root

    // --- API pública ---
    required property real targetX
    required property real targetWidth
    required property bool isFocused     // controla visibilidad (fade)
    required property real rowY          // posición vertical del Row padre
    required property real rowHeight

    // --- Posicionamiento ---
    x: targetX
    y: rowY + (rowHeight - height) / 2
    width: targetWidth
    height: 22

    // --- Apariencia ---
    radius: height / 2
    color: Qt.alpha(Theme.primary, 1)

    // Fade suave cuando el monitor pierde/gana foco
    opacity: isFocused ? 1 : 0

    // --- Animaciones ---
    Behavior on opacity { Anim { type: Anim.DefaultSpatial } }
    Behavior on x       { Anim { type: Anim.SlowSpatial    } }
    Behavior on width   { Anim { type: Anim.SlowSpatial    } }
}
