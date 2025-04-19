.import "Constants.js" as Constants

function isACharacter(character) {
    //return (/[a-zA-ZñÑ0-9,.;]/).test(character);
    return (/[^\s#]/).test(character)
}

function isH1Title(title) {
    return title !== undefined && title.startsWith(Constants.titleStarted)
}

function isH1TitleWithNewline(title) {
    return title !== undefined && title.startsWith(Constants.titleStartedWithNewline)
}

function isTitle(title) {
    return isH1Title(title) || isH1TitleWithNewline(title)
}

// Unit test ready
function countBreaks(text) {

    if (text === undefined)
        return 0

    const array = text.split(Constants._break)

    return array.length - 1
}

// function getTotalBlockLengthBeforeBlockCursorPos(paragraph, cursorPos) {

//     if (paragraph === undefined)
//         return 0

//     let length = 0
//     const array = paragraph.split(Constants._break)

//     const cursorPosInBlock = getCursorBlockIndexOnParagraph(paragraph,
//                                                             cursorPos)

//     for (var i = 0; i < cursorPosInBlock; i++) {

//         length += array[i].length
//     }

//     return length
// }


// Unit test ready
// Visible characters
function getTitleLength(markdown) {

    if (markdown === undefined)
        return 0

    if (markdown.length <= 2) {

        return markdown.length
    } else {

        return markdown.length - 2
    }
}

// Unit test ready
// Visible characters
function getTitleWithNewLineLength(markdown) {

    if (markdown === undefined)
        return 0

    if (markdown.length <= 3) {

        return markdown.length
    } else {

        return markdown.length - 2
    }
}

// Unit test ready
// Visible characters and newline(<br/>)
function getParagraphLength(markdown) {

    if (markdown === undefined) {
        return 0
    }

    const array = markdown.split(Constants._break)

    let breaks = countBreaks(markdown)

    let length = 0

    for (var i = 0; i < array.length; i++) {

        length += array[i].length
    }

    return length + breaks
}

// Unit test ready
// abcdf<br/>bcd|e<br/>qweet -> return 1
function getBrickIndexAtWhichCursoIsLocated(paragraph, displacement) {

    if(paragraph === undefined)
        return 0

    const array = paragraph.split(Constants._break)
    let i
    let length = 0

    for (i = 0; i < array.length; i++) {

        length += array[i].length

        if (length >= displacement) {
            break
        }

        length++
    }

    return i
}

function isFirstCharOfTitle(markdown) {

    if(markdown === undefined) {
        return false
    }

    return (markdown.startsWith(Constants.titleStarted) && markdown.length === 2) || (markdown.startsWith(Constants.titleStartedWithNewline) && markdown.length === 3)
}

function getBlocksFromText(text) {
    return text.split(Constants.newline)
}
