pragma Singleton
import Quickshell.Services.Notifications
import qs

NotificationServer {
    id: notificationServer

    onNotification: function (notification) {
        const ignoredNames = ["opencode", "Hyprshot"];
        const ignoredSummariesMatchers = ["Claude Code"];
        const isIgnored = ignoredNames.includes(notification.appName)
            || ignoredSummariesMatchers.some(sum => notification.summary.includes(sum));

        notification.tracked = true;
        ShellState.showToast(notification, isIgnored);
    }

    property bool hasNotifications: trackedNotifications.values.length > 0
}
