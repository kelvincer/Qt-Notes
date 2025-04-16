import QtQuick
import QtQuick.Controls
import Notes as Notes
import "../js/TextBlock.js" as Block
import "../js/MdArray.js" as MdArray
import "../js/Constants.js" as Constants

TextArea {

    // Notes.NotesBackend {
    //     id: notesBackend
    //     onCursorPositionChanged: {

    //     }
    // }

    property var backend
    readonly property string newline : '\n'
    readonly property string breakLine : "<br/>"
    readonly property string nonBreakingSpace : '\u00A0'
    readonly property string zeroWidthSpace : "\u200B"
    property int cursorPos : 0
    property var textArray : [{markdown: "", isTitle: false}]
    property int maxCursorPosValue: 0

    id: ta
    text: backend.md
    //anchors.fill: parent
    textFormat: TextArea.MarkdownText
    cursorPosition: backend.cursorPosition
    wrapMode: TextEdit.Wrap
    onCursorPositionChanged: {
        console.log("onCursorPositionChanged", cursorPosition)
    }
    onTextChanged: {

        //console.log("text", text.split(""))

    }
    Component.onCompleted: {

    }
    Keys.onPressed: event => {

                        console.log("===============================")

                        console.log("Key pressed:", event.text, "cursorPos:", cursorPos, "ta cp:", ta.cursorPosition)

                        const indexOnTextArray = MdArray.getCursorBlockIndex(textArray, ta.cursorPosition)
                        console.log("current index", indexOnTextArray)
                        console.log("cursor", ta.cursorPosition)

                        MdArray.printBlocks(textArray)

                        // const isH1Title = Block.isTitle(textArray[indexOnTextArray]?.markdown ?? "")

                        console.log("current index a title?", textArray[indexOnTextArray]?.isTitle ?? false)

                        // textArray[indexOnTextArray].isTitleFirstChar = Block.isTitleFirstChar(textArray[indexOnTextArray]?.markdown, event.text) ?? false

                        if(event.key === Qt.Key_Left) {

                            event.accepted = true

                            console.log("num", "0")

                            cursorPos = backend.cursorPosition === 0 ? 0 : ta.cursorPosition - 1

                        }

                        if(event.key === Qt.Key_Right) {

                            console.log("num", "01")

                            event.accepted = true

                            cursorPos = maxCursorPosValue > ta.cursorPosition ? ta.cursorPosition + 1 : ta.cursorPosition

                        }

                        if(Block.isACharacter(event.text)) {
                            event.accepted = true

                            console.log("start cp", ta.cursorPosition)
                            console.log("num", 1)

                            if(textArray[indexOnTextArray].isTitle) {

                                // if(textArray[indexOnTextArray].isTitleFirstChar) {
                                //     cursorPos = MdArray.getLengthBeforeCursorBlock(MdArray, ta.cursorPosition) + 1
                                // } else {
                                //     cursorPos = ta.cursorPosition + 1
                                // }

                                const markdownDisplacement = MdArray.getCursorDisplacementInsideMarkdownBlock(textArray, indexOnTextArray, ta.cursorPosition)

                                console.log("1", textArray[indexOnTextArray]?.markdown?.substring(0, markdownDisplacement).split("") ?? "")
                                console.log("2", event.text)
                                console.log("3", textArray[indexOnTextArray]?.markdown?.substring(markdownDisplacement, textArray[indexOnTextArray]?.markdown?.length) ?? "")

                                textArray[indexOnTextArray].markdown = (textArray[indexOnTextArray]?.markdown?.substring(0, markdownDisplacement) ?? "").concat(
                                    event.text).concat(textArray[indexOnTextArray]?.markdown?.substring(markdownDisplacement, textArray[indexOnTextArray]?.markdown?.length) ?? "")

                                if(textArray[indexOnTextArray].isTitleFirstChar) {

                                    if(Block.isH1TitleWithNewline(textArray[indexOnTextArray].markdown)) {                                        cursorPos =
                                        cursorPos = MdArray.getLengthBeforeCursorBlockIndex(textArray, indexOnTextArray) + 2

                                    } else {
                                        cursorPos =
                                        MdArray.getLengthBeforeCursorBlockIndex(textArray, indexOnTextArray) + 1
                                    }

                                } else {
                                    cursorPos = ta.cursorPosition + 1
                                }

                                // console.log("1", textArray[indexOnTextArray]?.markdown?.substring(0, cursorPos + 1).split("") ?? "")
                                // console.log("2", event.text)
                                // console.log("3", textArray[indexOnTextArray]?.markdown?.substring(cursorPos + 1, textArray[indexOnTextArray].markdown.length).split("") ?? "")

                                // textArray[indexOnTextArray].markdown = (textArray[indexOnTextArray]?.markdown?.substring(0, cursorPos + 1) ?? "").concat(
                                //     event.text).concat(textArray[indexOnTextArray]?.markdown?.substring(cursorPos + 1, textArray[indexOnTextArray]?.markdown?.length) ?? "")

                            } else {

                                if(MdArray.isStartingATitleInsideParagraph(textArray[indexOnTextArray]?.markdown) ?? false) {

                                    textArray[indexOnTextArray].markdown = textArray[indexOnTextArray].markdown.substring(0, textArray[indexOnTextArray].markdown.length - 7)

                                    textArray[indexOnTextArray + 1] = { markdown: Constants.titleStartedWithNewline + event.text , isTitle: true};

                                    cursorPos = ta.cursorPosition - 1

                                } else {

                                    cursorPos = ta.cursorPosition + 1

                                    if(textArray[indexOnTextArray]?.markdown?.includes(breakLine)) {

                                        console.log("12")

                                        const markdownDisplacement = MdArray.getCursorDisplacementInsideMarkdownBlock(textArray, indexOnTextArray, ta.cursorPosition)

                                        console.log("1", textArray[indexOnTextArray].markdown.substring(0, markdownDisplacement).split(""))
                                        console.log("2", event.text)
                                        console.log("3", textArray[indexOnTextArray].markdown.substring(markdownDisplacement, textArray[indexOnTextArray].markdown.length).split(""))

                                        textArray[indexOnTextArray].markdown = textArray[indexOnTextArray].markdown.substring(0, markdownDisplacement)
                                        + event.text + textArray[indexOnTextArray].markdown.substring(markdownDisplacement, textArray[indexOnTextArray].markdown.length)

                                    } else {

                                        console.log("11")

                                        const markdownDisplacement = MdArray.getCursorDisplacementInsideMarkdownBlock(textArray, indexOnTextArray, ta.cursorPosition)

                                        console.log("1", textArray[indexOnTextArray]?.markdown?.substring(0, markdownDisplacement).split("") ?? "")
                                        console.log("2", event.text)
                                        console.log("3", textArray[indexOnTextArray]?.markdown?.substring(markdownDisplacement, textArray[indexOnTextArray]?.markdown?.length) ?? "")

                                        textArray[indexOnTextArray].markdown = (textArray[indexOnTextArray]?.markdown?.substring(0, markdownDisplacement) ?? "").concat(
                                            event.text).concat(textArray[indexOnTextArray]?.markdown?.substring(markdownDisplacement, textArray[indexOnTextArray]?.markdown?.length) ?? "")

                                    }
                                }
                            }
                        }

                        if(event.key === Qt.Key_Space) {
                            event.accepted = true

                            console.log("start cp", ta.cursorPosition)
                            console.log("num", 2)

                            if(textArray[indexOnTextArray].isTitle) {

                                if(Block.isH1Title(textArray[indexOnTextArray].markdown)) {

                                    if(textArray[indexOnTextArray].isTitleFirstChar) {
                                        cursorPos = 1
                                    } else {
                                        cursorPos = ta.cursorPosition + 1
                                    }

                                    console.log("1", textArray[indexOnTextArray].markdown.substring(0, cursorPos + 1).split(""))
                                    console.log("2", "space")
                                    console.log("3", textArray[indexOnTextArray].markdown.substring(cursorPos + 1, textArray[indexOnTextArray].markdown.length).split(""))

                                    textArray[indexOnTextArray].markdown = textArray[indexOnTextArray].markdown.substring(0, cursorPos + 1)
                                    + nonBreakingSpace + textArray[indexOnTextArray].markdown.substring(cursorPos + 1, textArray[indexOnTextArray].markdown.length)
                                } else {

                                    if(textArray[indexOnTextArray].isTitleFirstChar) {
                                        console.log("1", textArray[indexOnTextArray].markdown.substring(0, ta.cursorPosition - 1).split(""))
                                        console.log("2", "space 1")
                                        console.log("3", textArray[indexOnTextArray].markdown.substring(ta.cursorPosition - 1, textArray[indexOnTextArray].markdown.length).split(""))

                                        textArray[indexOnTextArray].markdown = textArray[indexOnTextArray].markdown.substring(0, ta.cursorPosition - 1)
                                        + nonBreakingSpace + textArray[indexOnTextArray].markdown.substring(ta.cursorPosition - 1, textArray[indexOnTextArray].markdown.length)

                                        cursorPos = ta.cursorPosition - 1

                                    } else {
                                        //cursorPos = MdArray.getLengthUntilCursor(textArray, ta.cursorPosition) + 1

                                        const displacement = MdArray.getCursorDisplacementInsideMarkdownBlock(textArray, indexOnTextArray, ta.cursorPosition)

                                        console.log("1", textArray[indexOnTextArray].markdown.substring(0, displacement).split(""))
                                        console.log("2", "space 2")
                                        console.log("3", textArray[indexOnTextArray].markdown.substring(displacement, textArray[indexOnTextArray].markdown.length).split(""))

                                        textArray[indexOnTextArray].markdown = textArray[indexOnTextArray].markdown.substring(0, displacement)
                                        + nonBreakingSpace + textArray[indexOnTextArray].markdown.substring(displacement, textArray[indexOnTextArray].markdown.length)

                                        cursorPos = ta.cursorPosition + 1
                                    }
                                }
                            } else {

                                console.log("CURSOR POSITION 22")

                                const markdownDisplacement = MdArray.getCursorDisplacementInsideMarkdownBlock(textArray, indexOnTextArray, ta.cursorPosition)

                                console.log("1", textArray[indexOnTextArray]?.markdown?.substring(0, markdownDisplacement).split("") ?? "")
                                console.log("2", "space")
                                console.log("3", textArray[indexOnTextArray]?.markdown?.substring(markdownDisplacement, textArray[indexOnTextArray].markdown.length).split("") ?? "")

                                textArray[indexOnTextArray].markdown = (textArray[indexOnTextArray]?.markdown?.substring(0, markdownDisplacement) ?? "").concat(
                                    nonBreakingSpace).concat(textArray[indexOnTextArray]?.markdown?.substring(markdownDisplacement, textArray[indexOnTextArray]?.markdown?.length) ?? "")

                                cursorPos = ta.cursorPosition + 1

                                // if(Block.isH1TitleWithNewline(textArray[indexOnTextArray]?.markdown ?? "")) {
                                //     console.log("IS TITLE")
                                //     cursorPos = MdArray.getLengthBeforeCursorBlock(textArray, ta.cursorPosition) + MdArray.getCursorDisplacementInsideBlock(textArray, ta.cursorPosition) + 1
                                //     //cursorPos = 4

                                //     console.log("cursor:", cursorPos)
                                // } else if(Block.isH1Title(textArray[indexOnTextArray]?.markdown ?? "")) {
                                //     cursorPos = Block.getTitleLength(textArray[indexOnTextArray]?.markdown)
                                // }
                                // else {
                                //     console.log("IS NOT TITLE NEW LINE")
                                //     cursorPos = ta.cursorPosition + 1
                                // }

                            }
                        }

                        if(event.key === Qt.Key_Backspace) {

                            event.accepted = true

                            console.log("num", 3)

                            if(cursorPos === 0) {
                                return
                            }

                            if(textArray[indexOnTextArray]?.isTitle ?? false) {

                                if(Block.isH1Title(textArray[indexOnTextArray].markdown)) {

                                    if(textArray[indexOnTextArray].markdown.length === 3) {

                                        textArray[indexOnTextArray].markdown = ""

                                        cursorPos = MdArray.getLengthBeforeCursorBlockIndex(textArray, indexOnTextArray)

                                    } else {
                                        cursorPos = ta.cursorPosition - 1

                                        textArray[indexOnTextArray].markdown = textArray[indexOnTextArray].markdown.substring(0, cursorPos + 2)
                                        + textArray[indexOnTextArray].markdown.substring(cursorPos + 3, textArray[indexOnTextArray].markdown.length)

                                    }

                                } else {

                                    if(textArray[indexOnTextArray].markdown.length === 4) {

                                        textArray[indexOnTextArray].markdown = "\n"

                                        cursorPos = MdArray.getLengthBeforeCursorBlockIndex(textArray, indexOnTextArray) + 1

                                    } else {

                                        cursorPos = ta.cursorPosition - 1

                                        const markdownDisplacement = MdArray.getCursorDisplacementInsideMarkdownBlock(textArray, indexOnTextArray, ta.cursorPosition)

                                        console.log("displacement", markdownDisplacement)

                                        textArray[indexOnTextArray].markdown = textArray[indexOnTextArray].markdown.substring(0, markdownDisplacement - 1)
                                        + textArray[indexOnTextArray].markdown.substring(markdownDisplacement, textArray[indexOnTextArray].markdown.length)
                                    }
                                }

                            } else {

                                cursorPos = ta.cursorPosition - 1

                                if(textArray[indexOnTextArray]?.markdown?.includes(breakLine)) {

                                    if(MdArray.isCursorJustAfterParagraphBreakline(textArray, indexOnTextArray, ta.cursorPosition)) {
                                        console.log("31")

                                        const markdownDisplacement = MdArray.getCursorDisplacementInsideMarkdownBlock(textArray, indexOnTextArray, ta.cursorPosition)

                                        console.log("1", textArray[indexOnTextArray].markdown.substring(0, markdownDisplacement - breakLine.length))
                                        console.log("2", textArray[indexOnTextArray].markdown.substring(markdownDisplacement, textArray[indexOnTextArray].markdown.length))

                                        textArray[indexOnTextArray].markdown = textArray[indexOnTextArray].markdown.substring(0, markdownDisplacement - breakLine.length)
                                        + textArray[indexOnTextArray].markdown.substring(markdownDisplacement, textArray[indexOnTextArray].markdown.length)

                                    } else {

                                        console.log("32")

                                        const markdownDisplacement = MdArray.getCursorDisplacementInsideMarkdownBlock(textArray, indexOnTextArray, ta.cursorPosition)

                                        console.log("1", textArray[indexOnTextArray].markdown.substring(0, markdownDisplacement - 1))
                                        console.log("2", textArray[indexOnTextArray].markdown.substring(markdownDisplacement, textArray[indexOnTextArray].markdown.length))

                                        textArray[indexOnTextArray].markdown = textArray[indexOnTextArray].markdown.substring(0, markdownDisplacement - 1)
                                        + textArray[indexOnTextArray].markdown.substring(markdownDisplacement, textArray[indexOnTextArray].markdown.length)

                                    }

                                } else {

                                    const totalLengthBeforeCursorBlock = MdArray.getLengthBeforeCursorBlock(textArray, ta.cursorPosition)

                                    console.log("cursorPos:", cursorPos, "inside paragraph:", totalLengthBeforeCursorBlock)

                                    console.log("1", textArray[indexOnTextArray]?.markdown?.substring(0, cursorPos - totalLengthBeforeCursorBlock).split("") ?? "")
                                    console.log("3", textArray[indexOnTextArray]?.markdown?.substring(cursorPos + 1 - totalLengthBeforeCursorBlock, textArray[indexOnTextArray].markdown.length).split("") ?? "")

                                    textArray[indexOnTextArray].markdown = (textArray[indexOnTextArray]?.markdown?.substring(0, cursorPos - totalLengthBeforeCursorBlock) ?? "").concat(
                                        textArray[indexOnTextArray]?.markdown?.substring(cursorPos + 1 - totalLengthBeforeCursorBlock, textArray[indexOnTextArray]?.markdown?.length) ?? "")

                                    // if(textArray[indexOnTextArray]?.markdown === '\n') {

                                    //     textArray[indexOnTextArray].markdown = '\n' + zeroWidthSpace
                                    // }
                                }
                            }
                        }

                        if(event.key === Qt.Key_Return) {

                            event.accepted = true

                            console.log("num", 4)

                            console.log("KEY RETURN")

                            if(textArray[indexOnTextArray]?.isTitle) {

                                cursorPos = ta.cursorPosition + 1

                                if(Block.isH1TitleWithNewline(textArray[indexOnTextArray].markdown)) {

                                    if(MdArray.getCursorDisplacementInsideBlock(textArray, ta.cursorPosition) + 2 === textArray[indexOnTextArray].markdown.length)
                                    {
                                        if (textArray[indexOnTextArray + 1] === undefined) {
                                            textArray[indexOnTextArray + 1] = { markdown: "" , isTitle: false};
                                        }
                                        textArray[indexOnTextArray + 1].markdown = "\n" + zeroWidthSpace
                                    } else {

                                        const displacement = MdArray.getCursorDisplacementInsideMarkdownBlock(textArray, indexOnTextArray, ta.cursorPosition)

                                        //console.log(textArray[indexOnTextArray].markdown.substring(0, displacement).split(""))
                                        //console.log(textArray[indexOnTextArray].markdown.substring(displacement, textArray[indexOnTextArray].markdown.length).split(""))

                                        textArray.splice(indexOnTextArray + 1, 0, {markdown: "\n" + textArray[indexOnTextArray].markdown.substring(displacement, textArray[indexOnTextArray].markdown.length), isTitle: false})

                                        textArray[indexOnTextArray].markdown = textArray[indexOnTextArray].markdown.substring(0, displacement)
                                    }
                                } else {
                                    if (textArray[indexOnTextArray + 1] === undefined) {
                                        textArray[indexOnTextArray + 1] = { markdown: "" , isTitle: false};
                                    }

                                    if(ta.cursorPosition + 2 === textArray[indexOnTextArray].markdown.length) {

                                        textArray[indexOnTextArray + 1].markdown = "\n" + zeroWidthSpace
                                    } else {

                                        textArray[indexOnTextArray + 1].markdown = "\n" + textArray[indexOnTextArray].markdown.substring(ta.cursorPosition + 2, textArray[indexOnTextArray].markdown.length + 2)
                                        textArray[indexOnTextArray].markdown = textArray[indexOnTextArray].markdown.substring(0, ta.cursorPosition + 2)
                                    }
                                }

                            } else {

                                console.log("return no breakline")

                                cursorPos = ta.cursorPosition + 1

                                const markdownDisplacement = MdArray.getCursorDisplacementInsideMarkdownBlock(textArray, indexOnTextArray, ta.cursorPosition)

                                textArray[indexOnTextArray].markdown = (textArray[indexOnTextArray]?.markdown?.substring(0, markdownDisplacement) ?? "").concat(
                                    breakLine).concat(textArray[indexOnTextArray]?.markdown?.substring(markdownDisplacement, textArray[indexOnTextArray]?.markdown?.length) ?? "")
                            }
                        }

                        if (event.key === Qt.Key_Hash || event.text === "#") {
                            event.accepted = true
                            console.log("num", 5)
                            cursorPos = ta.cursorPosition + 1

                            textArray[indexOnTextArray].markdown = (textArray[indexOnTextArray]?.markdown ?? "").concat("#")

                        }

                        console.log("cursorPos", cursorPos)


                        if(textArray[indexOnTextArray]?.markdown?.endsWith('\n') ?? false) {
                            textArray[indexOnTextArray].markdown += zeroWidthSpace
                        }

                        //textArray = textArray.filter(e => e?.markdown?.length !== 0)
                        if(textArray.filter(e => e?.markdown?.length !== 0).length === 0) {
                            backend.blocks = []
                            backend.cursorPosition = cursorPos
                            //textArray.push({markdown: ""})
                            return
                        }

                        textArray[indexOnTextArray].isTitleFirstChar = Block.isFirstCharOfTitle(textArray[indexOnTextArray]?.markdown) ?? false

                        const isH1Title = Block.isTitle(textArray[indexOnTextArray]?.markdown ?? "")

                        textArray[indexOnTextArray].isTitle = isH1Title

                        if(textArray[indexOnTextArray]?.markdown.length === 0) {
                            textArray.splice(indexOnTextArray, 1)
                        }

                        const result = textArray.map((e) => e.markdown);

                        maxCursorPosValue = MdArray.getTotalLength(textArray)
                        console.log("max length", maxCursorPosValue)

                        backend.blocks = result
                        backend.cursorPosition = cursorPos

                        MdArray.printBlocks(textArray)
                        console.log("current index", MdArray.getCursorBlockIndex(textArray, cursorPos))
                    }
}
