pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import qs

/**
 * Polled resource usage service with RAM, Swap, CPU usage, and Temperature.
 */
Singleton {
    id: root

    // --- Configuration Paths ---
    property string thermalPath: MachineConfig.thermalPath

    // --- Memory & Swap ---
    property real memoryTotal: 1
    property real memoryFree: 0
    readonly property real memoryUsed: memoryTotal - memoryFree
    readonly property real memoryUsedPercentage: memoryTotal > 0 ? (memoryUsed / memoryTotal) : 0

    property real swapTotal: 1
    property real swapFree: 0
    readonly property real swapUsed: swapTotal - swapFree
    readonly property real swapUsedPercentage: swapTotal > 0 ? (swapUsed / swapTotal) : 0

    // --- CPU ---
    property real cpuUsage: 0
    property real cpuTemp: 0
    property var previousCpuStats: null

    function poll() {
        fileMeminfo.reload();
        fileStat.reload();
        if (root.thermalPath) fileTemp.reload();

        // Parse Memory & Swap
        const textMeminfo = fileMeminfo.text();
        memoryTotal = Number(textMeminfo.match(/MemTotal:\s+(\d+)/)?.[1] || 1);
        memoryFree = Number(textMeminfo.match(/MemAvailable:\s+(\d+)/)?.[1] || 0);
        swapTotal = Number(textMeminfo.match(/SwapTotal:\s+(\d+)/)?.[1] || 1);
        swapFree = Number(textMeminfo.match(/SwapFree:\s+(\d+)/)?.[1] || 0);

        // Parse CPU Usage
        const textStat = fileStat.text();
        const cpuLine = textStat.split('\n')[0].trim().split(/\s+/);

        if (cpuLine[0] === "cpu") {
            const user = Number(cpuLine[1] || 0);
            const nice = Number(cpuLine[2] || 0);
            const system = Number(cpuLine[3] || 0);
            const idle = Number(cpuLine[4] || 0);
            const iowait = Number(cpuLine[5] || 0);
            const irq = Number(cpuLine[6] || 0);
            const softirq = Number(cpuLine[7] || 0);
            const steal = Number(cpuLine[8] || 0);

            const idleAll = idle + iowait;
            const systemAll = system + irq + softirq;
            const nonIdleAll = user + nice + systemAll + steal;
            const total = idleAll + nonIdleAll;

            if (previousCpuStats) {
                const totalDiff = total - previousCpuStats.total;
                const idleDiff = idleAll - previousCpuStats.idleAll;
                cpuUsage = totalDiff > 0 ? (totalDiff - idleDiff) / totalDiff : 0;
            }

            previousCpuStats = { total: total, idleAll: idleAll };
        }

        // Parse CPU Temperature
        if (root.thermalPath) {
            const tempRaw = Number(fileTemp.text() || 0);
            cpuTemp = tempRaw > 0 ? (tempRaw / 1000) : 0;
        } else {
            cpuTemp = 0;
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: root.poll()
    }

    Component.onCompleted: poll()

    FileView {
        id: fileMeminfo
        path: "/proc/meminfo"
    }
    FileView {
        id: fileStat
        path: "/proc/stat"
    }
    FileView {
        id: fileTemp
        path: root.thermalPath
        onLoadFailed: root.cpuTemp = 0
    }

    // Detect coretemp/k10temp hwmon path at startup; falls back to thermalPath default
    Process {
        command: ["sh", "-c",
            "for f in /sys/class/hwmon/*/name; do " +
            "n=$(cat \"$f\" 2>/dev/null); " +
            "{ [ \"$n\" = coretemp ] || [ \"$n\" = k10temp ]; } && " +
            "printf '%s/temp1_input\\n' \"$(dirname \"$f\")\" && break; " +
            "done"]
        running: true
        stdout: SplitParser {
            onRead: data => { if (data) root.thermalPath = data }
        }
    }
}
