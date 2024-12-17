import QtQuick

ListModel {

    id: fruitModel
    ListElement { name: "Apple"; cost: 2.45 }
    ListElement { name: "Orange"; cost: 3.25 }
    ListElement { name: "Banana"; cost: 1.95 }
    ListElement { name: "Grape"; cost: 0.95 }


    function getId() {
        return "fruitModel2";
    }

}
