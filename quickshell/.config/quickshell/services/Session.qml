pragma Singleton
import Quickshell

Singleton {
    id: root

    function lock() {
        Quickshell.execDetached(["hyprlock"]);
    }

    function suspend() {
        Quickshell.execDetached(["systemctl", "suspend"]);
    }

    function poweroff() {
        Quickshell.execDetached(["systemctl", "poweroff"]);
    }

    function reboot() {
        Quickshell.execDetached(["systemctl", "reboot"]);
    }

    function rebootToFirmware() {
        Quickshell.execDetached(["systemctl", "reboot", "--firmware-setup"]);
    }
}
