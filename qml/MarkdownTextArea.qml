import QtQuick
import QtQuick.Controls
import "../js/TextBlock.js" as Block
import "../js/MdArray.js" as MdArray
import "../js/Constants.js" as Constants

TextArea {

    property var backend
    readonly property string newline : '\n'
    readonly property string breakLine : "<br/>"
    readonly property string nonBreakingSpace : '\u00A0'
    readonly property string zeroWidthSpace : "\u200B"
    property int cursorPos : 0
    property var textArray : [{markdown: "", isTitle: false}]
    property int maxCursorPosValue: 0
    property int noteIndex
    property bool isPressedArrowKey: false
    property int indexOnTextArray : 0
    property int italicStartPos : -1
    property var italics : []

    id: ta
    text: backend.md
    textFormat: TextArea.MarkdownText
    cursorVisible: true
    cursorPosition: backend.cursorPosition
    wrapMode: TextEdit.Wrap
    Connections {
            target: mainWindow
            function onSendEditorColor(editorColor) {
                ta.background.color = editorColor
            }
            function onSendLoadedText(array) {
                console.log("TEXT ARRAY")
                if(array.length === 0) {
                    ta.textArray = [{markdown: "", isTitle: false}]
                    ta.clear()
                } else {
                    ta.textArray = array
                }

                for (const element of ta.textArray) {
                    console.log(element.markdown);
                }
            }
            function  onSendCursorPosition(position) {
                ta.cursorPos = position
                ta.forceActiveFocus()
            }
            function  onSendNoteIndex(index) {
                ta.noteIndex = index
            }
    }
    onCursorPositionChanged: {
        console.log("onCursorPositionChanged", cursorPosition)
        if(isPressedArrowKey) {
            cursorPos = cursorPosition
            isPressedArrowKey = false
        }
        console.log("cursorPos", cursorPos)
    }
    onTextChanged: {
        
    }
    Keys.onPressed: event => {

                        console.log("===============================")

                        console.log("Key pressed:", event.text, "cursorPos:", cursorPos, "ta cp:", ta.cursorPosition)

                        indexOnTextArray = MdArray.getCursorBlockIndex(textArray, ta.cursorPosition)
                        console.log("current index", indexOnTextArray)
                        console.log("cursor", ta.cursorPosition)

                        if(italics[indexOnTextArray] !== undefined) {
                            for(const i of italics[indexOnTextArray]) {
                                console.log("italic start", i.start, i.end)
                            }
                        }

                        MdArray.printBlocks(textArray)

                        console.log("current index a title?", textArray[indexOnTextArray]?.isTitle ?? false)

                        if(event.key === Qt.Key_Up) {
                            //event.accepted = true
                            console.log("KEY UP")

                            if(indexOnTextArray === 0)
                                return

                            isPressedArrowKey = true
                            return
                        }

                        if(event.key === Qt.Key_Down) {
                            //event.accepted = true
                            console.log("KEY DOWN")

                            if(indexOnTextArray === textArray.length - 1)
                                return

                            isPressedArrowKey = true
                            return
                        }
                        
                        if(event.key === Qt.Key_Left) {

                            console.log("KEY LEFT")
                            isPressedArrowKey = true
                            return

                            //event.accepted = true

                            //cursorPos = backend.cursorPosition === 0 ? 0 : ta.cursorPosition - 1

                        }

                        if(event.key === Qt.Key_Right) {

                            console.log("KEY RIGHT")
                            if(ta.cursorPosition >= maxCursorPosValue)
                                return

                            isPressedArrowKey = true
                            return

                            //event.accepted = true

                            //cursorPos = maxCursorPosValue > ta.cursorPosition ? ta.cursorPosition + 1 : ta.cursorPosition

                        }

                        const markdownDisplacement = MdArray.getCursorDisplacementInsideMarkdownBlock(textArray, indexOnTextArray, ta.cursorPosition, italics[indexOnTextArray])

                        console.log("displacement", markdownDisplacement)

                        if(Block.isACharacter(event.text)) {
                            event.accepted = true
                            console.log("NEW CHARACTER")

                            if(textArray[indexOnTextArray]?.isTitle ?? false) {

                                console.log("1", textArray[indexOnTextArray]?.markdown?.substring(0, markdownDisplacement).split("") ?? "")
                                console.log("2", event.text)
                                console.log("3", textArray[indexOnTextArray]?.markdown?.substring(markdownDisplacement, textArray[indexOnTextArray]?.markdown?.length) ?? "")

                                textArray[indexOnTextArray].markdown = (textArray[indexOnTextArray]?.markdown?.substring(0, markdownDisplacement) ?? "").concat(
                                    event.text).concat(textArray[indexOnTextArray]?.markdown?.substring(markdownDisplacement, textArray[indexOnTextArray]?.markdown?.length) ?? "")

                                if(textArray[indexOnTextArray].isTitleFirstChar) {

                                    if(Block.isTitleWithNewLine(textArray[indexOnTextArray].markdown)) {                                        cursorPos =
                                        cursorPos = MdArray.getLengthBeforeCursorBlockIndex(textArray, indexOnTextArray) + 2

                                    } else {
                                        cursorPos =
                                        MdArray.getLengthBeforeCursorBlockIndex(textArray, indexOnTextArray) + 1
                                    }

                                } else {
                                    cursorPos = ta.cursorPosition + 1
                                }
                            } else {

                                if(Block.isStartingATitleInsideParagraph(textArray[indexOnTextArray]?.markdown) ?? false) {

                                    textArray[indexOnTextArray].markdown = textArray[indexOnTextArray].markdown.substring(0, textArray[indexOnTextArray].markdown.length - 7)

                                    //textArray[indexOnTextArray + 1] = { markdown: Constants.titleStartedWithNewline + event.text , isTitle: true};

                                    textArray.splice(indexOnTextArray + 1, 0, { markdown: Constants.titleStartedWithNewline + event.text , isTitle: true})

                                    cursorPos = ta.cursorPosition - 1

                                }
                                else if(Block.isStartingH2TitleInsideParagraph(textArray[indexOnTextArray]?.markdown) ?? false) {

                                    textArray[indexOnTextArray].markdown = textArray[indexOnTextArray].markdown.substring(0, textArray[indexOnTextArray].markdown.length - 8)

                                    //textArray[indexOnTextArray + 1] = { markdown: Constants.h2TitleStartedWithNewline + event.text , isTitle: true}

                                    textArray.splice(indexOnTextArray + 1, 0, { markdown: Constants.h2TitleStartedWithNewline + event.text , isTitle: true})

                                    cursorPos = ta.cursorPosition - 2
                                }
                                else if(Block.isStartingH3TitleInsideParagraph(textArray[indexOnTextArray]?.markdown) ?? false) {

                                    textArray[indexOnTextArray].markdown = textArray[indexOnTextArray].markdown.substring(0, textArray[indexOnTextArray].markdown.length - 9)

                                    //textArray[indexOnTextArray + 1] = { markdown: Constants.h3TitleStartedWithNewline + event.text , isTitle: true};

                                    textArray.splice(indexOnTextArray + 1, 0, { markdown: Constants.h3TitleStartedWithNewline + event.text , isTitle: true})

                                    cursorPos = ta.cursorPosition - 3
                                }
                                else {

                                    cursorPos = ta.cursorPosition + 1

                                    if(textArray[indexOnTextArray]?.markdown?.includes(breakLine)) {

                                        console.log("1", textArray[indexOnTextArray].markdown.substring(0, markdownDisplacement).split(""))
                                        console.log("2", event.text)
                                        console.log("3", textArray[indexOnTextArray].markdown.substring(markdownDisplacement, textArray[indexOnTextArray].markdown.length).split(""))

                                        textArray[indexOnTextArray].markdown = textArray[indexOnTextArray].markdown.substring(0, markdownDisplacement)
                                        + event.text + textArray[indexOnTextArray].markdown.substring(markdownDisplacement, textArray[indexOnTextArray].markdown.length)

                                    } else {

                                        if(Block.startedTypingFromItalicEnd(textArray[indexOnTextArray].markdown,markdownDisplacement, italics[indexOnTextArray])) {

                                            console.log("1", textArray[indexOnTextArray]?.markdown?.substring(0, markdownDisplacement - 1).split("") ?? "")
                                            console.log("2", event.text)
                                            console.log("3", textArray[indexOnTextArray]?.markdown?.substring(markdownDisplacement).split("") ?? "")

                                            textArray[indexOnTextArray].markdown = (textArray[indexOnTextArray]?.markdown?.substring(0, markdownDisplacement - 1) ?? "").concat(
                                                event.text).concat("*").concat(textArray[indexOnTextArray]?.markdown?.substring(markdownDisplacement) ?? "")

                                            cursorPos = ta.cursorPosition + 1

                                            italics[indexOnTextArray] = Block.updateItalicEndAsterisk(markdownDisplacement, italics[indexOnTextArray])

                                        } else {

                                            console.log("1", textArray[indexOnTextArray]?.markdown?.substring(0, markdownDisplacement).split("") ?? "")
                                            console.log("2", event.text)
                                            console.log("3", textArray[indexOnTextArray]?.markdown?.substring(markdownDisplacement) ?? "")

                                            textArray[indexOnTextArray].markdown = (textArray[indexOnTextArray]?.markdown?.substring(0, markdownDisplacement) ?? "").concat(
                                                event.text).concat(textArray[indexOnTextArray]?.markdown?.substring(markdownDisplacement) ?? "")

                                            cursorPos = ta.cursorPosition + 1
                                        }
                                    }
                                }
                            }

                            italics[indexOnTextArray] = Block.updateItalics(event.text, italics[indexOnTextArray], markdownDisplacement)
                        }

                        if(event.key === Qt.Key_Space) {
                            event.accepted = true
                            console.log("NEW SPACE")

                            if(textArray[indexOnTextArray].isTitle) {

                                if(Block.isH1Title(textArray[indexOnTextArray].markdown)) {

                                    if(textArray[indexOnTextArray].isTitleFirstChar) {
                                        cursorPos = 1
                                    } else {
                                        cursorPos = ta.cursorPosition + 1
                                    }

                                    console.log("1", textArray[indexOnTextArray].markdown.substring(0, markdownDisplacement).split(""))
                                    console.log("2", "space")
                                    console.log("3", textArray[indexOnTextArray].markdown.substring(markdownDisplacement).split(""))

                                    textArray[indexOnTextArray].markdown = textArray[indexOnTextArray].markdown.substring(0, markdownDisplacement)
                                    + nonBreakingSpace + textArray[indexOnTextArray].markdown.substring(markdownDisplacement)
                                } else {

                                    if(textArray[indexOnTextArray].isTitleFirstChar) {
                                        console.log("1", textArray[indexOnTextArray].markdown.substring(0, ta.cursorPosition - 1).split(""))
                                        console.log("2", "space 1")
                                        console.log("3", textArray[indexOnTextArray].markdown.substring(ta.cursorPosition - 1, textArray[indexOnTextArray].markdown.length).split(""))

                                        textArray[indexOnTextArray].markdown = textArray[indexOnTextArray].markdown.substring(0, ta.cursorPosition - 1)
                                        + nonBreakingSpace + textArray[indexOnTextArray].markdown.substring(ta.cursorPosition - 1, textArray[indexOnTextArray].markdown.length)

                                        cursorPos = ta.cursorPosition - 1

                                    } else {

                                        console.log("1", textArray[indexOnTextArray].markdown.substring(0, markdownDisplacement).split(""))
                                        console.log("2", "space 2")
                                        console.log("3", textArray[indexOnTextArray].markdown.substring(markdownDisplacement, textArray[indexOnTextArray].markdown.length).split(""))

                                        textArray[indexOnTextArray].markdown = textArray[indexOnTextArray].markdown.substring(0, markdownDisplacement)
                                        + nonBreakingSpace + textArray[indexOnTextArray].markdown.substring(markdownDisplacement, textArray[indexOnTextArray].markdown.length)

                                        cursorPos = ta.cursorPosition + 1
                                    }
                                }
                            } else {

                                if(Block.startedTypingFromItalicEnd(textArray[indexOnTextArray].markdown,markdownDisplacement, italics[indexOnTextArray])) {

                                    console.log("1", textArray[indexOnTextArray]?.markdown?.substring(0, markdownDisplacement - 1).split("") ?? "")
                                    console.log("2", "space")
                                    console.log("3", textArray[indexOnTextArray]?.markdown?.substring(markdownDisplacement).split("") ?? "")

                                    textArray[indexOnTextArray].markdown = (textArray[indexOnTextArray]?.markdown?.substring(0, markdownDisplacement - 1) ?? "").concat(
                                        nonBreakingSpace).concat("*").concat(textArray[indexOnTextArray]?.markdown?.substring(markdownDisplacement) ?? "")

                                    cursorPos = ta.cursorPosition + 1

                                    italics[indexOnTextArray] = Block.updateItalicEndAsterisk(markdownDisplacement, italics[indexOnTextArray])

                                } else {

                                    console.log("1", textArray[indexOnTextArray]?.markdown?.substring(0, markdownDisplacement).split("") ?? "")
                                    console.log("2", "space")
                                    console.log("3", textArray[indexOnTextArray]?.markdown?.substring(markdownDisplacement, textArray[indexOnTextArray].markdown.length).split("") ?? "")

                                    textArray[indexOnTextArray].markdown = (textArray[indexOnTextArray]?.markdown?.substring(0, markdownDisplacement) ?? "").concat(
                                        nonBreakingSpace).concat(textArray[indexOnTextArray]?.markdown?.substring(markdownDisplacement, textArray[indexOnTextArray]?.markdown?.length) ?? "")

                                    cursorPos = ta.cursorPosition + 1
                                }
                            }

                            italics[indexOnTextArray] = Block.updateItalics(event.text, italics[indexOnTextArray], markdownDisplacement)
                        }

                        if(event.key === Qt.Key_Backspace) {

                            event.accepted = true

                            console.log("NEW BACKSPACE")

                            if(cursorPos === 0) {
                                return
                            }

                            if(textArray[indexOnTextArray]?.isTitle ?? false) {

                                if(Block.isTitleDeleted(textArray[indexOnTextArray].markdown)
                                   || Block.isItalicTitleDeleted(textArray[indexOnTextArray].markdown, markdownDisplacement)) {

                                    textArray[indexOnTextArray].markdown = "\n"

                                    cursorPos = MdArray.getLengthBeforeCursorBlockIndex(textArray, indexOnTextArray) + 1

                                }
                                else if(markdownDisplacement === 3 && Block.isH1TitleWithNewline(textArray[indexOnTextArray].markdown)) {

                                    if(indexOnTextArray > 0) {
                                        textArray[indexOnTextArray - 1].markdown = textArray[indexOnTextArray - 1]?.markdown.concat(
                                        textArray[indexOnTextArray]?.markdown?.substring(markdownDisplacement, textArray[indexOnTextArray]?.markdown?.length) ?? "")
                                    }

                                    textArray[indexOnTextArray].markdown = ""

                                    cursorPos = ta.cursorPosition - 1
                                }
                                else if(markdownDisplacement === 4 && Block.isH2TitleWithNewline(textArray[indexOnTextArray].markdown)) {

                                    if(indexOnTextArray > 0) {
                                        textArray[indexOnTextArray - 1].markdown = textArray[indexOnTextArray - 1]?.markdown.concat(
                                        textArray[indexOnTextArray]?.markdown?.substring(markdownDisplacement, textArray[indexOnTextArray]?.markdown?.length) ?? "")
                                    }

                                    textArray[indexOnTextArray].markdown = ""

                                    cursorPos = ta.cursorPosition - 1
                                }
                                else if(markdownDisplacement === 5 && Block.isH3TitleWithNewline(textArray[indexOnTextArray].markdown)) {

                                    if(indexOnTextArray > 0) {
                                        textArray[indexOnTextArray - 1].markdown = textArray[indexOnTextArray - 1]?.markdown.concat(
                                        textArray[indexOnTextArray]?.markdown?.substring(markdownDisplacement, textArray[indexOnTextArray]?.markdown?.length) ?? "")
                                    }

                                    textArray[indexOnTextArray].markdown = ""

                                    cursorPos = ta.cursorPosition - 1
                                }
                                else {

                                    cursorPos = ta.cursorPosition - 1

                                    MdArray.deleteBlockChar(textArray, indexOnTextArray, ta.cursorPosition, italics, markdownDisplacement)
                                }

                            } else {

                                cursorPos = ta.cursorPosition - 1

                                if(textArray[indexOnTextArray]?.markdown?.includes(breakLine)) {

                                    if(MdArray.isCursorJustAfterParagraphBreakline(textArray, indexOnTextArray, ta.cursorPosition, italics[indexOnTextArray])) {

                                        console.log("1", textArray[indexOnTextArray].markdown.substring(0, markdownDisplacement - breakLine.length))
                                        console.log("2", textArray[indexOnTextArray].markdown.substring(markdownDisplacement, textArray[indexOnTextArray].markdown.length))

                                        textArray[indexOnTextArray].markdown = textArray[indexOnTextArray].markdown.substring(0, markdownDisplacement - breakLine.length)
                                        + textArray[indexOnTextArray].markdown.substring(markdownDisplacement, textArray[indexOnTextArray].markdown.length)

                                    } else {
                                        
                                        if(markdownDisplacement === 1 && textArray[indexOnTextArray].markdown.startsWith(Constants.newline)) {

                                            const firstNewParagraphBreaklineIndex = Block.getFirstParagraphBreaklineIndex(textArray[indexOnTextArray].markdown)

                                            console.log("1", textArray[indexOnTextArray - 1].markdown + textArray[indexOnTextArray].markdown.substring(1, firstNewParagraphBreaklineIndex))
                                            console.log("2", Constants.newline + textArray[indexOnTextArray].markdown.substring(firstNewParagraphBreaklineIndex + Constants._break.length, textArray[indexOnTextArray].markdown.length))

                                            textArray[indexOnTextArray - 1].markdown = textArray[indexOnTextArray - 1].markdown + textArray[indexOnTextArray].markdown.substring(1, firstNewParagraphBreaklineIndex)
                                            textArray[indexOnTextArray].markdown = Constants.newline + textArray[indexOnTextArray].markdown.substring(firstNewParagraphBreaklineIndex + Constants._break.length, textArray[indexOnTextArray].markdown.length)

                                        } else {

                                            console.log("breaklines here")
                                            MdArray.deleteBlockChar(textArray, indexOnTextArray, ta.cursorPosition, italics, markdownDisplacement)
                                        }
                                    }
                                } else {

                                    if (markdownDisplacement === 1 && textArray[indexOnTextArray].markdown.startsWith(Constants.newline)) {
                                            
                                        if(indexOnTextArray > 0)
                                            textArray[indexOnTextArray - 1].markdown = textArray[indexOnTextArray - 1]?.markdown.concat(
                                            textArray[indexOnTextArray]?.markdown?.substring(markdownDisplacement, textArray[indexOnTextArray]?.markdown?.length) ?? "")
                                        
                                        textArray[indexOnTextArray].markdown = ""
                                    } else {

                                        MdArray.deleteBlockChar(textArray, indexOnTextArray, ta.cursorPosition, italics, markdownDisplacement)

                                        // if(MdArray.isCursorJustAfterItalic(textArray, indexOnTextArray, ta.cursorPosition, italics[indexOnTextArray])) {

                                        //     console.log("italics")

                                        //     if(Block.isDeletingFinalItalicChar(textArray[indexOnTextArray].markdown, markdownDisplacement)) {

                                        //         textArray[indexOnTextArray].markdown = (textArray[indexOnTextArray]?.markdown?.substring(0, markdownDisplacement - 3) ?? "").concat(
                                        //             textArray[indexOnTextArray]?.markdown?.substring(markdownDisplacement) ?? "")

                                        //     } else {

                                        //         textArray[indexOnTextArray].markdown = (textArray[indexOnTextArray]?.markdown?.substring(0, markdownDisplacement - 2) ?? "").concat("*").concat(
                                        //             textArray[indexOnTextArray]?.markdown?.substring(markdownDisplacement) ?? "")
                                        //     }

                                        //     //italics[indexOnTextArray] = Block.updateItalicEnd(italics[indexOnTextArray], markdownDisplacement)

                                        // } else {

                                        //     console.log("1", textArray[indexOnTextArray]?.markdown?.substring(0, markdownDisplacement - 1).split("") ?? "")
                                        //     console.log("3", textArray[indexOnTextArray]?.markdown?.substring(markdownDisplacement, textArray[indexOnTextArray].markdown.length).split("") ?? "")

                                        //     textArray[indexOnTextArray].markdown = (textArray[indexOnTextArray]?.markdown?.substring(0, markdownDisplacement - 1) ?? "").concat(
                                        //         textArray[indexOnTextArray]?.markdown?.substring(markdownDisplacement, textArray[indexOnTextArray]?.markdown?.length) ?? "")
                                        // }

                                        // // Update italics
                                        // let indices = Block.findItalicIndices(textArray[indexOnTextArray].markdown)
                                        // italics[indexOnTextArray] = []
                                        // for(const i of indices) {
                                        //     italics[indexOnTextArray].push({start: i.start, end: i.end})
                                        // }
                                    }
                                }
                            }
                        }

                        if(event.text === '*') {
                            event.accepted = true
                            console.log("KEY ASTERISK")

                            if(italicStartPos === -1) {
                                if(Block.isStartingTitleWithNewline(textArray[indexOnTextArray].markdown)) {
                                    cursorPos = MdArray.getLengthBeforeCursorBlockIndex(textArray, indexOnTextArray) + 2
                                }
                                else if(Block.isStartingTitle(textArray[indexOnTextArray].markdown)) {
                                    cursorPos = 1
                                }
                                else {
                                    cursorPos = ta.cursorPosition + 1
                                }
                                italicStartPos = ta.cursorPosition
                            } else {
                                cursorPos = ta.cursorPosition - 1
                                italicStartPos = -1
                            }

                            italics[indexOnTextArray] = Block.updateItalics(event.text, italics[indexOnTextArray], markdownDisplacement)

                            if(italics[indexOnTextArray] !== undefined) {
                                for(const i of italics[indexOnTextArray]) {
                                    console.log("italic asterik", i.start, i.end)
                                }
                            }

                            textArray[indexOnTextArray].markdown = textArray[indexOnTextArray].markdown.substring(0, markdownDisplacement) + event.text + textArray[indexOnTextArray].markdown.substring(markdownDisplacement)

                            italics[indexOnTextArray] = Block.processNewItalic(textArray[indexOnTextArray].markdown, italics[indexOnTextArray] !== undefined ? italics[indexOnTextArray] : []).italics
                        }

                        if(event.key === Qt.Key_Return) {

                            event.accepted = true
                            console.log("KEY RETURN")

                            if(textArray[indexOnTextArray]?.isTitle) {

                                italicStartPos = -1

                                cursorPos = ta.cursorPosition + 1

                                if(Block.isH1TitleWithNewline(textArray[indexOnTextArray].markdown)) {

                                    if(markdownDisplacement === textArray[indexOnTextArray].markdown.length)
                                    {
                                        textArray.splice(indexOnTextArray + 1, 0, {markdown: "\n" + zeroWidthSpace , isTitle: false});
                                    } else {
                                        textArray.splice(indexOnTextArray + 1, 0, {markdown: "\n" + textArray[indexOnTextArray].markdown.substring(markdownDisplacement, textArray[indexOnTextArray].markdown.length), isTitle: false})

                                        textArray[indexOnTextArray].markdown = textArray[indexOnTextArray].markdown.substring(0, markdownDisplacement)
                                    }
                                } else {
                                    
                                    textArray.splice(indexOnTextArray + 1, 0, {markdown: "" , isTitle: false})

                                    if(markdownDisplacement === textArray[indexOnTextArray].markdown.length) {
                                        textArray[indexOnTextArray + 1].markdown = "\n" + zeroWidthSpace
                                    } else {
                                                            
                                        textArray[indexOnTextArray + 1].markdown = "\n" + textArray[indexOnTextArray].markdown.substring(markdownDisplacement, textArray[indexOnTextArray].markdown.length)
                                        textArray[indexOnTextArray].markdown = textArray[indexOnTextArray].markdown.substring(0, markdownDisplacement)
                                    }
                                }

                            } else {

                                cursorPos = ta.cursorPosition + 1

                                textArray[indexOnTextArray].markdown = (textArray[indexOnTextArray]?.markdown?.substring(0, markdownDisplacement) ?? "").concat(
                                    breakLine).concat(textArray[indexOnTextArray]?.markdown?.substring(markdownDisplacement, textArray[indexOnTextArray]?.markdown?.length) ?? "")
                            }
                        }

                        if (event.key === Qt.Key_Hash || event.text === "#") {
                            event.accepted = true
                            console.log("KEY HASH")
                            
                            textArray[indexOnTextArray].markdown = textArray[indexOnTextArray].markdown.substring(0, markdownDisplacement).concat("#").concat(textArray[indexOnTextArray].markdown.substring(markdownDisplacement))

                            cursorPos = ta.cursorPosition + 1

                            // if(Block.isH1Title(textArray[indexOnTextArray].markdown)) {
                            //     cursorPos = 0
                            // }
                            // else if(Block.isH1TitleWithNewline(textArray[indexOnTextArray].markdown)) {
                            //     cursorPos = MdArray.getLengthBeforeCursorBlock(textArray, ta.cursorPosition) + 1
                            // } else {
                            //     cursorPos = ta.cursorPosition + 1
                            // }
                        }

                        console.log("cursorPos", cursorPos)

                        if(italics[indexOnTextArray] !== undefined) {
                            for(let i = 0; i < italics[indexOnTextArray].length; i++) {
                                console.log("italic end", italics[indexOnTextArray][i].start, italics[indexOnTextArray][i].end)
                                if(italics[indexOnTextArray][i].start + 1 === italics[indexOnTextArray][i].end) {
                                    italics[indexOnTextArray].splice(i, 1)
                                }
                            }
                        }

                        if(textArray[indexOnTextArray]?.markdown?.endsWith('\n') ?? false) {
                            textArray[indexOnTextArray].markdown += zeroWidthSpace
                        }

                        if(textArray.filter(e => e?.markdown?.length !== 0).length === 0) {
                            backend.sendNoteInfo([], cursorPos, true, noteIndex)
                            return
                        }

                        textArray[indexOnTextArray].isTitleFirstChar = Block.isFirstCharOfTitle(textArray[indexOnTextArray].markdown)

                        textArray[indexOnTextArray].isTitle = Block.isTitle(textArray[indexOnTextArray]?.markdown ?? "")

                        if(textArray[indexOnTextArray]?.markdown.length === 0) {
                            textArray.splice(indexOnTextArray, 1)
                        }

                        if(textArray[0]?.markdown?.startsWith('\n')) {
                            textArray[0].markdown = textArray[0].markdown.slice(1)
                        }

                        const result = textArray.map((e) => e.markdown);

                        maxCursorPosValue = MdArray.getTotalLength(textArray)
                        console.log("max length", maxCursorPosValue)

                        backend.sendNoteInfo(result, cursorPos, true, noteIndex)

                        MdArray.printBlocks(textArray)
                        console.log("current index", MdArray.getCursorBlockIndex(textArray, cursorPos))
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
                        //notesBackend.cursorPosition = markDownInput.positionAt(mouse.x, mouse.y)
                        indexOnTextArray = MdArray.getCursorBlockIndex(textArray, ta.cursorPosition)
                        cursorPos = ta.positionAt(mouse.x, mouse.y)

                        console.log("current index onclick", indexOnTextArray)

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
            backend.cursorPosition = startPos; // Move cursor to start position
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
