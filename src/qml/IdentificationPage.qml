import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.0
import CowInspector 1.0
import QtQuick.Controls.Material 2.0

Page {
    id: root

//    IdentificationModel {
//        id: identificationModel
//        Component.onCompleted: identificationModel.refresh()
//    }

//    ListView {
//        id: identificationsView
//        anchors.fill: parent

//        model: identificationModel

//        delegate: Rectangle {
//            width: parent.width
//            implicitHeight: rowLayout.implicitHeight
//            color: cownumber ? "#FF9800" : "#8BC34A"
//            RowLayout {
//                id: rowLayout
//                anchors.fill: parent
//                Label {
//                    text: rfid
//                    Layout.minimumWidth: dp(100)
//                }
//                Label {
//                    text: cardnumber
//                    Layout.minimumWidth: dp(200)
//                }
//                TextField {
//                    Layout.fillWidth: true
//                    text: cownumber
//                }
//            }
//        }
//    }
}
