import QtQuick 2.15
import QtTest 1.2
import "../js/MdArray.js" as MdArray
import "../js/TextBlock.js" as Block

TestCase {
    name: "cursor_just_after_paragraph_breakline"

    function test_CursorOnTitle_ReturnMarkdownDisplacement() {
        const array = [{markdown: "#\u00A0title"}, {markdown: "\nthis is a paragraph<br/>another paragraph"}, {markdown: "\nthis is a paragraph<br/>another paragraph"}]
        compare(MdArray.isCursorJustAfterParagraphBreakline(array, 0, 5), false);
    }

    // Cursor index: 1
    // \nthis<br/>another| paragraph
    function test_CursorOnFirstParagraph_ReturnMarkdownDisplacement() {
        const array = [{markdown: "#\u00A0title"}, {markdown: "\nthis<br/>another paragraph"}, {markdown: "\nthis is a paragraph<br/>another paragraph"}]

        const cursorPos = Block.getTitleLength(array[0].markdown) + 13
        compare(MdArray.isCursorJustAfterParagraphBreakline(array, 1, cursorPos), false);
    }

    // Cursor index: 2
    // \nthis is a paragraph<br/>|another paragraph
    function test_CursorOnLastParagraph_ReturnMarkdownDisplacement() {
        const array = [{markdown: "#\u00A0title"}, {markdown: "\nthis is a paragraph<br/>another paragraph"}, {markdown: "\nthis is a paragraph<br/>another"}]

        const cursorPos = MdArray.getTotalLength(array) - 7

        compare(MdArray.isCursorJustAfterParagraphBreakline(array, 2, cursorPos), true);
    }

    function test_case1() {
        const array = [{markdown: "#\u00A0r"}, {markdown: "\nt<br/>t"}]
        compare(MdArray.isCursorJustAfterParagraphBreakline(array, 1, 4), true);
    }
}
