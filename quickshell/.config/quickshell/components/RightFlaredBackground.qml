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

        ctx.moveTo(w, 0);
        ctx.quadraticCurveTo(w, f, w - f, f);
        ctx.lineTo(r, f);
        ctx.arcTo(0, f, 0, f + r, r);
        ctx.lineTo(0, h - f - r);
        ctx.arcTo(0, h - f, r, h - f, r);
        ctx.lineTo(w - f, h - f);
        ctx.quadraticCurveTo(w, h - f, w, h);
        ctx.lineTo(w, 0);

        ctx.closePath();
        ctx.fill();
    }
}
