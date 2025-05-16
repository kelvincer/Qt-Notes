.import "Constants.js" as Constants

function isACharacter(character) {
    //return (/[a-zA-ZñÑ0-9,.;]/).test(character);
    return (/[^\s#*]/).test(character)
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

    let markdownWithoutItalics = removeItalics(markdown)

    const array = markdownWithoutItalics.split(Constants._break)

    let breaks = countBreaks(markdownWithoutItalics)

    let length = 0

    for (var i = 0; i < array.length; i++) {

        length += array[i].length
    }

    return length + breaks
}

// Unit test ready
// abcdf<br/>bcd|e<br/>qweet -> return 1
function getBrickIndexAtWhichCursoIsLocated(paragraph, displacement) {

    if (paragraph === undefined)
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

    if (markdown === undefined) {
        return false
    }

    return (markdown.startsWith(Constants.titleStarted) && markdown.length === 2) || (markdown.startsWith(Constants.titleStartedWithNewline) && markdown.length === 3)
}

function getBlocksFromText(text) {
    return text.split(Constants.newline)
}

function getFirstParagraphBreaklineIndex(paragraph) {
    return paragraph.indexOf(Constants._break)
}

function findItalicIndices(markdown) {
    const pattern = /(\*|_)([^*_\n]+?)\1/g // Matches *italic* or _italic_
    const matches = []
    let match

    while ((match = pattern.exec(markdown)) !== null) {
        const [fullMatch, marker, text] = match;
        const start = match.index;
        const end = start + fullMatch.length - 1;

        matches.push({
            text,
            start, // Start of opening * or _
            end,   // End of closing * or _
            fullMatch,
        })
    }

    return matches
}

function detectItalicIntent(text) {
    // Common plain-text italic indicators
    const patterns = [
        /\/\/(.*?)\/\//g,    // //italic//
        /_(.*?)_/g,          // _italic_
        /(^|[^*])\*(?!\*)([^*\n]+?)\*($|[^*])/g,      // *italic*
        /I\((.*?)\)/g        // I(italic)
    ]

    return patterns.some(p => p.test(text))
}

function removeItalics(paragraph) {

    let italics = findItalicIndices(paragraph)

    while (italics.length > 0) {
        const element = italics.pop()
        paragraph = paragraph.substring(0, element.start) + paragraph.substring(element.start + 1, element.end)
            + paragraph.substring(element.end + 1);
        italics = findItalicIndices(paragraph)
    }

    //console.log("paragraph after removing italics", paragraph)

    return paragraph
}

function countItalicsBeforeCursor(markdownText, cursorPositionOnBlock) {
    let visibleCount = 0;
    let italicCount = 0;
    let i = 0;
    let firstAsterisk = false;

    while (i < markdownText.length && visibleCount < cursorPositionOnBlock + 1) {
        const char = markdownText[i];

        // Handle <br/>
        if (markdownText.startsWith('<br/>', i)) {
            visibleCount += 1;
            i += 5;
            continue;
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

        // Count italics markers
        if ((char === '*' || char === '_') && firstAsterisk) {
            italicCount++;
            i++;
            firstAsterisk = false
            continue;
        }

        // Count italics markers
        const italics = findItalicIndices(markdownText)
        const found = italics.findIndex(italic => italic.start === i);
        if ((char === '*' || char === '_') && (markdownText[i + 1] !== '*' || markdownText[i + 1] !== '_') && found !== -1 ) {
            italicCount++;
            i++;
            firstAsterisk = true;
            continue;
        }

        // Default visible char
        visibleCount++;
        i++;
    }

    return italicCount
}

