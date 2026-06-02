import QtQuick
import qs.style

PropertyAnimation {
    enum Type {
        StandardSmall = 0,
        Standard,
        StandardLarge,
        StandardExtraLarge,
        EmphasizedSmall,
        Emphasized,
        EmphasizedLarge,
        EmphasizedExtraLarge,
        FastSpatial,
        DefaultSpatial,
        SlowSpatial
    }

    property int type: Anim.Standard

    duration: {
        if (type < Anim.StandardSmall || type > Anim.SlowSpatial)
            return Tokens.appearance.animDurations.normal;

        if (type === Anim.FastSpatial)
            return Tokens.appearance.animDurations.expressiveFastSpatial;
        if (type === Anim.DefaultSpatial)
            return Tokens.appearance.animDurations.expressiveDefaultSpatial;
        if (type === Anim.SlowSpatial)
            return Tokens.appearance.animDurations.expressiveSlowSpatial;

        const durationMap = {
            [Anim.StandardSmall]: "small",
            [Anim.Standard]: "normal",
            [Anim.StandardLarge]: "large",
            [Anim.StandardExtraLarge]: "extraLarge",
            [Anim.EmphasizedSmall]: "small",
            [Anim.Emphasized]: "normal",
            [Anim.EmphasizedLarge]: "large",
            [Anim.EmphasizedExtraLarge]: "extraLarge",
        };
        return Tokens.appearance.animDurations[durationMap[type]] ?? Tokens.appearance.animDurations.normal;
    }
    easing.type: Easing.Bezier
    easing.bezierCurve: {
        if (type === Anim.FastSpatial)
            return Tokens.appearance.curves.expressiveFastSpatial;
        if (type === Anim.DefaultSpatial)
            return Tokens.appearance.curves.expressiveDefaultSpatial;
        if (type === Anim.SlowSpatial)
            return Tokens.appearance.curves.expressiveSlowSpatial;

        if (type >= Anim.EmphasizedSmall && type <= Anim.EmphasizedExtraLarge)
            return Tokens.appearance.curves.emphasized;
        return Tokens.appearance.curves.standard;
    }
}
