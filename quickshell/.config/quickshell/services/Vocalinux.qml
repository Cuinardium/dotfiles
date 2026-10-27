pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.SystemTray

Singleton {
    id: root

    // Vocalinux publishes its phase only through its AppIndicator icon name; the
    // D-Bus interface below exposes Toggle/Start/Stop and no state at all.
    readonly property string busName: "com.vocalinux.Vocalinux"
    readonly property string objectPath: "/com/vocalinux/Vocalinux"

    readonly property var item: {
        const items = SystemTray.items.values;
        for (let i = 0; i < items.length; i++) {
            if ((items[i].id || "").indexOf("vocalinux") === 0)
                return items[i];
        }
        return null;
    }

    readonly property bool running: root.item !== null

    // Item icons arrive as "image://icon/<path>/<name>.svg?path=<dir>".
    readonly property string iconName: {
        if (!root.item)
            return "";
        const path = (root.item.icon || "").split("?")[0];
        return path.substring(path.lastIndexOf("/") + 1).replace(/\.svg$/, "");
    }

    // "absent" | "idle" | "listening" | "processing"
    readonly property string state: {
        if (!root.item)
            return "absent";
        if (root.iconName.indexOf("-process") > 0)
            return "processing";
        if (root.iconName.indexOf("-off") > 0)
            return "idle";
        return "listening";
    }

    readonly property bool listening: root.state === "listening"
    readonly property bool processing: root.state === "processing"
    readonly property bool active: root.listening || root.processing

    // Menu entries of the AppIndicator vocalinux registers next to its icon.
    readonly property bool menuReady: opener.children.values.length > 0

    function menuEntry(prefix): var {
        const entries = opener.children.values;
        for (let i = 0; i < entries.length; i++) {
            if ((entries[i].text || "").indexOf(prefix) === 0)
                return entries[i];
        }
        return null;
    }

    function trigger(prefix): void {
        const entry = root.menuEntry(prefix);
        if (entry !== null && entry.enabled)
            entry.triggered();
    }

    function toggle(): void {
        root.call("Toggle");
    }

    function start(): void {
        root.call("Start");
    }

    function stop(): void {
        root.call("Stop");
    }

    function call(method: string): void {
        if (!root.running)
            return;
        control.command = ["gdbus", "call", "--session", "--dest", root.busName,
            "--object-path", root.objectPath, "--method", root.busName + "." + method];
        control.running = true;
    }

    Process {
        id: control

        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0)
                console.warn("Vocalinux: " + control.command.join(" ") + " exited with " + exitCode);
        }
    }

    // Tracks vocalinux's own menu so entries it hides (missing model, gateway
    // stopped, no update) never surface here, and labels stay in sync.
    QsMenuOpener {
        id: opener

        menu: root.item ? root.item.menu : null
    }
}
