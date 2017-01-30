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
    }

    Timer {
        interval: 60 * 1000
        repeat: true
        running: true
        triggeredOnStart: false
        onTriggered: cowsModel.refresh()
    }

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

            Item { Layout.fillHeight: true }

        }

        GridView {
            id: grid
            flow: GridView.FlowTopToBottom
            cellHeight: dp(85)
            cellWidth: dp(600)


            Layout.fillHeight: true
            Layout.fillWidth: true
            clip: true

            model: cowsModel

            ScrollBar.horizontal: ScrollBar {
                id: scrollbar
                stepSize: 0.01
            }
            Keys.onLeftPressed: scrollbar.decrease()
            Keys.onRightPressed: scrollbar.increase()
            focus: true
            Component.onCompleted: grid.forceActiveFocus()

            delegate: Item {
                width: grid.cellWidth
                height: grid.cellHeight

                Rectangle {
                    anchors.fill: parent
                    anchors.leftMargin: 2
                    anchors.rightMargin: 2
                    color: "lightblue"
                    border.width: 1
                    border.color: "grey"

                    RowLayout {
                        id: rowLayout
                        anchors.fill: parent
                        anchors.margins: 5
                        Label {
                            text: cow
                            font.pixelSize: sp(25)
                            horizontalAlignment: Text.AlignHCenter
                            Layout.minimumWidth: dp(75)
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: alloca > 0 ? (meala/alloca < 0.25 ? "#FF9800" : "#8BC34A") : "transparent"

                            RowLayout {
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.top: parent.top
                                anchors.margins: 5
                                Label {
                                    text: qsTr("A: ")
                                }

                                Gauge {
                                    Layout.fillWidth: true
                                    prefix: "A: "
                                    total: alloca
                                    value: meala
                                }
                            }

                            SpinBox {
                                id: spinboxFoodA
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: -2

                                property bool modelUpdate: false
                                property int modelValue: alloca
                                onModelValueChanged: {
                                    modelUpdate = true
                                    value = modelValue
                                    modelUpdate = false
                                }

                                onValueChanged: if (!modelUpdate) cowsModel.setCowAllocation(cow, value, spinboxFoodB.value)
                                from: 0
                                to: 99999
                                stepSize: value >= 500 ? 500 : 50
                                editable: false
                                textFromValue: function(value) {
                                    if (value > 1000) return (value/1000.0).toFixed(1) + " kg"
                                    else return value + " gr"
                                }
                            }

                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: allocb > 0 ? (mealb/allocb < 0.25 ? "#FF9800" : "#8BC34A") : "transparent"

                            RowLayout {
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.top: parent.top
                                anchors.margins: 5
                                Label {
                                    text: qsTr("B: ")
                                }

                                Gauge {
                                    Layout.fillWidth: true
                                    prefix: "B: "
                                    total: allocb
                                    value: mealb
                                }
                            }

                            SpinBox {
                                id: spinboxFoodB
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: -2

                                property bool modelUpdate: false
                                property int modelValue: allocb
                                onModelValueChanged: {
                                    modelUpdate = true
                                    value = modelValue
                                    modelUpdate = false
                                }
                                onValueChanged: if (!modelUpdate) cowsModel.setCowAllocation(cow, spinboxFoodA.value, value)
                                from: 0
                                to: 99999
                                stepSize: value >= 500 ? 500 : 50
                                editable: false
                                textFromValue: function(value) {
                                    if (value > 1000) return (value/1000.0).toFixed(1) + " kg"
                                    else return value + " gr"
                                }
                            }
                        }
                    }
                }
            }
        }

    }

}
