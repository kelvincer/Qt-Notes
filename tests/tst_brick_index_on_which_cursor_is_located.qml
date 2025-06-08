import QtQuick 2.15
import QtTest 1.2
import "../js/TextBlock.js" as Block

TestCase {
    name: "brick_index_on_which_cursor_is_located"

    function test_Paragraph_ReturnZero() {
        const paragraph = "abc|def<br/>qwerty"
        const displacement = 3
        compare(Block.getBrickIndexAtWhichCursoIsLocated(paragraph, displacement), 0);
    }

    function test_CursorOnLastParagraph_ReturnTwo() {
        const paragraph = "abcdef<br/>qwerty<br/>las|t"
        const displacement = Block.getParagraphLength(paragraph) - 1
        compare(Block.getBrickIndexAtWhichCursoIsLocated(paragraph, displacement), 2);
    }

    function test_case01() {
        const paragraph = "hi *i*<br/>"
        compare(Block.getBrickIndexAtWhichCursoIsLocated(paragraph, 5, [{start: 3, end:5}] ), 1)
    }
}
