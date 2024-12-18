import QtQuick
import QtQuick.Controls

TabBar {

    property string tabBackgroundColor: "#EFEFEF"

    background: Rectangle {
        color: tabBackgroundColor
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
            color: "black"
        }

        background: Rectangle {
            color: noteTab.checked ?  "white" : tabBackgroundColor
            border.color: noteTab.checked ?  "green" : tabBackgroundColor
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
            color: "black"
        }

        background: Rectangle {
            color: archiveTab.checked ? "white" : tabBackgroundColor
            border.color: archiveTab.checked ? "green" : tabBackgroundColor
            border.width: 2
            radius: 10
        }
    }
}
