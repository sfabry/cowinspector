import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.0

Page {
    id: root

    ColumnLayout {
        anchors.centerIn: parent
        spacing: dp(100)

        GridLayout {
            columns: 2
            rowSpacing: dp(20)

            Label {
                text: qsTr("Database IP address :")
                font.pixelSize: sp(25)
            }

            TextField {
                id: databaseIp
                font.pixelSize: sp(20)
                text: ci.databaseIp
                horizontalAlignment: TextInput.AlignHCenter
            }

            Label {
                text: qsTr("Database name :")
                font.pixelSize: sp(25)
            }

            TextField {
                id: databaseName
                font.pixelSize: sp(20)
                text: ci.databaseName
                horizontalAlignment: TextInput.AlignHCenter
            }

            Label {
                text: qsTr("Database Username :")
                font.pixelSize: sp(25)
            }

            TextField {
                id: databaseUserName
                font.pixelSize: sp(20)
                text: ci.databaseUsername
                horizontalAlignment: TextInput.AlignHCenter
            }

            Label {
                text: qsTr("Database password :")
                font.pixelSize: sp(25)
            }

            TextField {
                id: databasePassword
                font.pixelSize: sp(20)
                echoMode: TextField.Password
                text: ci.databasePassword
                horizontalAlignment: TextInput.AlignHCenter
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: dp(20)
            Button {
                text: qsTr("Cancel")
                onClicked: {
                    databaseIp.text = ci.databaseIp
                    databaseName.text = ci.databaseName
                    databaseUserName.text = ci.databaseUsername
                    databasePassword.text = ci.databasePassword
                }
            }

            Button {
                text: qsTr("Validate")
                onClicked: {
                    ci.setDatabaseIp(databaseIp.text)
                    ci.setDatabaseName(databaseName.text)
                    ci.setDatabaseUsername(databaseUserName.text)
                    ci.setDatabasePassword(databasePassword.text)

                    ci.reconnectDatabase()
//                    rebootPopup.open()
                }
            }

            Popup {
                id: rebootPopup
                width: dp(400)
                height: dp(200)
                x: -width/2
                y: -height/2

                ColumnLayout {
                    anchors.fill: parent
                    spacing: dp(5)

                    Label {
                        text: qsTr("Restart application to apply changes")
                        font.pixelSize: sp(30)
                        Layout.alignment: Qt.AlignHCenter
                        Layout.maximumWidth: parent.width
                        wrapMode: Text.Wrap
                    }

                    Button {
                        text: qsTr("Ok")
                        onClicked: rebootPopup.close()
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }
        }

    }
}
