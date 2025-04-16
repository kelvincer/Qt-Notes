.import "TextBlock.js" as Block
.import "Constants.js" as Constants

function printBlocks(array) {
    for (var i = 0; i < array.length; i++) {
        console.log("block ele:", "markdown:", array[i].markdown, "isTitle:", array[i].isTitle, "isTitleFirstChar:", array[i].isTitleFirstChar)
    }
}

// Unit test ready
// Counting only visible characters, <br/> and '\n'
function getTotalLength(array) {

    array.map((element) => {

                  if(element?.markdown?.endsWith(Constants.zeroWidthSpace)) {
                      element.markdown = element.markdown.slice(0, -1)
                  }
              })

    let length = 0

    for(let i = 0; i < array.length; i++) {

        if(Block.isH1Title(array[i].markdown)) {

            length += Block.getTitleLength(array[i].markdown)

        } else if(Block.isH1TitleWithNewline(array[i].markdown)) {

            length += Block.getTitleWithNewLineLength(array[i].markdown)
        } else {

            length += Block.getParagraphLength(array[i].markdown)
        }
    }

    return length
}

// Unit test ready
function getCursorBlockIndex(array, cursorPos) {

    let length = 0
    let i

    for(i = 0; i < array.length; i++) {

        if(Block.isH1Title(array[i].markdown)) {

            length += Block.getTitleLength(array[i].markdown)

        } else if(Block.isH1TitleWithNewline(array[i].markdown)) {

            length += Block.getTitleWithNewLineLength(array[i].markdown)
        } else {

            length += Block.getParagraphLength(array[i].markdown)
        }


        if(length >= cursorPos) {
            break
        }
    }

    return i
}

// Unit test ready
// Counting only visible characters, <br/> and '\n'
// # title title
// \ndescript|ion > return 11
function getLengthBeforeCursorBlock(array, cursorPos) {

    let length = 0
    const cursorBlockIndex = getCursorBlockIndex(array, cursorPos)
    for(let i = 0; i < cursorBlockIndex; i++) {
        if(Block.isH1Title(array[i].markdown)) {
            length += Block.getTitleLength(array[i].markdown)
        } else if(Block.isH1TitleWithNewline(array[i].markdown)) {
            length += Block.getTitleWithNewLineLength(array[i].markdown)
        }
        else {
            length += Block.getParagraphLength(array[i].markdown)
        }
    }

    return length
}

// Unit test ready
function getCursorDisplacementInsideBlock(array, cursorPos) {

    return cursorPos - getLengthBeforeCursorBlock(array, cursorPos)
}

// Unit test ready
function getCursorDisplacementInsideMarkdownBlock(array, blockIndex, cursorPos) {

    const textArray = array.filter(e => e?.markdown?.length ?? 0 !== 0)

    if(textArray.length === 0 || array[blockIndex]?.markdown === undefined)
        return 0

    if(Block.isH1Title(array[blockIndex]?.markdown)) {

        const lengthBeforeCursorBlock = 0//getLengthBeforeCursorBlock(array, cursorPos)

        if(array[blockIndex].markdown.length <= 2) {

            return cursorPos - lengthBeforeCursorBlock

        } else {

            return cursorPos - lengthBeforeCursorBlock + 2
        }
    }
    else if(Block.isH1TitleWithNewline(array[blockIndex]?.markdown)) {

        const lengthBeforeCursorBlock = getLengthBeforeCursorBlock(array, cursorPos)

        if(array[blockIndex].markdown.length <= 3 )  {
            return cursorPos - lengthBeforeCursorBlock
        } else {
            return cursorPos - lengthBeforeCursorBlock + 2
        }
    }
    else {
        const displacement = getCursorDisplacementInsideBlock(array, cursorPos)
        const brickIndex = Block.getBrickIndexAtWhichCursoIsLocated(array[blockIndex]?.markdown, displacement)
        const numBreaksBeforeIndex = brickIndex

        let length = 0
        const bricks = array[blockIndex].markdown.split(Constants._break)

        for(let i = 0; i < brickIndex; i++) {
            length += bricks[i].length
        }

        const distanceBetweenBreaklineAndCursor = displacement - (length + numBreaksBeforeIndex)

        length += Constants._break.length * numBreaksBeforeIndex + distanceBetweenBreaklineAndCursor

        return length
    }
}


// Unit test ready
function isCursorJustAfterParagraphBreakline(array, blockIndex, cursorPos) {

    if(Block.isH1Title(array[blockIndex].markdown)) {
        return false
    } else {
        const displacement = getCursorDisplacementInsideBlock(array, cursorPos)
        const brickIndex = Block.getBrickIndexAtWhichCursoIsLocated(array[blockIndex].markdown, displacement)
        const numBreaksBeforeIndex = brickIndex

        let length = 0
        const bricks = array[blockIndex].markdown.split(Constants._break)

        for(let i = 0; i < brickIndex; i++) {
            length += bricks[i].length
        }

        const distanceBetweenBreaklineAndCursor = displacement - (length + numBreaksBeforeIndex)

        return distanceBetweenBreaklineAndCursor === 0
    }
}

// Unit test ready
// This is similar to ta.cursorPosition
function getLengthUntilCursor(array, cursorPos) {

    return  getLengthBeforeCursorBlock(array, cursorPos) +
            getCursorDisplacementInsideBlock(array, cursorPos)
}

function getLengthBeforeCursorBlockIndex(array, cursorBlockIndex) {

    let length = 0
    for(let i = 0; i < cursorBlockIndex; i++) {
        if(Block.isH1Title(array[i].markdown)) {
            length += Block.getTitleLength(array[i].markdown)
        } else if(Block.isH1TitleWithNewline(array[i].markdown)) {
            length += Block.getTitleWithNewLineLength(array[i].markdown)
        }
        else {
            length += Block.getParagraphLength(array[i].markdown)
        }
    }

    return length
}

function isStartingATitleInsideParagraph(markdown) {
    return markdown.substring(markdown.length - 7) === Constants._break + Constants.titleStarted
}
