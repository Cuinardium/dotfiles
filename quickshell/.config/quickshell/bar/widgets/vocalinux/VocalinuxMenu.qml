pragma ComponentBehavior: Bound

import QtQuick

import Quickshell
import Quickshell.Hyprland

import qs.components
import qs.services
import qs.style
import qs.style.motions

PopupWindow {
    id: root

    required property Item anchorItem
    property bool open: false

    property real openedAt: 0

    // The popup never writes `open` (it is bound by the owner); it asks instead,
    // otherwise the assignment would break the binding and the menu would never
    // open a second time.
    signal closeRequested()

    // Prefixes into vocalinux's own menu, grouped as rendered. Labels, enabled
    // state and visibility all come from that menu; a missing entry is hidden.
    // "Recent Snippets" is left out because it needs a nested flyout.
    readonly property var groups: [
        ["Start Voice Typing", "Stop Voice Typing", "Cancel Transcription"],
        ["Transcribe Audio File", "Dictation Pad", "View Logs", "Settings"],
        ["Quit"],
    ]

    readonly property var rows: {
        const rows = [];
        for (const group of root.groups) {
            const entries = group.map(prefix => ({ prefix: prefix, entry: Vocalinux.menuEntry(prefix) }))
                .filter(row => row.entry !== null);
            if (entries.length === 0)
                continue;
            if (rows.length > 0)
                rows.push({ separator: true, prefix: "", entry: null });
            rows.push(...entries);
        }
        return rows;
    }

    // Every row shares one width, so the widest label sizes the card.
    readonly property string widestLabel: root.rows.reduce((widest, row) => {
        const text = row.entry !== null ? row.entry.text : "";
        return text.length > widest.length ? text : widest;
    }, "")

    TextMetrics {
        id: metrics

        font.family: Tokens.appearance.fontFamily.sans
        font.pointSize: Tokens.appearance.fontSize.normal
        text: root.widestLabel
    }

    visible: root.open && Vocalinux.menuReady
    color: "transparent"
    implicitWidth: Math.max(180, metrics.advanceWidth + Tokens.appearance.padding.normal * 2
        + Tokens.appearance.padding.small * 2 + 8)
    implicitHeight: card.implicitHeight

    onVisibleChanged: {
        if (!visible && root.open)
            root.closeRequested();
    }

    onOpenChanged: {
        if (root.open && !Vocalinux.menuReady)
            console.warn("Vocalinux: menu opened before its dbusmenu layout was ready");

        if (root.open) {
            root.openedAt = Date.now();
            anchorTimer.restart();
        }
    }

    // The anchor rect is only read when the popup is shown; re-read it on the next
    // event loop turn so a popup opened before the bar settled still lands right.
    Timer {
        id: anchorTimer
        interval: 0

        onTriggered: root.anchor.updateAnchor()
    }

    // A grab needs an xdg_popup grab, which a layer-shell bar cannot provide.
    HyprlandFocusGrab {
        active: root.visible
        windows: [root]

        // A clear landing while the popup is still being mapped would close the
        // menu the instant it opens; only honour clears after it has settled.
        onCleared: {
            if (Date.now() - root.openedAt > 250)
                root.closeRequested();
        }
    }

    anchor.edges: Edges.Bottom | Edges.Left
    anchor.gravity: Edges.Bottom | Edges.Right
    anchor.adjustment: PopupAdjustment.None

    // Anchored to the item's rect, mapped by hand: `anchor.item` alone leaves the
    // rect at the origin, so the menu would open at the window's top-left corner.
    anchor.window: root.anchorItem.QsWindow.window
    anchor.onAnchoring: {
        const pos = root.anchorItem.QsWindow.contentItem.mapFromItem(
            root.anchorItem,
            0,
            root.anchorItem.height + Tokens.appearance.padding.smaller
        );

        root.anchor.rect.x = pos.x;
        root.anchor.rect.y = pos.y;
    }

    StyledRect {
        id: card

        anchors.fill: parent
        color: Qt.alpha(Theme.surface, 0.96)
        radius: Tokens.appearance.rounding.normal
        border.width: 1
        border.color: Qt.alpha(Theme.outline, 0.2)
        implicitHeight: column.implicitHeight + Tokens.appearance.padding.small * 2

        Column {
            id: column

            anchors.centerIn: parent
            width: card.width - Tokens.appearance.padding.small * 2
            spacing: 2

            Repeater {
                model: root.rows

                delegate: Item {
                    id: row

                    required property var modelData

                    readonly property bool isSeparator: row.modelData.separator === true

                    width: column.width
                    height: row.isSeparator ? 9 : item.implicitHeight

                    Rectangle {
                        visible: row.isSeparator
                        anchors.centerIn: parent
                        width: parent.width
                        height: visible ? 1 : 0
                        color: Qt.alpha(Theme.outline, 0.25)
                    }

                    VocalinuxMenuItem {
                        id: item

                        anchors.fill: parent
                        visible: !row.isSeparator
                        label: row.modelData.entry !== null ? row.modelData.entry.text : ""
                        available: row.modelData.entry !== null && row.modelData.entry.enabled

                        onActivated: {
                            Vocalinux.trigger(row.modelData.prefix);
                            root.closeRequested();
                        }
                    }
                }
            }
        }
    }
}
