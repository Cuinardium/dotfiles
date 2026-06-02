pragma ComponentBehavior: Bound
import QtQuick
import qs.style

Canvas {
    id: background
    anchors.fill: parent

    // --- CONFIGURATION ---
    property real flareRadius: 16
    property real cornerRadius: 16
    property color effectColor: Theme.surface
    property real alpha: 0.9

    // ---------------------

    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()
    onEffectColorChanged: requestPaint()

    onPaint: {
        var ctx = getContext("2d");
        ctx.reset();
        ctx.fillStyle = effectColor;
        ctx.globalAlpha = alpha;

        var w = width;
        var h = height;
        var f = flareRadius;
        var r = cornerRadius;

        ctx.beginPath();

        // Start at the absolute bottom-left
        ctx.moveTo(0, h);

        // 1. Bottom-Left Flare
        // Control point (f, h) forces it to start sideways along the bottom edge,
        // smoothly curving upward to end perfectly vertical at (f, h - f)
        ctx.quadraticCurveTo(f, h, f, h - f);

        // 2. Left Edge
        ctx.lineTo(f, r);

        // 3. Top-Left Corner
        ctx.arcTo(f, 0, f + r, 0, r);

        // 4. Top Edge
        ctx.lineTo(w - f - r, 0);

        // 5. Top-Right Corner
        ctx.arcTo(w - f, 0, w - f, r, r);

        // 6. Right Edge
        ctx.lineTo(w - f, h - f);

        // 7. Bottom-Right Flare
        // From straight down, control point (w - f, h) smoothly bends it
        // sideways to lay flat against the bottom-right edge
        ctx.quadraticCurveTo(w - f, h, w, h);

        // 8. Seal the bottom edge back to start
        ctx.lineTo(0, h);

        ctx.closePath();
        ctx.fill();
    }
}
