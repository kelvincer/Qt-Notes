import QtQuick 2.15
import QtTest 1.0
import "../js/MdArray.js" as MdArray
import "../js/TextBlock.js" as Block

TestCase {
    name: "title_with_newline_length"

    function test_TitleWithNewline_ReturnLength() {
        const title = "\n# My title"
        compare(Block.getH1TitleWithNewLineLength(title), title.length - 2)
    }
}
