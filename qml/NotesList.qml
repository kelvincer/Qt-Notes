import QtQuick
import "model"

ListView {

    id: list
    spacing: 10
    anchors.fill: parent
    clip: true

    signal colorUpdated(string color)

    property string itemCircleColor: ""

    Component.onCompleted: {
        console.log("width: " + list.width)
        console.log("Height: " + list.height)
    }

    model: ListNoteModel{}

    delegate: Item {
        width: parent.width
        height: 130

        NoteItem {
            id: noteItem
            anchors.fill: parent
            onEditorColorUpdated: color => {
                                      console.log("Editor color updated " + color)
                                      colorUpdated(color)
                                  }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("mouse area")
                list.currentIndex = index
            }
        }
    }
}
