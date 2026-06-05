pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import qs.bar.widgets.workspace
import qs.bar.widgets
import qs.style
import qs

Scope {
    required property string primaryScreen

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            visible: ShellState.barVisible;

            required property var modelData
            readonly property bool isPrimary: modelData.name === primaryScreen

            readonly property var hyprland_monitor: {
                // If the screen data isn't fully loaded yet, wait.
                if (!modelData || !modelData.name)
                    return null;

                return Hyprland.monitors.values.find(m => {
                    // If Hyprland hasn't fully broadcast this monitor yet, skip it.
                    if (!m || !m.name)
                        return false;

                    // Strip hyphens to ensure a perfect match (e.g., DP-1 vs DP1)
                    let hName = m.name.replace(/-/g, "").toLowerCase();
                    let qName = modelData.name.replace(/-/g, "").toLowerCase();
                    return hName === qName;
                }) || null;
            }

            screen: modelData
            anchors {
                top: true
                left: true
                right: true
            }
            implicitHeight: 40
            color: "transparent"

            Loader {
                anchors.fill: parent
                anchors.leftMargin: Tokens.appearance.padding.larger
                anchors.rightMargin: Tokens.appearance.padding.larger

                sourceComponent: isPrimary ? primaryBarContent : secondaryBarContent
                property var monitorBridge: bar.hyprland_monitor
            }
        }
    }

    // ==========================================
    // 🎨 LAYOUT DEFINITIONS
    // ==========================================

    Component {
        id: primaryBarContent

        Item {
            id: primaryRoot

            property var localMonitor: parent.monitorBridge

            RowLayout {
                anchors.left: parent.left
                anchors.leftMargin: Tokens.appearance.padding.small
                anchors.verticalCenter: parent.verticalCenter
                spacing: Tokens.appearance.spacing.larger

                PowerButton {
                }
                ResourcesWidget {
                }
                StereoWidget {}
                AgentWidget {}
            }


            WorkspacesWidget {
                anchors.centerIn: parent
                monitor: primaryRoot.localMonitor
            }

            RowLayout {
                anchors.rightMargin: Tokens.appearance.padding.small
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                spacing: Tokens.appearance.spacing.small

                ConnectivityWidget {}
                NotificationButton {}
                ClockWidget {}
            }
        }
    }

    Component {
        id: secondaryBarContent

        Item {
            id: secondaryRoot

            property var localMonitor: parent.monitorBridge

            WorkspacesWidget {
                anchors.left: parent.left
                anchors.leftMargin: Tokens.appearance.padding.medium
                anchors.verticalCenter: parent.verticalCenter
                monitor: secondaryRoot.localMonitor
            }

            ClockWidget {
                showDate: false
                anchors.rightMargin: Tokens.appearance.padding.large
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
