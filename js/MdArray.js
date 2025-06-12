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

        if (element?.markdown?.endsWith(Constants.zeroWidthSpace)) {
            element.markdown = element.markdown.slice(0, -1)
        }
    })

    let length = 0

    for (let i = 0; i < array.length; i++) {

        if (Block.isH1Title(array[i].markdown)) {

            length += Block.getTitleLength(array[i].markdown)
        }
        else if (Block.isH1TitleWithNewline(array[i].markdown)) {

            length += Block.getTitleWithNewLineLength(array[i].markdown)
        }
        else if(Block.isH2Title(array[i].markdown)) {

            length += Block.getH2TitleLength(array[i].markdown)
        }
        else if(Block.isH2TitleWithNewline(array[i].markdown)) {

            length += Block.getH2TitleWithNewLineLength(array[i].markdown)
        }
        else if(Block.isH3Title(array[i].markdown)) {

            length += Block.getH3TitleLength(array[i].markdown)
        }
        else if(Block.isH3TitleWithNewline(array[i].markdown)) {

            length += Block.getH3TitleWithNewLineLength(array[i].markdown)
        }
        else {

            length += Block.getParagraphLength(array[i].markdown)
        }
    }

    return length
}

// Unit test ready
function getCursorBlockIndex(array, cursorPos) {

    let length = 0
    let i

    array = removeAllItalics(array)

    for (i = 0; i < array.length; i++) {

        if (Block.isH1Title(array[i].markdown)) {

            length += Block.getTitleLength(array[i].markdown)

        } else if (Block.isH1TitleWithNewline(array[i].markdown)) {

            length += Block.getTitleWithNewLineLength(array[i].markdown)
        }
        else if(Block.isH2Title(array[i].markdown)) {

            length += Block.getH2TitleLength(array[i].markdown)
        }
        else if(Block.isH2TitleWithNewline(array[i].markdown)) {

            length += Block.getH2TitleWithNewLineLength(array[i].markdown)
        }
        else if(Block.isH3Title(array[i].markdown)) {

            length += Block.getH3TitleLength(array[i].markdown)
        }
        else if(Block.isH3TitleWithNewline(array[i].markdown)) {

            length += Block.getH3TitleWithNewLineLength(array[i].markdown)
        }
        else {

            length += Block.getParagraphLength(array[i].markdown)
        }


        if (length >= cursorPos) {
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
    array = removeAllItalics(array)
    const cursorBlockIndex = getCursorBlockIndex(array, cursorPos)

    //console.log("cbi", cursorBlockIndex)

    for (let i = 0; i < cursorBlockIndex; i++) {
        if (Block.isH1Title(array[i].markdown)) {
            length += Block.getTitleLength(array[i].markdown)
        } else if (Block.isH1TitleWithNewline(array[i].markdown)) {
            length += Block.getTitleWithNewLineLength(array[i].markdown)
        }
        else if(Block.isH2Title(array[i].markdown)) {
            length += Block.getH2TitleLength(array[i].markdown)
        }
        else if(Block.isH2TitleWithNewline(array[i].markdown)){
            length += Block.getH2TitleWithNewLineLength(array[i].markdown)
        }
        else if(Block.isH3Title(array[i].markdown)) {
            length += Block.getH3TitleLength(array[i].markdown)
        }
        else if(Block.isH3TitleWithNewline(array[i].markdown)) {
            length += Block.getH3TitleWithNewLineLength(array[i].markdown)
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
function getCursorDisplacementInsideMarkdownBlock(array, blockIndex, cursorPos, italics) {

    const textArray = array.filter(e => e?.markdown?.length ?? 0 !== 0)

    if (textArray.length === 0 || array[blockIndex]?.markdown === undefined)
        return 0

    if (Block.isH1Title(array[blockIndex]?.markdown)) {

        const lengthBeforeCursorBlock = 0//getLengthBeforeCursorBlock(array, cursorPos)

        if (array[blockIndex].markdown.length <= 2) {

            return cursorPos - lengthBeforeCursorBlock

        } else {

            //console.log("markdown:", array[blockIndex].markdown)

            const displacement = getCursorDisplacementInsideBlock(array, cursorPos)

            const asteriskNum = Block.countH1ItalicsAsterisksBeforeCursor(array[blockIndex].markdown, displacement, italics)

            //console.log("asteriskNum:", asteriskNum)

            return cursorPos - lengthBeforeCursorBlock + 2 + asteriskNum
        }
    }
    else if (Block.isH1TitleWithNewline(array[blockIndex]?.markdown)) {

        const lengthBeforeCursorBlock = getLengthBeforeCursorBlock(array, cursorPos)

        if (array[blockIndex].markdown.length <= 3) {
            return cursorPos - lengthBeforeCursorBlock
        } else {

            const displacement = getCursorDisplacementInsideBlock(array, cursorPos)

            const asteriskNum = Block.countH1ItalicsAsterisksBeforeCursor(array[blockIndex].markdown, displacement, italics)

            return cursorPos - lengthBeforeCursorBlock + 2 + asteriskNum
        }
    }
    else if(Block.isH2Title(array[blockIndex]?.markdown)) {

        const lengthBeforeCursorBlock = 0

        if (array[blockIndex].markdown.length <= 3) {

            return cursorPos - lengthBeforeCursorBlock

        } else {

            // console.log("markdown:", array[blockIndex].markdown)

            const displacement = getCursorDisplacementInsideBlock(array, cursorPos)

            const asteriskNum = Block.countH1ItalicsAsterisksBeforeCursor(array[blockIndex].markdown, displacement, italics)

            // console.log("asteriskNum:", asteriskNum)

            const h2TitleStartedLength = Constants.h2TitleStarted.length // 3

            return cursorPos - lengthBeforeCursorBlock + h2TitleStartedLength + asteriskNum
        }
    }
    else if (Block.isH2TitleWithNewline(array[blockIndex]?.markdown)) {

        const lengthBeforeCursorBlock = getLengthBeforeCursorBlock(array, cursorPos)

        if (array[blockIndex].markdown.length <= 3) {
            return cursorPos - lengthBeforeCursorBlock
        } else {

            console.log("md", array[blockIndex]?.markdown)

            const displacement = getCursorDisplacementInsideBlock(array, cursorPos)

            const asteriskNum = Block.countH1ItalicsAsterisksBeforeCursor(array[blockIndex].markdown, displacement, italics)

            const h2TitleStartedLength = Constants.h2TitleStarted.length // 3

            return cursorPos - lengthBeforeCursorBlock + h2TitleStartedLength + asteriskNum
        }
    }
    else if (Block.isH3Title(array[blockIndex]?.markdown)) {

        const lengthBeforeCursorBlock = 0//getLengthBeforeCursorBlock(array, cursorPos)

        if (array[blockIndex].markdown.length <= 4) {

            return cursorPos - lengthBeforeCursorBlock

        } else {

            //console.log("markdown:", array[blockIndex].markdown)

            const displacement = getCursorDisplacementInsideBlock(array, cursorPos)

            const asteriskNum = Block.countH1ItalicsAsterisksBeforeCursor(array[blockIndex].markdown, displacement, italics)

            //console.log("asteriskNum:", asteriskNum)

            const h3TitleStartedLength = Constants.h3TitleStarted.length // 4

            return cursorPos - lengthBeforeCursorBlock + h3TitleStartedLength + asteriskNum
        }
    }
    else if (Block.isH3TitleWithNewline(array[blockIndex]?.markdown)) {

        const lengthBeforeCursorBlock = getLengthBeforeCursorBlock(array, cursorPos)

        if (array[blockIndex].markdown.length <= 5) {
            return cursorPos - lengthBeforeCursorBlock
        } else {

            const displacement = getCursorDisplacementInsideBlock(array, cursorPos)

            const asteriskNum = Block.countH1ItalicsAsterisksBeforeCursor(array[blockIndex].markdown, displacement, italics)

            const h3TitleStartedLength = Constants.h3TitleStarted.length // 4

            return cursorPos - lengthBeforeCursorBlock + h3TitleStartedLength + asteriskNum
        }
    }
    else {
        const displacement = getCursorDisplacementInsideBlock(array, cursorPos)
        const brickIndex = Block.getBrickIndexAtWhichCursoIsLocated(array[blockIndex]?.markdown, displacement, italics)
        const numBreaksBeforeIndex = brickIndex

        let length = 0
        const bricks = Block.removeItalics(array[blockIndex].markdown).split(Constants._break)

        for (let i = 0; i < brickIndex; i++) {
            length += bricks[i].length
        }

        const distanceBetweenBreaklineAndCursor = displacement - (length + numBreaksBeforeIndex)

        const asteriskNum = Block.countItalicsAsterisksBeforeCursor(array[blockIndex].markdown, displacement, italics)

        //console.log("asteriskNum:", asteriskNum)
        
        length += Constants._break.length * numBreaksBeforeIndex + distanceBetweenBreaklineAndCursor + asteriskNum

        return length
    }
}


// Unit test ready
function isCursorJustAfterParagraphBreakline(array, blockIndex, cursorPos, italics) {

    if (Block.isTitle(array[blockIndex].markdown)) {
        return false
    } else {
        const displacement = getCursorDisplacementInsideBlock(array, cursorPos)
        const brickIndex = Block.getBrickIndexAtWhichCursoIsLocated(array[blockIndex].markdown, displacement, italics)
        const numBreaksBeforeIndex = brickIndex

        let length = 0

        const bricks = Block.removeItalics(array[blockIndex].markdown).split(Constants._break)

        for (let i = 0; i < brickIndex; i++) {
            console.log("brick", bricks[i])
            length += bricks[i].length
        }

        const distanceBetweenBreaklineAndCursor = displacement - (length + numBreaksBeforeIndex)

        return distanceBetweenBreaklineAndCursor === 0
    }
}

// Unit test ready
// This is similar to ta.cursorPosition
function getLengthUntilCursor(array, cursorPos) {

    return getLengthBeforeCursorBlock(array, cursorPos) +
        getCursorDisplacementInsideBlock(array, cursorPos)
}

function getLengthBeforeCursorBlockIndex(array, cursorBlockIndex) {

    let length = 0
    for (let i = 0; i < cursorBlockIndex; i++) {
        if (Block.isH1Title(array[i].markdown)) {
            length += Block.getTitleLength(array[i].markdown)
        } else if (Block.isH1TitleWithNewline(array[i].markdown)) {
            length += Block.getTitleWithNewLineLength(array[i].markdown)
        }
        else if(Block.isH2Title(array[i].markdown)) {
            length += Block.getH2TitleLength(array[i].markdown)
        }
        else if(Block.isH2TitleWithNewline(array[i].markdown)) {
            length += Block.getH2TitleWithNewLineLength(array[i].markdown)
        }
        else if (Block.isH3Title(array[i].markdown)) {
            length += Block.getH3TitleLength(array[i].markdown)
        }
        else if(Block.isH3TitleWithNewline(array[i].markdown)) {
            length += Block.getH3TitleWithNewLineLength(array[i].markdown)
        }
        else {
            length += Block.getParagraphLength(array[i].markdown)
        }
    }

    return length
}

function getStartAndEndOnMarkownForItalic(array, start, end) {

    const startBlockIndex = getCursorBlockIndex(array, start)
    const endBlockIndex = getCursorBlockIndex(array, end)

    printBlocks(array)

    console.log("startBlockIndex:", startBlockIndex, "endBlockIndex:", endBlockIndex)

    let indexes = []

    for (let i = startBlockIndex; i <= endBlockIndex; i++) {
        indexes.push(i)
        console.log(i)
    }

    if (indexes.length > 1) {

    } else {

        const startDisplacement = getCursorDisplacementInsideMarkdownBlock(array, startBlockIndex, start)
        const endDisplacement = getCursorDisplacementInsideMarkdownBlock(array, endBlockIndex, end)

        console.log("startDisplacement:", startDisplacement, "endDisplacement:", endDisplacement)

        return { index: startBlockIndex, start: startDisplacement, end: endDisplacement }
    }
}

// Unit test ready
function getMarkdownTextOnBlockBeforeCursor(array, markdownText, cursorPos) {
    let visibleCount = 0;
    let i = 0;
    let firstAsterisk = false;

    const displacement = getCursorDisplacementInsideBlock(array, cursorPos)
    const italics = Block.findItalicIndices(markdownText)

    while (i < markdownText.length && visibleCount < displacement) {
        const char = markdownText[i];
        //console.log('Char', char, "i", i, "visibleCount", visibleCount)

        if (char === Constants.nonBreakingSpace || char === '#') {
            i++;
            continue;
        }

        // Handle <br/>
        if (markdownText.startsWith('<br/>', i)) {
            visibleCount++
            i += 5
            continue
        }

        // Handle newline
        if (char === '\n') {
            visibleCount++;
            i++;
            continue;
        }

        // Handle escaped characters
        if (char === '\\' && (markdownText[i + 1] === '*' || markdownText[i + 1] === '_')) {
            i += 2; // skip escaped
            continue;
        }

        if ((char === '*' || char === '_') && firstAsterisk) {
            i++;
            firstAsterisk = false
            continue;
        }

        // Count italics markers
        if ((char === '*' || char === '_') && (markdownText[i + 1] !== '*' || markdownText[i + 1] !== '_')) {
            const found = italics.findIndex(italic => italic.start === i);
            if(found === -1) {
                i++
                visibleCount++
                firstAsterisk = false
            }
            else {
                i++;
                firstAsterisk = true
            }
            continue;
        }

        // Default visible char
        visibleCount++
        i++
    }

    // End of italic
    if (markdownText[i] === '*' && firstAsterisk) {
        i++
    }

    return markdownText.substring(0, i)
}

function removeAllItalics(array) {
    const newArray = []
    for (let i = 0; i < array.length; i++) {
        newArray.push({markdown: Block.removeItalics(array[i].markdown)})
    }
    return newArray
}

function isCursorJustAfterItalic(array, blockIndex, cursorPos, italics) {

    if(italics === undefined || italics.length === 0)
        return false

    const markdownDisplacement = getCursorDisplacementInsideMarkdownBlock(array, blockIndex, cursorPos, italics)

    for(const italic of italics) {

        //console.log("mdd", markdownDisplacement, italic.end)

        if(italic.end === markdownDisplacement - 1) {
            return true
        }
    }

    return false
}
