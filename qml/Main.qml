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
    property string editorBackgroundColor: ""
    property string noteTitle: ""
    property string noteDescription: ""

    NotesBackend {
        id: notesBackend
        onTitleOrDescriptionChanged: {
            noteTitle = title;
            noteDescription = description;
            console.log("A")
        }
    }

    RowLayout{
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.preferredWidth: parent.width * 0.35;
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
                                notesBackend.setNoteTitle("")
                                notesBackend.setTitleLength(0)
                                notesBackend.cursorPosition = 0
                                notesBackend.html = ""
                                markDownInput.clear()
                                notesList.model.addNewItem({
                                                               "title": "",
                                                               "description": "",
                                                               "timem": "14:45"
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
                    topMargin: 15
                }

                Item {
                    id: homeTab
                    NotesList {
                        id: notesList
                        onEditorUpdated: e => {
                            let element = notesList.model.get(currentIndex);
                            editorBackgroundColor = element.itemColor

                            // if(element.title === "")
                            //     return;

                            notesBackend.setNoteTitle(element.title)
                            notesBackend.setTitleLength(element.title.length)
                            notesBackend.cursorPosition = element.title.length + element.description.length + 1
                            notesBackend.html =  element.title + "\u2029" + element.description
                            console.log("B")
                        }
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
                Layout.fillHeight: true
                Layout.preferredWidth: 0.5
                Layout.fillWidth: true
                textFormat: TextEdit.RichText
                wrapMode: TextEdit.Wrap
                cursorPosition: notesBackend.cursorPosition
                background: Rectangle {
                    color: editorBackgroundColor
                }
                onCursorPositionChanged: {
                    notesBackend.cursorPosition = cursorPosition
                }
                onTextChanged: {
                    notesBackend.html = getText(0, length)
                    updateListItem()
                    console.log("C")
                }
                Keys.onPressed: event => {

                    if (event.key === Qt.Key_Backspace) {
                        
                    }
                    else if(event.key === Qt.Key_Space){ 
                        notesBackend.spacePressed = true
                    }
                }

                function updateListItem() {

                    if(noteTitle === "")
                        return;

                    console.log("console: " + noteTitle)

                    notesList.model.get(notesList.currentIndex).title = noteTitle
                    notesList.model.get(notesList.currentIndex).description = noteDescription
                }
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
