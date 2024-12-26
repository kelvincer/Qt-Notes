import QtQuick
import "model"

ListView {

    id: list
    spacing: 10
    anchors.fill: parent
    clip: true

    signal editorUpdated()

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
            Component.onCompleted: {
                editorUpdated()
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("mouse area")
                list.currentIndex = index
                editorUpdated()
            }
        }
    }
}
