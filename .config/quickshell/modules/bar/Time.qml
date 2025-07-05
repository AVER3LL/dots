pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    readonly property string time: {
        // Qt.formatDateTime(clock.date, "󰥔    MMMM dd hh:mm")
        Qt.formatDateTime(clock.date, "MMMM dd    hh:mm")
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

}
