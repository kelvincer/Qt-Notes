import QtQuick
import QtQuick.Controls.Universal
import QtQuick.Layouts
import Notes
import "../js/Constants.js" as Constants
import "../js/TextBlock.js" as Block
import "../js/MdArray.js" as MdArray

Window {
    id: mainWindow
    width: 880
    height: 620
    visible: true
    title: qsTr("Hello World")

    property int appMargin: 10
    property var currentEditorText: []

    signal sendEditorColor(var editorColor)
    signal sendLoadedText(var array)
    signal sendCursorPosition(int cursorPosition)
    signal sendNoteIndex(int index)

    NotesBackend {
        id: notesBackend
        onAddNewNoteChanged: (title, description) => {
            console.log("ADD NEW NOTE")
            console.log("new log title", title)
            console.log("new log description", description)
            notesList.model.addNewItem({
                                    "title": title,
                                    "description": description,
                                    "time": "14:45"
                                }, notesList.count);
        }
        onUpdateNoteChanged: (title, description) => {
            console.log("UPDATE NOTE")
            console.log("new log title", title)
            console.log("new log description", description)
            
            notesList.model.get(notesList.currentIndex).title = title
            notesList.model.get(notesList.currentIndex).description = description
        }
        onUpdateTextArrayOnEditor: (arrayData) => {
            let array = []
            for (const element of arrayData) {
                array.push({
                    markdown: element,
                    isTitle: Block.isTitle(element),
                    isTitleFirstChar: Block.isFirstCharOfTitle(element)
                });
            }
            sendLoadedText(array)
        }
        onEditorCursorPositionChanged: {}
        format: Format {
            id: formatter
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredWidth: 0.35
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
                            anchors.fill: parent
                            onClicked: {
                                console.log("ON CLICKED")
                                notesBackend.sendNoteInfo([], 0, false, 0);
                                let element = notesList.model.get(0);
                                sendEditorColor(element.itemColor);
                                sendCursorPosition(0)
                                sendNoteIndex(0)
                                notesList.currentIndex = 0
                            }
                            onPressedChanged: {
                                if (plusMouseArea.pressed) {
                                    plusIcon.source = "qrc:/images/icons8-plus-math-50.png";
                                } else {
                                    plusIcon.source = "qrc:/images/icons8-plus-50.png";
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
                            console.log("ON ITEM SELECTED")
                            console.log("index", currentIndex);
                            notesBackend.sendListIndex(currentIndex, true);
                            let element = notesList.model.get(currentIndex);
                            sendEditorColor(element.itemColor);
                            sendNoteIndex(currentIndex)
                            sendCursorPosition(notesBackend.cursorPosition)
                        }

                        Component.onCompleted: {
                            console.log("ON COMPLETED")
                            sendEditorColor(Constants.welcomeEditorColor)
                            notesBackend.setCurrentIndex(0);

                            currentEditorText.push({
                                markdown: Constants.welcomeTitle,
                                isTitle: true,
                                isTitleFirstChar: false
                            });

                            const blocks = Block.getBlocksFromText(Constants.welcomeDescription);
                            for (const element of blocks) {
                                console.log(element);
                                currentEditorText.push({
                                    markdown: "\n" + element,
                                    isTitle: Block.isTitle(element),
                                    isTitleFirstChar: false
                                });
                            }

                            //sendLoadedText(currentEditorText);

                            const result = currentEditorText.map(e => e.markdown);
                            const maxCursorPosValue = MdArray.getTotalLength(currentEditorText);
                            notesBackend.sendNoteInfo(result, maxCursorPosValue, false, 0);
                            sendCursorPosition(notesBackend.cursorPosition);
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

        MarkdownTextArea {
            id: markDownInput
            Layout.fillHeight: true
            Layout.preferredWidth: 0.6
            Layout.fillWidth: true
            backend: notesBackend
        }

        Column {
            Layout.topMargin: 15
            Layout.fillHeight: true
            Layout.preferredWidth: 0.05
            Layout.fillWidth: true
            spacing: 15

            Text {
                text: "H1"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: "H2"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: "H3"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Button {
                text: "I"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    console.log("I");

                    console.log("start", markDownInput.selectionStart);
                    console.log("end", markDownInput.selectionEnd);
                    const displacement = MdArray.getStartAndEndOnMarkownForItalic(markDownInput.textArray, markDownInput.selectionStart, markDownInput.selectionEnd)

                    markDownInput.textArray[displacement.index].markdown = markDownInput.textArray[displacement.index].markdown.substring(0, displacement.start) + 
                        "*" + markDownInput.selectedText 
                        + "*" + markDownInput.textArray[displacement.index].markdown.substring(displacement.end, markDownInput.textArray[displacement.index].markdown.length);

                    const result = markDownInput.textArray.map((e) => e.markdown);
                    notesBackend.sendNoteInfo(result, markDownInput.cursorPos, true, markDownInput.noteIndex)

                    return
                    console.log("cursorPos", markDownInput.cursorPos);

                    const lengthBeforeCursor = MdArray.getLengthBeforeCursorBlockIndex(markDownInput.textArray, markDownInput.indexOnTextArray)   

                    console.log("lengthBeforeCursor", lengthBeforeCursor);
                    console.log("start", markDownInput.selectionStart);
                    console.log("end", markDownInput.selectionEnd);
                    console.log("cursorOnIndexArray", markDownInput.indexOnTextArray);


                    console.log("1", markDownInput.textArray[markDownInput.indexOnTextArray].markdown.substring(0, markDownInput.selectionStart - lengthBeforeCursor))
                    console.log("2", markDownInput.textArray[markDownInput.indexOnTextArray].markdown.substring(markDownInput.selectionEnd - lengthBeforeCursor, markDownInput.textArray[markDownInput.indexOnTextArray].markdown.length))

                    markDownInput.textArray[markDownInput.indexOnTextArray].markdown = markDownInput.textArray[markDownInput.indexOnTextArray].markdown.substring(0, markDownInput.selectionStart - lengthBeforeCursor) + 
                        "*" + markDownInput.selectedText 
                        + "*" + markDownInput.textArray[markDownInput.indexOnTextArray].markdown.substring(markDownInput.selectionEnd - lengthBeforeCursor, markDownInput.textArray[markDownInput.indexOnTextArray].markdown.length);

                    //const result = markDownInput.textArray.map((e) => e.markdown);
                    notesBackend.sendNoteInfo(result, markDownInput.cursorPos, true, markDownInput.noteIndex)

                    if (markDownInput.userSelected !== "") {
                        notesBackend.setBoldFormat(markDownInput.getText(0, markDownInput.length), markDownInput.selectionStart, markDownInput.selectionEnd);
                    }
                }
            }
        }
    }
}
