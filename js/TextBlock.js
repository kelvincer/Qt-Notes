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

function isH2Title(title) {
    return title !== undefined && title.startsWith(Constants.h2TitleStarted)
}

function isH2TitleWithNewline(title) {
    return title !== undefined && title.startsWith(Constants.h2TitleStartedWithNewline)
}

function isH3Title(title) {
    return title !== undefined && title.startsWith(Constants.h3TitleStarted)
}

function isH3TitleWithNewline(title) {
    return title !== undefined && title.startsWith(Constants.h3TitleStartedWithNewline)
}

function isTitleWithNewLine(title) {
    return isH1TitleWithNewline(title) || isH2TitleWithNewline(title)
    || isH3TitleWithNewline(title)
}

function isTitle(title) {
    return isH1Title(title) || isH1TitleWithNewline(title) || isH2Title(title)
    || isH2TitleWithNewline(title) || isH3Title(title) || isH3TitleWithNewline(title)
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

function getH2TitleLength(markdown) {
    if (markdown === undefined)
        return 0

    if (markdown.length <= 3) {

        return markdown.length
    } else {

        return markdown.length - 3
    }
}

function getH3TitleLength(markdown) {
    if (markdown === undefined)
        return 0

    if (markdown.length <= 4) {

        return markdown.length
    } else {

        return markdown.length - 4
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

// Visible characters
function getH2TitleWithNewLineLength(markdown) {

    if (markdown === undefined)
        return 0

    if (markdown.length <= 4) {

        return markdown.length
    } else {

        return markdown.length - 3
    }
}

// Visible characters
function getH3TitleWithNewLineLength(markdown) {

    if (markdown === undefined)
        return 0

    if (markdown.length <= 5) {

        return markdown.length
    } else {

        return markdown.length - 4
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
function getBrickIndexAtWhichCursoIsLocated(paragraph, displacement, italics = []) {

    if (paragraph === undefined)
        return 0

    const array = paragraph.split(Constants._break)
    let i
    let length = 0

    displacement += countItalicsAsterisksBeforeCursor(paragraph, displacement, italics)

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

    return (markdown.startsWith(Constants.titleStarted) && markdown.length === 2)
            || (markdown.startsWith(Constants.titleStartedWithNewline) && markdown.length === 3)
            || (markdown.startsWith(Constants.h2TitleStarted) && markdown.length === 3)
            || (markdown.startsWith(Constants.h2TitleStartedWithNewline) && markdown.length === 4)
            || (markdown.startsWith(Constants.h3TitleStarted) && markdown.length === 4)
            || (markdown.startsWith(Constants.h3TitleStartedWithNewline) && markdown.length === 5)

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

function processNewItalic(markdownText, italicsSpans) {
    if (!Array.isArray(italicsSpans)) {
        return markdownText
    }

    let result = markdownText

    for (const { start, end } of italicsSpans) {
        if (result[start] !== '*' || result[end] !== '*') continue

        result =
                result.slice(0, start) +
                '~' +
                result.slice(start + 1, end) +
                '~' +
                result.slice(end + 1)
    }

    console.log("rsult italic", result)

    const newItalic = findItalicIndices(result)

    if(newItalic.length > 0 && newItalic[0].start !== undefined) {
        italicsSpans.push({start: newItalic[0].start, end: newItalic[0].end})
    }

    return { result: result, italics: italicsSpans }
}

function updateItalics(char, italics, markdownDisplacement) {

    if(italics === undefined || italics.length === 0)
        return italics

    italics.sort((a, b) => b.start - a.start) // descending
    if(isACharacter(char) || char === '*' || char === ' ') {
        for (let italic of italics) {
            if(markdownDisplacement <= italic.start) {
                italic.start++
                italic.end++
            }
        }
    }

    return italics
}

// function updateItalicEnd(italics, markdownDisplacement) {

//     if(italics === undefined || italics.length === 0)
//         return italics

//     for(let italic of italics) {
//         if(markdownDisplacement === italic.end + 1) {
//             italic.end--
//             break
//         }
//     }

//     return italics
// }

// function decreaseItalics(italics, markdownDisplacement) {

//     if(italics === undefined || italics.length === 0)
//         return italics

//     italics.sort((a, b) => b.start - a.start) // descending

//     for (let italic of italics) {
//         console.log("disp", markdownDisplacement, italic.start)
//         if(markdownDisplacement <= italic.start) {
//             italic.start--
//             italic.end--
//         }
//     }

//     return italics
// }

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

function countItalicsAsterisksBeforeCursor(markdownText, cursorPositionOnBlock, prevItalics) {
    let visibleCount = 0;
    let italicCount = 0;
    let i = 0;
    let firstAsterisk = false;

    //console.log("markdown", markdownText, cursorPositionOnBlock)

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
        const found = prevItalics !== undefined ? prevItalics.findIndex(italic => italic.start === i) : -1
        //console.log("found", found, char, i)
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

function countH1ItalicsAsterisksBeforeCursor(markdownText, cursorPositionOnBlock, prevItalics) {

    let visibleCount = 0
    let italicCount = 0
    let i = 0
    let firstAsterisk = false
    let firstNonBreakingSpace = true

    //console.log("markdown", markdownText, cursorPositionOnBlock)

    while (i < markdownText.length && visibleCount < cursorPositionOnBlock + 1) {
        const char = markdownText[i];

        //console.log("char", char)

        if(char === Constants.nonBreakingSpace && firstNonBreakingSpace) {
            i++
            firstNonBreakingSpace = false
            continue
        }

        if(char === '#') {
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
        const found = prevItalics !== undefined ? prevItalics.findIndex(italic => italic.start === i) : -1
        //console.log("found", found, char, i)
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

function isStartingATitleInsideParagraph(markdown) {
    return markdown !== undefined && markdown.substring(markdown.length - 7) === Constants._break + Constants.titleStarted
}

function isStartingH2TitleInsideParagraph(markdown) {
    return markdown !== undefined && markdown.substring(markdown.length - 8) === Constants._break + Constants.h2TitleStarted
}

function isStartingH3TitleInsideParagraph(markdown) {
    return markdown !== undefined && markdown.substring(markdown.length - 9) === Constants._break + Constants.h3TitleStarted
}

function isH1TitleDeleted(title) {
    return (isH1Title(title) && title.length === 3) || (isH1TitleWithNewline(title) && title.length === 4)
}

function isH2TitleDeleted(title) {
    return (isH2Title(title) && title.length === 4) || (isH2TitleWithNewline(title) && title.length === 5)
}

function isH3TitleDeleted(title) {
    return (isH3Title(title) && title.length === 5) || (isH3TitleWithNewline(title) && title.length === 6)
}

function isTitleDeleted(title) {
    return isH1TitleDeleted(title) || isH2TitleDeleted(title) || isH3TitleDeleted(title)
}

