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
        onEditorCursorPositionChanged: {

        }
        format: Format {
            id: formatter
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
                            notesBackend.cursorPosition = element.title.length + element.description.length
                            notesBackend.html =  element.title + "\u2029" + element.description
                            notesBackend.cursorPosition = element.title.length + element.description.length + 1
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
                // anchors.fill: parent
                text: notesBackend.html
                Layout.fillHeight: true
                Layout.preferredWidth: 0.9
                Layout.fillWidth: true
                textFormat: TextEdit.RichText
                wrapMode: TextEdit.Wrap
                cursorPosition: notesBackend.cursorPosition
                background: Rectangle {
                    color: editorBackgroundColor
                }
                onCursorPositionChanged: {
                    // console.log("change cp: " + cursorPosition)
                    notesBackend.cursorPosition = cursorPosition
                }
                onTextChanged: {
                    notesBackend.html = getText(0, length)
                }
                Keys.onPressed: event => {

                                    event.accepted = false

                                    if (event.key === Qt.Key_Backspace) {

                                    }
                                    else if(event.key === Qt.Key_Space){
                                        notesBackend.spacePressed = true
                                    }
                                }
                selectByMouse: true
                // focus: true

                property string userSelected: ""

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    // propagateComposedEvents: false

                    property bool selecting: false // Track whether selection is active
                    property int startPos: -1     // Store the start position of the selection


                    onClicked: mouse => {
                                   notesBackend.cursorPosition = markDownInput.positionAt(mouse.x, mouse.y)
                               }
                    onDoubleClicked: mouse => {
                                         const position = markDownInput.cursorPosition
                                         selectWordAtPos(position)
                                     }

                    function selectWordAtPos(position) {

                        const textContent = markDownInput.getText(0, markDownInput.length); // Full text in the TextArea
                        let start = position;
                        let end = position;

                        // Find the start of the word
                        while (start > 0 && !isDelimiter(textContent[start - 1])) {
                            start--;
                        }

                        // Find the end of the word
                        while (end < textContent.length && !isDelimiter(textContent[end])) {
                            end++;
                        }

                        // Below line also works
                        // notesBackend.cursorPosition = end

                        markDownInput.moveCursorSelection(end)

                        markDownInput.select(start, end)

                        console.log("Word selected from", start, "to", end, ":", textContent.substring(start, end));
                    }

                    function isDelimiter(character) {
                        return character === ' ' || character === '\n' || character === '\t'
                                || character === '.' || character === ',' || character === ';'
                                || character === '\u2029' || character === '\u00a0'
                    }

                    onPressed: mouse => {
                        // Start selection
                        selecting = true;
                        startPos = markDownInput.positionAt(mouse.x, mouse.y);
                        notesBackend.cursorPosition = startPos; // Move cursor to start position
                    }

                    onPositionChanged: mouse => {
                        if (selecting) {
                            const endPos = markDownInput.positionAt(mouse.x, mouse.y);
                            console.log("endPos:", endPos)

                            if (startPos !== -1) {

                                markDownInput.moveCursorSelection(endPos)
                                markDownInput.select(startPos, endPos); // Select text between start and end
                            }
                        }
                    }

                    onReleased: {
                        // End selection
                        selecting = false;
                        console.log("Selected text:", markDownInput.selectedText);
                        markDownInput.userSelected = markDownInput.selectedText;

                        markDownInput.forceActiveFocus()
                    }
                }
            }
        }

        Column {

            Layout.fillHeight: true
            Layout.preferredWidth: 0.1
            Layout.fillWidth: true

            Text {
                text: "H1"
            }

            Text {
                text: "H2"
            }

            Text {
                text: "H3"
            }

            Button {
                text: "B"
                onClicked: {
                    console.log("B")
                    if(markDownInput.userSelected !== "") {

                        notesBackend.setBoldFormat(markDownInput.getText(0, markDownInput.length),
                                          markDownInput.selectionStart,
                                          markDownInput.selectionEnd)


                    }
                }
            }
        }
    }
}


