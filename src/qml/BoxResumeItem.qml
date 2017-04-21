import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.0
import CowInspector 1.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls 1.4 as Controls1

Rectangle {
	id: root
	property alias number: boxModel.number
	property bool boxConnected: (Date.now() - boxModel.lastConnected.getTime()) < 300000

	BoxModel {
        id: boxModel
        
    }
	
	
}