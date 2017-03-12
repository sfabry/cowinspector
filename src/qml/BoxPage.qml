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

    RowLayout {
        anchors.fill: parent
        anchors.margins: 15

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
