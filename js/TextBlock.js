.import "Constants.js" as Constants

function isACharacter(character) {
    //return (/[a-zA-ZñÑ0-9,.;]/).test(character);
    return (/[^\s#*]/).test(character)
}

function isParagraph(markdown) {
    return markdown !== undefined && !isTitleWithoutNewline(markdown)
}

function isParagraphWithNewline(markdown) {
    return markdown !== undefined && !isTitleWithNewLine(markdown)
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

function isTitleWithoutNewline(title) {
    return isH1Title(title) || isH2Title(title) || isH3Title(title)
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
function getH1TitleLength(markdown) {

    if (markdown === undefined)
        return 0

    markdown = removeItalics(markdown)

    if (markdown.length <= 2) {

        return markdown.length
    } else {

        return markdown.length - 2
    }
}

function getH2TitleLength(markdown) {
    if (markdown === undefined)
        return 0

    markdown = removeItalics(markdown)

    if (markdown.length <= 3) {

        return markdown.length
    } else {

        return markdown.length - 3
    }
}

function getH3TitleLength(markdown) {
    if (markdown === undefined)
        return 0

    markdown = removeItalics(markdown)

    if (markdown.length <= 4) {

        return markdown.length
    } else {

        return markdown.length - 4
    }
}

function getTitleWithoutNewlineLength(title) {

    if(isH1Title(title)) {
        return getH1TitleLength(title)
    } else if (isH2Title(title)) {
        return getH2TitleLength(title)
    } else if(isH3Title(title)) {
        return getH3TitleLength(title)
    }

    return undefined
}

// Unit test ready
// Visible characters
function getH1TitleWithNewLineLength(markdown) {

    if (markdown === undefined)
        return 0

    markdown = removeItalics(markdown)

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

    markdown = removeItalics(markdown)

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

    markdown = removeItalics(markdown)

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

    let result = markdownText

    if(italicsSpans !== undefined) {
        for (const {start, end} of italicsSpans) {
            if (result[start] !== '*' || result[end] !== '*') continue

            result =
                result.slice(0, start) +
                '~' +
                result.slice(start + 1, end) +
                '~' +
                result.slice(end + 1)
        }
    } else {
        italicsSpans = []
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
    }

    return paragraph
}

/*function countItalicsAsterisksBeforeCursor(markdownText, cursorPositionOnBlock, prevItalics) {
    let visibleCount = 0;
    let italicCount = 0;
    let i = 0;
    let firstAsterisk = false;

    console.log("markdown", markdownText, cursorPositionOnBlock)

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
}*/

function countItalicsAsterisksBeforeCursor(markdownText, cursorPositionOnBlock, prevItalics) {

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

        // Handle newline
        if (char === '\n') {
            visibleCount++;
            i++;
            continue;
        }

        if(i === 0 && char === '#' && isH1Title(markdownText)) {
            i++;
            continue;
        }

        if(i === 1 && char === '#' && isH1TitleWithNewline(markdownText)) {
            i++;
            continue;
        }

        if((i === 0 || i === 1) && char === '#' && isH2Title(markdownText)) {
            i++;
            continue;
        }

        if((i === 1 || i === 2) && char === '#' && isH2TitleWithNewline(markdownText)) {
            i++;
            continue;
        }

        if((i === 0 || i === 1 || i === 2) && char === '#' && isH3Title(markdownText)) {
            i++;
            continue;
        }

        if((i === 1 || i === 2 || i === 3) && char === '#' && isH3TitleWithNewline(markdownText)) {
            i++;
            continue;
        }

        // Handle <br/>
        if (markdownText.startsWith('<br/>', i)) {
            visibleCount += 1;
            i += 5;
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

function isStartingH1TitleInsideParagraph(markdown) {
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

function isDeletingFinalItalicChar(markdown, markdownDisplacement) {
    return markdown.charAt(markdownDisplacement - 1) === '*' && markdown.charAt(markdownDisplacement - 3) === '*'
                                               && isACharacter(markdown.charAt(markdownDisplacement - 2))
}

function isStartingH1TitleWithNewline(title) {
    return title !== undefined && title.startsWith(Constants.titleStartedWithNewline) && title.length === 3
}

function isStartingH2TitleWithNewline(title) {
    return title !== undefined && title.startsWith(Constants.h2TitleStartedWithNewline) && title.length === 4
}

function isStartingH3TitleWithNewline(title) {
    return title !== undefined && title.startsWith(Constants.h3TitleStartedWithNewline) && title.length === 5
}

function isStartingTitleWithNewline(title) {
    return isStartingH1TitleWithNewline(title) || isStartingH2TitleWithNewline(title)
    || isStartingH3TitleWithNewline(title)
}

function isStartingH1Title(title) {
    return title !== undefined && title.startsWith(Constants.titleStarted) && title.length === 2
}

function isStartingH2Title(title) {
    return title !== undefined && title.startsWith(Constants.h2TitleStarted) && title.length === 3
}

function isStartingH3Title(title) {
    return title !== undefined && title.startsWith(Constants.h3TitleStarted) && title.length === 4
}

function isStartingTitle(title) {

    return isStartingH1Title(title) || isStartingH2Title(title)
    || isStartingH3Title(title)
}

// \n# *t*
function isH1ItalicNewlineDeleted(title, markdownDisplacement) {
    return title.length === 6 && isTitle(title) && isDeletingFinalItalicChar(title, markdownDisplacement)
}

// # *t*
function isH1ItalicDeleted(title, markdownDisplacement) {
    return title.length === 5 && isTitle(title) && isDeletingFinalItalicChar(title, markdownDisplacement)
}

// \n## *t*
function isH2ItalicNewlineDeleted(title, markdownDisplacement) {
    return title.length === 7 && isTitle(title) && isDeletingFinalItalicChar(title, markdownDisplacement)
}

// ## *t*
function isH2ItalicDeleted(title, markdownDisplacement) {
    return title.length === 6 && isTitle(title) && isDeletingFinalItalicChar(title, markdownDisplacement)
}

// \n### *t*
function isH3ItalicNewlineDeleted(title, markdownDisplacement) {
    return title.length === 8 && isTitle(title) && isDeletingFinalItalicChar(title, markdownDisplacement)
}

// ### *t*
function isH3ItalicDeleted(title, markdownDisplacement) {
    return title.length === 7 && isTitle(title) && isDeletingFinalItalicChar(title, markdownDisplacement)
}

function isItalicTitleDeleted(title, markdownDisplacement) {
    return isH1ItalicNewlineDeleted(title, markdownDisplacement) || isH2ItalicNewlineDeleted(title, markdownDisplacement)
    || isH3ItalicNewlineDeleted(title, markdownDisplacement) || isH1ItalicDeleted(title, markdownDisplacement)
    || isH2ItalicDeleted(title, markdownDisplacement) || isH3ItalicDeleted(title, markdownDisplacement)
}

function startedTypingFromItalicEnd(markdown, markdownDisplacement, italics) {

    if (italics === undefined)
        return false

    // console.log("mark", markdown, markdownDisplacement)
    // console.log("italic", markdown.substring(markdownDisplacement).split(""))

    for (const {start, end} of italics) {
        // console.log("end", end)
        if (end === markdownDisplacement - 1 && markdown.substring(markdownDisplacement).length > 0) {
            return true
        }
    }

    return false
}

function updateItalicEndAsterisk(markdownDisplacement, italics) {

    italics.forEach((italic, index)=>{
        if(italic.end === markdownDisplacement- 1){
            italic.end = italic.end + 1
        }
    })

    return italics
}

function findLastHTMLBreakEndIndex(paragraph) {

    //let markdownWithoutItalics = removeItalics(paragraph)
    const splitted = paragraph.split(Constants._break)
    let length = 0

    for(let i = 0; i < splitted.length - 1; i++) {
        length += splitted[i].length
    }

    return length + Constants._break.length * (splitted.length - 1) - 1
}

function getNewParagraph(arrayIndex, markdown) {
    if (arrayIndex === 0) {
        if(!isParagraph(markdown)) {
            let startIndex = undefined
            if(isH1Title(markdown)) {
                startIndex = 2
            } else if(isH2Title(markdown)) {
                startIndex = 3
            } else if(isH3Title(markdown)) {
                startIndex = 4
            }
            return markdown.substring(startIndex)
        } else {
            return markdown
        }
    } else {
        if(!isParagraphWithNewline(markdown)) {
            let startIndex = undefined
            if(isH1TitleWithNewline(markdown)) {
                startIndex = 3
            } else if(isH2TitleWithNewline(markdown)) {
                startIndex = 4
            } else if(isH3TitleWithNewline(markdown)) {
                startIndex = 5
            }
            return Constants.newline + markdown.substring(startIndex)
        } else {
            return markdown
        }
    }
}

function getNewH1Title(arrayIndex, markdown) {
    if(arrayIndex === 0) {
        if(!isH1Title(markdown)) {
            let startIndex = 0
            if(isH2Title(markdown)) {
                startIndex = 3
            } else if (isH3Title(markdown)) {
                startIndex = 4
            }
            return Constants.titleStarted + markdown.substring(startIndex)
        } else {
            return markdown
        }
    } else {
        if(!isH1TitleWithNewline(markdown)) {
            let startIndex = 1
            if(isH2TitleWithNewline(markdown)) {
                startIndex = 4
            } else if (isH3TitleWithNewline(markdown)) {
                startIndex = 5
            }
            return Constants.titleStartedWithNewline + markdown.substring(startIndex)
        } else {
            return markdown
        }
    }
}

function getNewH2Title(arrayIndex, markdown) {
    if(arrayIndex === 0) {
        if(!isH2Title(markdown)) {
            let startIndex = 0
            if(isH1Title(markdown)) {
                startIndex = 2
            } else if (isH3Title(markdown)) {
                startIndex = 4
            }
            return Constants.h2TitleStarted + markdown.substring(startIndex)
        } else {
            return markdown
        }
    } else {
        if(!isH2TitleWithNewline(markdown)) {
            let startIndex = 1
            if(isH1TitleWithNewline(markdown)) {
                startIndex = 3
            } else if (isH3TitleWithNewline(markdown)) {
                startIndex = 5
            }
            return Constants.h2TitleStartedWithNewline + markdown.substring(startIndex)
        } else {
            return markdown
        }
    }
}

function getNewH3Title(arrayIndex, markdown) {
    if(arrayIndex === 0) {
        if(!isH3Title(markdown)) {
            let startIndex = 0
            if(isH1Title(markdown)) {
                startIndex = 2
            } else if (isH2Title(markdown)) {
                startIndex = 3
            }
            return Constants.h3TitleStarted + markdown.substring(startIndex)
        } else {
            return markdown
        }
    } else {
        if(!isH3TitleWithNewline(markdown)) {
            let startIndex = 1
            if(isH1TitleWithNewline(markdown)) {
                startIndex = 3
            } else if (isH2TitleWithNewline(markdown)) {
                startIndex = 4
            }
            return Constants.h3TitleStartedWithNewline + markdown.substring(startIndex)
        } else {
            return markdown
        }
    }
}

function removeItalic(paragraph, start, end) {

    paragraph = paragraph.substring(0, start) + paragraph.substring(start + 1, end)
            + paragraph.substring(end + 1);

    return paragraph
}




