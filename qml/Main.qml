import QtQuick
import QtQuick.Controls.Universal
import QtQuick.Layouts
import Notes

Window {
    width: 880
    height: 620
    visible: true
    title: qsTr("Hello World")

    property int appMargin: 10
    property bool inputByKeyboard: false
    property bool inputDelete: false

    NotesBackend {
        id: notesBackend
    }

    RowLayout{
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.preferredWidth: parent.width * 0.35;
            //Layout.preferredHeight: parent.height
            color: "white"
            Layout.fillHeight: true

            RowLayout {
                id: rowBar
                width: parent.width
                anchors.top: parent.top
                anchors.margins: appMargin

                Item {
                    Layout.preferredWidth: 0.25
                    Layout.fillWidth: true
                }

                NotesTabBar {
                    id: bar
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 0.5
                    Layout.fillWidth: true
                }

                Item {
                    Layout.preferredWidth: 0.1
                    Layout.fillWidth: true
                }

                Rectangle {
                    color: "transparent"
                    Layout.preferredWidth: 0.15
                    Layout.fillWidth: true
                    height: plusIcon.height

                    Image {
                        id: plusIcon
                        width: 25
                        height: 25
                        source: "qrc:/images/icons8-plus-50.png"
                        fillMode: Image.PreserveAspectFit
                        anchors {
                            verticalCenter: parent.verticalCenter
                            right: parent.right
                            rightMargin: appMargin
                        }
                        
                        MouseArea {
                            id: plusMouseArea
                            anchors.fill: parent;
                            onClicked: {
                                notesList.model.addNewItem({
                                                               "name": "coconut",
                                                               "cost": 23.89
                                                           },
                                                           notesList.model.count)
                            }
                            onPressedChanged: {

                                console.log("MouseArea pressed changed to", plusMouseArea.pressed)

                                if(plusMouseArea.pressed) {
                                    plusIcon.source = "qrc:/images/icons8-plus-math-50.png"
                                } else {
                                    plusIcon.source = "qrc:/images/icons8-plus-50.png"
                                }
                            }
                        }
                    }
                }
            }

            StackLayout {
                width: parent.width
                currentIndex: bar.currentIndex
                anchors {
                    top: rowBar.bottom
                    bottom: searchBox.top
                    right: parent.right
                    left: parent.left
                    margins: appMargin
                }

                Item {
                    id: homeTab
                    NotesList {
                        id: notesList
                    }
                }

                Item {
                    id: discoverTab
                    Text {
                        text: qsTr("Archive")
                    }
                }
            }

            TextField {
                id: searchBox
                font.pointSize: 14
                leftPadding: 30
                implicitHeight: 30
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                    leftMargin: 55
                    rightMargin: 55
                    bottomMargin: 20
                }
                background: Rectangle {
                    radius: 3
                    border.color: "#707070"
                    border.width: 1

                    Image {
                        width: 16
                        height: 16
                        source: "qrc:/images/icons8-search-50.png"
                        anchors.left: parent.left
                        anchors.leftMargin: 8
                        anchors.verticalCenter: parent.verticalCenter

                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            TextArea {
                id: markDownInput
                text: notesBackend.html
                //text: "<h1>Title</h1><p>paragraph</p>"
                Layout.fillHeight: true
                Layout.preferredWidth: 0.5
                Layout.fillWidth: true
                textFormat: TextEdit.RichText
                wrapMode: TextEdit.WordWrap
                cursorPosition: notesBackend.cursorPosition

                // Binding {
                //     target: notesBackend
                //     property: "html"
                //     value: markDownInput.getText(0, markDownInput.length)
                //     when: markDownInput.getText(0, markDownInput.length) !== notesBackend.html
                // }

                // Binding {
                //     target: notesBackend
                //     property: "cursorPosition"
                //     value: markDownInput.cursorPosition
                // }

                onCursorPositionChanged: {

                    // if(cursorPosition < length) {
                    //     console.log("less")
                    //     notesBackend.len = cursorPosition
                    // } else {
                    //     notesBackend.len = length
                    // }
                    console.log("positionChanged")

                    notesBackend.cursorPosition = cursorPosition

                    // console.log("Cursor pos: " + cursorPosition)
                }

                onTextChanged: {
                    //notesBackend.sendNoteDescription(getText(0, length))

                    // console.log("textChanged")

                    // if(!inputByKeyboard) {
                    //     inputByKeyboard = false
                    //     return
                    // }


                    // console.log("cursor: " + cursorPos)

                    //console.log("console html: " + text)

                    // console.log("console: " + getText(0, length))

                    notesBackend.html = getText(0, length)


                    //notesBackend.html = text
                }

                focus: true
                Keys.onPressed: event => {

                    console.log("onPressed")

                    inputByKeyboard = true

                    if (event.key === Qt.Key_Backspace) {
                        // // Custom word deletion to the left
                        // // (You'd need to implement the actual logic here)
                        // console.log("Custom Ctrl+Backspace");

                        // //notesBackend.html = getText(0, length - 1)

                        // notesBackend.html = getText(0, cursorPosition - 1) + getText(cursorPosition, length)


                        // event.accepted = true; // Prevent default behavior
                    } else if(event.key === Qt.Key_Return) {
                        notesBackend.hasDescription = true
                    }
                }

                // Keys.onReturnPressed: {
                //     console.log("enter pressed")

                //     notesBackend.hasDescription = true

                // }


                // Keys.onPressed: event => {

                //                     inputByKeyboard = true

                //                     console.log("txt: " + event.text + " key: " + event.key)


                //                     if (event.key === Qt.Key_Backspace) {
                //                         // Handle tab key press
                //                         console.log("delete")

                //                         pressedBackSpaceKey = true
                //                         //return
                //                     }
                //                     else if (event.key === Qt.Key_Return)  {

                //                         console.log("KEY BACK")

                //                         //return

                //                     } else if(event.key === Qt.Key_Space) {

                //                         console.log("SPACE KEY")

                //                         pressedSpaceKey = true

                //                         //return
                //                     }

                //                     console.log("input: " + event.text)
                //                 }

                property int titleLength: 0
                property string title: ""
                property bool pressedSpaceKey: false
                property bool pressedBackSpaceKey: false
                property string c: ""
                property int cursorPos: 0;

            }

            TextEdit{
                text: markDownInput.text
                Layout.fillHeight: true
                Layout.preferredWidth: 0.5
                Layout.fillWidth: true
                textFormat: TextEdit.AutoText
                wrapMode: TextEdit.Wrap

            }
        }

    }
}
