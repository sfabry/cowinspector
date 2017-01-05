import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

Button {
    id: control
    property string icon
    implicitWidth: dp(48)
    implicitHeight: dp(48)

    contentItem: Image {
         source: control.icon
         horizontalAlignment: Text.AlignHCenter
         verticalAlignment: Text.AlignVCenter
         fillMode: Image.PreserveAspectFit
     }

     background: Rectangle {
         color: Material.background
         border.color: Material.primary
         border.width: 1
         radius: dp(12)
     }
}
