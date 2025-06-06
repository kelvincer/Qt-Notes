import QtQuick 2.15
import QtTest 1.2
import "../js/MdArray.js" as MdArray
import "../js/TextBlock.js" as Block

TestCase {
    name: "cursor_displacement_inside_block"

    function test_CursorOnTitle_ReturnDisplacement() {
        const array = [{markdown: "#\u00A0title"}, {markdown: "\nthis is a paragraph<br/>another paragraph"}]
        compare(MdArray.getCursorDisplacementInsideBlock(array, 4), 4);
    }

    function test_CursorOnParagraph_ReturnDisplacement() {
        const array = [{markdown: "#\u00A0title"}, {markdown: "\nthis is a paragraph<br/>another paragraph"}]
        const cursorPos = Block.getTitleLength(array[0].markdown) + 5
        compare(MdArray.getCursorDisplacementInsideBlock(array, cursorPos), 5);
    }

    function test_CursorOnLastBlock_ReturnDisplacement() {
        const array = [{markdown: "#\u00A0title"}, {markdown: "\nthis is a paragraph<br/>another paragraph"}, {markdown: "\nthis is a paragraph<br/>another paragraph"}]
        const cursorPos = Block.getTitleLength(array[0].markdown) + Block.getParagraphLength(array[1].markdown) + Block.getParagraphLength(array[2].markdown)

        const expected = Block.getParagraphLength(array[2].markdown)
        compare(MdArray.getCursorDisplacementInsideBlock(array, cursorPos), expected);
    }

    function test_CursorOnInitialPosition_ReturnDisplacement() {
        const array = [{markdown: "#\u00A0t"}, {markdown: "\nb"}]
        compare(MdArray.getCursorDisplacementInsideBlock(array, 2), 1)
    }

    function test_case01() {
        const array = [{markdown: "#\u00A0Hi"}, {markdown: "\n*You*"}]
        compare(MdArray.getCursorDisplacementInsideBlock(array, 6), 4)
    }

    function test_case02() {
        const array = [{markdown: "##\u00A0Hi"}]
        compare(MdArray.getCursorDisplacementInsideBlock(array, 2), 2)
    }

    function test_case03() {
        const array = [{markdown: "##\u00A0Hi"}, {markdown: "\n##\u00A0Hi"}]
        compare(MdArray.getCursorDisplacementInsideBlock(array, 5), 3)
    }

    function test_case04() {
        const array = [{markdown: "##\u00A0Hi"}, {markdown: "\n###\u00A0Hi"}]
        compare(MdArray.getCursorDisplacementInsideBlock(array, 5), 3)
    }
}
