
import QtQuick
import qs.style

StyledText {
    property real fill

    font.family: Tokens.appearance.fontFamily.material
    font.pointSize: Tokens.appearance.fontSize.large
    font.variableAxes: ({
            FILL: fill.toFixed(1),
            opsz: fontInfo.pixelSize,
            wght: fontInfo.weight
        })

    renderType: Text.NativeRendering
    font.kerning: true
}
