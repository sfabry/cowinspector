import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.0
import CowInspector 1.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls 1.4 as Controls1

Rectangle {
	id: root
	property alias number: boxModel.number
	property bool boxConnected: (Date.now() - boxModel.lastConnected.getTime()) < 300000

    property date statDay
    property int boxFoodA
    property int boxFoodB
    property int totalFoodA: 1
    property int totalFoodB: 1

    function refreshModel() {
        boxModel.refresh()
        var result = boxModel.totalFoodForDay(statDay)
        root.boxFoodA = result["foodA"]
        root.boxFoodB = result["foodB"]
    }
    onStatDayChanged: refreshModel()

    implicitHeight: dp(120)
    border.color: "blue"
    border.width: 2
    radius: dp(8)

	BoxModel {
        id: boxModel
        
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

        RowLayout {
            Label { text: qsTr("Food A:") }
            Gauge {
                id: gaugeA
                value: root.boxFoodA
                total: root.totalFoodA
                Layout.fillWidth: true
                warningThreshold: 0.1
            }
        }

        RowLayout {
            Label { text: qsTr("Food B:") }
            Gauge {
                id: gaugeB
                value: root.boxFoodB
                total: root.totalFoodB
                Layout.fillWidth: true
                warningThreshold: 0.1
            }
        }

    }
}
