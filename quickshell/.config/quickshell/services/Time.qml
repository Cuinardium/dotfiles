pragma Singleton

import Quickshell
import QtQuick // for Text

Singleton {
    id: root

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    readonly property string date: {
        Qt.formatDateTime(clock.date, "ddd d MMM")
    }


    readonly property string time: {
        Qt.formatDateTime(clock.date, "hh:mm")
    }
}
