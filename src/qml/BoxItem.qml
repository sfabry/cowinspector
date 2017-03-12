import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.0
import CowInspector 1.0
import QtQuick.Controls.Material 2.0

Rectangle {
    id: root
    property var boxModel
    property bool boxConnected: (Date.now() - boxModel.lastConnected.getTime()) < 300000

    implicitWidth: dp(400)
    implicitHeight: mainLayout.implicitHeight + dp(20)
    border.color: "blue"
    border.width: 2
    radius: dp(8)

    function minutesToText(minutes) {
        return minutes + qsTr(" min")
    }

    function foodspeedToText(speed) {
        return speed + qsTr(" gr/s")
    }

    function secondsToText(seconds) {
        return seconds + qsTr(" s")
    }

    function grammesToText(grammes) {
        return grammes + qsTr(" gr")
    }

    function updateIdleSchedule1() {
        var startDate = Date.fromLocaleTimeString(Qt.locale(), start1field.text, "hh:mm:ss")
        var endDate = new Date(startDate.getTime() + stop1duration.value * 60000)
        boxModel.setIdleStart1(startDate)
        boxModel.setIdleStop1(endDate)
    }

    function updateIdleSchedule2() {
        var startDate = Date.fromLocaleTimeString(Qt.locale(), start2field.text, "hh:mm:ss")
        var endDate = new Date(startDate.getTime() + stop2duration.value * 60000)
        boxModel.setIdleStart2(startDate)
        boxModel.setIdleStop2(endDate)
    }

    ColumnLayout {
        id: mainLayout
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: dp(10)
        spacing: 10

        RowLayout {
            Label {
                id: nameLabel
                text: boxModel.name
                font.bold: true
            }

            Item { Layout.fillWidth: true }

            Rectangle {
                color: boxConnected ? "green" : "red"
                height: nameLabel.height
                width: height
                radius: height / 2
            }
        }

        Rectangle {
            height: 1
            Layout.fillWidth: true
            color: "blue"
        }

        // Idle schedule 1
        ColumnLayout {
            spacing: -5

            Label {
                text: qsTr("Idle schedule 1")
                font.underline: true
            }

            RowLayout {
                Label {
                    text: qsTr("Starts from :")
                }
                Item { Layout.fillWidth: true }

                TextField {
                    id: start1field
                    inputMethodHints: Qt.ImhTime
                    text: boxModel.idleStart1.toTimeString()
                    horizontalAlignment: TextInput.AlignHCenter
                    onEditingFinished: root.updateIdleSchedule1()
                }

            }

            RowLayout {
                Label {
                    text: qsTr("Duration :")
                }
                Item { Layout.fillWidth: true }

                SpinBox {
                    id: stop1duration
                    editable: false
                    textFromValue: root.minutesToText
                    stepSize: 5
                    from: 0
                    to: 720
                    value: (boxModel.idleStop1 - boxModel.idleStart1) / 60000
                    onValueChanged: root.updateIdleSchedule1()
                }
            }

        }

        // Idle schedule 2
        ColumnLayout {
            spacing: -5
            Label {
                text: qsTr("Idle schedule 2")
                font.underline: true
            }

            RowLayout {
                Label {
                    text: qsTr("Starts from :")
                }
                Item { Layout.fillWidth: true }

                TextField {
                    id: start2field
                    inputMethodHints: Qt.ImhTime
                    text: boxModel.idleStart2.toTimeString()
                    horizontalAlignment: TextInput.AlignHCenter
                    onEditingFinished: root.updateIdleSchedule2()
                }

            }

            RowLayout {
                Label {
                    text: qsTr("Duration :")
                }
                Item { Layout.fillWidth: true }

                SpinBox {
                    id: stop2duration
                    editable: false
                    textFromValue: root.minutesToText
                    stepSize: 5
                    from: 0
                    to: 720
                    value: (boxModel.idleStop2 - boxModel.idleStart2) / 60000
                    onValueChanged: root.updateIdleSchedule2()
                }
            }
        }

        Rectangle {
            height: 1
            Layout.fillWidth: true
            color: "blue"
        }

        ColumnLayout {
            spacing: -5

            RowLayout {
                Label {
                    text: qsTr("Food speed A :")
                }
                Item { Layout.fillWidth: true }

                SpinBox {
                    editable: false
                    textFromValue: root.foodspeedToText
                    stepSize: 1
                    from: 0
                    to: 50
                    value: boxModel.foodSpeedA
                    onValueChanged: boxModel.setFoodSpeedA(value)
                }
            }
            RowLayout {
                Label {
                    text: qsTr("Food speed B :")
                }
                Item { Layout.fillWidth: true }

                SpinBox {
                    editable: false
                    textFromValue: root.foodspeedToText
                    stepSize: 1
                    from: 0
                    to: 50
                    value: boxModel.foodSpeedB
                    onValueChanged: boxModel.setFoodSpeedB(value)
                }
            }
        }

        Rectangle {
            height: 1
            Layout.fillWidth: true
            color: "blue"
        }

        ColumnLayout {
            spacing: -5

            RowLayout {
                Label {
                    text: qsTr("Calib. duration :")
                }
                Item { Layout.fillWidth: true }

                SpinBox {
                    editable: false
                    textFromValue: root.secondsToText
                    stepSize: 10
                    from: 0
                    to: 3600
                    value: boxModel.calibrationDuration
                    onValueChanged: boxModel.setCalibrationDuration(value)
                }
            }
            RowLayout {
                Label {
                    text: qsTr("Meal minimum :")
                }
                Item { Layout.fillWidth: true }

                SpinBox {
                    editable: false
                    textFromValue: root.grammesToText
                    stepSize: 10
                    from: 0
                    to: 1000
                    value: boxModel.mealMinimum
                    onValueChanged: boxModel.setMealMinimum(value)
                }
            }
        }

    }

}
