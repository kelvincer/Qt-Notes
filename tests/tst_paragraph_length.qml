import QtQuick 2.15
import QtTest 1.0
import "../js/TextBlock.js" as Block
import "../js/Constants.js" as Contansts

TestCase {
    name: "paragraph_length"

    function test_UndefinedParagraph_ReturnZero() {
        compare(Block.getParagraphLength(undefined), 0)
    }

    function test_ParagraphWithOutBreaks_ReturnLength() {
        const paragraph = "this is a paragraph"
        compare(Block.getParagraphLength(paragraph), paragraph.length)
    }

    function test_ParagraphWithBreaks_ReturnLengthAndBreaks() {
        const paragraph = "This is" + Contansts._break + "a small" + Contansts._break + "paragraph"
        const length = "This is".length + "a small".length + "paragraph".length + 2
        compare(Block.getParagraphLength(paragraph), length)
    }
}
