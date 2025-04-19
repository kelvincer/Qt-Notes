import QtQuick 2.12

ListModel {

    id: notesModel

    property variant colors: ["papayawhip", "mistyrose", "springgreen", "wheat", "peru", "aliceblue"]

    // ListElement {
    //     itemColor: "papayawhip"
    //     title: "#\u00A0Hi"
    //     description: "You\n#\u00A0Another title"
    //     time: "12:56"
    // }

    function addNewItem(item, i) {
        console.log("color: " + colors[i % colors.length]);
        notesModel.insert(0, {"itemColor": colors[i % colors.length], "title": item.title, "description": item.description, "time": item.time})
    }
}
