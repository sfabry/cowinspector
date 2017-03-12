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
                    hoverEnabled: true
                    ToolTip.delay: 1000
                    ToolTip.timeout: 5000
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("Speed calibration for food distribution in that box.")
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
                    hoverEnabled: true
                    ToolTip.delay: 1000
                    ToolTip.timeout: 5000
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("Speed calibration for food distribution in that box.")
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
                    hoverEnabled: true
                    ToolTip.delay: 1000
                    ToolTip.timeout: 5000
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("When pressing the debug button on the electronic board.\n" +
                                       "Amount of time the food is given (seconds)")
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
                    hoverEnabled: true
                    ToolTip.delay: 1000
                    ToolTip.timeout: 5000
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("Minimum amount of food given in one chunk.")
                }
            }
        }

        Rectangle {
            height: 1
            Layout.fillWidth: true
            color: "blue"
        }

        ComboBox {
            id: roleComboBox
            Layout.fillWidth: true
            model: [qsTr("Food A"), qsTr("Food B"), qsTr("Number of visits"), qsTr("Meal counts")]
            onCurrentIndexChanged: bars.max = 1
        }

        Rectangle {
            id: backgroundRect
            height: dp(300)
            Layout.fillWidth: true

            gradient: Gradient {
                id: background
                property color color: "lightblue"
                GradientStop { position: 0.0; color: background.color }
                GradientStop { position: 1.0; color: Qt.lighter(background.color) }
            }

            Repeater {
                id: bars
                model: boxModel.statsModel()
                property real barWidth: backgroundRect.width / (2 * bars.model.rowCount() - 1)
                property real max: 1

                delegate: Rectangle {
                    property real roleValue: roleComboBox.currentIndex == 0 ? Math.round(suma / 1000) : (roleComboBox.currentIndex == 1 ? Math.round(sumb / 1000) : (roleComboBox.currentIndex == 2 ? cowvisits : mealcounts))
                    onRoleValueChanged: bars.max = Math.max(roleValue, bars.max)
                    gradient: Gradient {
                        id: pile
                        property color color: "orange"
                        GradientStop { position: 0.0; color: pile.color }
                        GradientStop { position: 1.0; color: Qt.lighter(pile.color) }
                    }

                    anchors.bottom: parent.bottom
                    height: backgroundRect.height * (roleValue / bars.max)
                    width: bars.barWidth

                    x: width + index * dp(2 * width)


                    Text {
                        anchors.left: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        text: Qt.formatDate(day, "dd/MM/yyyy") + " : " + roleValue + (roleComboBox.currentIndex < 2 ? " kg" : "")
                        rotation: -90
                        transformOrigin: Item.Left
                    }
                }

            }
        }
    }

}
