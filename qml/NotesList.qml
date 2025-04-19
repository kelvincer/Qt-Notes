import QtQuick
import "model"

ListView {

    id: list
    spacing: 10
    anchors.fill: parent
    clip: true
    currentIndex: 0

    signal listItemSelected()

    model: ListNoteModel{}

    delegate: Item {
        width: parent.width
        height: 150

        NoteItem {
            id: noteItem
            anchors.fill: parent
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                list.currentIndex = index
                listItemSelected()
            }
        }
    }
}
