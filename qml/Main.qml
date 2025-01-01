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

    NotesBackend {
        id: notesBackend
        onTitleOrDescriptionChanged: (title, description) => {
                                         notesList.model.get(notesList.currentIndex).title = title
                                         notesList.model.get(notesList.currentIndex).description = description
                                     }
    }

    RowLayout {
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
                                markDownInput.clear()
                                notesBackend.setCurrentIndex(0)
                                notesBackend.setNoteTitle("")
                                notesBackend.setTitleLength(0)
                                notesBackend.cursorPosition = 0
                                notesBackend.html = ""

                                notesList.model.addNewItem({
                                                               "title": "",
                                                               "description": "",
                                                               "time": "14:45"
                                                           },
                                                           notesList.count)

                                notesList.currentIndex = 0

                                let element = notesList.model.get(0);
                                editorBackgroundColor = element.itemColor

                            }
                            onPressedChanged: {

                                // console.log("MouseArea pressed changed to", plusMouseArea.pressed)

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
                        onListItemSelected: {

                            console.log("cu i E: " +  currentIndex)

                            markDownInput.clear()

                            let element = notesList.model.get(currentIndex);
                            editorBackgroundColor = element.itemColor

                            console.log("title E: " +  element.title)

                            notesBackend.setCurrentIndex(currentIndex)

                            notesBackend.setNoteTitle(element.title)
                            notesBackend.setTitleLength(element.title.length)
                            notesBackend.cursorPosition = element.title.length + element.description.length + 1
                            notesBackend.html =  element.title + "\u2029" + element.description

                            console.log("E")
                        }
                        Component.onCompleted: {
                            let element = notesList.model.get(0);
                            editorBackgroundColor = element.itemColor

                            console.log("title D: " +  element.title)

                            notesBackend.setCurrentIndex(0)

                            notesBackend.setNoteTitle(element.title)
                            notesBackend.setTitleLength(element.title.length)
                            notesBackend.cursorPosition = element.title.length + element.description.length + 1
                            notesBackend.html =  element.title + "\u2029" + element.description
                            console.log("D")
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
                }
                Keys.onPressed: event => {

                                    if (event.key === Qt.Key_Backspace) {

                                    }
                                    else if(event.key === Qt.Key_Space){
                                        notesBackend.spacePressed = true
                                    }
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
