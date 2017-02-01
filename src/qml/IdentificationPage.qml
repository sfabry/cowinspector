import QtQuick 2.7
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.0
import CowInspector 1.0
import QtQuick.Controls.Material 2.0

Page {
    id: root

    IdentificationModel {
        id: identificationModel
        Component.onCompleted: identificationModel.refresh()
    }

    property int rfidColumnWidth: dp(250)
    property int cardColumnWidth: dp(150)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 5

        RowLayout {
            width: parent.width
            Label {
                Layout.minimumWidth: rfidColumnWidth
                text: qsTr("RFID number")
                horizontalAlignment: Text.AlignHCenter
            }
            Label {
                Layout.minimumWidth: cardColumnWidth
                text: qsTr("Card number")
                horizontalAlignment: Text.AlignHCenter
            }
            Label {
                Layout.fillWidth: true
                text: qsTr("Cow number")
                horizontalAlignment: Text.AlignHCenter
            }
        }

        ListView {
            id: identificationsView
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: -1
            clip: true

            model: identificationModel

            ScrollBar.vertical: ScrollBar {
                id: scrollbar
                stepSize: 0.01
            }
            Keys.onUpPressed: scrollbar.decrease()
            Keys.onDownPressed: scrollbar.increase()
            focus: true
            Component.onCompleted: identificationsView.forceActiveFocus()

            delegate: Rectangle {
                width: parent.width
                implicitHeight: rowLayout.implicitHeight
                color: cownumber ? Material.background : "#FF9800"
                border.width: 1
                border.color: Material.foreground
                RowLayout {
                    id: rowLayout
                    anchors.fill: parent
                    Label {
                        text: rfid
                        Layout.minimumWidth: rfidColumnWidth
                        horizontalAlignment: Text.AlignHCenter
                    }
                    Label {
                        text: cardnumber
                        Layout.minimumWidth: cardColumnWidth
                        horizontalAlignment: Text.AlignHCenter
                    }
                    Item {
                        Layout.fillWidth: true
                        Layout.minimumHeight: childrenRect.height

                        TextField {
                            anchors.centerIn: parent
                            text: cownumber
                            placeholderText: qsTr("Click to assign a cow")
                            horizontalAlignment: Text.AlignHCenter
                            onEditingFinished: {
                                identificationModel.assignCow(text, rfid)
                            }
                        }
                    }

                }
            }
        }
    }
}
