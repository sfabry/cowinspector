import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.0
import CowInspector 1.0
import QtQuick.Controls.Material 2.0

Page {
    id: root

    BoxModel {
        id: box1
        number: 1
    }

    BoxModel {
        id: box2
        number: 2
    }

    BoxModel {
        id: box3
        number: 3
    }

    BoxModel {
        id: box4
        number: 4
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 20

        RowLayout {
            Label {
                text: qsTr("All boxes new day time : ")
            }
            TextField {
                inputMethodHints: Qt.ImhTime
                text: box1.newDayTime.toTimeString()
                horizontalAlignment: TextInput.AlignHCenter
                onEditingFinished: {
                    var newDayDate = Date.fromLocaleTimeString(Qt.locale(), text, "hh:mm:ss")
                    box1.setNewDayTime(newDayDate)
                    box2.setNewDayTime(newDayDate)
                    box3.setNewDayTime(newDayDate)
                    box4.setNewDayTime(newDayDate)
                }
            }
        }

        Label {
            visible: (box1.newDayTime.getTime() !== box2.newDayTime.getTime())
                     || (box2.newDayTime.getTime() !== box3.newDayTime.getTime())
                     || (box3.newDayTime.getTime() !== box4.newDayTime.getTime())
            Layout.fillWidth: true
            horizontalAlignment: TextField.AlignHCenter
            text: qsTr("CAUTION : All boxes do not have the same new day time, please change above to solve !")
            color: "red"
            font.pixelSize: sp(30)
        }

        RowLayout {
            Layout.fillWidth: true

            BoxItem {
                boxModel: box1
            }

            BoxItem {
                boxModel: box2
            }

            BoxItem {
                boxModel: box3
            }

            BoxItem {
                boxModel: box4
            }
        }
    }

}
