import QtQuick

ListView {

    id: list

    Component.onCompleted: {
        console.log("width: " + list.width)
        console.log("Height: " + list.height)
    }

    anchors.fill: parent

    model: ListNoteModel{}

    delegate: NoteItem {}
}
