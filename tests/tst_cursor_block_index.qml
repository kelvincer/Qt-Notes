import QtQuick 2.15
import QtTest 1.2
import "../js/MdArray.js" as MdArray

TestCase {
    name: "cursor_block_index"

    // cursor index: 0
    function test_CursorOnTitle_ReturnZero() {
        const array = [{markdown: "#\u00A0title"}, {markdown: "\nthis is a paragraph<br/>another paragraph"}]
        compare(MdArray.getCursorBlockIndex(array, 4), 0);
    }

    // cursor index: 1
    function test_CursorOnParagraph_ReturnOne() {
        const array = [{markdown: "#\u00A0title"}, {markdown: "\nthis is a paragraph<br/>another paragraph"}]
        compare(MdArray.getCursorBlockIndex(array, 12), 1);
    }

    function test_CursorOnParagraghBeginning_ReturnIndex() {
        const array = [{markdown: "#\u00A0title"}, {markdown: "\nthis is a paragraph<br/>another paragraph"}]
        compare(MdArray.getCursorBlockIndex(array, 3), 0);
    }

    function test_CursorOnLastParagraph_ReturnIndex() {
        const array = [{markdown: "#\u00A0title"}, {markdown: "\nthis is a paragraph<br/>another paragraph"},
                    {markdown: "\nthis is a paragraph<br/>another paragraph"}, {markdown: "\nthis is a paragraph<br/>another paragr|aph"}]
        const totalLength = MdArray.getTotalLength(array)
        compare(MdArray.getCursorBlockIndex(array, totalLength - 3), 3);
    }

    // cursor index: 1
    function test_CursorOnSecondTitle_ReturnIndex() {
        const array = [{markdown: "#\u00A0title"}, {markdown: "\n#\u00A0title123"}]
        compare(MdArray.getCursorBlockIndex(array, 9), 1);
    }

    function test_case01() {
        const array = [{markdown: "#\u00A0a"}, {markdown: "\n#\u00A0c"}]
        compare(MdArray.getCursorBlockIndex(array, 3), 1);
    }

    function test_case02() {
        const array = [{markdown: "#\u00A0Hi"}, {markdown: "\nYou"}, {markdown:"\n#\u00A0a *b*"}, {markdown: "\n\u200B"}]
        compare(MdArray.getCursorBlockIndex(array, 11), 3)
    }

    function test_case03() {
        const array = [{markdown: "#\u00A0Hi"}, {markdown: "\nYou"}, {markdown: "\n\u200B"}, {markdown: "\n\u200B"}, {markdown: "\n#\u00A0Another title"}]
        compare(MdArray.getCursorBlockIndex(array, 10), 3)
    }
}
