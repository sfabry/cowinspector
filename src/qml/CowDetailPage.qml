import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.0
import CowInspector 1.0
import QtQuick.Controls.Material 2.0

Page {
    id: root
    property int cow

    CowDaysModel {
        id: cowDaysModel
        cowNumber: root.cow
    }

    CowMealsModel {
        id: cowMealsModel
        cowNumber: root.cow
    }

    property int dayColumnWidth: 200
    property int foodaColumnWidth: 100
    property int foodbColumnWidth: 100
    property int boxColumnWidth: 100
    property int entryColumnWidth: 200
    property int exitColumnWidth: 200

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 5
        spacing: 10

        RowLayout {
            width: parent.width
            Label {
                Layout.minimumWidth: dayColumnWidth
                text: qsTr("Day")
                horizontalAlignment: Text.AlignHCenter
            }
            Label {
                Layout.minimumWidth: foodaColumnWidth
                text: qsTr("Total Food A")
                horizontalAlignment: Text.AlignHCenter
            }
            Label {
                Layout.minimumWidth: foodbColumnWidth
                text: qsTr("Total Food B")
                horizontalAlignment: Text.AlignHCenter
            }
            Label {
                Layout.fillWidth: true
                text: qsTr("Meal count")
                horizontalAlignment: Text.AlignHCenter
            }
        }

        ListView {
            id: cowDaysView
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: -1
            clip: true

            model: cowDaysModel

            ScrollBar.vertical: ScrollBar {
                id: scrollbar
                stepSize: 0.01
            }
            Keys.onUpPressed: scrollbar.decrease()
            Keys.onDownPressed: scrollbar.increase()
            focus: true
            Component.onCompleted: cowDaysView.forceActiveFocus()

            delegate: Rectangle {
                width: parent.width
                implicitHeight: rowLayout.implicitHeight
                color: Material.background
                border.width: 1
                border.color: Material.foreground
                RowLayout {
                    id: rowLayout
                    anchors.fill: parent
                    Label {
                        text: day
                        Layout.minimumWidth: dayColumnWidth
                        horizontalAlignment: Text.AlignHCenter
                    }
                    Label {
                        text: sa
                        Layout.minimumWidth: foodaColumnWidth
                        horizontalAlignment: Text.AlignHCenter
                    }
                    Label {
                        text: sb
                        Layout.minimumWidth: foodbColumnWidth
                        horizontalAlignment: Text.AlignHCenter
                    }
                    Label {
                        text: mealcount
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }
        }


        RowLayout {
            width: parent.width
            Label {
                Layout.minimumWidth: entryColumnWidth
                text: qsTr("Entry")
                horizontalAlignment: Text.AlignHCenter
            }
            Label {
                Layout.minimumWidth: exitColumnWidth
                text: qsTr("Exit")
                horizontalAlignment: Text.AlignHCenter
            }
            Label {
                Layout.minimumWidth: boxColumnWidth
                text: qsTr("Box")
                horizontalAlignment: Text.AlignHCenter
            }
            Label {
                Layout.minimumWidth: foodaColumnWidth
                text: qsTr("Food A")
                horizontalAlignment: Text.AlignHCenter
            }
            Label {
                Layout.fillWidth: true
                text: qsTr("Food B")
                horizontalAlignment: Text.AlignHCenter
            }
        }

        ListView {
            id: cowMealsView
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: -1
            clip: true

            model: cowMealsModel

            ScrollBar.vertical: ScrollBar {
                id: scrollbar2
                stepSize: 0.01
            }
            Keys.onUpPressed: scrollbar2.decrease()
            Keys.onDownPressed: scrollbar2.increase()
            focus: true
            Component.onCompleted: cowMealsView.forceActiveFocus()

            delegate: Rectangle {
                width: parent.width
                implicitHeight: rowLayout2.implicitHeight
                color: Material.background
                border.width: 1
                border.color: Material.foreground
                RowLayout {
                    id: rowLayout2
                    anchors.fill: parent
                    Label {
                        text: entry
                        Layout.minimumWidth: entryColumnWidth
                        horizontalAlignment: Text.AlignHCenter
                    }
                    Label {
                        text: exit
                        Layout.minimumWidth: exitColumnWidth
                        horizontalAlignment: Text.AlignHCenter
                    }
                    Label {
                        text: box
                        Layout.minimumWidth: boxColumnWidth
                        horizontalAlignment: Text.AlignHCenter
                    }
                    Label {
                        text: fooda
                        Layout.minimumWidth: foodaColumnWidth
                        horizontalAlignment: Text.AlignHCenter
                    }
                    Label {
                        text: foodb
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }
        }

    }
}
