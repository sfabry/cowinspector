import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

ApplicationWindow {
    id: rootWindow
    title: qsTr("Cow Inspector")
    x: 650
    y: 30
    width: 1250
    height: 1024
    visible: true

    Material.accent: Material.Green
    color: Material.background

    function dp(pixel) { return pixel * Screen.pixelDensity / 6 }
    function sp(pixel) { return pixel * Screen.pixelDensity / 6 }

    minimumHeight: 400
    minimumWidth: 800

    RowLayout {
        id: mainLayout
        anchors.fill: parent

        ButtonGroup {
            id: drawerButtons
            buttons: menuLayout.children
            Component.onCompleted: removeButton(closeButton)
        }

        ColumnLayout {
            id: menuLayout
            property bool expanded: true
            spacing: 0

            DrawerButton {
                text: qsTr("Home")
                icon: "../images/home_white.png"
                expanded: menuLayout.expanded
                qmlFile: "HomePage.qml"
                checked: true
            }

            DrawerButton {
                text: qsTr("Box")
                expanded: menuLayout.expanded
                qmlFile: "BoxPage.qml"
            }

            DrawerButton {
                text: qsTr("Cows")
                qmlFile: "CowsPage.qml"
                expanded: menuLayout.expanded
            }

            DrawerButton {
                text: qsTr("Silos")
                expanded: menuLayout.expanded
                qmlFile: "SilosPage.qml"
            }

            Item { Layout.fillHeight: true }

            DrawerButton {
                text: qsTr("Settings")
                qmlFile: "Settings.qml"
                icon: "../images/settings_white.png"
                expanded: menuLayout.expanded
            }

            DrawerButton {
                text: qsTr("Ident.")
                qmlFile: "IdentificationPage.qml"
                expanded: menuLayout.expanded
            }

            DrawerButton {
                text: qsTr("Logs")
                qmlFile: "LogsPage.qml"
                icon: "../images/logs_white.png"
                expanded: menuLayout.expanded
            }

            DrawerButton {
                id: closeButton
                checkable: false
                text: qsTr("Close")
                icon: expanded ? "../images/left_arrow_white.png" : "../images/right_arrow.png"
                expanded: menuLayout.expanded
                onClicked: menuLayout.expanded = !menuLayout.expanded
            }
        }

        Loader {
            id: contentLoader
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 1
            source: drawerButtons.checkedButton.qmlFile
        }
    }

}
