pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

import qs.components
import qs.style
import qs.services
import qs

Item {
    id: root
    anchors.fill: parent

    Connections {
        target: ShellState.menus
        function onRunMenuChanged() {
            if (ShellState.menus.runMenu) {
                searchField.text = ""
                searchField.forceActiveFocus()
                Applications.search("")
                appList.currentIndex = 0
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        ListView {
            id: appList
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 2

            model: Applications.filteredApps

            preferredHighlightBegin: 0
            preferredHighlightEnd: height - 56
            highlightRangeMode: ListView.ApplyRange

            delegate: Rectangle {
                id: delegateItem
                required property var modelData
                required property int index

                width: ListView.view.width
                height: 56
                radius: Tokens.appearance.rounding.small
                color: ListView.isCurrentItem ? Qt.alpha(Theme.primary, 0.12) : "transparent"
                property bool selected: ListView.isCurrentItem

                StateLayer {
                    id: stateLayer
                    effectColor: Theme.primary
                    onClicked: {
                        if (Applications.launch(delegateItem.index)) {
                            ShellState.menus.runMenu = false
                            searchField.text = ""
                        }
                    }
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 12
                    anchors.topMargin: 8
                    anchors.bottomMargin: 8
                    spacing: 12

                    Rectangle {
                        Layout.preferredWidth: 40
                        Layout.preferredHeight: 40
                        radius: 20
                        color: "transparent"
                        clip: true

                        IconImage {
                            anchors.fill: parent
                            anchors.margins: 4
                            source: delegateItem.modelData.icon ? ("image://icon/" + delegateItem.modelData.icon) : ""
                            mipmap: true
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 1

                        StyledText {
                            Layout.fillWidth: true
                            text: delegateItem.modelData.name
                            color: delegateItem.selected ? Theme.primary : Theme.on_surface
                            font.pointSize: Tokens.appearance.fontSize.small
                            font.weight: Font.Medium
                            elide: Text.ElideRight
                        }

                        StyledText {
                            Layout.fillWidth: true
                            text: delegateItem.modelData.genericName || ""
                            color: Theme.on_surface_variant
                            font.pointSize: Tokens.appearance.fontSize.smaller
                            elide: Text.ElideRight
                            visible: text.length > 0
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 44
            Layout.bottomMargin: 8
            Layout.topMargin: 8
            radius: Tokens.appearance.rounding.full
            color: Qt.alpha(Theme.primary, 0.12)

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 14
                anchors.rightMargin: 14
                spacing: 8

                MaterialIcon {
                    text: "search"
                    color: Theme.primary
                    verticalAlignment: Text.AlignVCenter
                }

                TextInput {
                    id: searchField
                    Layout.fillWidth: true
                    verticalAlignment: TextInput.AlignVCenter
                    color: Theme.on_surface_variant
                    font.pixelSize: Tokens.appearance.fontSize.large
                    font.family: Tokens.appearance.fontFamily.sans
                    clip: true
                    focus: true

                    StyledText {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Search apps..."
                        color: Theme.on_surface_variant
                        visible: !parent.text
                    }

                    onTextChanged: {
                        Applications.search(text)
                        appList.currentIndex = 0
                    }

                    Keys.onDownPressed: { appList.incrementCurrentIndex(); (event) => event.accepted = true }
                    Keys.onUpPressed: { appList.decrementCurrentIndex(); (event) => event.accepted = true }
                    Keys.onTabPressed: { appList.incrementCurrentIndex(); (event) => event.accepted = true }
                    Keys.onBacktabPressed: { appList.decrementCurrentIndex(); (event) => event.accepted = true }
                    Keys.onReturnPressed: { 
                        if (Applications.launch(appList.currentIndex)) {
                            ShellState.menus.runMenu = false
                            searchField.text = ""
                        }

                        (event) => event.accepted = true 
                    }
                }

                MaterialIcon {
                    text: "close"
                    color: Theme.on_surface_variant
                    verticalAlignment: Text.AlignVCenter
                    visible: searchField.text.length > 0

                    StateLayer {
                        onClicked: searchField.text = ""
                    }
                }
            }
        }
    }

}
