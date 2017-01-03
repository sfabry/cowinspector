import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.0
import CowInspector 1.0
import QtQuick.Controls.Material 2.0

Page {
    id: root

    LogsModel {
        id: logsModel
        Component.onCompleted: logsModel.refresh()
    }

    ListView {
        id: logsView
        anchors.fill: parent

        model: logsModel

        ScrollBar.vertical: ScrollBar {
            id: scrollbar
            stepSize: 0.001
        }
        Keys.onUpPressed: scrollbar.decrease()
        Keys.onDownPressed: scrollbar.increase()
        focus: true
        Component.onCompleted: logsView.forceActiveFocus()

        delegate: Rectangle {
            width: parent.width
            implicitHeight: rowLayout.implicitHeight
            color: level === "WARNING" ? "#FF9800" : "#8BC34A"
            RowLayout {
                id: rowLayout
                anchors.fill: parent
                Label {
                    text: level
                    Layout.minimumWidth: dp(100)
                }
                Label {
                    text: time
                    Layout.minimumWidth: dp(200)
                }
                Label {
                    Layout.fillWidth: true
                    text: message
                    elide: Text.ElideRight
                }
            }
        }
    }
}
