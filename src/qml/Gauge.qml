import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

Rectangle {
    id: control
    property real total: 1.0
    property real value: 0.4
    property string prefix: ""
    property real warningThreshold: 0.75

    implicitHeight: dp(20)
    implicitWidth: dp(100)

    border.color: "black"

    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: 1
        color: value / total > warningThreshold ? "green" : "orange"
        width: Math.min(parent.width - 2, parent.width * value / total)
    }

    Label {
        anchors.centerIn: parent
        text: prefix + (value === 0 ? 0 : (value / total * 100).toFixed()) + " %"
    }
}
