import QtQuick
import "model"

ListView {

    id: list
    spacing: 10
    anchors.fill: parent
    clip: true

    Component.onCompleted: {
        console.log("width: " + list.width)
        console.log("Height: " + list.height)
    }

    model: ListNoteModel{}

    delegate: NoteItem {}
}
