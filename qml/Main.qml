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

        Item {
            Layout.topMargin: 0
            Layout.fillHeight: true
            Layout.preferredWidth: 0.05
            Layout.fillWidth: true

            Button {
                id: h1Button
                text: "H1"
                height: 40
                width: 50
                x: (parent.width - width) / 2
                y: 0
                font.family: "Courier New"
                font.pointSize: 20
                background: Rectangle {
                    color: "transparent"
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true // Enable hover detection
                    onEntered: {
                        //console.log("Mouse entered the area")
                        h1Button.font.pointSize = 23
                        h1Button.font.bold = true
                    }
                    onExited: {
                        //console.log("Mouse exited the area")
                        h1Button.font.pointSize = 20
                        h1Button.font.bold = false
                    }
                    onClicked: {
                        console.log("H1")
                        //console.log("starts", markDownInput.selectionStart)
                        //console.log("ends", markDownInput.selectionEnd)
                        const arrayIndexStart = MdArray.getCursorBlockIndex(markDownInput.textArray, markDownInput.selectionStart)
                        const arrayIndexEnd = MdArray.getCursorBlockIndex(markDownInput.textArray, markDownInput.selectionEnd)

                        for(let i = arrayIndexStart; i <= arrayIndexEnd; i++) {
                            markDownInput.textArray[i].markdown = Block.getNewH1Title(i, markDownInput.textArray[i].markdown)
                        }

                        const result = markDownInput.textArray.map((e) => e.markdown);
                        notesBackend.sendNoteInfo(result, markDownInput.cursorPos, true, markDownInput.noteIndex)
                    }
                }
            }

            Button {
                id: h2Button
                text: "H2"
                width: 50
                height: 40
                x: (parent.width - width) / 2
                y: h1Button.y + h1Button.height + 5
                font.family: "Courier New"
                font.pointSize: 20
                background: Rectangle {
                    color: "transparent"
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true // Enable hover detection
                    onEntered: {
                        //console.log("Mouse entered the area")
                        h2Button.font.pointSize = 23
                        h2Button.font.bold = true
                    }
                    onExited: {
                        //console.log("Mouse exited the area")
                        h2Button.font.pointSize = 20
                        h2Button.font.bold = false
                    }
                    onClicked: {
                        console.log("H1")
                        //console.log("starts", markDownInput.selectionStart)
                        //console.log("ends", markDownInput.selectionEnd)
                        const arrayIndexStart = MdArray.getCursorBlockIndex(markDownInput.textArray, markDownInput.selectionStart)
                        const arrayIndexEnd = MdArray.getCursorBlockIndex(markDownInput.textArray, markDownInput.selectionEnd)

                        for(let i = arrayIndexStart; i <= arrayIndexEnd; i++) {
                            markDownInput.textArray[i].markdown = Block.getNewH2Title(i, markDownInput.textArray[i].markdown)
                        }

                        const result = markDownInput.textArray.map((e) => e.markdown);
                        notesBackend.sendNoteInfo(result, markDownInput.cursorPos, true, markDownInput.noteIndex)
                    }
                }
            }

            Button {
                id: h3Button
                text: "H3"
                width: 50
                height: 40
                x: (parent.width - width) / 2
                y: h2Button.y + h2Button.height + 5
                font.family: "Courier New"
                font.pointSize: 20
                background: Rectangle {
                    color: "transparent"
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true // Enable hover detection
                    onEntered: {
                        //console.log("Mouse entered the area")
                        h3Button.font.pointSize = 23
                        h3Button.font.bold = true
                    }
                    onExited: {
                        //console.log("Mouse exited the area")
                        h3Button.font.pointSize = 20
                        h3Button.font.bold = false
                    }
                    onClicked: {
                        console.log("H1")
                        //console.log("starts", markDownInput.selectionStart)
                        //console.log("ends", markDownInput.selectionEnd)
                        const arrayIndexStart = MdArray.getCursorBlockIndex(markDownInput.textArray, markDownInput.selectionStart)
                        const arrayIndexEnd = MdArray.getCursorBlockIndex(markDownInput.textArray, markDownInput.selectionEnd)

                        for(let i = arrayIndexStart; i <= arrayIndexEnd; i++) {
                            markDownInput.textArray[i].markdown = Block.getNewH3Title(i, markDownInput.textArray[i].markdown)
                        }

                        const result = markDownInput.textArray.map((e) => e.markdown);
                        notesBackend.sendNoteInfo(result, markDownInput.cursorPos, true, markDownInput.noteIndex)
                    }
                }
            }

            Button {
                id: paragraphButton
                text: "P"
                width: 50
                height: 40
                x: (parent.width - width) / 2
                y: h3Button.y + h3Button.height + 5
                font.family: "Courier New"
                font.pointSize: 20
                background: Rectangle {
                    color: "transparent"
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true // Enable hover detection
                    onEntered: {
                        //console.log("Mouse entered the area")
                        paragraphButton.font.pointSize = 23
                        paragraphButton.font.bold = true
                    }
                    onExited: {
                        //console.log("Mouse exited the area")
                        paragraphButton.font.pointSize = 20
                        paragraphButton.font.bold = false
                    }
                    onClicked: {
                        console.log("P")
                        const arrayIndexStart = MdArray.getCursorBlockIndex(markDownInput.textArray, markDownInput.selectionStart)
                        const arrayIndexEnd = MdArray.getCursorBlockIndex(markDownInput.textArray, markDownInput.selectionEnd)

                        for(let i = arrayIndexStart; i <= arrayIndexEnd; i++) {
                            markDownInput.textArray[i].markdown = Block.getNewParagraph(i, markDownInput.textArray[i].markdown)
                        }

                        const result = markDownInput.textArray.map((e) => e.markdown);
                        notesBackend.sendNoteInfo(result, markDownInput.cursorPos, true, markDownInput.noteIndex)

                    }
                }
            }

            Button {
                id: italicButton
                text: "I"
                width: 50
                height: 40
                x: (parent.width - width) / 2
                y: paragraphButton.y + paragraphButton.height + 5
                font.family: "Courier New"
                font.pointSize: 20
                background: Rectangle {
                    color: "transparent"
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true // Enable hover detection
                    onEntered: {
                        //console.log("Mouse entered the area")
                        italicButton.font.pointSize = 23
                        italicButton.font.bold = true
                    }
                    onExited: {
                        //console.log("Mouse exited the area")
                        italicButton.font.pointSize = 20
                        italicButton.font.bold = false
                    }
                    onClicked: {
                        console.log("I")

                        if (markDownInput.selectionStart === markDownInput.selectionEnd)
                            return

                        const arrayIndexStart = MdArray.getCursorBlockIndex(markDownInput.textArray, markDownInput.selectionStart)
                        const arrayIndexEnd = MdArray.getCursorBlockIndex(markDownInput.textArray, markDownInput.selectionEnd)

                        if(arrayIndexStart === arrayIndexEnd) {

                            const startDisplacement = MdArray.getCursorDisplacementInsideMarkdownBlock(markDownInput.textArray, markDownInput.indexOnTextArray, markDownInput.selectionStart, markDownInput.italics[markDownInput.indexOnTextArray])
                            const endDisplacement = MdArray.getCursorDisplacementInsideMarkdownBlock(markDownInput.textArray, markDownInput.indexOnTextArray, markDownInput.selectionEnd, markDownInput.italics[markDownInput.indexOnTextArray])

                            if (MdArray.isItalicSelected(markDownInput.textArray[markDownInput.indexOnTextArray].markdown, markDownInput.italics[markDownInput.indexOnTextArray], startDisplacement, endDisplacement)) {

                                const newMarkdownAndItalic = MdArray.removeItalic(markDownInput.textArray[markDownInput.indexOnTextArray].markdown, markDownInput.italics[markDownInput.indexOnTextArray], startDisplacement, endDisplacement)
                                markDownInput.textArray[markDownInput.indexOnTextArray].markdown = newMarkdownAndItalic.markdown

                            } else {

                                //markDownInput.italics[markDownInput.indexOnTextArray] = Block.updateItalics("*", markDownInput.italics[markDownInput.indexOnTextArray], startDisplacement)
                                //markDownInput.italics[markDownInput.indexOnTextArray] = Block.updateItalics("*", markDownInput.italics[markDownInput.indexOnTextArray], endDisplacement)

                                markDownInput.textArray[markDownInput.indexOnTextArray].markdown = markDownInput.textArray[markDownInput.indexOnTextArray].markdown.substring(0, startDisplacement)
                                    + "*" + markDownInput.textArray[markDownInput.indexOnTextArray].markdown.substring(startDisplacement, endDisplacement) +
                                    "*" + markDownInput.textArray[markDownInput.indexOnTextArray].markdown.substring(endDisplacement)
                            }
                            markDownInput.italics[markDownInput.indexOnTextArray] = Block.findItalicIndices(markDownInput.textArray[markDownInput.indexOnTextArray].markdown)

                        } else if(arrayIndexStart + 1 === arrayIndexEnd) {

                            const startDisplacement = MdArray.getCursorDisplacementInsideMarkdownBlock(markDownInput.textArray, arrayIndexStart, markDownInput.selectionStart, markDownInput.italics[arrayIndexStart])
                            const endDisplacement = MdArray.getCursorDisplacementInsideMarkdownBlock(markDownInput.textArray, arrayIndexEnd, markDownInput.selectionEnd, markDownInput.italics[arrayIndexEnd])

                            const blockLength = markDownInput.textArray[arrayIndexStart].markdown.length
                            markDownInput.textArray[arrayIndexStart].markdown = markDownInput.textArray[arrayIndexStart].markdown.substring(0, startDisplacement)
                                + "*" + markDownInput.textArray[arrayIndexStart].markdown.substring(startDisplacement, blockLength)
                                + "*"
                            markDownInput.italics[arrayIndexStart] = Block.findItalicIndices(markDownInput.textArray[arrayIndexStart].markdown)

                            const cursorStartPositionOnSecondBlock = MdArray.getLengthBeforeCursorBlockIndex(markDownInput.textArray, arrayIndexEnd) + 1
                            const startDisplacementOnSecondBlock = MdArray.getCursorDisplacementInsideMarkdownBlock(markDownInput.textArray, arrayIndexEnd, cursorStartPositionOnSecondBlock, markDownInput.italics[arrayIndexEnd])

                            markDownInput.textArray[arrayIndexEnd].markdown = markDownInput.textArray[arrayIndexEnd].markdown.substring(0, startDisplacementOnSecondBlock) + "*" + markDownInput.textArray[arrayIndexEnd].markdown.substring(startDisplacementOnSecondBlock, endDisplacement)
                                + "*" + markDownInput.textArray[arrayIndexEnd].markdown.substring(endDisplacement)
                            markDownInput.italics[arrayIndexEnd] = Block.findItalicIndices(markDownInput.textArray[arrayIndexEnd].markdown)

                        } else {

                            const startDisplacement = MdArray.getCursorDisplacementInsideMarkdownBlock(markDownInput.textArray, arrayIndexStart, markDownInput.selectionStart, markDownInput.italics[arrayIndexStart])
                            const endDisplacement = MdArray.getCursorDisplacementInsideMarkdownBlock(markDownInput.textArray, arrayIndexEnd, markDownInput.selectionEnd, markDownInput.italics[arrayIndexEnd])

                            const blockLength = markDownInput.textArray[arrayIndexStart].markdown.length
                            markDownInput.textArray[arrayIndexStart].markdown = markDownInput.textArray[arrayIndexStart].markdown.substring(0, startDisplacement)
                                + "*" + markDownInput.textArray[arrayIndexStart].markdown.substring(startDisplacement, blockLength)
                                + "*"
                            markDownInput.italics[arrayIndexStart] = Block.findItalicIndices(markDownInput.textArray[arrayIndexStart].markdown)

                            for (let i = arrayIndexStart + 1; i < arrayIndexEnd; i++) {
                                const cursorStartPositionOnSecondBlock = MdArray.getLengthBeforeCursorBlockIndex(markDownInput.textArray, i) + 1
                                const startDisplacementOnSecondBlock = MdArray.getCursorDisplacementInsideMarkdownBlock(markDownInput.textArray, i, cursorStartPositionOnSecondBlock, markDownInput.italics[i])
                                markDownInput.textArray[i].markdown = markDownInput.textArray[i].markdown.substring(0, startDisplacementOnSecondBlock) + "*" + markDownInput.textArray[i].markdown.substring(startDisplacementOnSecondBlock) + "*"
                                markDownInput.italics[i] = Block.findItalicIndices(markDownInput.textArray[i].markdown)
                            }

                            const cursorStartPositionOnSecondBlock = MdArray.getLengthBeforeCursorBlockIndex(markDownInput.textArray, arrayIndexEnd) + 1
                            const startDisplacementOnSecondBlock = MdArray.getCursorDisplacementInsideMarkdownBlock(markDownInput.textArray, arrayIndexEnd, cursorStartPositionOnSecondBlock, markDownInput.italics[arrayIndexEnd])

                            markDownInput.textArray[arrayIndexEnd].markdown = markDownInput.textArray[arrayIndexEnd].markdown.substring(0, startDisplacementOnSecondBlock) + "*" + markDownInput.textArray[arrayIndexEnd].markdown.substring(startDisplacementOnSecondBlock, endDisplacement)
                                + "*" + markDownInput.textArray[arrayIndexEnd].markdown.substring(endDisplacement)
                            markDownInput.italics[arrayIndexEnd] = Block.findItalicIndices(markDownInput.textArray[arrayIndexEnd].markdown)
                        }

                        const result = markDownInput.textArray.map((e) => e.markdown);
                        notesBackend.sendNoteInfo(result, markDownInput.cursorPos, true, markDownInput.noteIndex)

                        if(markDownInput.italics[markDownInput.indexOnTextArray] !== undefined) {
                            for(const i of markDownInput.italics[markDownInput.indexOnTextArray]) {
                                console.log("final italic", i.start, i.end)
                            }
                        }
                    }
                }
            }
        }
    }
}

