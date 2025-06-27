import QtQuick 2.15
import QtTest 1.0
import "../js/MdArray.js" as MdArray
import "../js/TextBlock.js" as Block

TestCase {
    name: "length_before_cursor_block"

    // cursor index: 0
    function test_CursorOnFirstBlock_ReturnZero() {
        const array = [{markdown: "#\u00A0title"}, {markdown: "\nthis is a paragraph<br/>another paragraph"}]
        compare(MdArray.getLengthBeforeCursorBlock(array, 3), 0);
    }

    // cursor index: 1
    function test_CursorOnSecondBlock_ReturnLength() {
        const array = [{markdown: "#\u00A0title"}, {markdown: "\nthis is a paragraph<br/>another paragraph"}, {markdown: "\nanother paragraph"}]
        const length = Block.getH1TitleLength(array[0].markdown)
        compare(MdArray.getLengthBeforeCursorBlock(array, 19), length)
    }

    function test_CursorOnLastBlock_ReturnLength() {
        const array = [{markdown: "#\u00A0title"}, {markdown: "\nthis is a paragraph<br/>another paragraph"}, {markdown: "\nanother parag|raph"}]
        const length = Block.getH1TitleLength(array[0].markdown) + Block.getParagraphLength(array[1].markdown)
        compare(MdArray.getLengthBeforeCursorBlock(array, length + 4), length)
    }

    function test_emptyArray_ReturnZero() {
        const array = []
        compare(MdArray.getLengthBeforeCursorBlock(array, 0), 0)
    }

    function test_case01() {
        const array = [{markdown: "#\u00A0Hi"}, {markdown: "\nYou"}, {markdown:"\n#\u00A0a *b*"}, {markdown: "\n\u200B"}]
        compare(MdArray.getLengthBeforeCursorBlock(array, 11), 10)
    }

    function test_case02() {
        const array = [{markdown: "##\u00A0Hi"}, {markdown: "\n##\u00A0Hi"}]
        compare(MdArray.getLengthBeforeCursorBlock(array, 5), 2)
    }
}
