import QtQuick
import QtQuick.Controls

TabBar {
    background: Rectangle {
        color: "lightgray"
        radius: 10
    }

    TabButton {
        id: noteTab
        text: qsTr("Notes")
        implicitHeight: 30

        contentItem: Text {
            text: parent.text
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: parent.checked ? "black" : "white"
            font.bold: true
            font.pointSize: 14
            font.family: "Roboto"
        }

        background: Rectangle {
            color: noteTab.checked ?  "white" : "lightgray"
            border.color: noteTab.checked ?  "green" : "lightgray"
            border.width: 2
            radius: 10
        }
    }

    TabButton {
        id: archiveTab
        text: qsTr("Archive")
        implicitHeight: 30
        contentItem: Text {
            text: parent.text
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: parent.checked ? "black" : "white"
            font.bold: true
            font.pointSize: 14
            font.family: "Roboto"
        }

        background: Rectangle {
            color: archiveTab.checked ? "white" : "lightgray"
            border.color: archiveTab.checked ? "green" : "lightgray"
            border.width: 2
            radius: 10
        }
    }
}
