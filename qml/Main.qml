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
                    topMargin: 15
                }

                Item {
                    id: homeTab
                    NotesList {
                        id: notesList
                        onEditorUpdated: e => {
                            let element = notesList.model.get(currentIndex);
                            editorBackgroundColor = element.itemColor

                            // notesBackend.noteTitle = element.title
                            // notesBackend.titleLength = element.title.length
                            // notesBackend.hasDescription = true
                            // notesBackend.cursorPosition = element.title.length + element.description.length + 1
                            // notesBackend.html =  element.title + "\u2029" + element.description
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
                        
                    } else if(event.key === Qt.Key_Return) {
                        notesBackend.hasDescription = true
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
