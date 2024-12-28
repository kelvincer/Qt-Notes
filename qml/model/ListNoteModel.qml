import QtQuick 2.12

ListModel {

    id: notesModel

    property variant colors: ["papayawhip", "mistyrose", "springgreen", "wheat", "peru", "aliceblue"]

    ListElement {
        itemColor: "papayawhip"
        title: "Hi"
        description: "You"
        time: "9:53"
    }

    function addNewItem(item, i) {

        console.log("color: " + colors[i % colors.length]);

        notesModel.insert(0, {"itemColor": colors[i % colors.length], "title": "", "description": "", "time": "item.time"})
    }
}
