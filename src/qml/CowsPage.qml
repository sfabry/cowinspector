import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.0
import CowInspector 1.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls 1.4 as Controls1

Page {
    id: root

    CowsModel {
        id: cowsModel
        showUnallocated: true
    }

//    Component.onCompleted: cowsModel.refresh()

    RowLayout {
        anchors.fill: parent
        anchors.margins: 5

        ColumnLayout {
            spacing: 5

            Label {
                text: qsTr("Day Summary")
                horizontalAlignment: Text.AlignHCenter
                Layout.minimumWidth: dp(300)
            }

            Controls1.Calendar {
                id: calendar
                Layout.minimumWidth: dp(300)
                Component.onCompleted: calendar.selectedDate = cowsModel.summaryDate
                onSelectedDateChanged: cowsModel.summaryDate = selectedDate
            }

            ListView {
                id: cowsView
                property int selectedCow: -1
                implicitWidth: dp(300)
                Layout.fillHeight: true
                clip: true

                model: cowsModel

                ScrollBar.vertical: ScrollBar {
                    id: scrollbar
                    stepSize: 0.01
                }
                Keys.onUpPressed: scrollbar.decrease()
                Keys.onDownPressed: scrollbar.increase()
                focus: true
                Component.onCompleted: cowsView.forceActiveFocus()

                delegate: Rectangle {
                    width: parent.width
                    implicitHeight: rowLayout.implicitHeight + 20
                    color: ((alloca > 0 && meala/alloca < 0.25) || (allocb>0 && mealb/allocb < 0.25)) ? "#FF9800" : "#8BC34A"
                    border.color: cowsView.selectedCow === cow ? "red" : "lightblue"
                    border.width: cowsView.selectedCow === cow ? 2 : 1
                    RowLayout {
                        id: rowLayout
                        anchors.fill: parent
                        anchors.margins: 10
                        Label {
                            text: cow
                            font.pixelSize: sp(25)
                            Layout.minimumWidth: dp(50)
                        }
                        ColumnLayout {
                            Gauge {
                                Layout.fillWidth: true
                                prefix: "A: "
                                total: alloca
                                value: meala
                            }
                            Gauge {
                                Layout.fillWidth: true
                                prefix: "B: "
                                total: allocb
                                value: mealb
                            }
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: cowsView.selectedCow = cow
                    }
                }
            }
        }

        // Details page
        CowDetailPage {
            Layout.fillHeight: true
            Layout.fillWidth: true
            cow: cowsView.selectedCow
        }
    }

}
