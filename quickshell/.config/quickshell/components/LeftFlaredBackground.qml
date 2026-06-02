pragma ComponentBehavior: Bound
import QtQuick
import qs.style

Canvas {
    id: background
    anchors.fill: parent

    // --- CONFIGURATION ---
    property real flareRadius: Tokens.appearance.rounding.normal
    property real cornerRadius: Tokens.appearance.rounding.normal
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

        // Your original math
        ctx.moveTo(0, 0);
        ctx.quadraticCurveTo(0, f, f, f);
        ctx.lineTo(w - r, f);
        ctx.arcTo(w, f, w, f + r, r);
        ctx.lineTo(w, h - f - r);
        ctx.arcTo(w, h - f, w - r, h - f, r);
        ctx.lineTo(f, h - f);
        ctx.quadraticCurveTo(0, h - f, 0, h);
        ctx.lineTo(0, 0);

        ctx.closePath();
        ctx.fill();
    }
}
