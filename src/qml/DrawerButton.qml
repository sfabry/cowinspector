import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

Button {
    id: control
    property bool expanded: true
    property string icon
    property string qmlFile: ""
    font.pixelSize: sp(30)
    leftPadding: dp(96-12)
    implicitWidth: expanded ? dp(96*3) : dp(96)
    implicitHeight: dp(96)
    checkable: true

    contentItem: Text {
         text: control.text
         font: control.font
         color: "white"
         horizontalAlignment: Text.AlignHCenter
         verticalAlignment: Text.AlignVCenter
         elide: Text.ElideRight
     }

     background: Rectangle {
         color: control.checked ? Material.primary : "Grey"
         border.color: "white"
         border.width: 1

         Image {
             source: control.icon
             anchors.verticalCenter: parent.verticalCenter
             anchors.left: parent.left
             anchors.leftMargin: dp(12)
             width: dp(72)
             fillMode: Image.PreserveAspectFit
         }
     }
}
