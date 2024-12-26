import QtQuick 2.12

ListModel {

    id: notesModel

    property variant colors: ["papayawhip", "mistyrose", "springgreen", "wheat", "peru", "aliceblue"]

    ListElement {
        itemColor: "papayawhip"
        title: "Hi! I'm a sticky note. ❤️"
        description: "You can do all sorts of things with me. For example...\nCreate titles with # at the beginning of each paragraph."
        time: "9:53"
    }

    function addNewItem(item, i) {

        console.log("color: " + colors[i % colors.length]);

        notesModel.insert(0, {"itemColor": colors[i % colors.length], "title": "Hi! I'm a sticky note. ❤️", "description": "You can do all sorts of things with me. For example...\nCreate titles with # at the beginning of each paragraph.", "time": "item.time"})
    }
}
