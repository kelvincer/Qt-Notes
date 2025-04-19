import QtQuick 2.15
import QtTest 1.2
import "../js/MdArray.js" as MdArray
import "../js/TextBlock.js" as Block

TestCase {
    name: "cursor_displacement_inside_markdown_block"

    // Cursor index: 0
    // #\u00A0title|
    function test_CursorOnTitle_ReturnMarkdownDisplacement() {
        const array = [{markdown: "#\u00A0title"}, {markdown: "\nthis is a paragraph<br/>another paragraph"}, {markdown: "\nthis is a paragraph<br/>another paragraph"}]
        compare(MdArray.getCursorDisplacementInsideMarkdownBlock(array, 0, 5), 7);
    }

    // Cursor index: 1
    // \n#\u00A0titl|e
    function test_CursorOnTitleAndTitleOnIndexOne_ReturnMarkdownDisplacement() {
        const array = [{markdown: "this is a paragraph<br/>another"}, {markdown: "\n#\u00A0title"}, {markdown: "\nthis is a paragraph<br/>another paragraph"}]
        const cursorPos = Block.getParagraphLength(array[0].markdown) + 5
        compare(MdArray.getCursorDisplacementInsideMarkdownBlock(array, 1, cursorPos), 7);
    }

    // Cursor index: 1
    // \nthis<br/>another| paragraph
    function test_CursorOnFirstParagraph_ReturnMarkdownDisplacement() {
        const array = [{markdown: "#\u00A0title"}, {markdown: "\nthis<br/>another paragraph"}, {markdown: "\nthis is a paragraph<br/>another paragraph"}]

        const cursorPos = Block.getTitleLength(array[0].markdown) + 13
        compare(MdArray.getCursorDisplacementInsideMarkdownBlock(array, 1, cursorPos), 17);
    }

    // Cursor index: 2
    // \nthis is a paragraph<br/>another paragraph|
    function test_CursorOnLastParagraph_ReturnMarkdownDisplacement() {
        const array = [{markdown: "#\u00A0title"}, {markdown: "\nthis is a paragraph<br/>another paragraph"}, {markdown: "\nthis is a paragraph<br/>another paragraph"}]

        const cursorPos = MdArray.getTotalLength(array)
        const breaks = Block.countBreaks(array[2].markdown)

        const expected = Block.getParagraphLength(array[2].markdown) + 4 * breaks

        compare(MdArray.getCursorDisplacementInsideMarkdownBlock(array, 2, cursorPos), expected);
    }

    function test_ArrayOnlyParagraph_ReturnDisplacement() {
        const array = [{markdown: "this is a paragraph<br/>another paragraph"}]

        compare(MdArray.getCursorDisplacementInsideMarkdownBlock(array, 0, 4), 4);
    }

    function test_ArrayOnlyParagraphWithCursorAfterBreak_ReturnDisplacement() {
        const array = [{markdown: "\nthis is a paragraph<br/>another paragraph"}]
        const cursorPos = Block.getParagraphLength("\nthis is a paragraph<br/>an")

        compare(MdArray.getCursorDisplacementInsideMarkdownBlock(array, 0, cursorPos), 27);
    }

    // Cursor index: 1
    function test_CursorOnSecondTitle_ReturnDisplacement() {
        const array = [{markdown: "#\u00A0t"}, {markdown: "\n#\u00A0t"}]
        compare(MdArray.getCursorDisplacementInsideMarkdownBlock(array, 1, 3), 4);
    }

    // Cursor index: 1
    function test_case01() {
        const array = [{markdown: "#\u00A0tit"}, {markdown: "\n#\u00A0dem"}]
        compare(MdArray.getCursorDisplacementInsideMarkdownBlock(array, 1, 7), 6);
    }
}
